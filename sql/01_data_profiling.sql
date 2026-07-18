-- Purpose: Profile source structure, date coverage, uniqueness and core-field completeness.
-- Input: stg_crashes, dq_source_schema
-- Output: dq_field_inventory, dq_core_field_profile, dq_category_profile
-- Dialect: DuckDB 1.5.x

CREATE OR REPLACE TABLE dq_field_inventory AS
SELECT
    ordinal_position,
    column_name,
    data_type,
    is_not_null_declared
FROM dq_source_schema
ORDER BY ordinal_position;

CREATE OR REPLACE TABLE dq_core_field_profile AS
WITH profile AS (
    SELECT 'OBJECTID' AS column_name, COUNT(*) AS total_rows, COUNT(*) FILTER (WHERE OBJECTID IS NULL) AS missing_count, COUNT(DISTINCT OBJECTID) AS distinct_count FROM stg_crashes
    UNION ALL SELECT 'X', COUNT(*), COUNT(*) FILTER (WHERE X IS NULL), COUNT(DISTINCT X) FROM stg_crashes
    UNION ALL SELECT 'Y', COUNT(*), COUNT(*) FILTER (WHERE Y IS NULL), COUNT(DISTINCT Y) FROM stg_crashes
    UNION ALL SELECT 'areaUnitID', COUNT(*), COUNT(*) FILTER (WHERE areaUnitID IS NULL), COUNT(DISTINCT areaUnitID) FROM stg_crashes
    UNION ALL SELECT 'meshblockId', COUNT(*), COUNT(*) FILTER (WHERE meshblockId IS NULL), COUNT(DISTINCT meshblockId) FROM stg_crashes
    UNION ALL SELECT 'crashYear', COUNT(*), COUNT(*) FILTER (WHERE crashYear IS NULL), COUNT(DISTINCT crashYear) FROM stg_crashes
    UNION ALL SELECT 'crashFinancialYear', COUNT(*), COUNT(*) FILTER (WHERE crashFinancialYear IS NULL), COUNT(DISTINCT crashFinancialYear) FROM stg_crashes
    UNION ALL SELECT 'region', COUNT(*), COUNT(*) FILTER (WHERE region IS NULL), COUNT(DISTINCT region) FROM stg_crashes
    UNION ALL SELECT 'tlaId', COUNT(*), COUNT(*) FILTER (WHERE tlaId IS NULL), COUNT(DISTINCT tlaId) FROM stg_crashes
    UNION ALL SELECT 'tlaName', COUNT(*), COUNT(*) FILTER (WHERE tlaName IS NULL), COUNT(DISTINCT tlaName) FROM stg_crashes
    UNION ALL SELECT 'crashLocation1', COUNT(*), COUNT(*) FILTER (WHERE crashLocation1 IS NULL), COUNT(DISTINCT crashLocation1) FROM stg_crashes
    UNION ALL SELECT 'crashLocation2', COUNT(*), COUNT(*) FILTER (WHERE crashLocation2 IS NULL), COUNT(DISTINCT crashLocation2) FROM stg_crashes
    UNION ALL SELECT 'crashSHDescription', COUNT(*), COUNT(*) FILTER (WHERE crashSHDescription IS NULL), COUNT(DISTINCT crashSHDescription) FROM stg_crashes
    UNION ALL SELECT 'crashSeverity', COUNT(*), COUNT(*) FILTER (WHERE crashSeverity IS NULL), COUNT(DISTINCT crashSeverity) FROM stg_crashes
    UNION ALL SELECT 'fatalCount', COUNT(*), COUNT(*) FILTER (WHERE fatalCount IS NULL), COUNT(DISTINCT fatalCount) FROM stg_crashes
    UNION ALL SELECT 'seriousInjuryCount', COUNT(*), COUNT(*) FILTER (WHERE seriousInjuryCount IS NULL), COUNT(DISTINCT seriousInjuryCount) FROM stg_crashes
    UNION ALL SELECT 'minorInjuryCount', COUNT(*), COUNT(*) FILTER (WHERE minorInjuryCount IS NULL), COUNT(DISTINCT minorInjuryCount) FROM stg_crashes
    UNION ALL SELECT 'speedLimit', COUNT(*), COUNT(*) FILTER (WHERE speedLimit IS NULL), COUNT(DISTINCT speedLimit) FROM stg_crashes
    UNION ALL SELECT 'NumberOfLanes', COUNT(*), COUNT(*) FILTER (WHERE NumberOfLanes IS NULL), COUNT(DISTINCT NumberOfLanes) FROM stg_crashes
    UNION ALL SELECT 'roadCharacter', COUNT(*), COUNT(*) FILTER (WHERE roadCharacter IS NULL), COUNT(DISTINCT roadCharacter) FROM stg_crashes
    UNION ALL SELECT 'roadLane', COUNT(*), COUNT(*) FILTER (WHERE roadLane IS NULL), COUNT(DISTINCT roadLane) FROM stg_crashes
    UNION ALL SELECT 'roadSurface', COUNT(*), COUNT(*) FILTER (WHERE roadSurface IS NULL), COUNT(DISTINCT roadSurface) FROM stg_crashes
    UNION ALL SELECT 'trafficControl', COUNT(*), COUNT(*) FILTER (WHERE trafficControl IS NULL), COUNT(DISTINCT trafficControl) FROM stg_crashes
    UNION ALL SELECT 'urban', COUNT(*), COUNT(*) FILTER (WHERE urban IS NULL), COUNT(DISTINCT urban) FROM stg_crashes
    UNION ALL SELECT 'flatHill', COUNT(*), COUNT(*) FILTER (WHERE flatHill IS NULL), COUNT(DISTINCT flatHill) FROM stg_crashes
    UNION ALL SELECT 'light', COUNT(*), COUNT(*) FILTER (WHERE light IS NULL), COUNT(DISTINCT light) FROM stg_crashes
    UNION ALL SELECT 'streetLight', COUNT(*), COUNT(*) FILTER (WHERE streetLight IS NULL), COUNT(DISTINCT streetLight) FROM stg_crashes
    UNION ALL SELECT 'weatherA', COUNT(*), COUNT(*) FILTER (WHERE weatherA IS NULL), COUNT(DISTINCT weatherA) FROM stg_crashes
    UNION ALL SELECT 'weatherB', COUNT(*), COUNT(*) FILTER (WHERE weatherB IS NULL), COUNT(DISTINCT weatherB) FROM stg_crashes
    UNION ALL SELECT 'crashDirectionDescription', COUNT(*), COUNT(*) FILTER (WHERE crashDirectionDescription IS NULL), COUNT(DISTINCT crashDirectionDescription) FROM stg_crashes
    UNION ALL SELECT 'directionRoleDescription', COUNT(*), COUNT(*) FILTER (WHERE directionRoleDescription IS NULL), COUNT(DISTINCT directionRoleDescription) FROM stg_crashes
)
SELECT
    column_name,
    total_rows::BIGINT AS total_rows,
    missing_count::BIGINT AS missing_count,
    ROUND(100.0 * missing_count / NULLIF(total_rows, 0), 4) AS missing_pct,
    distinct_count::BIGINT AS distinct_count
FROM profile
ORDER BY missing_pct DESC, column_name;

CREATE OR REPLACE TABLE dq_category_profile AS
SELECT
    'crashSeverity' AS column_name,
    COALESCE(crashSeverity, '<NULL>') AS category_value,
    COUNT(*)::BIGINT AS records_n,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS record_pct
FROM stg_crashes
GROUP BY crashSeverity
ORDER BY records_n DESC;

CREATE OR REPLACE TABLE dq_year_profile AS
SELECT
    crashYear AS crash_year,
    COUNT(*)::BIGINT AS records_n
FROM stg_crashes
GROUP BY crashYear
ORDER BY crashYear;

CREATE OR REPLACE TABLE dq_financial_year_profile AS
SELECT
    trim(crashFinancialYear) AS crash_financial_year,
    COUNT(*)::BIGINT AS records_n
FROM stg_crashes
GROUP BY trim(crashFinancialYear)
ORDER BY crash_financial_year;

COPY dq_core_field_profile TO 'outputs/sql/core_field_profile.csv' (HEADER, DELIMITER ',');
COPY dq_category_profile TO 'outputs/sql/category_profile.csv' (HEADER, DELIMITER ',');
