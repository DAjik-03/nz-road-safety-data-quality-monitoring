# Assumptions and Limitations

## Purpose of This Document
This document sets out the main assumptions, interpretive boundaries, and practical limitations that apply to this version 1 review of publicly available NZTA Crash Analysis System (CAS) data.

Its purpose is to support disciplined use of the project outputs by clarifying what the current review is designed to support, where caution is required, and what this project does not claim.

## Analytical Position
This project is designed as a public-sector style data quality and monitoring review.

It is intended to show how publicly available crash data can be reviewed for reporting readiness through:
- field inventory
- quality validation
- exception review
- monitoring-oriented summary outputs
- stakeholder-facing interpretation with caveats
- presentation-facing outputs built from the completed review

The current version 1 position is:

**fit for monitoring use, with targeted caveats rather than broad reliability concerns**

## Core Assumptions

### 1. Public extract is suitable for structured review
This project assumes the publicly available CAS extract is suitable for a structured analytical review of:
- field coverage
- completeness
- validity
- internal consistency
- monitoring readiness

The project does not assume the extract is perfect, complete in every field, or equivalent to an internal operational reporting environment.

### 2. Materiality matters more than raw exception count
This review assumes that not all quality exceptions carry the same reporting significance.

Low-volume exceptions should not automatically be treated as material reporting failure.  
Instead, exceptions are interpreted in context, including:
- volume
- pattern
- field importance
- likely reporting impact
- whether the issue affects national monitoring or only detailed local reporting

### 3. Version 1 is oriented toward annual and financial-year monitoring
This project assumes that the current extract is more naturally suited to:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing summary interpretation

It is not primarily designed as a monthly or daily operational reporting framework.

### 4. Reporting should follow validation, not precede it
This project assumes that stakeholder-facing interpretation should only follow after the source has been reviewed for structural quality risks.

This means trend or summary discussion is intentionally framed by validation outcomes, exception review, and documented caveats.

The same principle applies to front-facing portfolio outputs such as static figures, README presentation, and summary artefacts: they should reflect the reviewed interpretation rather than introduce a new one.

## Main Limitations

### 1. Public data context
This project uses publicly available NZTA CAS data rather than internal reporting infrastructure.

Accordingly, this review should not be interpreted as:
- official NZTA analysis
- official government reporting
- operational sign-off on source-system quality
- a replacement for internal governance or operational data assurance processes

### 2. Geographic completeness caveat
A small number of records contain incomplete geographic reference fields, including fields such as:
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`

This does not appear material to broad national monitoring outputs such as annual or financial-year summaries.

However, this limitation becomes more relevant where outputs are used for:
- TLA-level reporting
- area-unit or meshblock-linked interpretation
- detailed map-based outputs
- highly localised geographic comparisons

### 3. Isolated historical exception remains on record
The current review identified one isolated historical record from 2005 in Auckland with missing:
- `fatalCount`
- `seriousInjuryCount`
- `minorInjuryCount`

This item is retained as a monitored exception.

Because it is isolated and low-volume, it is not treated as a headline reporting risk for version 1 monitoring use.

### 4. Version 1 is not a full production reporting framework
Although this project is structured in a reporting-oriented way, version 1 remains a portfolio workflow rather than a live enterprise reporting system.

This means the project demonstrates disciplined analytical practice, but does not claim:
- production-grade automation
- enterprise governance integration
- full operational exception management
- official stakeholder sign-off processes

### 5. Interpretation is bounded by the current extract
All findings are limited to the version of the extract reviewed in this project.

The conclusions should therefore be read as:
- extract-specific
- workflow-specific
- version 1 appropriate

They should not automatically be generalised to every future extract without rerunning the validation and monitoring steps.

## Practical Interpretation Boundaries

### Suitable uses
The current version 1 workflow appears suitable for:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- stakeholder-facing interpretation with targeted caveats

### Uses requiring additional caution
Additional caution is appropriate where outputs are intended for:
- fine-grained geographic reporting
- local-area comparison
- map-based presentation
- interpretation that depends heavily on fully complete geographic reference fields

### Uses not claimed by this project
This project does not claim suitability for:
- official NZTA performance reporting
- operational real-time monitoring
- production-level local-area decisioning
- policy interpretation beyond the constraints of the reviewed public extract

## Overall Limitation Statement
The main limitation in version 1 is not broad structural unreliability, but the need to apply targeted caveats where reporting becomes more geographically detailed.

Overall, the reviewed extract appears usable for structured monitoring purposes, provided that:
- low-volume exceptions are interpreted proportionately
- geographic completeness caveats are disclosed where relevant
- outputs are not overstated beyond the scope of the reviewed extract

These same limitation boundaries should remain visible across documentation, static figures, README presentation, and other front-facing portfolio outputs.