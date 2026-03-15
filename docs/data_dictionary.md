# Data Dictionary

## Purpose

This document records the working fields, data types, derived definitions, and usage decisions for the current NZTA Crash Analysis System (CAS) extract used in this project.

This version replaces the earlier planning draft and reflects the actual field inventory generated from the raw source file currently stored in `data/raw/`.

## Current Extract Profile

- **Source file:** `Crash_Analysis_System_(CAS)_data.csv`
- **Rows:** 913,464
- **Columns:** 72
- **Project use case:** Public-sector style road safety data quality review and monitoring workflow
- **Analytical emphasis:** Annual and financial-year monitoring, data quality validation, reporting readiness, and stakeholder-facing documentation

## Working Principle

This project does not treat all available fields equally.

Fields are grouped into:

1. **Core fields**  
   Used directly in the main quality checks, reporting summaries, and interpretation.

2. **Secondary fields**  
   Retained for possible supporting analysis, but not relied on in the main monitoring layer.

3. **Excluded or low-priority fields**  
   Not used in the first version of the project due to very high missingness or low relevance to the core reporting objective.

---

## Core Fields

### 1. Record and Geographic Reference

#### `OBJECTID`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Record-level identifier used for row counts, duplicate checks, and overall dataset validation.

#### `areaUnitID`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Geographic reference field used for location-linked review and possible consistency checks.

#### `meshblockId`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Fine-grained geographic reference field used for record structure and spatial completeness review.

#### `X`
- **Type:** numeric
- **Missingness:** 0.00%
- **Purpose:** Spatial coordinate used for location completeness and possible mapping support.

#### `Y`
- **Type:** numeric
- **Missingness:** 0.00%
- **Purpose:** Spatial coordinate used for location completeness and possible mapping support.

---

### 2. Time Fields

#### `crashYear`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Primary annual reporting field used for year-based summaries, trend review, and completeness checks.

#### `crashFinancialYear`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Public-sector style reporting field used for financial-year comparisons and alternative reporting views.

---

### 3. Location and Regional Reporting Fields

#### `region`
- **Type:** character
- **Missingness:** 0.38%
- **Purpose:** Regional grouping used for geographic reporting and comparison.
- **Usage note:** Suitable for core analysis, but minor missingness should be acknowledged.

#### `tlaId`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Territorial local authority identifier used for local-area reporting structure.

#### `tlaName`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Human-readable territorial local authority field used in reporting tables and stakeholder-facing outputs.

#### `crashLocation1`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Primary location description field used for qualitative location context.

#### `crashLocation2`
- **Type:** character
- **Missingness:** 0.21%
- **Purpose:** Secondary location description field used to support location review.
- **Usage note:** Small amount of missingness exists but does not prevent use.

#### `crashSHDescription`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** State highway description field used for location context and reporting segmentation where relevant.

---

### 4. Severity and Outcome Fields

#### `crashSeverity`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Core severity classification used to structure key reporting outputs.

#### `fatalCount`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Count field used in severity and outcome summaries.

#### `seriousInjuryCount`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Count field used in injury outcome reporting.

#### `minorInjuryCount`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Count field used in outcome summaries and comparison across periods and groups.

---

### 5. Road Context and Environment Fields

#### `speedLimit`
- **Type:** integer
- **Missingness:** 0.16%
- **Purpose:** Key contextual road variable used for descriptive reporting and quality review.
- **Usage note:** Appropriate for core analysis with minor caution.

#### `NumberOfLanes`
- **Type:** integer
- **Missingness:** 0.25%
- **Purpose:** Road structure variable used for contextual summaries and completeness review.

#### `roadCharacter`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Describes the road context for grouping and interpretation.

#### `roadLane`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Used for road configuration context.

#### `roadSurface`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Used for surface condition grouping and reporting context.

#### `trafficControl`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Used for interpreting traffic environment and control conditions.

#### `urban`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Supports urban / non-urban style segmentation.

#### `flatHill`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Terrain-related contextual field.

#### `light`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Lighting condition field used in contextual summaries.

#### `streetLight`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Used alongside light conditions for additional interpretation context.

#### `weatherA`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Primary weather context field.

#### `weatherB`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** Secondary weather context field.

---

### 6. Crash Direction and Event Description Fields

