# NZ Road Safety Data Quality & Monitoring Review

**Author:** Wonjik Kim  
**Project Type:** Public-sector style data quality and reporting portfolio project  
**Primary Tooling:** R, SQL, Excel, GitHub  
**Status:** Phase 3 - Validation and monitoring layer implemented

## Project Overview

This project is an end-to-end public-sector style analytics portfolio piece built using New Zealand road safety data from the NZTA Crash Analysis System (CAS) open data source.

The project is designed to demonstrate not only data analysis capability, but also the ability to assess whether a dataset is reliable enough for reporting and decision-making. Rather than focusing on visualisation alone, the repository emphasises data quality validation, reporting reliability, structured documentation, and stakeholder-ready interpretation.

## Business Context

In public-sector and regulated reporting environments, trend outputs are only useful when the underlying data is sufficiently complete, internally consistent, and appropriately caveated.

This project is framed as a road safety data quality and monitoring review for a public-sector style stakeholder audience. It is intended to reflect how an analyst might:

- assess whether incoming data is reliable enough for reporting
- identify missingness, consistency, and validity issues
- separate core reporting risks from lower-severity watch items
- build monitoring-ready summary outputs
- document limitations before presenting findings to stakeholders

## Project Objective

The objective of this project is to build a structured, reproducible workflow that:

1. assesses the quality and reliability of NZ road safety data
2. creates monitoring-ready outputs for annual and financial-year reporting
3. documents assumptions and limitations clearly
4. presents findings in a format suitable for non-technical stakeholders

## Current Project Position

The repository has moved beyond initial setup and field profiling.

Work completed so far includes:

- repository structure and core documentation
- raw CAS extract acquisition
- field inventory and missingness review
- working field definition for version 1
- formal quality validation checks
- targeted review of severity consistency exceptions
- exception review and monitoring layer outputs

The current task is no longer to design validation logic from scratch.  
The project is now focused on stakeholder-facing packaging, issue register interpretation, and final presentation polish.

## Data Source

This project uses publicly available road safety data from the **New Zealand Transport Agency (NZTA) Crash Analysis System (CAS)** open data source.

**Primary working file:**  
`data/raw/Crash_Analysis_System_(CAS)_data.csv`

**Current extract profile:**  
- Rows: 913,464  
- Columns: 72

## Version 1 Analytical Framing

Version 1 is intentionally focused on:

- annual reporting
- financial-year monitoring
- severity and outcome review
- geographic data quality review
- issue logging and monitoring-ready summaries

This direction was chosen because the current extract supports `crashYear` and `crashFinancialYear`, but does not currently provide a clearly usable full event date field for strong monthly or daily reporting logic in v1.

## Scope

### In Scope
- raw data ingestion and structure review
- field inventory and missingness profiling
- data quality validation checks
- issue logging and exception review
- annual / financial-year monitoring summaries
- stakeholder-focused interpretation
- documentation suitable for portfolio review

### Out of Scope
- causal policy evaluation
- predictive modelling in version 1
- production deployment
- claiming operational policy impact
- representing the work as official NZTA or government analysis

## Key Questions

This project is designed to answer questions such as:

- Is the data reliable enough to support reporting?
- Are there obvious completeness, validity, or consistency issues that should be flagged?
- Which issue types belong in a stakeholder-facing issue register?
- How should data quality risk be summarised across annual and financial-year views?
- What would a stakeholder need to know before using this data in reporting or discussion?

## Workflow Summary

The workflow is currently structured in the following layers:

1. **Field Inventory**
   - load raw source data
   - inspect fields and structure
   - review missingness and basic extract profile

2. **Working Field Definition**
   - identify core, secondary, and excluded fields
   - align the project with a disciplined v1 reporting scope

3. **Quality Validation**
   - duplicate / uniqueness checks
   - required-field completeness checks
   - warning-level completeness checks
   - crash year and financial-year validity checks
   - year / financial-year consistency checks
   - severity consistency checks
   - location completeness checks
   - record-level quality flags

4. **Exception Review and Monitoring Layer**
   - review low-volume error-level exceptions
   - create issue-type monitoring summaries
   - create a v1 issue register
   - create annual and financial-year monitoring summaries
   - produce stakeholder headline metrics

5. **Stakeholder Packaging**
   - finalise issue register interpretation
   - prepare stakeholder-facing summaries
   - polish repository presentation and documentation

## Data Quality Framework

The project assesses data reliability using the following categories:

- **Completeness** - Are required fields populated?
- **Validity** - Are values within expected ranges and formats?
- **Consistency** - Do related fields align logically?
- **Uniqueness** - Are there potential duplicate records?
- **Monitoring significance** - Should the issue be treated as a core reporting risk, a secondary watch item, or an internal-only observation?

## Key Outputs Generated So Far

### Field Inventory Layer
- `outputs/tables/field_inventory.csv`
- `outputs/tables/missingness_summary.csv`
- `outputs/tables/date_range_summary.csv`

### Quality Validation Layer
- `outputs/tables/quality_issue_summary.csv`
- `outputs/tables/quality_issues_long.csv`
- `outputs/tables/record_quality_flags.csv`

### Monitoring Layer
- `outputs/tables/issue_type_monitoring_summary.csv`
- `outputs/tables/issue_register_v1.csv`
- `outputs/tables/exception_review_register.csv`
- `outputs/tables/exception_review_records.csv`
- `outputs/tables/annual_quality_monitoring_summary.csv`
- `outputs/tables/financial_year_quality_monitoring_summary.csv`
- `outputs/tables/priority_field_completeness_by_year.csv`
- `outputs/tables/priority_field_completeness_by_financial_year.csv`
- `outputs/tables/stakeholder_quality_headlines.csv`

## Current Validation Position

The current validation position is that the extract does not show high-volume structural failures.

Early validation and review work established that:

- no duplicate `OBJECTID` issues were found
- no exact duplicate row issues were found
- no crash year validity failures were found
- no crash financial year format failures were found
- no crash year / financial year alignment failures were found
- no fatal-or-serious severity contradictions were found

Most flagged issues were warning-level completeness gaps rather than major structural defects.

## Repository Structure

```text
nz-road-safety-data-quality-monitoring/
├─ README.md
├─ .gitignore
├─ data/
│  ├─ raw/
│  ├─ processed/
│  └─ reference/
├─ scripts/
│  ├─ 01_field_inventory.R
│  ├─ 02_quality_checks.R
│  ├─ 02a_review_severity_conflicts.R
│  └─ 03_exception_review_and_monitoring_layer.R
├─ sql/
├─ outputs/
│  ├─ figures/
│  ├─ tables/
│  └─ excel/
├─ docs/
│  ├─ project_charter.md
│  ├─ executive_summary.md
│  ├─ stakeholder_brief.md
│  ├─ methodology.md
│  ├─ data_dictionary.md
│  ├─ assumptions_and_limitations.md
│  ├─ data_sources.md
│  ├─ project_status.md
│  └─ decision_log.md
└─ assets/