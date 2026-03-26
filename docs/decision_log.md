# Decision Log

## Purpose of this document
This log records the main analytical and presentation decisions that shaped the Version 1 workflow and reporting position.

The main analytical structure is in place, including:
- field inventory
- quality validation
- severity exception review
- exception review and monitoring layer outputs
- stakeholder-facing presentation artefacts

At this stage, the main role of this document is to explain the reasoning behind the current Version 1 position rather than to reopen foundational design choices.

---

## Decision 1 — Use a public-sector style data quality review rather than a simple dashboard project

**Decision**  
The project was framed as a public-sector style data quality and monitoring review rather than a visualisation-first portfolio project.

**Reasoning**  
The purpose of the portfolio is to demonstrate disciplined analyst practice, including:
- reviewing source data before interpretation
- documenting limitations and assumptions
- distinguishing between data issues and reporting suitability
- producing stakeholder-safe monitoring outputs

**Implication**  
The repository prioritises validation, exception review, documentation, and reporting readiness over visual presentation alone.

**Status**  
Confirmed

---

## Decision 2 — Validate reporting readiness before producing stakeholder-facing interpretation

**Decision**  
Stakeholder-facing interpretation should follow validation rather than precede it.

**Reasoning**  
Trend summaries and reporting outputs can be misleading if the underlying extract has not first been reviewed for:
- completeness
- validity
- consistency
- uniqueness
- material exceptions

**Implication**  
The analytical flow was intentionally structured as:

field inventory → quality validation → exception review → monitoring layer → stakeholder-facing interpretation

**Status**  
Confirmed

---

## Decision 3 — Frame Version 1 around annual and financial-year monitoring

**Decision**  
Version 1 was framed primarily around annual and financial-year monitoring rather than monthly or daily operational reporting.

**Reasoning**  
The current public extract is more naturally suited to:
- `crashYear`
- `crashFinancialYear`

than to a strongly event-date-driven operational reporting design.

**Implication**  
Version 1 conclusions are strongest for:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- reporting-readiness interpretation

**Status**  
Confirmed

---

## Decision 4 — Keep the project extract-specific and Version 1 bounded

**Decision**  
The project should present conclusions as extract-specific and Version 1 appropriate rather than universal claims about all future CAS extracts.

**Reasoning**  
The review is based on the currently assessed public extract and the current workflow implementation.  
It should not imply ongoing operational sign-off or permanent source-system guarantees.

**Implication**  
Documentation consistently frames conclusions as:
- Version 1 appropriate
- workflow-specific
- bounded to the reviewed extract

**Status**  
Confirmed

---

## Decision 5 — Apply a formal quality validation layer before exception interpretation

**Decision**  
The project should use a formal validation layer covering completeness, validity, consistency, and uniqueness before any monitoring interpretation is made.

**Reasoning**  
A structured validation layer creates a defensible basis for distinguishing:
- broad structural concerns
- isolated anomalies
- warning-level completeness gaps
- issues that matter for stakeholder reporting

**Implication**  
`scripts/02_quality_checks.R` became the core validation layer for Version 1.

**Status**  
Confirmed

---

## Decision 6 — Refine severity-conflict interpretation instead of treating all severity conflicts the same

**Decision**  
Severity-related conflicts should be interpreted with more nuance rather than treated as a single undifferentiated error type.

**Reasoning**  
Not all apparent severity conflicts carry the same reporting meaning.

The Version 1 refinement adopted was:
- non-injury + fatal/serious counts = error
- non-injury + minor-only count = warning

**Implication**  
The project avoids overstating lower-severity inconsistencies while still treating stronger contradictions as material quality concerns.

**Status**  
Confirmed

---

## Decision 7 — Use materiality-based interpretation rather than raw exception inflation

**Decision**  
Low-volume exception rows should not automatically be presented as multiple front-facing stakeholder issues.

**Reasoning**  
Raw exception counts alone can overstate reporting risk.  
The project should distinguish between:
- low-volume isolated exceptions
- warning-level gaps
- issues with likely stakeholder impact
- issues that materially affect monitoring suitability

**Implication**  
Version 1 interpretation is based on materiality, context, and likely reporting effect rather than simply the number of flagged rows.

**Status**  
Confirmed

---

## Decision 8 — Treat incomplete geographic reference fields as the main residual stakeholder-facing caveat

**Decision**  
The main residual stakeholder-relevant caveat for Version 1 should be incomplete geographic reference fields.

