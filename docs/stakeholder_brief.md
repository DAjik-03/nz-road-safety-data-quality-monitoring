# Stakeholder Brief

## Project Title
**NZ Road Safety Data Quality & Monitoring Review**

## Brief Summary
This project is a public-sector style analytical review of publicly available New Zealand road safety data from the NZTA Crash Analysis System (CAS).

The purpose is not simply to describe crash patterns, but to assess whether the available extract is reliable enough for structured reporting and monitoring before stakeholder-facing interpretation is produced.

The review is designed to show how an analyst might move from raw public data to a more disciplined reporting position through:
- field inventory and structural review
- formal data quality validation
- targeted exception review
- monitoring-ready summary outputs
- stakeholder-facing interpretation and caveats

## Intended Audience
This brief is written for a non-technical or semi-technical stakeholder who may rely on reporting outputs without working directly in the raw source data.

This includes:
- managers
- reporting users
- policy or planning staff
- operational stakeholders

## Why This Review Matters
Trend outputs can be misleading if the underlying data is incomplete, internally inconsistent, or used without appropriate caveats.

Before using road safety data to compare periods or support discussion, an analyst should first establish:
- whether the source appears sufficiently complete for reporting
- whether any exceptions are material or low-volume
- whether identified issues affect national monitoring, detailed geographic reporting, or both
- what limitations should be disclosed before interpretation

## Current Project Position
The repository has moved beyond setup and first-pass validation.

It now includes:
- a completed field inventory layer
- a formal quality validation layer
- a targeted severity exception review
- a monitoring layer that converts validation outputs into issue summaries, exception review outputs, and annual / financial-year monitoring summaries

At this stage, the project is focused on final interpretation, stakeholder-safe wording, and portfolio presentation polish rather than redesigning the validation logic.

## Stakeholder-Facing Interpretation
Based on the current version 1 workflow, the extract appears suitable for:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing interpretation with targeted caveats

No major high-volume structural failures were identified in the current validation process.

Most flagged items were low-volume exceptions or warning-level completeness gaps rather than broad defects that would materially weaken national monitoring use.

## Main Residual Caveat
The main residual stakeholder-relevant caveat is a very small number of records with incomplete geographic reference fields, including fields such as TLA and other small-area identifiers.

This does not appear material to:
- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, it should be noted where reporting moves into:
- TLA-level outputs
- area-unit or meshblock-linked views
- map-based interpretation
- tightly scoped local-area reporting

## Monitored Exception
A separate isolated historical exception remains on record: one 2005 Auckland record with missing `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`.

Given its isolated nature, this is retained as a monitored exception rather than treated as a headline stakeholder concern.

## Final Position for Version 1
The version 1 reporting position is best described as:

**fit for monitoring use, with targeted caveats rather than broad reliability concerns**

In practice, this means:
- suitable for annual monitoring
- suitable for financial-year monitoring
- not materially undermined by high-volume structural failure
- appropriate for stakeholder-facing use when geographic completeness caveats are stated clearly

## What This Project Does Not Claim
This project does not:
- represent official NZTA analysis
- claim policy impact
- present public data as if it were an internal operational reporting source
- overstate isolated exceptions as broad structural failure

## Practical Takeaway
A stakeholder using this dataset for broad monitoring should be able to proceed with reasonable confidence.

Where reporting becomes more geographically granular, a short caveat should be included noting that a very small number of records have incomplete geographic reference fields, which may slightly reduce precision for fine-grained local reporting.