-- Purpose: Apply traceable, reporting-focused data quality rules.
-- Input: stg_crashes
-- Output: dq_rule_catalog, dq_issue_detail, dq_check_results
-- Dialect: DuckDB 1.5.x

CREATE OR REPLACE TABLE dq_rule_catalog (
    check_id VARCHAR,
    check_name VARCHAR,
    check_category VARCHAR,
    issue_severity VARCHAR,
    reporting_impact VARCHAR,
    recommended_action VARCHAR
);

INSERT INTO dq_rule_catalog VALUES
    ('DQ-01', 'Crash ID is populated', 'completeness', 'critical', 'A missing crash ID prevents reliable record tracing.', 'Stop publication and investigate the source record.'),
    ('DQ-02', 'Crash ID is unique', 'uniqueness', 'critical', 'Duplicate IDs can double-count crashes and casualties.', 'Resolve duplicate keys before using aggregates.'),
    ('DQ-03', 'Injury counts are non-negative', 'validity', 'high', 'Negative casualty counts invalidate outcome metrics.', 'Correct or exclude invalid source records.'),
    ('DQ-04', 'Fatal severity agrees with fatal count', 'consistency', 'high', 'Severity and casualty measures could tell conflicting stories.', 'Review the source classification and casualty counts.'),
    ('DQ-05', 'Non-injury crashes have no fatal or serious counts', 'consistency', 'high', 'Serious outcomes could be hidden in a non-injury category.', 'Review source definitions before reporting severity.'),
    ('DQ-06', 'Crash year aligns with financial year', 'validity', 'high', 'Invalid periods can distort annual and financial-year trends.', 'Correct invalid periods before time-based reporting.'),
    ('DQ-07', 'Primary TLA reference is complete', 'completeness', 'medium', 'Incomplete TLA fields can misstate detailed geographic results.', 'Retain national totals and caveat or exclude affected local records.'),
    ('DQ-08', 'Fine geographic reference is complete', 'completeness', 'medium', 'Missing area-unit or meshblock values limit detailed mapping.', 'Use national reporting normally and caveat fine-grained geography.'),
    ('DQ-09', 'Crash severity uses an expected category', 'validity', 'high', 'Unexpected categories can fragment or omit severity totals.', 'Map new values explicitly before reporting.'),
    ('DQ-10', 'Region reference is populated', 'completeness', 'medium', 'Missing regions reduce completeness of subnational reporting.', 'Monitor the rate by year and caveat regional outputs.'),
    ('DQ-11', 'Non-injury crashes have no minor injury count', 'consistency', 'medium', 'Minor injury counts attached to non-injury crashes need definition review.', 'Keep as a monitored exception and avoid silent reclassification.'),
    ('DQ-12', 'Required injury counts are populated', 'completeness', 'high', 'Missing injury counts can understate casualties.', 'Review the record and document any retained exception.');

CREATE OR REPLACE TABLE dq_issue_detail AS
SELECT
    OBJECTID AS crash_id,
    'DQ-01' AS check_id,
    'Crash ID is populated' AS check_name,
    'completeness' AS check_category,
    'critical' AS issue_severity,
    'OBJECTID is missing' AS issue_description
FROM stg_crashes
WHERE OBJECTID IS NULL

UNION ALL

SELECT
    s.OBJECTID,
    'DQ-02',
    'Crash ID is unique',
    'uniqueness',
    'critical',
    'OBJECTID occurs more than once'
FROM stg_crashes AS s
INNER JOIN (
    SELECT OBJECTID
    FROM stg_crashes
    WHERE OBJECTID IS NOT NULL
    GROUP BY OBJECTID
    HAVING COUNT(*) > 1
) AS duplicates USING (OBJECTID)

UNION ALL

SELECT
    OBJECTID,
    'DQ-03',
    'Injury counts are non-negative',
    'validity',
    'high',
    'At least one injury count is negative'
FROM stg_crashes
WHERE COALESCE(fatalCount, 0) < 0
   OR COALESCE(seriousInjuryCount, 0) < 0
   OR COALESCE(minorInjuryCount, 0) < 0

UNION ALL

SELECT
    OBJECTID,
    'DQ-04',
    'Fatal severity agrees with fatal count',
    'consistency',
    'high',
    'Fatal severity and fatalCount disagree'
FROM stg_crashes
WHERE (lower(crashSeverity) LIKE '%fatal%' AND COALESCE(fatalCount, 0) < 1)
   OR (COALESCE(fatalCount, 0) >= 1 AND lower(COALESCE(crashSeverity, '')) NOT LIKE '%fatal%')

UNION ALL

SELECT
    OBJECTID,
    'DQ-05',
    'Non-injury crashes have no fatal or serious counts',
    'consistency',
    'high',
    'Non-injury crash has a fatal or serious injury count'
