# Data Sources

## Purpose of This Document
This document records the main data source used in version 1 of the NZ Road Safety Data Quality & Monitoring Review and explains the source context, usage boundaries, and interpretive constraints that apply to this portfolio project.

The purpose is not only to identify the source file, but also to clarify how the source should be understood within a reporting-readiness and data quality review workflow.

---

## Primary Data Source
Primary working file:
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

Source context:
- publicly available New Zealand road safety data
- sourced from the NZTA Crash Analysis System (CAS) public data extract
- used as the primary input for field inventory, validation, exception review, and monitoring-oriented summary outputs

Current extract profile:
- Rows: 913,464
- Columns: 72

---

## Source Role in This Project
This source is used as the foundation for a public-sector style data quality and monitoring review.

In version 1, the source is used to support:
- field inventory and structural review
- missingness review
- date coverage review
- formal quality validation
- targeted exception review
- annual monitoring summaries
- financial-year monitoring summaries
- stakeholder-facing interpretation with caveats

The project does not use the source simply for descriptive charting.  
It uses the source to assess whether the reviewed extract is sufficiently reliable for structured reporting and monitoring before interpretation is produced.

---

## Source Boundary
This project uses a **public extract** rather than an internal operational reporting environment.

Accordingly, the source should not be interpreted as:
- official NZTA reporting output
- official government reporting
- a live operational reporting feed
- production-grade enterprise reporting infrastructure
- operational sign-off on source-system quality

The source is treated as a public analytical input that can be reviewed for reporting readiness within the limits of the extract available to the project.

---

## Version 1 Usage Context
Version 1 is primarily framed around:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic data quality review
- issue logging and monitoring-ready summary outputs

Version 1 is not primarily framed around:
- monthly operational reporting
- daily operational reporting
- real-time monitoring

This reflects the structure of the reviewed extract, which is more naturally aligned to:
- `crashYear`
- `crashFinancialYear`

than to a strongly event-date-driven operational reporting design.

---

## Source Handling Approach
The source is handled through a layered analytical workflow:

1. **Field Inventory Layer**
   - `scripts/01_field_inventory.R`

2. **Quality Validation Layer**
   - `scripts/02_quality_checks.R`

3. **Severity Exception Review**
   - `scripts/02a_review_severity_conflicts.R`

4. **Exception Review and Monitoring Layer**
   - `scripts/03_exception_review_and_monitoring_layer.R`

This means the source is not interpreted directly without review.  
It is first assessed for structure, completeness, validity, consistency, uniqueness, and exception patterns before stakeholder-facing conclusions are drawn.

---

## Extract-Specific Interpretation
All conclusions in version 1 should be read as applying to the reviewed extract used in this project.

This means findings are:
- extract-specific
- workflow-specific
- version 1 bounded

The project does not assume that every future CAS extract will necessarily produce identical findings without rerunning the same review steps.

---

## Source-Related Caveat Position
Based on the current version 1 review, no major high-volume structural failures were identified in the reviewed extract.

Most flagged issues were low-volume exceptions or warning-level completeness gaps rather than broad defects that would materially weaken national monitoring use.

The main residual stakeholder-relevant caveat is a very small number of records with incomplete geographic reference fields, including fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This is not expected to materially affect:
- national annual summaries
- national financial-year summaries
- broad monitoring interpretation

However, it becomes more relevant where reporting becomes more geographically detailed, including:
- TLA-level reporting
- area-unit interpretation
- meshblock-linked analysis
- map-based outputs
- tightly scoped local-area summaries

A separate isolated historical exception also remains on record:
- one 2005 Auckland record with missing `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`

Because this issue is isolated and low-volume, it is retained as a monitored exception rather than treated as a headline source reliability concern.

---

## Practical Source Interpretation
For version 1, the reviewed source appears usable for structured monitoring purposes, provided that:
- low-volume exceptions are interpreted proportionately
- geographic completeness caveats are disclosed where relevant
- outputs are not overstated beyond the scope of the reviewed public extract

In practical terms, the current source is best understood as:

**fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**

---

## Related Documentation
This document should be read together with:
- `README.md`
- `docs/project_status.md`
- `docs/decision_log.md`
- `docs/executive_summary.md`
- `docs/stakeholder_brief.md`
- `docs/methodology.md`
- `docs/assumptions_and_limitations.md`

Together, these documents explain how the source was reviewed, how findings were interpreted, and how reporting boundaries were defined for version 1.