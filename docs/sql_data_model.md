# SQL data model

## Flow

```text
Public CAS CSV
    -> stg_crashes
    -> profiling and source controls
    -> dq_issue_detail + dq_check_results
    -> vw_exception_register
    -> monitoring views
    -> analysis views and Power BI CSV outputs
    -> R-SQL reconciliation tests
```

## Core objects and grain

| Object | Type | Grain | Purpose |
|---|---|---|---|
| `stg_crashes` | table | one row per source crash record | Typed copy of the reviewed CSV snapshot |
| `dq_source_control` | table | one row per run | Row, ID and year-range controls |
| `dq_core_field_profile` | table | one row per profiled field | Missingness and cardinality evidence |
| `dq_issue_detail` | table | crash record x failed rule | Record-level traceability |
| `dq_check_results` | table | one row per quality rule | PASS, REVIEW, MONITOR or FAIL summary |
| `vw_exception_register` | view | crash record x failed rule | Drill-through context and recommended action |
| `vw_annual_crash_monitoring` | view | one row per crash year | Annual totals, outcomes and year-over-year change |
| `vw_financial_year_monitoring` | view | one row per financial year | Financial-year totals and prior-period comparison |
| `vw_severity_monitoring` | view | one row per severity category | Crash and casualty totals by severity |
| `vw_geographic_completeness` | view | one row per crash year | Region, TLA and fine-geography completeness |
| `dq_validation_results` | table | one row per release test | Reconciliation and release gate |

## Naming

- `stg_`: source-near staging object
- `dq_`: data-quality, profiling, exception or validation object
- `vw_`: stable reporting-consumption view
- `aq_`: representative analytical question

Source column names are preserved in `stg_crashes` so the SQL remains auditable against the CSV and R code. `vw_crash_reporting_base` provides snake-case aliases for downstream SQL.
