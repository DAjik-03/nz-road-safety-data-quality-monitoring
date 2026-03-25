# Decision Log

## Purpose

This document records the major project decisions made so far, including why they were made and how they affect the direction of the repository.

The purpose of this log is to preserve project reasoning so that future work remains consistent, even if the project is resumed in a new conversation or after a gap.

---

## Decision 1 — The project should be a serious portfolio piece, not a quick filler project

### Decision
The project will be developed as a high-effort representative portfolio project rather than a short placeholder exercise.

### Why
The main goal is to strengthen LinkedIn, CV, GitHub, and interview readiness with something that looks credible enough to support applications for junior or graduate analytical roles.

### Implication
The repository must look structured, documented, and realistic rather than like a simple classroom exercise or notebook-only submission.

---

## Decision 2 — The project should be positioned for real-world employability

### Decision
The project should be framed to make the author look ready for practical entry-level analytical work.

### Why
The desired impression is not just “can analyse data,” but “can contribute in a real reporting environment.”

### Implication
The project should emphasise:

- clear structure
- documentation
- cautious interpretation
- stakeholder readability
- reproducible workflow
- realistic reporting logic

---

## Decision 3 — Government / public-sector alignment is the strongest fit

### Decision
The project should align most closely with public-sector style work.

### Why
The target job direction prioritises:

1. government / public sector
2. banking / finance
3. large organisations

### Implication
The project should feel more like:

- reporting support
- data quality review
- monitoring workflow
- stakeholder briefing

and less like:

- experimental machine learning
- purely academic modelling
- flashy dashboard-only work

---

## Decision 4 — The project should use a new domain rather than rely on previous personal experience

### Decision
The project should use a fresh domain rather than directly re-use earlier work areas.

### Why
The goal was to build broader and more transferable experience rather than simply repeat existing themes.

### Implication
A public data domain with strong portfolio value was preferred.

---

## Decision 5 — NZ public data is preferred over global data where possible

### Decision
The project should prioritise New Zealand data if a strong source is available.

### Why
NZ-relevant work is more useful for local employability and makes the portfolio more directly relevant to target roles.

### Implication
The chosen source needed to be:

- publicly accessible
- credible
- relevant to public-sector style analysis
- rich enough for documentation-heavy portfolio work

---

## Decision 6 — The selected project domain is NZ road safety using NZTA CAS data

### Decision
The project domain selected is NZ road safety using NZTA Crash Analysis System (CAS) public data.

### Why
This option best matched the project goals:

- official New Zealand public source
- realistic public-sector relevance
- rich enough for documentation and quality review
- suitable for structured monitoring work
- less “student assignment” in appearance than many common public datasets

### Implication
The project is now anchored around road safety reporting, data reliability, and monitoring readiness.

---

## Decision 7 — The project should be data quality and monitoring focused, not just descriptive analysis

### Decision
The project should be framed as a **data quality and monitoring review** rather than a simple crash analysis project.

### Why
This better supports the intended professional impression.

It positions the author as someone who can:

- assess data reliability
- identify reporting risks
- separate dependable findings from cautionary ones
- support decision-making more responsibly

### Implication
The repository should prioritise:

- validation logic
- limitations documentation
- issue logging
- reporting caution
- structured stakeholder communication

---

## Decision 8 — GitHub is the main portfolio delivery surface

### Decision
The project should be built primarily as a GitHub portfolio repository.

### Why
GitHub supports:

- structured presentation
- documentation
- code transparency
- reproducibility
- portfolio linking from LinkedIn and CV

### Implication
The project needed a strong folder structure, multiple supporting documents, and a professional README from the beginning.

---

## Decision 9 — The project should use R as the main analytical tool, with SQL as support

### Decision
R is the main implementation language, with SQL used as a supporting validation tool where useful.

### Why
R was explicitly preferred, and SQL adds practical analytical credibility without changing the project’s core direction.

### Implication
The codebase should be R-led, but structured in a way that still reflects practical analytical work rather than a purely academic script collection.

---

## Decision 10 — Excel should be used as a reporting-support artefact, not as the main analytical engine

### Decision
Excel remains part of the project, but mainly as a supporting artefact such as an issue register or validation summary.

### Why
This adds realism and business usability without weakening the technical identity of the project.

### Implication
Excel should appear in outputs and project packaging, not as the main analytical workflow.

---

## Decision 11 — The initial planned time scope was a recent five-year reporting window

### Decision
The original intended scope was a recent five-year reporting window.

### Why
This was chosen to balance relevance, manageability, and a realistic reporting frame.

### Implication
Documentation and planning were initially written with a recent five-year monitoring focus.

---

## Decision 12 — The practical v1 time structure has shifted toward annual and financial-year analysis

### Decision
Based on the current extract, version 1 will focus primarily on annual and financial-year reporting rather than monthly reporting.

### Why
The current extract contains:

- `crashYear`
- `crashFinancialYear`

but does not appear to include a clearly usable full event date field for monthly or daily analysis.

### Implication
Version 1 should prioritise:

- annual reporting
- financial-year comparison
- geographic comparison
- severity reporting
- quality validation

Monthly or quarterly monitoring may be added later only if a usable date field becomes available in a future extract.

---

## Decision 13 — Not all available columns should be used

### Decision
The project should deliberately use only a controlled subset of fields.

### Why
Using every field would increase complexity, reduce clarity, and make the project feel less purposeful.

### Implication
Fields are now grouped into:

- core
- secondary
- excluded / low-priority

This supports a cleaner v1 design.

---

## Decision 14 — High-missingness fields should not drive the main reporting layer

