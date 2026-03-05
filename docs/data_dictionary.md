# Data Dictionary

## Purpose

This document records the main fields, derived measures, and working definitions used in this project.

It is intended to make the analytical logic transparent and to reduce ambiguity when interpreting outputs.

Because the project uses public source data, exact working fields may be refined after full source review. This document begins as a controlled draft and will be updated as the analytical dataset is confirmed.

## Field Categories

The project is expected to use fields that broadly support the following areas:

- event identification
- event date / reporting period
- crash severity
- location or region
- road user or vehicle category
- contributing factor categories
- source record quality or completeness indicators where applicable

## Initial Core Fields (Planned)

The following field groups are expected to be central to the first working version of the project.

### 1. Record Identifier

A field used to uniquely reference an individual crash record or event record.

**Purpose:**  
Used for counting, duplicate checks, and record-level validation.

### 2. Event Date

The date associated with the crash event.

**Purpose:**  
Used for time-based aggregation, reporting windows, and trend analysis.

### 3. Reporting Period

A derived field created from the event date, such as month, quarter, or year.

**Purpose:**  
Used for monitoring summaries and period comparisons.

### 4. Severity Category

A field indicating the severity of the crash, such as fatal, injury, or non-injury.

**Purpose:**  
Used for segmentation of core monitoring metrics.

### 5. Location / Region

A location-based field used for broad geographic grouping.

**Purpose:**  
Used for regional summaries and comparison of reporting patterns.

### 6. Road User / Vehicle Group

A field or grouped set of fields describing the type of road user or vehicle involved.

**Purpose:**  
Used for category-level trend review and monitoring breakdowns.

### 7. Contributing Factor Category

A field or grouped classification that captures broad contributing factors.

**Purpose:**  
Used for high-level contextual trend review where appropriate.

## Derived Fields (Planned)

The following derived fields are expected to be created within the project workflow.

### Analysis Year

Extracted from the event date.

**Purpose:**  
Supports annual summaries and year-based completeness checks.

### Analysis Month

Extracted from the event date.

**Purpose:**  
Supports monthly trend monitoring.

### Analysis Quarter

Derived from the event date.

**Purpose:**  
Supports quarter-level reporting where monthly data may be unstable.

### Latest Full Period Flag

A flag indicating whether a reporting period is considered complete enough for stable comparison.

**Purpose:**  
Helps avoid overstating incomplete recent-period movements.

### Quality Issue Flag

A derived label used to indicate whether a record or field contributes to a validation concern.

**Purpose:**  
Supports issue logging and structured review.

## Documentation Note

This dictionary is intentionally written as a controlled draft during Phase 1.

Once the source data has been fully reviewed, this document will be expanded to include:

- confirmed field names
- exact definitions
- exclusions
- transformation logic
- final derived metric definitions