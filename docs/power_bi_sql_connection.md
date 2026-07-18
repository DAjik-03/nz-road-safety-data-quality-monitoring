# Power BI connection to SQL outputs

## Minimum connection

The SQL workflow exports three Power BI-ready files:

| File | Grain | Recommended use |
|---|---|---|
| `outputs/sql/power_bi_quality_check_summary.csv` | one row per quality rule | Status cards, failure rate and issue summary |
| `outputs/sql/power_bi_annual_crash_monitoring.csv` | one row per crash year | Crash, casualty and year-over-year monitoring |
| `outputs/sql/power_bi_geographic_completeness.csv` | one row per crash year | Geographic completeness caveat and trend |

Connect at least the first two files to the existing summary page. The third file supports the established geographic caveat.

## Validation checks in Power BI

- Annual crash totals must match `vw_annual_crash_monitoring` and the R annual baseline.
- Filter or visibly label `partial_snapshot_period`; do not compare it as a complete year or financial year.
- `failure_rate` is stored as a proportion and should be formatted as a percentage.
- `crash_year` and `crash_financial_year` must remain separate dimensions.
- Quality-rule counts are rule failures, not unique crash counts; use the exception register when a unique-record measure is required.
- Detailed geography visuals must keep the missing-reference caveat visible.

## Current artifact boundary

The repository contains a screenshot of the existing Power BI summary but no `.pbix` source file. The SQL exports and mapping above complete the reproducible data handoff; updating the visual file itself requires the original PBIX in Power BI Desktop.
