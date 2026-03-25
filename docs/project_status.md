# Project Status

## Project Title

**NZ Road Safety Data Quality & Monitoring Review**

## Current Phase

**Phase 3 — Quality validation complete and monitoring layer implemented**

This project has moved beyond initial setup, field inventory, and first-pass validation.

The repository now includes a completed validation layer, a targeted severity exception review, and a first monitoring layer that converts raw validation outputs into issue registers, exception review outputs, and annual / financial-year monitoring summaries.

---

## Project Objective

The purpose of this project is to build a public-sector style analytics portfolio piece using NZTA Crash Analysis System (CAS) public data.

The project is designed to demonstrate the ability to:

- structure a realistic analytical workflow
- assess whether data is reliable enough for reporting
- identify data quality risks before interpreting trends
- document assumptions and limitations clearly
- produce stakeholder-ready monitoring outputs

---

## Current Repository Status

### Repository
- Git repository created locally
- GitHub remote repository created
- Main branch is active and tracking origin
- Core folder structure established
- Analytical workflow now extends from field inventory through monitoring-layer outputs

### Core Documentation Completed
The following core documentation files have been created and are active project references:

- `README.md`
- `docs/project_charter.md`
- `docs/stakeholder_brief.md`
- `docs/methodology.md`
- `docs/data_dictionary.md`
- `docs/assumptions_and_limitations.md`
- `docs/executive_summary.md`
- `docs/data_sources.md`
- `docs/project_status.md`
- `docs/decision_log.md`

### Project Structure Completed
The repository currently includes working folders for:

- `data/raw/`
- `data/processed/`
- `data/reference/`
- `scripts/`
- `sql/`
- `outputs/figures/`
- `outputs/tables/`
- `outputs/excel/`
- `docs/`
- `assets/`

---

## Source Data Status

### Primary Source
**Dataset:** `Crash_Analysis_System_(CAS)_data.csv`  
**Location:** `data/raw/`

### Current Extract Profile
- **Rows:** 913,464
- **Columns:** 72

### Time Structure Available in v1
The current extract supports:

- `crashYear`
- `crashFinancialYear`

The extract does not currently provide a clearly usable full event date field for strong monthly or daily monitoring logic in v1.

As a result, version 1 remains focused on:

- annual monitoring
- financial-year monitoring
- quality validation and issue logging
- severity and geographic reporting readiness

---

## Workflow Status by Layer

### 1. Field Inventory Layer — Complete
**Script:** `scripts/01_field_inventory.R`

This layer was created and run successfully. It established the initial structural profile of the raw CAS extract.

**Outputs generated:**
- `outputs/tables/field_inventory.csv`
- `outputs/tables/missingness_summary.csv`
- `outputs/tables/date_range_summary.csv`

### 2. Quality Validation Layer — Complete
**Script:** `scripts/02_quality_checks.R`

This layer introduced formal validation checks across completeness, validity, consistency, and uniqueness dimensions.

**Outputs generated:**
- `outputs/tables/quality_issue_summary.csv`
- `outputs/tables/quality_issues_long.csv`
- `outputs/tables/record_quality_flags.csv`

### 3. Severity Exception Review — Complete
**Script:** `scripts/02a_review_severity_conflicts.R`

A targeted review was completed for non-injury severity inconsistencies flagged during the first validation pass.

This review supported refinement of the original severity rule so that:

- non-injury with fatal or serious injury counts remains error-level
- non-injury with minor injury count only is treated as warning-level

### 4. Exception Review and Monitoring Layer — Complete
**Script:** `scripts/03_exception_review_and_monitoring_layer.R`

This layer promotes raw validation outputs into monitoring-ready and stakeholder-facing summary structures.

**Outputs generated:**
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

---

## Key Findings So Far

### 1. The extract is structurally usable for a reporting-focused portfolio project
The dataset is large enough and rich enough to support a realistic data quality and monitoring review.

