# SQL validation and reporting layer

## Purpose

This extension shows how the existing NZ road-safety review can be reproduced as an analytical SQL workflow: load the public CAS extract, profile the source, apply rule-based checks, trace exceptions, build reporting views and reconcile the results with the independent R baseline.

The implementation uses **DuckDB SQL with transferable analytical SQL patterns**. It does not claim SQL Server or production database experience.

## Quick review

If you have three minutes, review these files in order:

1. [`02_quality_checks.sql`](02_quality_checks.sql) - 12 traceable rules with business impact and treatment.
2. [`03_exception_register.sql`](03_exception_register.sql) - drill-through from a failed rule to source records.
3. [`04_monitoring_views.sql`](04_monitoring_views.sql) - stable reporting grains for Power BI.
4. [`06_validation_tests.sql`](06_validation_tests.sql) - exact R-SQL reconciliation and release gates.
5. [`../docs/sql_reconciliation.md`](../docs/sql_reconciliation.md) - verified results and remaining caveats.

## Environment

- DuckDB CLI 1.5.x; validated with 1.5.4
- approximately 300 MB of free working space
- source CSV prepared as described in [`../data/README.md`](../data/README.md)

DuckDB installation: https://duckdb.org/install/

## Run the project

From the repository root:

```powershell
duckdb road_safety.duckdb -c ".read sql/run_all.sql"
```

Or on Windows PowerShell:

```powershell
.\scripts\run_sql.ps1
```

On macOS or Linux:

```bash
./scripts/run_sql.sh
```

The reviewed 913,464-row snapshot executes in roughly 15-30 seconds on a typical local machine. The command is idempotent: rerunning it replaces generated tables and views and refreshes the CSV evidence.

The latest crash year and financial year in the snapshot are marked `partial_snapshot_period`. Year-over-year change is intentionally suppressed for the partial crash year to avoid comparing an incomplete period with a complete year.

## Execution order

| File | Purpose | Main outputs |
|---|---|---|
| `00_setup.sql` | Load and type the source | `stg_crashes`, source/schema controls |
| `01_data_profiling.sql` | Profile structure and core fields | field, category, year and missingness profiles |
| `02_quality_checks.sql` | Apply rule-based checks | `dq_issue_detail`, `dq_check_results` |
| `03_exception_register.sql` | Add source context to failures | `vw_exception_register`, exception summary |
| `04_monitoring_views.sql` | Build reporting layers | annual, FY, severity, geography and quality views |
| `05_analysis_queries.sql` | Answer six business questions | `aq_01` to `aq_06` and CSV results |
| `06_validation_tests.sql` | Reconcile and enforce gates | comparison tables and 12 release tests |

## Quality rules

| ID | Rule | Current result |
|---|---|---|
| DQ-01 | Crash ID populated | PASS |
| DQ-02 | Crash ID unique | PASS |
| DQ-03 | Injury counts non-negative | PASS |
| DQ-04 | Fatal severity agrees with fatal count | PASS |
| DQ-05 | Non-injury crashes have no fatal/serious counts | PASS |
| DQ-06 | Crash year aligns with financial year | PASS |
| DQ-07 | Primary TLA reference complete | REVIEW - 5 records |
| DQ-08 | Fine geographic reference complete | REVIEW - 4 records |
| DQ-09 | Expected crash-severity domain | PASS |
| DQ-10 | Region populated | MONITOR - 3,474 records (0.3803%) |
| DQ-11 | Non-injury crashes have no minor count | REVIEW - 56 records |
| DQ-12 | Required injury counts populated | REVIEW - 1 record |

`failure_rate` is stored as a proportion. For example, `0.00380311` should be displayed as approximately `0.3803%`.

## Representative business questions

| View | Business question | SQL pattern |
|---|---|---|
| `aq_01_annual_yoy` | How did annual crash counts change year over year? | CTE + `LAG` |
| `aq_02_fatal_serious_share` | What share of crashes were fatal or serious? | conditional aggregation |
| `aq_03_geographic_missingness_rank` | Which years have the highest detailed-geography missingness? | conditional aggregation + `RANK` |
| `aq_04_quality_issue_contribution` | Which rules contribute most rule failures? | window `SUM` + `DENSE_RANK` |
| `aq_05_exception_trend` | Are exceptions concentrated in particular periods? | grouped trend |
| `aq_06_geographic_reporting_risk` | Which reporting grains require caveats? | multi-level completeness comparison |

## Validation

All 12 release tests currently pass. SQL matches the R baseline exactly for:

- 913,464 total rows and 913,464 distinct crash IDs
- every annual and financial-year crash total
- every selected core-field missing count
- crash and casualty totals for all four severity groups
- the documented one-record 2005 Auckland injury-count exception

See [`../docs/sql_reconciliation.md`](../docs/sql_reconciliation.md) and `../outputs/sql/validation_results.csv` for the audit trail.

## Power BI handoff

The run exports compact CSVs for quality status, annual monitoring and geographic completeness. See [`../docs/power_bi_sql_connection.md`](../docs/power_bi_sql_connection.md) for grain, formatting and validation guidance.

## Limitations

- Results apply to the reviewed snapshot and can change when NZTA refreshes the public extract.
- The 2026 crash year and 2025/2026 financial year are partial in this snapshot and must not be interpreted as complete-period trends.
- CAS records crashes reported to NZ Police; the project does not claim complete capture of all crashes.
- Low-volume geographic exceptions do not materially change national totals but matter more for local or map-based reporting.
- The repository does not contain the original PBIX file, so the SQL-to-Power BI handoff is supplied as validated CSVs and a connection specification.