#### `crashDirectionDescription`
- **Type:** character
- **Missingness:** 0.00%
- **Purpose:** High-level event description field used for crash pattern interpretation.

#### `directionRoleDescription`
- **Type:** character
- **Missingness:** 0.01%
- **Purpose:** Supplementary event description used for crash configuration interpretation.
- **Usage note:** Minimal missingness only.

---

### 7. Vehicle Involvement Fields

These fields are treated as vehicle involvement count or presence fields and may be used for category-level comparisons.

#### `bicycle`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for cyclist-related involvement summaries.

#### `bus`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for public transport-related involvement summaries.

#### `carStationWagon`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for broad vehicle mix reporting.

#### `moped`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for two-wheel motor vehicle involvement summaries.

#### `motorcycle`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for motorcycle involvement summaries.

#### `otherVehicleType`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for residual vehicle category review.

#### `schoolBus`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for school bus involvement checks if needed.

#### `suv`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for vehicle mix summaries.

#### `taxi`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for category-specific involvement review where relevant.

#### `truck`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for heavy vehicle involvement summaries.

#### `unknownVehicleType`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used to assess ambiguity in vehicle classification.

#### `vanOrUtility`
- **Type:** integer
- **Missingness:** 0.00%
- **Purpose:** Used for vehicle mix summaries.

---

## Secondary Fields

These fields are retained in the dataset but are not expected to sit in the core reporting layer for version 1.

### `holiday`
- **Type:** character
- **Missingness:** 94.48%
- **Reason for secondary status:** Too incomplete for dependable baseline reporting.

### `pedestrian`
- **Type:** integer
- **Missingness:** 96.69%
- **Reason for secondary status:** Conceptually useful but too incomplete for core v1 reporting.

### `temporarySpeedLimit`
- **Type:** integer
- **Missingness:** 98.28%
- **Reason for secondary status:** Too incomplete for standard monitoring use.

### `advisorySpeed`
- **Type:** integer
- **Missingness:** 96.05%
- **Reason for secondary status:** Too incomplete for main comparative reporting.

### `vehicle`
- **Type:** integer
- **Missingness:** 58.76%
- **Reason for secondary status:** Possible supporting field, but missingness is too high for primary reliance.

---

## Excluded or Low-Priority Fields for Version 1

These fields are not planned for the main v1 analytical workflow.

### Fully Missing
- `crashRoadSideRoad` — logical — 100.00%
- `intersection` — logical — 100.00%

### High-Missingness Object / Obstacle Style Fields
These are currently treated as low-priority due to substantial missingness and lower relevance to the initial reporting objective.

- `bridge`
- `cliffBank`
- `debris`
- `ditch`
- `fence`
- `guardRail`
- `houseOrBuilding`
- `kerb`
- `objectThrownOrDropped`
- `otherObject`
- `overBank`
- `parkedVehicle`
- `phoneBoxEtc`
- `postOrPole`
- `roadworks`
- `slipOrFlood`
- `strayAnimal`
- `trafficIsland`
- `trafficSign`
- `train`
- `tree`
- `waterRiver`

These may be reconsidered in a future enhancement phase.

---

## Derived Fields Planned for the Project

The following working fields are expected to be created during transformation and reporting.

### `analysis_year`
- Derived from `crashYear`
- Used for clean reporting labels and controlled aggregation logic

### `analysis_financial_year`
- Derived or standardised from `crashFinancialYear`
- Used for public-sector style reporting outputs

### `severity_group`
- Derived from `crashSeverity`
- Used to standardise reporting categories if needed

### `latest_stable_period_flag`
- Derived using project logic
- Used to distinguish stable reporting periods from recent periods that may require caution

### `quality_issue_flag`
- Derived using validation logic
- Used to identify records or fields involved in specific quality checks

---

## Fields Not Currently Available for Full Date-Level Analysis

The current extract does not appear to include a clear full event date field suitable for direct daily or monthly time-series construction.

Because of this, version 1 of the project will primarily focus on:

- annual reporting
- financial-year reporting
- cross-sectional quality review
- geographic and severity-based comparisons

If a future extract includes a usable event date field, the monitoring layer may be extended to monthly or quarterly analysis.

---

## Usage Note

This dictionary is a practical working document rather than a full official metadata catalogue.

Its purpose is to define how fields are being used in this repository so that the project remains transparent, reproducible, and suitable for portfolio review.