# Project Status

## Project Title

**NZ Road Safety Data Quality & Monitoring Review**

## Current Phase

**Phase 2 — Data acquisition, field inventory, and working field definition**

This project has moved beyond initial setup and documentation.  
The repository structure is established, core documentation has been drafted, the primary raw dataset has been downloaded, and the first field inventory workflow has been successfully executed.

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
- Initial push completed successfully
- Main branch is active and tracking origin

### Core Documentation Completed
The following core documentation files have been created:

- `README.md`
- `docs/project_charter.md`
- `docs/stakeholder_brief.md`
- `docs/methodology.md`
- `docs/data_dictionary.md`
- `docs/assumptions_and_limitations.md`
- `docs/executive_summary.md`
- `docs/data_sources.md`

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

### Field Inventory Status
The initial field inventory script has been created and run successfully.

**Script:** `scripts/01_field_inventory.R`

### Generated Outputs
The following outputs were successfully created in `outputs/tables/`:

- `field_inventory.csv`
- `missingness_summary.csv`
- `date_range_summary.csv`

---

## Key Findings So Far

### 1. Field inventory execution was successful
The project can read the raw CAS extract and generate basic structural summaries.

### 2. The current extract appears suitable for a structured reporting-focused project
The dataset is large enough and rich enough for a strong portfolio project, especially for:

- annual reporting
- financial-year monitoring
- regional comparison
- severity-based comparison
- contextual road environment review
- data quality assessment

### 3. The current extract does not appear to contain a clear full event date field
At this stage, the extract appears to support:

- `crashYear`
- `crashFinancialYear`

However, it does **not** appear to include a clearly usable full event date field for direct monthly or daily analysis.

This has shifted the practical analytical focus of version 1 toward:

- annual monitoring
- financial-year monitoring
- cross-sectional quality review
- geographic and severity-based reporting

### 4. Several fields have very high missingness
The highest-missingness fields identified so far include:

- `crashRoadSideRoad` — 100.00%
- `intersection` — 100.00%
- `temporarySpeedLimit` — 98.28%
- `pedestrian` — 96.69%
- `advisorySpeed` — 96.05%

These fields are not suitable for the core v1 monitoring layer.

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
- field inventory script written
- field inventory executed successfully
- missingness summary reviewed
- core / secondary / excluded field direction defined
- data dictionary updated toward actual extract usage

---

## What Still Needs To Be Done

### Immediate Next Step
Build the next script in the workflow:

**`scripts/02_quality_checks.R`**

This script should introduce the first structured quality review layer.

### Expected Focus of `02_quality_checks.R`
The next script is expected to include checks such as:

- duplicate / uniqueness checks
- required field completeness checks
- missingness review for core fields
- value validity checks for key variables
- severity count sanity checks
- year and financial-year consistency checks
- basic location completeness checks

### After That
Subsequent work is expected to move into:

1. formal data quality outputs
2. issue register structure
3. monitoring metric creation
4. stakeholder-facing summaries
5. final portfolio polish

---

## Current Project Risks

### 1. No clear full-date field in the current extract
This limits immediate monthly / quarterly analysis in version 1.

### 2. High missingness in several conceptually useful fields
Some fields that appear attractive for analysis are too incomplete to support dependable reporting.

### 3. Scope creep risk
The project must remain focused on a strong, realistic v1 portfolio deliverable rather than trying to use every available field.

---

## Current Recommended Direction

The current best direction for version 1 is:

**Annual and financial-year road safety data quality and monitoring review using NZTA CAS public data**

This direction remains well aligned with the original project goal of producing a credible public-sector style portfolio piece.

---

## Handoff Note for a New Chat

If this project is continued in a new conversation, the next assistant should assume:

- the repository is already set up
- GitHub push has already been completed
- the CAS raw CSV file has already been downloaded
- `01_field_inventory.R` has already run successfully
- field inventory outputs already exist
- the project is now ready to move into `02_quality_checks.R`

The next recommended action is to design and implement the first formal data quality checks script based on the core fields documented in `docs/data_dictionary.md`.