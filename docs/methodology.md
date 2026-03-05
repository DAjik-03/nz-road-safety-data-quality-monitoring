# Methodology

## Methodological Approach

This project follows a public-sector style analytical workflow designed to assess whether publicly available road safety data is suitable for reliable monitoring and reporting.

The workflow is intentionally structured to prioritise data quality and reporting readiness before interpretation. Rather than moving directly from raw data to charts, the project first evaluates whether the data appears sufficiently complete, consistent, and current to support meaningful reporting.

## Analytical Workflow

The methodology is organised into five stages.

### 1. Data Ingestion

The project begins by loading publicly available NZ road safety data from the NZTA Crash Analysis System (CAS) source into a reproducible analytical workflow.

This stage includes:

- loading raw source files
- reviewing field names and structure
- checking data types
- identifying key identifiers and reporting periods
- defining the working analytical window

### 2. Data Cleaning and Standardisation

Once the source files are loaded, the data is prepared for structured review.

This stage includes:

- standardising date fields
- aligning categorical values where required
- checking for formatting irregularities
- isolating relevant fields for monitoring
- creating a stable working dataset for analysis

The goal of this stage is not to alter the underlying meaning of the source, but to make the dataset easier to review consistently and reproducibly.

### 3. Data Quality Validation

This is the core of the project.

Before trends are interpreted, the project evaluates whether the dataset appears reliable enough for reporting. The validation framework is structured around six key categories:

- completeness
- validity
- consistency
- uniqueness
- timeliness
- change / drift

Example checks may include:

- missing values in important fields
- values outside expected ranges
- conflicting logic across related fields
- potential duplicate records
- unstable recent-period reporting due to lag
- visible changes in field distributions over time

### 4. Monitoring Metric Creation

After the quality review, the project creates monitoring-ready outputs designed for reporting rather than purely exploratory analysis.

This stage includes:

- calculating summary metrics by period
- comparing crash severity categories
- reviewing broad location or category patterns
- identifying trends that appear stable enough to summarise
- distinguishing stronger findings from cautionary findings

### 5. Stakeholder-Focused Interpretation

The final stage translates technical review findings into documentation that a non-technical stakeholder can understand.

This includes:

- summarising what appears reliable
- flagging what requires caution
- documenting assumptions
- recording limitations
- presenting findings in a way that avoids overstating certainty

## Reproducibility Principles

This project is designed to be reviewable and as reproducible as practical for a portfolio context.

The repository structure separates:

- raw data
- processed data
- scripts
- validation queries
- outputs
- documentation

This makes it easier to understand how the project moves from source data to reported outputs.

## Why This Method Was Chosen

This methodology was chosen because it better reflects real reporting environments, where analysts need to assess data reliability before drawing conclusions.

The project is intended to demonstrate disciplined analytical thinking, documentation quality, and stakeholder awareness, rather than simply producing descriptive charts.