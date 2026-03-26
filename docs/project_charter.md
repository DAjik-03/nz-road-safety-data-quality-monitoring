# Project Charter

## Project Title
**NZ Road Safety Data Quality & Monitoring Review**

## Project Type
Independent portfolio project using publicly available New Zealand road safety data from the NZTA Crash Analysis System (CAS).

This project is structured as a public-sector style data quality and monitoring review rather than a simple visualisation or dashboard exercise.

---

## Project Purpose
The purpose of this project is to assess whether a publicly available NZ road safety dataset is sufficiently reliable for structured reporting and monitoring before stakeholder-facing interpretation is produced.

The project is designed to demonstrate how an analyst can move from a raw public extract to a more disciplined reporting-readiness position through:
- field inventory
- data quality validation
- targeted exception review
- monitoring-oriented summary outputs
- stakeholder-safe interpretation with documented caveats
- presentation-facing outputs built from the completed review

---

## Project Context
Public road safety data can appear straightforward at summary level while still containing issues that matter for interpretation, especially where reporting moves from broad monitoring into more detailed analysis.

For that reason, this project is intentionally framed around validating the extract before drawing reporting conclusions.

The project uses publicly available CAS data rather than an internal operational reporting source.

Accordingly, the project does not attempt to replicate official NZTA reporting, internal governance, or live production monitoring.

---

## Project Objective
The objective of version 1 is to determine whether the reviewed public extract is usable for structured monitoring and, if so, under what limitations and caveats.

In practical terms, the project aims to:
- review raw source structure and field coverage
- identify missingness and date coverage patterns
- apply formal quality checks across completeness, validity, consistency, and uniqueness
- interpret exceptions using materiality rather than raw issue inflation
- convert validation results into monitoring-ready summary outputs
- document stakeholder-facing caveats clearly and proportionately

---

## Version 1 Scope
Version 1 is primarily scoped around:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic data quality review
- issue logging and monitoring-oriented summary outputs

Version 1 is not primarily scoped as:
- monthly operational reporting
- daily operational reporting
- real-time monitoring
- official government reporting
- enterprise production governance

This reflects the structure of the reviewed extract, which is more naturally aligned to `crashYear` and `crashFinancialYear` than to a strongly event-date-driven operational reporting design.

---

## Analytical Workflow
The version 1 workflow is structured as five linked workflow layers:

1. **Field Inventory Layer**
   - review raw extract structure
   - generate field inventory
   - summarise missingness
   - summarise date coverage

2. **Quality Validation Layer**
   - apply completeness, validity, consistency, and uniqueness checks
   - generate record-level quality flags

3. **Severity Exception Review**
   - refine interpretation of severity-related conflicts
   - distinguish stronger contradictions from lower-severity warning cases

4. **Exception Review and Monitoring Layer**
   - convert raw validation outputs into monitoring-ready and stakeholder-facing summary structures
   - support issue logging, annual / financial-year review, and documented reporting caveats

5. **Presentation-Facing Output Layer**
   - convert completed conclusions into static figures and other front-facing portfolio outputs
   - support README presentation, stakeholder review, and portfolio communication without changing the analytical core

---

## Primary Working Source
Primary file:
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

Current extract profile:
- Rows: 913,464
- Columns: 72

---

## Key Methodological Principle
The central principle of this project is:

**validate before interpreting**

This means stakeholder-facing conclusions are intentionally grounded in:
- source structure review
- formal validation logic
- targeted exception review
- documented interpretation boundaries

The project does not treat every flagged issue as equally material.  
Instead, version 1 applies a materiality-based interpretation that distinguishes:
- isolated anomalies
- warning-level completeness gaps
- issues that matter for broad monitoring
- issues that matter mainly for detailed geographic reporting

---

## Current Version 1 Position
The current documented version 1 position is:

- no major high-volume structural failures were identified
- most flagged items are low-volume exceptions or warning-level completeness gaps
- the main residual caveat is a very small number of incomplete geographic reference records
- one isolated historical injury-count exception remains on file as a monitored item
- overall position: **fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**

This means the reviewed extract appears suitable for:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing interpretation with clear caveats

---

## Main Residual Caveat
The main stakeholder-relevant residual caveat in version 1 is incomplete geographic reference coverage in a very small number of records, including fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This is not expected to materially affect:
- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, additional caution is appropriate where reporting becomes more geographically detailed, including:
- TLA-level reporting
- area-unit interpretation
- meshblock-linked analysis
- map-based outputs
- tightly scoped local-area summaries

---

## Monitored Historical Exception
One isolated historical exception remains on record:
- a 2005 Auckland record with missing `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`

Because this issue is isolated and low-volume, it is retained as a monitored exception rather than treated as a headline stakeholder concern.

---

## Project Deliverables
The project is intended to produce and maintain:
- structured repository documentation
- field inventory outputs
- validation outputs
- exception review outputs
- monitoring-oriented summary outputs
- stakeholder-facing interpretation documents
- presentation-facing static and summary outputs

Key repository materials include:
- `README.md`
- `docs/project_status.md`
- `docs/decision_log.md`
- `docs/executive_summary.md`
- `docs/final_reporting_position.md`
- `docs/stakeholder_brief.md`
- `docs/monitoring_summary.md`
- `docs/stakeholder_issue_register_final.md`
- `docs/project_charter.md`
- `docs/methodology.md`
- `docs/data_dictionary.md`
- `docs/assumptions_and_limitations.md`
- `docs/data_sources.md`

Representative monitoring outputs include:
- `outputs/tables/issue_type_monitoring_summary.csv`
- `outputs/tables/issue_register_v1.csv`
- `outputs/tables/exception_review_register.csv`
- `outputs/tables/exception_review_records.csv`
- `outputs/tables/annual_quality_monitoring_summary.csv`
- `outputs/tables/financial_year_quality_monitoring_summary.csv`
- `outputs/tables/priority_field_completeness_by_year.csv`
- `outputs/tables/priority_field_completeness_by_financial_year.csv`
- `outputs/tables/stakeholder_quality_headlines.csv`

---

## Success Criteria
Version 1 is considered successful if it demonstrates:
- a clear analytical workflow from raw source review to reporting-readiness interpretation
- transparent validation logic
- proportionate treatment of low-volume exceptions
- a defensible distinction between national monitoring suitability and detailed geographic caveat risk
- documentation that is coherent, stakeholder-safe, and portfolio-ready

---

## Boundaries and Non-Claims
This project does not claim to be:
- official NZTA analysis
- official government reporting
- operational sign-off on source-system quality
- a live enterprise monitoring environment
- a production-grade governance framework

All findings should be read as:
- extract-specific
- workflow-specific
- version 1 bounded

---

## Current Phase
**Phase 4 — Interpretation, presentation outputs, and final portfolio packaging**

The core validation-led analytical build has been completed.

The current focus is:
- stakeholder-facing packaging
- interpretation refinement
- documentation consistency
- presentation-facing static outputs
- final portfolio presentation polish

This means the project is now in a finishing and communication phase rather than a foundational build phase.

---

## Charter Summary
This charter establishes the NZ Road Safety Data Quality & Monitoring Review as a documentation-heavy, validation-led portfolio project focused on reporting readiness rather than visual output alone.

The version 1 conclusion is that the reviewed extract appears usable for structured monitoring purposes, provided that:
- low-volume exceptions are interpreted proportionately
- geographic completeness caveats are disclosed where relevant
- outputs are not overstated beyond the scope of the reviewed public extract