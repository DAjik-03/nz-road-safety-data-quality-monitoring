-- Purpose: Execute the complete DuckDB validation and reporting workflow.
-- Dialect: DuckDB SQL plus DuckDB CLI dot commands.
-- Run from repository root:
--   duckdb road_safety.duckdb -c ".read sql/run_all.sql"

.bail on
.timer on

.print '01/07 - Loading and standardising the source extract'
.read sql/00_setup.sql

.print '02/07 - Profiling source structure and completeness'
.read sql/01_data_profiling.sql

.print '03/07 - Running rule-based data quality checks'
.read sql/02_quality_checks.sql

.print '04/07 - Building the record-level exception register'
.read sql/03_exception_register.sql

.print '05/07 - Building monitoring and reporting views'
.read sql/04_monitoring_views.sql

.print '06/07 - Answering representative business questions'
.read sql/05_analysis_queries.sql

.print '07/07 - Reconciling SQL results with the R baseline'
.read sql/06_validation_tests.sql

.print 'SQL validation and reporting layer completed successfully.'
