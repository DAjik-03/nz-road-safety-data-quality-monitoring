-- Purpose: Answer six representative reporting and data-quality questions.
-- Input: monitoring views and exception register
-- Output: aq_01 through aq_06 views plus CSV evidence
-- Dialect: DuckDB 1.5.x

-- AQ-01: How did annual crash counts change year over year?
CREATE OR REPLACE VIEW aq_01_annual_yoy AS
SELECT
    crash_year,
    period_status,
    crash_count,
    prior_year_crash_count,
    yoy_crash_change,
    yoy_crash_change_pct
FROM vw_annual_crash_monitoring
ORDER BY crash_year;

-- AQ-02: What share of crashes were fatal or serious each year?
CREATE OR REPLACE VIEW aq_02_fatal_serious_share AS
SELECT
    crash_year,
    period_status,
    crash_count,
    fatal_or_serious_crashes,
    fatal_or_serious_crash_pct
FROM vw_annual_crash_monitoring
ORDER BY crash_year;

-- AQ-03: Which years have the highest detailed-geography missingness?
CREATE OR REPLACE VIEW aq_03_geographic_missingness_rank AS
SELECT
    crash_year,
    records_checked,
    missing_region_records,
    missing_tla_records,
    missing_fine_geography_records,
    missing_region_pct,
    missing_tla_pct,
    missing_fine_geography_pct,
    RANK() OVER (
        ORDER BY missing_fine_geography_pct DESC, missing_tla_pct DESC, crash_year
    ) AS missingness_rank
FROM vw_geographic_completeness;

-- AQ-04: Which rules contribute the largest share of all rule failures?
CREATE OR REPLACE VIEW aq_04_quality_issue_contribution AS
SELECT
    check_id,
    check_name,
    status,
    failed_records,
    ROUND(
        100.0 * failed_records / NULLIF(SUM(failed_records) OVER (), 0),
        4
    ) AS share_of_all_rule_failures_pct,
    DENSE_RANK() OVER (ORDER BY failed_records DESC) AS contribution_rank
FROM vw_quality_check_summary
WHERE failed_records > 0;

-- AQ-05: Are known exceptions concentrated in particular periods?
CREATE OR REPLACE VIEW aq_05_exception_trend AS
SELECT
    crash_year,
    check_id,
    check_name,
    COUNT(*)::BIGINT AS exception_rows,
    COUNT(DISTINCT crash_id)::BIGINT AS affected_records
FROM vw_exception_register
GROUP BY crash_year, check_id, check_name;

-- AQ-06: Which reporting grains remain safe and which require caveats?
CREATE OR REPLACE VIEW aq_06_geographic_reporting_risk AS
WITH total AS (
    SELECT COUNT(*)::BIGINT AS records_checked
    FROM vw_crash_reporting_base
), risks AS (
    SELECT 1 AS risk_order, 'National' AS reporting_grain, 0::BIGINT AS affected_records,
        'No geographic key required for national totals' AS interpretation
    FROM total
    UNION ALL
    SELECT 2, 'Region', COUNT(*) FILTER (WHERE region IS NULL)::BIGINT,
        'Caveat or exclude records with missing region'
    FROM vw_crash_reporting_base
    UNION ALL
    SELECT 3, 'TLA', COUNT(*) FILTER (WHERE tla_id IS NULL OR tla_name IS NULL)::BIGINT,
        'Caveat detailed TLA reporting and map outputs'
    FROM vw_crash_reporting_base
    UNION ALL
    SELECT 4, 'Area unit / meshblock',
        COUNT(*) FILTER (WHERE area_unit_id IS NULL OR meshblock_id IS NULL)::BIGINT,
        'Use explicit completeness caveats for fine-grained geography'
    FROM vw_crash_reporting_base
)
SELECT
    risks.risk_order,
    risks.reporting_grain,
    total.records_checked,
    risks.affected_records,
    ROUND(100.0 * risks.affected_records / NULLIF(total.records_checked, 0), 4)
        AS affected_record_pct,
    risks.interpretation
FROM risks
CROSS JOIN total
ORDER BY risks.risk_order;

COPY aq_01_annual_yoy TO 'outputs/sql/aq_01_annual_yoy.csv' (HEADER, DELIMITER ',');
COPY aq_02_fatal_serious_share TO 'outputs/sql/aq_02_fatal_serious_share.csv' (HEADER, DELIMITER ',');
COPY aq_03_geographic_missingness_rank TO 'outputs/sql/aq_03_geographic_missingness_rank.csv' (HEADER, DELIMITER ',');
COPY aq_04_quality_issue_contribution TO 'outputs/sql/aq_04_quality_issue_contribution.csv' (HEADER, DELIMITER ',');
COPY aq_05_exception_trend TO 'outputs/sql/aq_05_exception_trend.csv' (HEADER, DELIMITER ',');
COPY aq_06_geographic_reporting_risk TO 'outputs/sql/aq_06_geographic_reporting_risk.csv' (HEADER, DELIMITER ',');