**Reasoning**  
A very small number of records show incomplete values in fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This is more relevant to stakeholder-facing reporting than isolated low-volume exceptions because it can affect the precision of detailed geographic outputs.

**Implication**  
Documentation should consistently state that:
- national annual monitoring is not materially weakened
- national financial-year monitoring is not materially weakened
- detailed geographic reporting requires clearer caveats

**Status**  
Confirmed

---

## Decision 9 — Retain the 2005 Auckland injury-count anomaly as a monitored exception, not a headline issue

**Decision**  
The isolated 2005 Auckland record with missing injury counts should remain on file as a monitored exception rather than a major stakeholder-facing concern.

**Reasoning**  
The issue is:
- historical
- isolated
- low-volume

It does not indicate a broad structural failure across the extract.

**Implication**  
The issue remains documented, but it is not elevated into a headline statement about overall reporting unsuitability.

**Status**  
Confirmed

---

## Decision 10 — Build a monitoring layer that converts validation outputs into reporting-ready summary structures

**Decision**  
The project should include a monitoring layer that elevates raw validation outputs into monitoring-ready and stakeholder-facing summaries.

**Reasoning**  
Record-level flags alone are not sufficient for reporting interpretation.  
A stakeholder-facing workflow needs summary structures such as:
- issue summaries
- exception registers
- annual monitoring summaries
- financial-year monitoring summaries
- priority completeness summaries
- stakeholder headline tables

**Implication**  
`scripts/03_exception_review_and_monitoring_layer.R` was added as a distinct analytical layer rather than leaving the project at raw validation output level.

**Status**  
Confirmed

---

## Decision 11 — Treat scripts and documentation as the source of truth where outputs are not fully visible in Git

**Decision**  
If some output tables are not tracked or visible in the repository, the project should still interpret the workflow based on scripts and supporting documentation.

**Reasoning**  
Some generated outputs may not appear in Git even though the workflow clearly defines and produces them.

**Implication**  
The project should not treat non-visible outputs as automatically absent when:
- script logic is present
- documentation references are present
- workflow intent is clear

**Status**  
Confirmed

---

## Decision 12 — Shift the project from analytical build mode to final packaging mode

**Decision**  
The repository should now be treated as being in final interpretation and presentation polish mode rather than foundational build mode.

**Reasoning**  
The core Version 1 analytical layers are already complete.

Reopening foundational design questions would create unnecessary churn and weaken the clarity of the final portfolio state.

**Implication**  
Natural next-step work moved into:
- README alignment
- wording consistency across documentation
- stakeholder-facing interpretation polish
- repository-facing presentation cleanup
- final portfolio packaging

**Status**  
Confirmed

---

## Decision 13 — Add front-facing presentation outputs without changing the analytical core

**Decision**  
A small set of front-facing presentation outputs was added to the repository, including a one-page portfolio snapshot, a workflow diagram, a Power BI summary view, a static figure set, a stakeholder-friendly Excel export, and a concise monitoring summary note.

**Reasoning**  
The project had already completed its core validation-led analytical build.  
However, the repository remained easier to understand after reading than at first glance.  
These additions were made to improve portfolio readability and stakeholder-facing communication without introducing a new analytical framework or changing the established reporting position.

**Implication**  
The project remains an independent public-data portfolio review rather than an official reporting product.  
The added artefacts are packaging outputs designed to make the completed findings easier to assess and communicate at a glance.

**Status**  
Confirmed

---

## Current Version 1 Position
Taken together, the decisions above support the following Version 1 conclusion:

- no major high-volume structural failures were identified
- most flagged items are low-volume exceptions or warning-level completeness gaps
- the main residual stakeholder-facing caveat is incomplete geographic reference coverage in a very small number of records
- one isolated historical injury-count exception remains as a monitored item
- overall position: **fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**

---

## Decisions Not Being Reopened
The following are treated as settled for Version 1 and are not being reopened as if still under early design discussion:
- repository structure foundation
- field inventory design
- core validation design
- severity conflict refinement
- monitoring layer design
- annual / financial-year framing
- materiality-based interpretation logic
- front-facing packaging rationale

---

## Final Note
This decision log should be read together with:
- `README.md`
- `docs/project_status.md`
- `docs/executive_summary.md`
- `docs/stakeholder_brief.md`
- `docs/monitoring_summary.md`
- `docs/assumptions_and_limitations.md`

Its function is to show that the project’s final position was not accidental or purely descriptive, but the result of documented analytical choices made within a bounded Version 1 workflow.