### Decision
Fields with very high missingness should be excluded from the main monitoring layer.

### Why
A reporting project focused on reliability should not rely heavily on fields that are too incomplete for dependable interpretation.

### Implication
Fields such as the following are not suitable for core v1 reporting:

- `crashRoadSideRoad`
- `intersection`
- `temporarySpeedLimit`
- `pedestrian`
- `advisorySpeed`

Some may remain as secondary fields, but not as core reporting drivers.

---

## Decision 15 — The repository should be treated as the source of truth, not the chat history

### Decision
The repository documentation and Git history should act as the authoritative project record.

### Why
Conversation history can become long, slow, or fragmented across sessions.

### Implication
Key project state and decision logic should be written into repository documents so the project can be resumed in a new conversation without losing direction.

---

## Decision 16 — Handoff resilience is required

### Decision
The project should remain easy to resume in a new chat.

### Why
Long conversations may become slow, and project work may need to continue later.

### Implication
The repository now includes dedicated handoff-style documentation such as:

- `docs/project_status.md`
- `docs/decision_log.md`

These files are intended to preserve continuity.

---

## Decision 17: Implement v1 quality validation as a separate script layer

Date: 24 Mar 2026

Decision:
A dedicated script, scripts/02_quality_checks.R, was introduced as the first formal validation layer after field inventory. The script runs directly from the raw CAS extract and exports structured CSV outputs to support issue review, summary reporting, and future monitoring logic.

Reason:
Phase 2 required a move from descriptive field profiling to explicit data quality rules. A separate script keeps profiling and validation responsibilities distinct, improves reproducibility, and creates a clearer foundation for later monitoring outputs.

Scope included in v1:
- duplicate / uniqueness checks
- required field completeness checks
- warning-level completeness checks for selected core fields
- crash year and financial year validity checks
- crash year / financial year consistency checks
- severity sanity checks
- basic location completeness checks
- record-level issue flags

Outcome from first execution:
The first execution completed successfully on the current extract (913,464 rows; 80 columns). Most flagged issues were warning-level completeness gaps. No high-volume duplication or temporal consistency failures were found. The main error-level finding was a small group of non-injury severity records with non-zero injury counts, which will be reviewed before the next phase.

---

## Decision 18: Refine non-injury severity consistency logic after targeted review

Date: 2026-03-24

### Decision
The original v1 severity rule treated any non-injury crash with one or more injury counts above zero as an error-level issue.

After targeted review of the flagged records, the rule was refined into two separate checks:

- non-injury with fatal or serious injury counts -> error
- non-injury with minor injury count only -> warning

### Why
The targeted review showed that the identified severity inconsistencies did not involve fatalCount > 0 or seriousInjuryCount > 0.

The issue pattern was limited to non-injury records with minorInjuryCount above zero only. Treating all such cases as error-level issues overstated the severity of the contradiction.

### Implication
The v1 quality framework now distinguishes between:

- high-severity logical contradictions that should remain error-level
- lower-severity classification inconsistencies that should remain visible but not dominate the issue narrative

This makes the validation output more accurate, more defensible, and more suitable for stakeholder-facing monitoring work.

---

## Decision 19: Promote validation outputs into a separate monitoring layer

Date: 2026-03-25

### Decision
A separate script, `scripts/03_exception_review_and_monitoring_layer.R`, was added after the validation layer to convert raw validation outputs into monitoring-ready and stakeholder-facing summary outputs.

### Why
By the end of the 02 layer, the project already had structured issue outputs, but they were still too close to raw validation logs.

A dedicated monitoring layer was needed to:

- organise issue types into a register structure
- isolate low-volume error issues for targeted review
- produce annual and financial-year quality summaries
- generate stakeholder headline metrics
- shift the project from “quality checks exist” to “quality findings can be monitored and communicated”

### Implication
The project now has a clearer analytical progression:

- field inventory
- validation
- exception review
- monitoring layer
- stakeholder packaging

This makes the repository look more like a realistic reporting workflow rather than a set of disconnected scripts.

### Outcome
The script was executed successfully on the current extract and generated:

- `issue_type_monitoring_summary.csv`
- `issue_register_v1.csv`
- `exception_review_register.csv`
- `exception_review_records.csv`
- `annual_quality_monitoring_summary.csv`
- `financial_year_quality_monitoring_summary.csv`
- `priority_field_completeness_by_year.csv`
- `priority_field_completeness_by_financial_year.csv`
- `stakeholder_quality_headlines.csv`

---

## Decision 20: Treat low-volume error issues as review items before final stakeholder packaging

Date: 2026-03-25

### Decision
Low-volume error-level issues should not automatically dominate the stakeholder-facing narrative.

Instead, they should first be separated into a dedicated exception review register and assessed before final presentation decisions are made.

### Why
The quality framework is intended to be rigorous without overstating concern.

A small number of error-level issues may still matter, but they should be interpreted in context:

- whether they are geographically concentrated
- whether they affect reporting materially
- whether they reflect likely source limitations or genuine defects
- whether they should remain in the core issue register or be handled as monitored exceptions

### Implication
The project now distinguishes between:

- core stakeholder-facing issues
- secondary monitoring items
- internal watch-list items
- low-volume exceptions requiring analyst review before final packaging

This supports a more defensible and more public-sector-style reporting approach.

---

## Current Next Decision Area

The next major decision area is no longer validation design.

The next major decision area is stakeholder-facing packaging, specifically:

- which issues remain in the final stakeholder register
- how caveats should be written
- how monitoring summaries should be interpreted in plain language
- whether the final presentation layer should include charts, tables only, or both