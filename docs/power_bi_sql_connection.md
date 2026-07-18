# Power BI connection to SQL outputs

## Minimum connection

The SQL workflow exports three Power BI-ready files:

| File | Grain | Recommended use |
|---|---|---|
| `outputs/sql/power_bi_quality_check_summary.csv` | one row per quality rule | Status cards, failure rate and issue summary |
| `outputs/sql/power_bi_annual_crash_monitoring.csv` | one row per crash year | Crash, casualty and year-over-year monitoring |
| `outputs/sql/power_bi_geographic_completeness.csv` | one row per crash year | Geographic completeness caveat and trend |

Connect at least the first two files to the existing summary page. The third file supports the established geographic caveat.

## Completed Power BI connection

The local Power BI report now includes a dedicated `SQL Monitoring` page connected to the first two handoff files:

- `SQL Quality Checks` uses `power_bi_quality_check_summary.csv`.
- `SQL Annual Monitoring` uses `power_bi_annual_crash_monitoring.csv`.
- The annual line chart filters to `period_status = complete_period`, so the partial 2026 snapshot is excluded from the trend comparison.
- The rule-outcome chart shows 7 PASS, 4 REVIEW and 1 MONITOR rule.
- The KPI cards show 913,464 records reviewed, 12 quality rules tested and 5 checks requiring attention.

The validated report page is published as `assets/pbi_sql_monitoring_screenshot.png`.

## Visual evidence generated from the handoff

The repository includes two visuals generated directly from the first two handoff files:

| SQL output | Generated visual | Review purpose |
|---|---|---|
| `power_bi_quality_check_summary.csv` | `assets/sql_quality_check_exceptions.png` | Compare the five checks with non-zero exceptions and retain PASS/REVIEW/MONITOR context |
| `power_bi_annual_crash_monitoring.csv` | `assets/sql_annual_crash_monitoring.png` | Review the annual crash trend across complete periods while excluding the partial 2026 snapshot |

Run `Rscript scripts/05_sql_portfolio_figures.R` from the repository root to regenerate both images. This provides reproducible visual evidence from the same compact files prepared for Power BI.

## Validation checks in Power BI

- Annual crash totals must match `vw_annual_crash_monitoring` and the R annual baseline.
- Filter or visibly label `partial_snapshot_period`; do not compare it as a complete year or financial year.
- `failure_rate` is stored as a proportion and should be formatted as a percentage.
- `crash_year` and `crash_financial_year` must remain separate dimensions.
- Quality-rule counts are rule failures, not unique crash counts; use the exception register when a unique-record measure is required.
- Detailed geography visuals must keep the missing-reference caveat visible.

## Current artifact boundary

The local PBIX was updated and validated in Power BI Desktop. The binary is intentionally not committed; the repository publishes the validated screenshot, source CSVs, field mapping and regeneration path without exposing machine-specific connections.
