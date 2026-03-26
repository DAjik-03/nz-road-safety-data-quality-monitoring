# Methodology

## Purpose of the Methodology
This document explains the methodological approach used in version 1 of the NZ Road Safety Data Quality & Monitoring Review.

The methodology is designed to show how a public-sector style analytical workflow can move from a raw public extract to a more disciplined reporting-readiness position through:
- structural field review
- formal quality validation
- targeted exception review
- monitoring-oriented summary outputs
- stakeholder-facing interpretation with documented caveats

This is not a visualisation-first workflow.  
It is a reporting-readiness and data quality review workflow.

---

## Methodological Position
The project uses publicly available New Zealand road safety data from the NZTA Crash Analysis System (CAS).

The central methodological principle is:

**validate before interpreting**

This means stakeholder-facing interpretation is not produced until the extract has first been reviewed for:
- structural coverage
- missingness
- validity
- internal consistency
- uniqueness
- material exceptions relevant to reporting use

The methodology is therefore designed to answer a practical analyst question:

**Is this public extract usable for structured monitoring, and if so, under what caveats?**

---

## Version 1 Analytical Scope
Version 1 is primarily framed around:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic data quality review
- issue logging and monitoring-ready summaries

Version 1 is not primarily designed as a monthly or daily operational reporting framework.

This reflects the structure of the reviewed extract, which is more naturally aligned to:
- `crashYear`
- `crashFinancialYear`

than to a strongly event-date-driven operational reporting design.

---

## Source Data Context
Primary working source:
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

Current extract profile:
- 913,464 rows
- 72 columns

This project uses a public extract rather than an internal operational reporting environment.

Accordingly, the methodology is designed to assess reporting readiness within the constraints of a public dataset, not to replicate internal production governance.

---

## Workflow Overview
The version 1 workflow is structured as five linked workflow layers:

1. **Field inventory**
2. **Quality validation**
3. **Targeted exception review**
4. **Monitoring layer and stakeholder-facing interpretation**
5. **Presentation-facing static outputs**

This sequence is intentional.  
It prevents reporting conclusions from being produced before the extract has been structurally reviewed and quality-checked.

The first four layers establish reporting-readiness judgement and interpretation boundaries.  
The fifth layer packages those completed conclusions into static, presentation-facing outputs for portfolio, README, and stakeholder review use.

---

## Layer 1 — Field Inventory

### Script
- `scripts/01_field_inventory.R`

### Purpose
The field inventory layer provides a structured first-pass review of the raw extract.

It is designed to:
- identify the available fields
- document field types and coverage
- summarise missingness
- review date-related field coverage
- establish a basic structural understanding of the extract before formal validation begins

### Representative Outputs
- `outputs/tables/field_inventory.csv`
- `outputs/tables/missingness_summary.csv`
- `outputs/tables/date_range_summary.csv`

### Methodological Role
This layer establishes the baseline structure of the data and supports later decisions about:
- which fields matter most for reporting
- which fields should be prioritised in validation
- which fields may require caution in interpretation

---

## Layer 2 — Quality Validation

### Script
- `scripts/02_quality_checks.R`

### Purpose
The quality validation layer applies structured checks across the extract to identify record-level and issue-type quality concerns.

The validation framework is organised around four dimensions:
- completeness
- validity
- consistency
- uniqueness

### Validation Logic
The purpose of validation is not to inflate issue counts, but to create a disciplined basis for distinguishing:
- broad structural concerns
- low-volume anomalies
- warning-level gaps
- issues likely to matter for reporting interpretation

### Representative Outputs
- `outputs/tables/quality_issue_summary.csv`
- `outputs/tables/quality_issues_long.csv`
- `outputs/tables/record_quality_flags.csv`

### Methodological Role
This layer creates the formal evidence base for later exception review and stakeholder-facing interpretation.

It ensures that conclusions about reporting suitability are grounded in a defined validation process rather than impressionistic review.

---

## Layer 3 — Targeted Severity Exception Review

### Script
- `scripts/02a_review_severity_conflicts.R`

### Purpose
This layer refines the interpretation of severity-related conflicts identified in the broader validation process.

Rather than treating all severity conflicts as equally material, version 1 adopts a more proportionate interpretation.

### Applied Refinement
The key refinement used in version 1 is:

- non-injury + fatal or serious counts = **error**
- non-injury + minor-only count = **warning**

### Methodological Role
This refinement supports a materiality-based approach to exception interpretation.

It reduces the risk of overstating lower-severity inconsistencies while still preserving stronger contradictions as meaningful quality concerns.

---

## Layer 4 — Exception Review and Monitoring Layer

### Script
- `scripts/03_exception_review_and_monitoring_layer.R`

### Purpose
The monitoring layer converts raw validation outputs into monitoring-ready and stakeholder-facing summary structures.

