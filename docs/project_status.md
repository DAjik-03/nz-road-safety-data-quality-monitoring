
---

### `docs/project_status.md`

```md
# Project Status

## Current Phase
**Phase 3 complete — quality validation complete, monitoring layer implemented, and stakeholder-facing presentation outputs packaged**

This project has progressed beyond initial setup, field inventory, and first-pass validation.

The core analytical workflow for Version 1 is already in place.  
At this stage, the repository is no longer being treated as a foundational build.  
The remaining work is limited to final wording alignment, repository consistency, and portfolio presentation polish.

---

## Project Purpose
This project is a public-sector style data quality and monitoring review using publicly available New Zealand road safety data from the NZTA Crash Analysis System (CAS).

The project is designed to assess whether the reviewed extract is sufficiently reliable for structured reporting and monitoring before stakeholder-facing interpretation is produced.

The portfolio aim is to demonstrate how an analyst can move from raw public data to a more disciplined reporting position through:
- field inventory
- data quality validation
- targeted exception review
- monitoring-oriented summary outputs
- stakeholder-safe interpretation and documented caveats

---

## Version 1 Analytical Framing
Version 1 is primarily framed around:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic data quality review
- issue logging and monitoring-ready summaries

Version 1 is not primarily designed as a monthly or daily operational reporting workflow.

This is because the current extract is more naturally structured around `crashYear` and `crashFinancialYear` than a strongly event-date-driven operational reporting design.

---

## Current Source Context
Primary working source:
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

Current extract profile:
- Rows: 913,464
- Columns: 72

---

## Completed Work

### 1. Field Inventory Layer — Complete
Script:
- `scripts/01_field_inventory.R`

Purpose:
- review raw extract structure
- generate field inventory
- summarise missingness
- summarise date coverage

Representative outputs:
- `outputs/tables/field_inventory.csv`
- `outputs/tables/missingness_summary.csv`
- `outputs/tables/date_range_summary.csv`

### 2. Quality Validation Layer — Complete
Script:
- `scripts/02_quality_checks.R`

Purpose:
- apply completeness, validity, consistency, and uniqueness checks
- generate record-level quality flags

Representative outputs:
- `outputs/tables/quality_issue_summary.csv`
- `outputs/tables/quality_issues_long.csv`
- `outputs/tables/record_quality_flags.csv`

### 3. Severity Exception Review — Complete
Script:
- `scripts/02a_review_severity_conflicts.R`

Interpretive refinement:
- non-injury + fatal/serious counts = error
- non-injury + minor-only count = warning

### 4. Exception Review and Monitoring Layer — Complete
Script:
- `scripts/03_exception_review_and_monitoring_layer.R`

Purpose:
- elevate raw validation outputs into monitoring-ready and stakeholder-facing summary structures

Representative outputs:
- `outputs/tables/monitoring_layer_run_metadata.csv`
- `outputs/tables/issue_type_monitoring_summary.csv`
- `outputs/tables/issue_register_v1.csv`
- `outputs/tables/exception_review_register.csv`
- `outputs/tables/exception_review_records.csv`
- `outputs/tables/annual_quality_monitoring_summary.csv`
- `outputs/tables/financial_year_quality_monitoring_summary.csv`
- `outputs/tables/priority_field_completeness_by_year.csv`
- `outputs/tables/priority_field_completeness_by_financial_year.csv`
- `outputs/tables/stakeholder_quality_headlines.csv`

### 5. Stakeholder-Facing Presentation Outputs — Complete
Purpose:
- make the completed review easier to assess at a glance
- provide front-facing outputs alongside the technical documentation
- support README presentation, portfolio review, and interview discussion

Added outputs:
- `assets/portfolio_snapshot_onepager.png`
- `assets/project_workflow_diagram.png`
- `assets/NZ Road Safety Data Quality & Monitoring Review.png`
- `outputs/figures/fig_01_v1_validation_to_monitoring_workflow.png`
- `outputs/figures/fig_02_validation_outcome_summary.png`
- `outputs/figures/fig_03_quality_monitoring_annual_fy_issue_coverage.png`
- `outputs/figures/fig_04_geographic_completeness_caveat_matrix.png`
- `outputs/excel/nz-road-safety-monitoring-supporting-export.xlsx`
- `docs/monitoring_summary.md`

These additions package the completed review more clearly, but they do not change the underlying analytical core or the Version 1 reporting position.

---

## Current Documented Position
The current Version 1 position is:

- no major high-volume structural failures were identified
- most flagged issues are low-volume exceptions or warning-level completeness gaps
- the main residual caveat is a very small number of incomplete geographic reference records
- one isolated historical injury-count exception remains on record as a monitored exception
- overall position: **fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**

This means the current extract appears suitable for:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing interpretation with clear caveats

---

## Current Exception Interpretation Position

### 1. Incomplete geographic reference fields
The main stakeholder-relevant residual caveat is a small number of records with incomplete geographic reference fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This does not appear material to:
- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, additional caution is appropriate where reporting becomes more geographically detailed, including:
- TLA-level reporting
- area-unit interpretation
- meshblock-linked analysis
- map-based outputs
- tightly scoped local-area summaries

### 2. Isolated historical injury-count exception
One 2005 Auckland record remains on file with missing:
- `fatalCount`
- `seriousInjuryCount`
- `minorInjuryCount`

Because this exception is isolated and low-volume, it is retained as a monitored exception rather than treated as a headline stakeholder concern.

### 3. Materiality-based interpretation
Low-volume error rows are not treated as automatically equivalent to broad reporting failure.

For stakeholder-facing interpretation, Version 1 applies a materiality-based position:
- low-volume exceptions are interpreted in context
- caveats are prioritised according to likely reporting impact
- national monitoring use is distinguished from detailed geographic reporting risk

---

## Current Documentation Position
The main reference documents for the current repository state are:
- `README.md`
- `docs/project_status.md`
- `docs/decision_log.md`
- `docs/executive_summary.md`
- `docs/final_reporting_position.md`
- `docs/stakeholder_brief.md`
- `docs/monitoring_summary.md`
- `docs/project_charter.md`
- `docs/methodology.md`
- `docs/data_dictionary.md`
- `docs/assumptions_and_limitations.md`
- `docs/data_sources.md`

Where minor differences appear between documentation, scripts, and visible tracked outputs, the working interpretation should prioritise:
1. current repository documentation
2. completed script structure
3. documented Version 1 analytical position

Outputs that are not visible in Git should not automatically be treated as absent if they are clearly defined in scripts and supporting documentation.

---

## What Is Already Considered Complete
The following are already treated as completed for Version 1 and should not be reopened as if still in design phase:
- repository setup and initial project structure
- Phase 1 documentation foundation
- field inventory design
- core validation logic design
- severity exception review design
- monitoring layer design
- Version 1 reporting position
- front-facing presentation artefact packaging

The project is now in a finishing and presentation phase rather than a foundational build phase.

---

## Current Work Focus
The most natural work at this stage is repository polish rather than additional core analysis.

Current high-priority work areas are:
- final README and documentation consistency checks
- file placement and naming consistency across assets and outputs
- light wording cleanup where needed
- portfolio-ready maintenance rather than analytical redesign

---

## Important Positioning Note
This repository is an independent portfolio project using publicly available data.

It does not represent:
- official NZTA analysis
- official government reporting
- operational sign-off on source-system quality
- a live production reporting framework

Its purpose is to demonstrate disciplined analytical practice in assessing reporting readiness, documenting caveats, and producing monitoring-oriented outputs that are suitable for stakeholder-facing interpretation.

---

## Version 1 Bottom Line
The current Version 1 conclusion is that the reviewed extract appears usable for structured monitoring purposes, provided that:
- low-volume exceptions are interpreted proportionately
- geographic completeness caveats are disclosed where relevant
- outputs are not overstated beyond the scope of the reviewed extract

In practical terms, the project is best described as:

**a completed validation-led, documentation-heavy monitoring workflow with targeted caveats rather than broad reliability concerns**