-- Purpose: Turn failed quality rules into a record-level review register.
-- Input: dq_issue_detail, dq_check_results, vw_crash_reporting_base
-- Output: vw_exception_register, dq_exception_summary
-- Dialect: DuckDB 1.5.x

CREATE OR REPLACE VIEW vw_exception_register AS
SELECT
    issues.crash_id,
    issues.check_id,
    issues.check_name,
    issues.check_category,
    issues.issue_severity,
    checks.status AS check_status,
    issues.issue_description,
    checks.reporting_impact,
    checks.recommended_action,
    crashes.crash_year,
    crashes.crash_financial_year,
    crashes.crash_severity,
    crashes.fatal_count,
    crashes.serious_injury_count,
    crashes.minor_injury_count,
    crashes.region,
    crashes.tla_id,
    crashes.tla_name,
    crashes.area_unit_id,
    crashes.meshblock_id,
    crashes.crash_location_1,
    crashes.crash_location_2
FROM dq_issue_detail AS issues
INNER JOIN dq_check_results AS checks USING (check_id)
LEFT JOIN vw_crash_reporting_base AS crashes
    ON issues.crash_id = crashes.crash_id;

CREATE OR REPLACE TABLE dq_exception_summary AS
SELECT
    check_id,
    check_name,
    check_category,
    issue_severity,
    check_status,
    COUNT(*)::BIGINT AS exception_rows,
    COUNT(DISTINCT crash_id)::BIGINT AS affected_records,
    MIN(crash_year) AS first_crash_year,
    MAX(crash_year) AS last_crash_year,
    COUNT(DISTINCT crash_year)::BIGINT AS affected_years
FROM vw_exception_register
GROUP BY
    check_id,
    check_name,
    check_category,
    issue_severity,
    check_status
ORDER BY affected_records DESC, check_id;

COPY dq_exception_summary TO 'outputs/sql/exception_summary.csv' (HEADER, DELIMITER ',');
COPY (SELECT * FROM vw_exception_register ORDER BY check_id, crash_year, crash_id)
TO 'outputs/sql/exception_register.csv' (HEADER, DELIMITER ',');
