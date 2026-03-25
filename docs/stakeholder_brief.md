# Stakeholder Brief

## Project Title

**NZ Road Safety Data Quality & Monitoring Review**

## Brief Summary

This project is a public-sector style analytical review designed to assess whether publicly available NZ road safety data is suitable for reliable reporting and monitoring.

Rather than focusing only on charts or descriptive analysis, the project examines whether the source data is complete, internally consistent, and current enough to support interpretation. It also aims to translate technical review findings into a format that a non-technical stakeholder could understand.

## Intended Audience

This brief is written for a stakeholder who may rely on reporting outputs but may not work directly with raw data. This includes:

- managers
- policy staff
- reporting users
- operational stakeholders

## Problem Statement

A reporting trend can be misleading if the underlying data has gaps, delays, or classification issues.

Before using road safety data to summarise changes, compare periods, or support decisions, an analyst should first confirm:

- whether the data appears complete
- whether recent values are still stabilising
- whether field definitions are comparable over time
- whether any obvious anomalies require caution

## What This Project Will Deliver

This project will deliver:

- a structured review of data quality risks
- a set of monitoring-ready metrics
- clear documentation of assumptions and limitations
- a concise explanation of which trends appear dependable
- a record of issues that should be considered before reporting

## What This Project Will Not Claim

This project will not:

- claim to represent official NZTA analysis
- claim direct policy impact
- present public data as if it were an internal operational source
- overstate uncertain trends as confirmed findings

## Key Stakeholder Value

The value of this project is that it demonstrates a disciplined analytical approach.

Instead of moving directly from raw data to charts, it shows a workflow that:

1. checks the reliability of the source
2. identifies issues that affect interpretation
3. separates stronger findings from weaker ones
4. documents those decisions clearly

This helps reduce the risk of over-interpreting incomplete or unstable data.

## Questions This Review Helps Answer

- Is the dataset usable for monitoring?
- Which metrics are safe to report with confidence?
- Which recent values need caution?
- What quality issues should be disclosed to users?
- What follow-up checks should be considered in future reporting cycles?

## Deliverable Format

The project is being packaged in a GitHub repository with structured documentation, scripts, and supporting outputs so that the workflow can be reviewed transparently and understood without relying on verbal explanation alone.

## Current Status

The project has moved beyond setup and documentation.

The repository now includes a completed field inventory layer, a formal quality validation layer, a targeted severity exception review, and a first monitoring layer that converts validation outputs into stakeholder-facing issue summaries.

### Low-volume exception review

The exception review identified two residual themes.

The first is a very small number of records with incomplete geographic reference fields, including missing TLA and related small-area identifiers. These records are retained in the stakeholder-facing issue register because they are relevant to location-based reporting quality, even though they are not material to national annual or financial-year monitoring.

The second is a single historical record from 2005 with missing injury-count fields. This has been retained as a monitored exception but is not treated as a headline reporting risk.