### 2. Version 1 is best framed around annual and financial-year monitoring
Because the extract supports year and financial-year fields more clearly than full event-date reporting, the strongest v1 structure remains annual / financial-year based.

### 3. The current validation layer did not identify major high-volume structural failures
Validation and review work established that:

- no duplicate `OBJECTID` issues were found
- no exact duplicate row issues were found
- no crash year validity failures were found
- no crash financial year format failures were found
- no crash year / financial year alignment failures were found
- no fatal-or-serious severity contradictions were found

### 4. Most flagged issues were warning-level completeness gaps
The issue profile is more consistent with monitoring and caveating needs than with large-scale structural failure.

### 5. A low-volume set of error-level exceptions remains appropriate for targeted review
The monitoring layer now isolates low-volume error issues into a dedicated exception review register so they can be assessed before final stakeholder-facing packaging.

---

## Working Field Strategy

### Core Fields
The project has identified a working set of core fields across the following categories:

- record and geographic reference
- annual / financial-year reporting
- regional and location reporting
- severity and outcome reporting
- road context and environment
- crash direction and event description
- vehicle involvement categories

These are documented in `docs/data_dictionary.md`.

### Secondary Fields
Some fields are retained as secondary or optional due to high missingness, including:

- `holiday`
- `pedestrian`
- `temporarySpeedLimit`
- `advisorySpeed`
- `vehicle`

### Excluded / Low-Priority Fields
Some fields are currently excluded from v1 due to very high missingness or low relevance to the core reporting objective, including:

- fully missing fields such as `intersection` and `crashRoadSideRoad`
- high-missingness obstacle / object style fields such as `bridge`, `tree`, `trafficSign`, `roadworks`, and similar fields

---

## What Has Been Completed

### Completed Work
- project direction selected
- public-sector style reporting positioning confirmed
- repository structure created
- Git and GitHub setup completed
- Phase 1 core documentation drafted
- primary raw CAS source downloaded
- source documentation started
- field inventory script written and executed
- missingness summary reviewed
- core / secondary / excluded field direction defined
- data dictionary aligned toward actual extract usage
- `scripts/02_quality_checks.R` designed and executed successfully
- first-pass quality issue outputs generated
- targeted review of severity consistency exceptions completed
- severity rule refined after targeted review
- `scripts/03_exception_review_and_monitoring_layer.R` written and executed successfully
- v1 issue register created
- low-volume error exception review register created
- annual and financial-year monitoring summaries created
- stakeholder headline metrics created

---

## Current Project Position

The project is no longer at the stage of designing validation rules from scratch.

The current project position is:

- validation logic implemented
- monitoring layer outputs generated
- remaining work has shifted toward interpretation, packaging, and presentation

This means the next phase is mainly about deciding how the outputs should be presented and explained to a stakeholder audience.

---

## Immediate Next Steps

### Next Working Priorities
- review the remaining low-volume exception items in the exception review register
- confirm which issue types should remain in the stakeholder-facing register
- write stakeholder-facing interpretation for the issue register and monitoring summaries
- align README and supporting documents with the completed 03 layer
- polish final portfolio presentation

### Likely Next Deliverables
- refined stakeholder-facing issue narrative
- interpretation notes for annual / financial-year monitoring outputs
- final documentation cleanup
- optional charts or reporting-support artefacts for presentation packaging

---

## Current Risk / Watch Areas

The main remaining watch areas are not structural repository problems, but interpretation and packaging decisions:

- how to position warning-level issues in stakeholder communication
- how much detail to surface from the low-volume exception register
- how to present data quality caveats without overstating concern
- how to keep the final repository presentation concise while still looking rigorous

---

## Resume / Portfolio Value

At the current stage, the repository demonstrates:

- structured analytical workflow design
- data quality validation logic
- issue logging and exception review
- monitoring-oriented output design
- documentation discipline
- stakeholder-facing analytical framing

This makes the project stronger as a portfolio piece for junior or graduate analyst roles than a simple descriptive dashboard-only project.