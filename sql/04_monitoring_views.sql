-- Purpose: Provide stable, documented grains for monitoring and Power BI consumption.
-- Input: vw_crash_reporting_base, dq_check_results, vw_exception_register
-- Output: six vw_* reporting views
-- Dialect: DuckDB 1.5.x

CREATE OR REPLACE VIEW vw_quality_check_summary AS
SELECT
    check_id,
    check_name,
    check_category,
    issue_severity,
    status,
    records_checked,
    failed_records,
    failure_rate,
    reporting_impact,
    recommended_action,
    run_timestamp
FROM dq_check_results;

CREATE OR REPLACE VIEW vw_annual_crash_monitoring AS
WITH annual AS (
    SELECT
        crash_year,
        COUNT(*)::BIGINT AS crash_count,
        SUM(COALESCE(fatal_count, 0))::BIGINT AS fatalities,
        SUM(COALESCE(serious_injury_count, 0))::BIGINT AS serious_injuries,
        SUM(COALESCE(minor_injury_count, 0))::BIGINT AS minor_injuries,
        COUNT(*) FILTER (WHERE crash_severity IN ('Fatal Crash', 'Serious Crash'))::BIGINT
            AS fatal_or_serious_crashes
    FROM vw_crash_reporting_base
    GROUP BY crash_year
), bounds AS (
    SELECT MAX(crash_year) AS latest_snapshot_year
    FROM annual
), with_prior AS (
    SELECT
        annual.*,
        annual.crash_year = bounds.latest_snapshot_year AS is_partial_period,
        LAG(crash_count) OVER (ORDER BY crash_year) AS prior_year_crash_count
    FROM annual
    CROSS JOIN bounds
)
SELECT
    crash_year,
    CASE WHEN is_partial_period THEN 'partial_snapshot_period' ELSE 'complete_period' END
        AS period_status,
    crash_count,
    prior_year_crash_count,
    CASE WHEN NOT is_partial_period THEN crash_count - prior_year_crash_count END
        AS yoy_crash_change,
    CASE WHEN NOT is_partial_period THEN
        ROUND(
            100.0 * (crash_count - prior_year_crash_count)
            / NULLIF(prior_year_crash_count, 0),
            2
        )
    END AS yoy_crash_change_pct,
    fatalities,
    serious_injuries,
    minor_injuries,
    fatal_or_serious_crashes,
    ROUND(100.0 * fatal_or_serious_crashes / NULLIF(crash_count, 0), 4)
        AS fatal_or_serious_crash_pct
FROM with_prior;

CREATE OR REPLACE VIEW vw_financial_year_monitoring AS
WITH annual AS (
    SELECT
        crash_financial_year,
        COUNT(*)::BIGINT AS crash_count,
        SUM(COALESCE(fatal_count, 0))::BIGINT AS fatalities,
        SUM(COALESCE(serious_injury_count, 0))::BIGINT AS serious_injuries,
        SUM(COALESCE(minor_injury_count, 0))::BIGINT AS minor_injuries
    FROM vw_crash_reporting_base
    GROUP BY crash_financial_year
), bounds AS (
    SELECT MAX(crash_financial_year) AS latest_snapshot_financial_year
    FROM annual
)
SELECT
    annual.*,
    CASE
        WHEN annual.crash_financial_year = bounds.latest_snapshot_financial_year
        THEN 'partial_snapshot_period'
        ELSE 'complete_period'
    END AS period_status,
    LAG(crash_count) OVER (ORDER BY crash_financial_year) AS prior_financial_year_crash_count
FROM annual
CROSS JOIN bounds;

CREATE OR REPLACE VIEW vw_severity_monitoring AS
WITH severity AS (
    SELECT
        crash_severity,
        COUNT(*)::BIGINT AS crash_count,
        SUM(COALESCE(fatal_count, 0))::BIGINT AS fatalities,
        SUM(COALESCE(serious_injury_count, 0))::BIGINT AS serious_injuries,
        SUM(COALESCE(minor_injury_count, 0))::BIGINT AS minor_injuries
    FROM vw_crash_reporting_base
    GROUP BY crash_severity
)
SELECT
    *,
    ROUND(100.0 * crash_count / SUM(crash_count) OVER (), 4) AS share_of_crashes_pct
FROM severity;

CREATE OR REPLACE VIEW vw_geographic_completeness AS
SELECT
    crash_year,
    COUNT(*)::BIGINT AS records_checked,
    COUNT(*) FILTER (WHERE region IS NULL)::BIGINT AS missing_region_records,
    COUNT(*) FILTER (WHERE tla_id IS NULL OR tla_name IS NULL)::BIGINT AS missing_tla_records,
    COUNT(*) FILTER (WHERE area_unit_id IS NULL OR meshblock_id IS NULL)::BIGINT
        AS missing_fine_geography_records,
    ROUND(100.0 * COUNT(*) FILTER (WHERE region IS NULL) / COUNT(*), 4)
        AS missing_region_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE tla_id IS NULL OR tla_name IS NULL) / COUNT(*), 4)
        AS missing_tla_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE area_unit_id IS NULL OR meshblock_id IS NULL)
        / COUNT(*),
        4
    ) AS missing_fine_geography_pct
FROM vw_crash_reporting_base
GROUP BY crash_year;

CREATE OR REPLACE VIEW vw_quality_monitoring_by_year AS
SELECT
    crashes.crash_year,
    COUNT(DISTINCT crashes.crash_id)::BIGINT AS total_records,
    COUNT(DISTINCT exceptions.crash_id)::BIGINT AS records_with_any_issue,
    COUNT(DISTINCT exceptions.crash_id) FILTER (WHERE exceptions.check_status = 'FAIL')::BIGINT
        AS records_with_failed_check,
    COUNT(DISTINCT exceptions.crash_id) FILTER (WHERE exceptions.check_status = 'REVIEW')::BIGINT
        AS records_for_review,
    COUNT(DISTINCT exceptions.crash_id) FILTER (WHERE exceptions.check_status = 'MONITOR')::BIGINT
        AS records_to_monitor
FROM vw_crash_reporting_base AS crashes
LEFT JOIN vw_exception_register AS exceptions
    ON crashes.crash_id = exceptions.crash_id
GROUP BY crashes.crash_year;

COPY (SELECT * FROM vw_quality_check_summary ORDER BY check_id)
TO 'outputs/sql/power_bi_quality_check_summary.csv' (HEADER, DELIMITER ',');
COPY (SELECT * FROM vw_annual_crash_monitoring ORDER BY crash_year)
TO 'outputs/sql/power_bi_annual_crash_monitoring.csv' (HEADER, DELIMITER ',');
COPY (SELECT * FROM vw_geographic_completeness ORDER BY crash_year)
TO 'outputs/sql/power_bi_geographic_completeness.csv' (HEADER, DELIMITER ',');
