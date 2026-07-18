-- Purpose: Load the public CAS CSV into a typed DuckDB staging table.
-- Input: data/raw/Crash_Analysis_System_(CAS)_data.csv
-- Output: stg_crashes, dq_source_control, dq_source_schema
-- Dialect: DuckDB 1.5.x

SET threads = 4;
SET preserve_insertion_order = false;

CREATE OR REPLACE TABLE stg_crashes AS
SELECT *
FROM read_csv_auto(
    'data/raw/Crash_Analysis_System_(CAS)_data.csv',
    header = true,
    nullstr = ['', 'NA', 'NULL'],
    sample_size = -1
);

CREATE OR REPLACE TABLE dq_source_control AS
SELECT
    'data/raw/Crash_Analysis_System_(CAS)_data.csv' AS source_file,
    COUNT(*)::BIGINT AS row_count,
    COUNT(DISTINCT OBJECTID)::BIGINT AS distinct_objectid_count,
    MIN(crashYear)::BIGINT AS min_crash_year,
    MAX(crashYear)::BIGINT AS max_crash_year,
    CURRENT_TIMESTAMP AS loaded_at
FROM stg_crashes;

CREATE OR REPLACE TABLE dq_source_schema AS
SELECT
    cid AS ordinal_position,
    name AS column_name,
    type AS data_type,
    "notnull" AS is_not_null_declared,
    dflt_value AS default_value,
    pk AS is_primary_key_declared
FROM pragma_table_info('stg_crashes')
ORDER BY cid;

CREATE OR REPLACE VIEW vw_crash_reporting_base AS
SELECT
    OBJECTID AS crash_id,
    crashYear AS crash_year,
    trim(crashFinancialYear) AS crash_financial_year,
    crashSeverity AS crash_severity,
    fatalCount AS fatal_count,
    seriousInjuryCount AS serious_injury_count,
    minorInjuryCount AS minor_injury_count,
    trim(region) AS region,
    tlaId AS tla_id,
    trim(tlaName) AS tla_name,
    areaUnitID AS area_unit_id,
    meshblockId AS meshblock_id,
    trim(crashLocation1) AS crash_location_1,
    trim(crashLocation2) AS crash_location_2,
    trim(crashSHDescription) AS crash_sh_description,
    X AS x_coordinate,
    Y AS y_coordinate,
    speedLimit AS speed_limit,
    NumberOfLanes AS number_of_lanes,
    roadCharacter AS road_character,
    roadLane AS road_lane,
    roadSurface AS road_surface,
    trafficControl AS traffic_control,
    urban,
    flatHill AS flat_hill,
    light,
    streetLight AS street_light,
    weatherA AS weather_a,
    weatherB AS weather_b,
    crashDirectionDescription AS crash_direction_description,
    directionRoleDescription AS direction_role_description
FROM stg_crashes;
