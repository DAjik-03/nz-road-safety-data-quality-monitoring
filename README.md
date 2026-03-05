# NZ Road Safety Data Quality & Monitoring Review

**Author:** Wonjik Kim  
**Project Type:** Public-sector style data quality and reporting portfolio project  
**Primary Tooling:** R, SQL, Excel, GitHub  
**Status:** Phase 1 - Project setup and documentation

## Project Overview

This project is an end-to-end public-sector style analytics portfolio piece built using New Zealand road safety data from the NZTA Crash Analysis System (CAS) open data source.

The project is designed to demonstrate not only data analysis capability, but also the ability to assess whether a dataset is reliable enough for reporting and decision-making. Rather than focusing on visualisation alone, the project emphasises data quality validation, reporting reliability, structured documentation, and stakeholder-ready interpretation.

## Business Context

In real-world public sector and regulated environments, data is often used to support operational monitoring, policy discussions, and reporting to non-technical stakeholders. However, trend reporting is only useful when the underlying data is sufficiently complete, consistent, and correctly interpreted.

This project is framed as a road safety monitoring review for a public-sector style stakeholder group. It aims to reflect how an analyst might:

- review the quality of incoming crash data
- identify potential issues such as missingness, lag, or classification changes
- produce reliable trend summaries
- document limitations before turning data into advice

## Project Objective

The objective of this project is to build a structured, reproducible workflow that:

1. assesses the quality and reliability of NZ road safety data
2. creates monitoring-ready metrics for reporting
3. documents assumptions and limitations clearly
4. presents findings in a format suitable for non-technical stakeholders

## Data Source

This project uses publicly available road safety data from the **New Zealand Transport Agency (NZTA) Crash Analysis System (CAS)** open data source.

The primary analytical focus is on the **most recent five-year period**, to keep the reporting context relevant and manageable while still allowing trend analysis.

A secondary aggregate source may be used for high-level cross-checking of totals where appropriate.

## Scope

### In Scope
- recent five-year reporting window
- data ingestion and structure review
- cleaning and transformation
- data quality validation checks
- monitoring metric creation
- stakeholder-focused interpretation
- documentation suitable for portfolio review

### Out of Scope
- causal policy evaluation
- forecasting / predictive modelling in the initial version
- claiming operational policy impact
- production deployment
- representing this as official NZTA or government work

## Key Questions

This project is designed to answer questions such as:

- Is the data complete enough to support reporting?
- Are there obvious consistency or validity issues that need to be flagged?
- Which trends appear reliable, and which require caution?
- How should recent movement be interpreted in light of data lag or classification changes?
- What would a stakeholder need to know before using this data in decision-making?

## Methodology Summary

The workflow will be structured in the following stages:

1. **Data Ingestion**
   - load raw source files
   - inspect fields and data types
   - review schema and key identifiers

2. **Data Cleaning and Standardisation**
   - standardise date and category fields
   - resolve format issues where required
   - define the working analytical dataset

3. **Data Quality Validation**
   - completeness checks
   - validity checks
   - consistency checks
   - uniqueness checks
   - timeliness / reporting lag checks
   - change / drift checks

4. **Monitoring Layer**
   - calculate reporting metrics
   - create trend summaries
   - compare severity and regional patterns
   - identify areas requiring caution

5. **Stakeholder Communication**
   - produce executive summary outputs
   - document assumptions and limitations
   - maintain an issue register
   - package outputs in a reviewable GitHub structure

## Data Quality Framework

The project will assess data reliability using the following categories:

- **Completeness** - Are required fields populated?
- **Validity** - Are values within expected ranges and formats?
- **Consistency** - Do related fields align logically?
- **Uniqueness** - Are there potential duplicate records?
- **Timeliness** - Is recent data fully available yet?
- **Change / Drift** - Have source patterns changed in ways that affect comparability?

## Planned Outputs

This repository is intended to contain:

- reproducible R scripts for data ingestion, transformation, and checks
- SQL validation queries for targeted cross-checks
- an Excel-based data quality issue register
- chart outputs for trend monitoring
- an executive summary for non-technical readers
- a stakeholder brief
- a project charter
- a data dictionary
- assumptions and limitations documentation

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
│  └─ assumptions_and_limitations.md
└─ assets/