FROM stg_crashes
WHERE crashSeverity = 'Non-Injury Crash'
  AND (COALESCE(fatalCount, 0) > 0 OR COALESCE(seriousInjuryCount, 0) > 0)

UNION ALL

SELECT
    OBJECTID,
    'DQ-06',
    'Crash year aligns with financial year',
    'validity',
    'high',
    'crashYear or crashFinancialYear is invalid or misaligned'
FROM stg_crashes
WHERE crashYear IS NULL
   OR crashYear < 1900
   OR crashYear > year(CURRENT_DATE)
   OR NOT regexp_matches(trim(COALESCE(crashFinancialYear, '')), '^\d{4}/\d{4}$')
   OR try_cast(substr(trim(crashFinancialYear), 6, 4) AS INTEGER)
        - try_cast(substr(trim(crashFinancialYear), 1, 4) AS INTEGER) <> 1
   OR crashYear NOT IN (
        try_cast(substr(trim(crashFinancialYear), 1, 4) AS INTEGER),
        try_cast(substr(trim(crashFinancialYear), 6, 4) AS INTEGER)
   )

UNION ALL

SELECT
    OBJECTID,
    'DQ-07',
    'Primary TLA reference is complete',
    'completeness',
    'medium',
    'tlaId or tlaName is missing'
FROM stg_crashes
WHERE tlaId IS NULL OR tlaName IS NULL

UNION ALL

SELECT
    OBJECTID,
    'DQ-08',
    'Fine geographic reference is complete',
    'completeness',
    'medium',
    'areaUnitID or meshblockId is missing'
FROM stg_crashes
WHERE areaUnitID IS NULL OR meshblockId IS NULL

UNION ALL

SELECT
    OBJECTID,
    'DQ-09',
    'Crash severity uses an expected category',
    'validity',
    'high',
    'crashSeverity is null or outside the expected four-value domain'
FROM stg_crashes
WHERE crashSeverity IS NULL
   OR crashSeverity NOT IN ('Non-Injury Crash', 'Minor Crash', 'Serious Crash', 'Fatal Crash')

UNION ALL

SELECT
    OBJECTID,
    'DQ-10',
    'Region reference is populated',
    'completeness',
    'medium',
    'region is missing'
FROM stg_crashes
WHERE region IS NULL

UNION ALL

SELECT
    OBJECTID,
    'DQ-11',
    'Non-injury crashes have no minor injury count',
    'consistency',
    'medium',
    'Non-injury crash has minorInjuryCount above zero'
FROM stg_crashes
WHERE crashSeverity = 'Non-Injury Crash'
  AND COALESCE(fatalCount, 0) = 0
  AND COALESCE(seriousInjuryCount, 0) = 0
  AND COALESCE(minorInjuryCount, 0) > 0

UNION ALL

SELECT
    OBJECTID,
    'DQ-12',
    'Required injury counts are populated',
    'completeness',
    'high',
    'At least one required injury count is missing'
FROM stg_crashes
WHERE fatalCount IS NULL
   OR seriousInjuryCount IS NULL
   OR minorInjuryCount IS NULL;

CREATE OR REPLACE TABLE dq_check_results AS
WITH source_count AS (
    SELECT COUNT(*)::BIGINT AS records_checked
    FROM stg_crashes
), failure_counts AS (
    SELECT check_id, COUNT(*)::BIGINT AS failed_records
    FROM dq_issue_detail
    GROUP BY check_id
), scored AS (
    SELECT
        catalog.check_id,
        catalog.check_name,
        catalog.check_category,
        catalog.issue_severity,
        source_count.records_checked,
        COALESCE(failure_counts.failed_records, 0)::BIGINT AS failed_records,
        ROUND(
            1.0 * COALESCE(failure_counts.failed_records, 0)
            / NULLIF(source_count.records_checked, 0),
            8
        ) AS failure_rate,
        catalog.reporting_impact,
        catalog.recommended_action
    FROM dq_rule_catalog AS catalog
    CROSS JOIN source_count
    LEFT JOIN failure_counts USING (check_id)
)
SELECT
    check_id,
    check_name,
    check_category,
    issue_severity,
    records_checked,
    failed_records,
    failure_rate,
    CASE
        WHEN failed_records = 0 THEN 'PASS'
        WHEN check_id IN ('DQ-07', 'DQ-08', 'DQ-11') THEN 'REVIEW'
        WHEN check_id = 'DQ-10' THEN 'MONITOR'
        WHEN check_id = 'DQ-12' AND failed_records <= 1 THEN 'REVIEW'
        ELSE 'FAIL'
    END AS status,
    reporting_impact,
    recommended_action,
    CURRENT_TIMESTAMP AS run_timestamp
FROM scored
ORDER BY check_id;

COPY dq_check_results TO 'outputs/sql/quality_check_results.csv' (HEADER, DELIMITER ',');