This layer exists because record-level flags alone are not sufficient for reporting interpretation.  
A stakeholder-facing workflow requires summary-level outputs that show:
- which issue types exist
- how frequently they occur
- whether they appear material
- whether they affect annual or financial-year monitoring use
- which caveats should be elevated in documentation

### Representative Outputs
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

### Methodological Role
This layer elevates the project from a raw validation exercise into a monitoring-oriented analytical workflow.

It is the point at which technical validation outputs become usable for:
- reporting-readiness judgement
- issue logging
- stakeholder-safe summary interpretation

---

## Layer 5 — Presentation-Facing Static Outputs

### Script
- `scripts/04_static_figures.R`

### Purpose
This layer converts the completed monitoring interpretation into static visual outputs that can be reviewed quickly by portfolio readers, hiring managers, and non-technical stakeholders.

It is not used to generate new analytical conclusions.  
Its purpose is to present already-reviewed findings in a front-facing and communication-friendly format.

### Representative Outputs
- `outputs/figures/fig_01_v1_validation_to_monitoring_workflow.png`
- `outputs/figures/fig_02_validation_outcome_summary.png`
- `outputs/figures/fig_03_quality_monitoring_annual_fy_issue_coverage.png`
- `outputs/figures/fig_04_geographic_completeness_caveat_matrix.png`

### Methodological Role
This layer supports final communication rather than primary analysis.

It helps ensure that:
- the validation-led workflow can be understood at a glance
- the final reporting position is visible in front-facing form
- caveats remain tied to the documented interpretation rather than presented as isolated visuals

---

## Exception Interpretation Approach

### Materiality-Based Interpretation
A core methodological choice in version 1 is that low-volume exception rows are not automatically treated as broad reporting failure.

Instead, exceptions are interpreted using a materiality-based approach that considers:
- issue volume
- issue pattern
- likely reporting effect
- whether the issue affects national monitoring or detailed local reporting
- whether the issue should remain monitored or be elevated as a stakeholder-facing caveat

### Main Residual Caveat
The main residual stakeholder-relevant caveat in version 1 is incomplete geographic reference coverage in a very small number of records, including fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This is not expected to materially affect:
- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, it becomes more relevant where reporting is used for:
- TLA-level outputs
- area-unit interpretation
- meshblock-linked analysis
- map-based views
- tightly scoped local-area summaries

### Isolated Historical Exception
A separate isolated historical exception remains on file:
- one 2005 Auckland record with missing `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`

Because this issue is historical, isolated, and low-volume, it is retained as a monitored exception rather than treated as a headline reporting concern.

---

## Reporting-Readiness Logic
The methodology does not treat all validation findings as equally important.

Instead, the reporting-readiness position is built by asking:
- Were any major high-volume structural failures identified?
- Are the flagged issues concentrated in isolated exceptions or widespread defects?
- Do the identified issues materially weaken annual or financial-year monitoring?
- Which issues require clear caveats before stakeholder-facing interpretation?

Using that logic, version 1 supports the following overall position:

**fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**

---

## Interpretation Boundary
This methodology supports conclusions about:
- reporting readiness
- monitoring suitability
- caveat identification
- stakeholder-facing interpretation boundaries

It does not claim:
- official NZTA analysis
- official government reporting
- operational sign-off on source-system quality
- production-grade enterprise governance
- real-time operational monitoring suitability

All conclusions should be read as:
- extract-specific
- workflow-specific
- version 1 bounded

---

## Documentation and Output Interpretation
Some generated outputs may not be visible in the Git repository at all times.

Where this occurs, the methodology treats the following as the working source of truth:
1. current repository documentation
2. completed script structure
3. defined workflow outputs referenced by the scripts

Non-visible outputs should not automatically be interpreted as absent if the workflow clearly defines and produces them.

---

## Reproducibility Position
The methodology is designed to be transparent and reproducible at a portfolio-project level.

Reproducibility is supported through:
- named script layers
- documented workflow stages
- clearly defined representative outputs
- explicit interpretive boundaries
- documented caveats and assumptions

This is intended to demonstrate disciplined analytical practice rather than a fully automated enterprise production framework.

---

## Version 1 Bottom Line
The methodology used in this project is designed to show how a public road safety extract can be assessed for structured monitoring use before stakeholder-facing interpretation is produced.

In practical terms, version 1 demonstrates:
- structured source review before interpretation
- validation-led reporting readiness assessment
- materiality-based exception interpretation
- monitoring-ready summary outputs
- stakeholder-safe documentation of caveats
- presentation-facing static communication outputs built from the completed review

The resulting methodological position is that the reviewed extract appears usable for structured monitoring purposes, provided that:
- low-volume exceptions are interpreted proportionately
- geographic completeness caveats are disclosed where relevant
- outputs are not overstated beyond the scope of the reviewed public extract