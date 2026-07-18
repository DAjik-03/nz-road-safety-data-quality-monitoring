-- Purpose: Reconcile SQL results to the existing R baseline and enforce release gates.
-- Input: data/reference/*.csv and all SQL objects created earlier
-- Output: dq_reconciliation_*, dq_validation_results
-- Dialect: DuckDB 1.5.x

CREATE OR REPLACE TABLE dq_reconciliation_year AS
WITH expected AS (
    SELECT crashYear, records_n
    FROM read_csv_auto('data/reference/year_summary.csv', header = true)
), actual AS (
    SELECT crash_year AS crashYear, crash_count AS records_n
    FROM vw_annual_crash_monitoring
)
SELECT
    COALESCE(expected.crashYear, actual.crashYear) AS crash_year,
    expected.records_n AS r_records_n,
    actual.records_n AS sql_records_n,
    COALESCE(actual.records_n, 0) - COALESCE(expected.records_n, 0) AS difference,
    CASE WHEN expected.records_n = actual.records_n THEN 'PASS' ELSE 'FAIL' END AS status
FROM expected
FULL OUTER JOIN actual USING (crashYear)
ORDER BY crash_year;

CREATE OR REPLACE TABLE dq_reconciliation_financial_year AS
WITH expected AS (
    SELECT crashFinancialYear, records_n
    FROM read_csv_auto('data/reference/financial_year_summary.csv', header = true)
), actual AS (
    SELECT crash_financial_year AS crashFinancialYear, crash_count AS records_n
    FROM vw_financial_year_monitoring
)
SELECT
    COALESCE(expected.crashFinancialYear, actual.crashFinancialYear) AS crash_financial_year,
    expected.records_n AS r_records_n,
    actual.records_n AS sql_records_n,
    COALESCE(actual.records_n, 0) - COALESCE(expected.records_n, 0) AS difference,
    CASE WHEN expected.records_n = actual.records_n THEN 'PASS' ELSE 'FAIL' END AS status
FROM expected
FULL OUTER JOIN actual USING (crashFinancialYear)
ORDER BY crash_financial_year;

CREATE OR REPLACE TABLE dq_reconciliation_missingness AS
WITH expected AS (
    SELECT column_name, missing_count
    FROM read_csv_auto('data/reference/core_field_missingness_summary.csv', header = true)
), actual AS (
    SELECT column_name, missing_count
    FROM dq_core_field_profile
)
SELECT
    COALESCE(expected.column_name, actual.column_name) AS column_name,
    expected.missing_count AS r_missing_count,
    actual.missing_count AS sql_missing_count,
    COALESCE(actual.missing_count, 0) - COALESCE(expected.missing_count, 0) AS difference,
    CASE WHEN expected.missing_count = actual.missing_count THEN 'PASS' ELSE 'FAIL' END AS status
FROM expected
FULL OUTER JOIN actual USING (column_name)
ORDER BY column_name;

CREATE OR REPLACE TABLE dq_reconciliation_severity AS
WITH expected AS (
    SELECT
        crashSeverity,
        records_n,
        fatalCount_sum,
        seriousInjuryCount_sum,
        minorInjuryCount_sum
    FROM read_csv_auto('data/reference/severity_distribution_summary.csv', header = true)
), actual AS (
    SELECT
        crash_severity AS crashSeverity,
        crash_count AS records_n,
        fatalities AS fatalCount_sum,
        serious_injuries AS seriousInjuryCount_sum,
        minor_injuries AS minorInjuryCount_sum
    FROM vw_severity_monitoring
)
SELECT
    COALESCE(expected.crashSeverity, actual.crashSeverity) AS crash_severity,
    expected.records_n AS r_records_n,
    actual.records_n AS sql_records_n,
    COALESCE(actual.records_n, 0) - COALESCE(expected.records_n, 0) AS record_difference,
    COALESCE(actual.fatalCount_sum, 0) - COALESCE(expected.fatalCount_sum, 0) AS fatality_difference,
    COALESCE(actual.seriousInjuryCount_sum, 0) - COALESCE(expected.seriousInjuryCount_sum, 0) AS serious_injury_difference,
    COALESCE(actual.minorInjuryCount_sum, 0) - COALESCE(expected.minorInjuryCount_sum, 0) AS minor_injury_difference,
    CASE
        WHEN expected.records_n = actual.records_n
         AND expected.fatalCount_sum = actual.fatalCount_sum
         AND expected.seriousInjuryCount_sum = actual.seriousInjuryCount_sum
         AND expected.minorInjuryCount_sum = actual.minorInjuryCount_sum
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM expected
FULL OUTER JOIN actual USING (crashSeverity)
ORDER BY crash_severity;

CREATE OR REPLACE TABLE dq_validation_results AS
SELECT 'T-001' AS test_id, 'Source row count is preserved' AS test_name,
    '913464' AS expected, CAST((SELECT row_count FROM dq_source_control) AS VARCHAR) AS actual,
    CASE WHEN (SELECT row_count FROM dq_source_control) = 913464 THEN 'PASS' ELSE 'FAIL' END AS status,
    'Exact match required' AS notes
UNION ALL
SELECT 'T-002', 'Annual totals reconcile to R', '0 mismatched years',
    CAST((SELECT COUNT(*) FROM dq_reconciliation_year WHERE status = 'FAIL') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_reconciliation_year WHERE status = 'FAIL') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'All year-level counts must match'
UNION ALL
SELECT 'T-003', 'Financial-year totals reconcile to R', '0 mismatched financial years',
    CAST((SELECT COUNT(*) FROM dq_reconciliation_financial_year WHERE status = 'FAIL') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_reconciliation_financial_year WHERE status = 'FAIL') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'All financial-year counts must match'
UNION ALL
SELECT 'T-004', 'Core-field missingness reconciles to R', '0 mismatched fields',
    CAST((SELECT COUNT(*) FROM dq_reconciliation_missingness WHERE status = 'FAIL') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_reconciliation_missingness WHERE status = 'FAIL') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'Missing counts must match exactly'
UNION ALL
SELECT 'T-005', 'Severity totals reconcile to R', '0 mismatched severity groups',
    CAST((SELECT COUNT(*) FROM dq_reconciliation_severity WHERE status = 'FAIL') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_reconciliation_severity WHERE status = 'FAIL') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'Crash and casualty totals must match exactly'
UNION ALL
SELECT 'T-006', 'Crash ID remains unique', '0 duplicate ID rows',
    CAST((SELECT failed_records FROM dq_check_results WHERE check_id = 'DQ-02') AS VARCHAR),
    CASE WHEN (SELECT failed_records FROM dq_check_results WHERE check_id = 'DQ-02') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'Duplicate IDs are a release blocker'
UNION ALL
SELECT 'T-007', 'No blocking quality rule fails', '0 failed checks',
    CAST((SELECT COUNT(*) FROM dq_check_results WHERE status = 'FAIL') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_check_results WHERE status = 'FAIL') = 0 THEN 'PASS' ELSE 'FAIL' END,
    'Documented REVIEW and MONITOR results are allowed'
UNION ALL
SELECT 'T-008', 'At least eight quality rules exist', '>= 8 rules',
    CAST((SELECT COUNT(*) FROM dq_check_results) AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_check_results) >= 8 THEN 'PASS' ELSE 'FAIL' END,
    'Portfolio scope requires meaningful rule coverage'
UNION ALL
SELECT 'T-009', 'At least four reporting views exist', '>= 4 views',
    CAST((SELECT COUNT(*) FROM duckdb_views() WHERE view_name LIKE 'vw_%') AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM duckdb_views() WHERE view_name LIKE 'vw_%') >= 4 THEN 'PASS' ELSE 'FAIL' END,
    'Views must expose stable reporting grains'
UNION ALL
SELECT 'T-010', 'Known 2005 Auckland injury-count exception is detected', '1 record',
    CAST((SELECT COUNT(DISTINCT crash_id) FROM vw_exception_register
          WHERE check_id = 'DQ-12' AND crash_year = 2005 AND tla_name = 'Auckland') AS VARCHAR),
    CASE WHEN (SELECT COUNT(DISTINCT crash_id) FROM vw_exception_register
               WHERE check_id = 'DQ-12' AND crash_year = 2005 AND tla_name = 'Auckland') = 1
         THEN 'PASS' ELSE 'FAIL' END,
    'Confirms record-level traceability to the documented exception'
UNION ALL
SELECT 'T-011', 'Source column count matches the reviewed extract', '72 columns',
    CAST((SELECT COUNT(*) FROM dq_source_schema) AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM dq_source_schema) = 72 THEN 'PASS' ELSE 'FAIL' END,
    'Schema drift requires review'
UNION ALL
SELECT 'T-012', 'Annual monitoring view is populated', '> 0 rows',
    CAST((SELECT COUNT(*) FROM vw_annual_crash_monitoring) AS VARCHAR),
    CASE WHEN (SELECT COUNT(*) FROM vw_annual_crash_monitoring) > 0 THEN 'PASS' ELSE 'FAIL' END,
    'Empty reporting outputs are a release blocker';

COPY dq_reconciliation_year TO 'outputs/sql/reconciliation_year.csv' (HEADER, DELIMITER ',');
COPY dq_reconciliation_financial_year TO 'outputs/sql/reconciliation_financial_year.csv' (HEADER, DELIMITER ',');
COPY dq_reconciliation_missingness TO 'outputs/sql/reconciliation_missingness.csv' (HEADER, DELIMITER ',');
COPY dq_reconciliation_severity TO 'outputs/sql/reconciliation_severity.csv' (HEADER, DELIMITER ',');
COPY dq_validation_results TO 'outputs/sql/validation_results.csv' (HEADER, DELIMITER ',');

SELECT * FROM dq_validation_results ORDER BY test_id;

SELECT CASE
    WHEN COUNT(*) = 0 THEN 'All release-blocking validation tests passed.'
    ELSE error('One or more release-blocking validation tests failed. Review outputs/sql/validation_results.csv.')
END AS validation_gate
FROM dq_validation_results
WHERE status = 'FAIL';
