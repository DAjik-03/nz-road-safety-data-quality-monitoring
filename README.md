# NZ Road Safety Data Quality Review for Reporting and Monitoring

A portfolio project showing how a junior analyst can review whether a public dataset is reliable enough for recurring reporting before producing stakeholder-facing outputs.

![Power BI summary view](assets/pbi_main_summary_screenshot.png)

## Project in one sentence

I reviewed publicly available NZ road safety crash data to assess whether it was suitable for reporting and monitoring use, then turned the findings into practical outputs including summary tables, a Power BI summary view, an Excel export, and a clear written reporting position.

## What business problem this project simulates

This project simulates a practical analyst task:

Before a team uses a dataset for recurring monitoring or stakeholder-facing reporting, someone needs to check whether the source data is complete enough, consistent enough, and usable enough to support safe interpretation.

Rather than starting with trend analysis, this project focuses on validating the source data first, identifying issues that could affect reporting, and documenting what the dataset can and cannot safely support.

## Who this project is for

This project is framed as if the audience were:

- an analyst preparing recurring monitoring outputs
- a reporting lead reviewing whether a dataset is safe to use
- a stakeholder who needs a clear summary of reporting risks, caveats, and usable outputs

## Tools used

- **R** for field inventory, quality checks, exception review, and summary-table generation
- **Excel** for stakeholder-friendly supporting export
- **Power BI** for a summary reporting view
- **GitHub** for project structure, documentation, and portfolio presentation

## Outputs produced

- field inventory and missingness review
- data quality validation checks
- exception review for flagged issues
- monitoring-ready summary tables
- Power BI summary view
- stakeholder-friendly Excel export
- concise written reporting position and caveats

## Key result

The reviewed extract was assessed as **fit for Version 1 monitoring use**, with targeted caveats rather than broad structural reliability concerns.

In practical terms, the current extract appears suitable for:

- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing interpretation with clear caveats

## Main caveat

The main residual caveat is a small number of incomplete geographic reference records, including fields such as:

- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This is unlikely to materially affect:

- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, more caution is appropriate where reporting becomes more geographically detailed, including:

- TLA-level reporting
- area-unit or meshblock-linked analysis
- map-based outputs
- tightly scoped local-area summaries

A separate isolated historical exception also remains on record:
one 2005 Auckland record with missing `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`.

Because it is isolated and low-volume, it is retained as a monitored exception rather than treated as a broader reporting concern.

## Data reviewed

**Primary working file**
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

**Reviewed extract profile**
- Rows: 913,464
- Columns: 72

## What a reviewer should look at first

If you are reviewing this repository quickly, start with:

- `assets/pbi_main_summary_screenshot.png`
- `assets/portfolio_snapshot_onepager.png`
- `docs/final_reporting_position.md`
- `docs/monitoring_summary.md`
- `outputs/excel/nz-road-safety-monitoring-supporting-export.xlsx`

## Workflow overview

The project follows a practical reporting-readiness workflow:

1. **Field inventory**
   - review raw extract structure, missingness, and date coverage

2. **Quality validation**
   - apply completeness, validity, consistency, and uniqueness checks

3. **Targeted exception review**
   - review flagged issues that may affect reporting interpretation

4. **Monitoring output preparation**
   - convert validation outputs into monitoring-ready summary tables

5. **Reporting position and caveat documentation**
   - summarise what the dataset can support and where caution is still needed

## Key project files

### Scripts
- `scripts/01_field_inventory.R`
- `scripts/02_quality_checks.R`
- `scripts/02a_review_severity_conflicts.R`
- `scripts/03_exception_review_and_monitoring_layer.R`
- `scripts/04_static_figures.R`

### Presentation assets
- `assets/portfolio_snapshot_onepager.png`
- `assets/project_workflow_diagram.png`
- `assets/pbi_main_summary_screenshot.png`

### Outputs
- `outputs/tables/`
- `outputs/figures/`
- `outputs/excel/nz-road-safety-monitoring-supporting-export.xlsx`

### Supporting documentation
- `docs/final_reporting_position.md`
- `docs/monitoring_summary.md`
- `docs/stakeholder_brief.md`
- `docs/stakeholder_issue_register_final.md`
- `docs/methodology.md`
- `docs/assumptions_and_limitations.md`
- `docs/data_dictionary.md`
- `docs/data_sources.md`

---

## Repository Structure

```text
nz-road-safety-data-quality-monitoring/
│
├── assets/
│   ├── portfolio_snapshot_onepager.png
│   ├── project_workflow_diagram.png
│   └── pbi_main_summary_screenshot.png
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── reference/
│
├── scripts/
│   ├── 01_field_inventory.R
│   ├── 02_quality_checks.R
│   ├── 02a_review_severity_conflicts.R
│   ├── 03_exception_review_and_monitoring_layer.R
│   └── 04_static_figures.R
│
├── outputs/
│   ├── tables/
│   ├── figures/
│   │   ├── fig_01_v1_validation_to_monitoring_workflow.png
│   │   ├── fig_02_validation_outcome_summary.png
│   │   ├── fig_03_quality_monitoring_annual_fy_issue_coverage.png
│   │   └── fig_04_geographic_completeness_caveat_matrix.png
│   └── excel/
│       └── nz-road-safety-monitoring-supporting-export.xlsx
│
└── docs/
    ├── project_status.md
    ├── decision_log.md
    ├── executive_summary.md
    ├── final_reporting_position.md
    ├── stakeholder_brief.md
    ├── monitoring_summary.md
    ├── stakeholder_issue_register_final.md
    ├── project_charter.md
    ├── methodology.md
    ├── data_dictionary.md
    ├── assumptions_and_limitations.md
    └── data_sources.md

Deliverables in this repository
Technical outputs
field inventory and reviewed field coverage
issue summaries and exception registers
annual and financial-year monitoring summaries
priority-field completeness tracking
stakeholder headline summary tables
Presentation-facing outputs
one-page portfolio snapshot
workflow diagram
Power BI summary view
static figure set
stakeholder-friendly Excel export
concise monitoring summary note
Reporting approach

A core principle in this project is:

validate before interpreting

The reporting position is based on:

field inventory
formal validation logic
targeted exception review
monitoring-oriented summary outputs
documented caveats and limitations

The project also uses proportionate interpretation rather than treating every flagged row as an equally important reporting issue.

In practice, this means:

low-volume exceptions are interpreted proportionately
national monitoring use is separated from detailed geographic reporting risk
isolated anomalies are not automatically elevated into headline concerns
Scope note

This Version 1 project is primarily framed around:

annual monitoring
financial-year monitoring
severity and outcome review
geographic data quality review
issue logging and monitoring-oriented summaries

It is not primarily framed as a daily or monthly operational reporting workflow.

This reflects the structure of the reviewed extract, which is more naturally aligned to:

crashYear
crashFinancialYear

than to a strongly event-date-driven operational reporting design.

Important positioning note

This repository is an independent portfolio project using publicly available data.

It does not represent:

official NZTA analysis
official government reporting
operational sign-off on source-system quality
a production enterprise reporting framework
formal employment work completed on behalf of NZTA or another organisation