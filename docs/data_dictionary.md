# Data Dictionary

## Purpose of This Document
This document provides a version 1 field interpretation guide for the public NZTA Crash Analysis System (CAS) extract used in the NZ Road Safety Data Quality & Monitoring Review.

It is designed to support:
- field inventory interpretation
- data quality validation
- exception review
- monitoring-oriented summaries
- stakeholder-facing caveat wording
- consistent field interpretation across presentation-facing outputs

This is not intended to be an official NZTA schema document.  
It is a project-facing data dictionary based on the reviewed extract and the project workflow.

---

## Dictionary Boundary
This project uses a public extract rather than an internal operational reporting environment.

Accordingly, this document does not claim to provide:
- official NZTA source-system definitions
- enterprise metadata governance
- production-grade schema stewardship
- universal definitions for all future extracts

This dictionary should be read as:
- extract-specific
- workflow-specific
- version 1 bounded

Where a full structural reference is required, the main supporting inventory output is:
- `outputs/tables/field_inventory.csv`

---

## Source Profile
Primary working file:
- `data/raw/Crash_Analysis_System_(CAS)_data.csv`

Reviewed extract profile:
- Rows: 913,464
- Columns: 72

Inventory support files:
- `outputs/tables/field_inventory.csv`
- `outputs/tables/missingness_summary.csv`
- `outputs/tables/date_range_summary.csv`

---

## How to Read This Dictionary
Fields in this project are not treated as equally important.

Version 1 gives the most attention to fields that support:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic caveat interpretation
- validation and exception review

The table below uses the following practical interpretation style:
- **Project role** = why the field matters in this workflow
- **Interpretation note** = how the field should be read in version 1
- missingness is included because it affects reporting usefulness

---

## Key Missingness Patterns in the Reviewed Extract
Several patterns in the field inventory are important for interpretation:

- `crashRoadSideRoad` and `intersection` are present in the extract but currently 100% missing, so they should not be treated as usable reporting fields in version 1.
- Many object / roadside impact fields have approximately 58.76% missingness, suggesting they are conditional-use fields rather than universally populated attributes.
- `holiday` (94.48%), `advisorySpeed` (96.05%), `pedestrian` (96.69%), and `temporarySpeedLimit` (98.28%) have very high missingness and should be interpreted cautiously.
- Core monitoring and severity fields such as `crashYear`, `crashFinancialYear`, `crashSeverity`, `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount` are essentially complete and are central to the version 1 reporting position.
- Geographic reference fields such as `tlaId`, `tlaName`, `areaUnitID`, and `meshblockId` are effectively complete at inventory level, but remain important because geographic completeness is still the main stakeholder-facing caveat area in the wider workflow.

---

## Field Dictionary

### 1. Identifiers and Spatial Reference

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `OBJECTID` | integer | 0.00 | row identifier | Technical record identifier in the extract. |
| `X` | numeric | 0.00 | spatial coordinate | Coordinate field; useful for spatial reference, not central to version 1 headline reporting. |
| `Y` | numeric | 0.00 | spatial coordinate | Coordinate field; useful for spatial reference, not central to version 1 headline reporting. |
| `region` | character | 0.38 | geographic reporting | Broad regional geography field; relevant to subnational summaries. |
| `tlaId` | integer | 0.00 | geographic reference | Important for TLA-level interpretation and geographic caveat review. |
| `tlaName` | character | 0.00 | geographic reference | Human-readable TLA field; important for stakeholder-facing geographic summaries. |
| `areaUnitID` | integer | 0.00 | fine-grained geography | More relevant to detailed local reporting than national aggregate monitoring. |
| `meshblockId` | integer | 0.00 | fine-grained geography | Highly local geography field; part of the main residual geographic caveat discussion. |
| `urban` | character | 0.00 | geography / context | Urban-rural context field; useful for segmentation but not a headline caveat driver. |
| `crashLocation1` | character | 0.00 | location description | Primary location descriptor. |
| `crashLocation2` | character | 0.21 | location description | Secondary location descriptor; near-complete but slightly less complete than `crashLocation1`. |
| `crashSHDescription` | character | 0.00 | state highway context | Helps distinguish state-highway-related location context where relevant. |

---

### 2. Time and Calendar Fields

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `crashYear` | integer | 0.00 | core monitoring field | One of the main version 1 reporting fields for annual monitoring. |
| `crashFinancialYear` | character | 0.00 | core monitoring field | One of the main version 1 reporting fields for financial-year monitoring. |
| `holiday` | character | 94.48 | calendar context | Very high missingness; should be treated cautiously and not relied on as a broadly usable monitoring field. |

---

### 3. Crash Event Description and Road Context

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `crashSeverity` | character | 0.00 | core severity field | Central severity descriptor used in validation and reporting-readiness interpretation. |
| `crashDirectionDescription` | character | 0.00 | crash context | Directional crash description field. |
| `directionRoleDescription` | character | 0.01 | crash context | Near-complete descriptive role field; useful for interpretation rather than headline monitoring. |
| `crashRoadSideRoad` | logical | 100.00 | intersection / location logic | Present but fully missing in the current extract; not usable in version 1. |
| `intersection` | logical | 100.00 | intersection logic | Present but fully missing in the current extract; not usable in version 1. |
| `trafficControl` | character | 0.00 | road context | Road control environment field; complete and available for contextual analysis. |
| `light` | character | 0.00 | environment context | Lighting condition field relevant to crash context. |
| `streetLight` | character | 0.00 | environment context | Street-light-related context field. |
| `weatherA` | character | 0.00 | environment context | Primary weather-related descriptive field. |
| `weatherB` | character | 0.00 | environment context | Secondary weather-related descriptive field. |
| `roadCharacter` | character | 0.00 | road context | Describes road character context. |
| `roadLane` | character | 0.00 | road context | Lane-related descriptor. |
| `roadSurface` | character | 0.00 | road context | Road surface condition descriptor. |
| `NumberOfLanes` | integer | 0.25 | road geometry | Near-complete lane count field. |
| `speedLimit` | integer | 0.16 | road rules / context | Near-complete and potentially useful contextual field. |
| `temporarySpeedLimit` | integer | 98.28 | roadworks / temporary control | Extremely high missingness; treat as condition-specific only. |
| `advisorySpeed` | integer | 96.05 | road geometry / advisory context | Extremely high missingness; usable only as a narrow context field. |
| `roadworks` | integer | 58.76 | conditional road context | Conditional-use field; appears to be populated only in relevant cases. |
| `flatHill` | character | 0.00 | road shape / topography | Complete context field for terrain or alignment setting. |

---

### 4. Severity and Injury Outcome Fields

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `fatalCount` | integer | 0.00 | core severity count | Central to outcome checks; one isolated historical exception is monitored in the wider workflow. |
| `seriousInjuryCount` | integer | 0.00 | core severity count | Central to outcome checks and severity exception review. |
| `minorInjuryCount` | integer | 0.00 | core severity count | Central to outcome checks and materiality-based severity interpretation. |

---

### 5. Vehicle Involvement Fields

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `bicycle` | integer | 0.00 | mode / vehicle involvement | Indicates bicycle-related involvement context. |
| `bus` | integer | 0.00 | mode / vehicle involvement | Indicates bus-related involvement context. |
| `carStationWagon` | integer | 0.00 | mode / vehicle involvement | Indicates car/station-wagon involvement context. |
| `moped` | integer | 0.00 | mode / vehicle involvement | Indicates moped-related involvement context. |
| `motorcycle` | integer | 0.00 | mode / vehicle involvement | Indicates motorcycle-related involvement context. |
| `otherVehicleType` | integer | 0.00 | mode / vehicle involvement | Captures other vehicle-type involvement context. |
| `schoolBus` | integer | 0.00 | mode / vehicle involvement | Indicates school-bus-related involvement context. |
| `suv` | integer | 0.00 | mode / vehicle involvement | Indicates SUV involvement context. |
| `taxi` | integer | 0.00 | mode / vehicle involvement | Indicates taxi involvement context. |
| `train` | integer | 58.76 | mode / vehicle involvement | Conditional-use field; likely populated when relevant. |
| `truck` | integer | 0.00 | mode / vehicle involvement | Indicates truck involvement context. |
| `unknownVehicleType` | integer | 0.00 | mode / vehicle involvement | Indicates unknown vehicle-type involvement context. |
| `vanOrUtility` | integer | 0.00 | mode / vehicle involvement | Indicates van / utility vehicle involvement context. |
| `vehicle` | integer | 58.76 | general vehicle impact context | Conditional-use field rather than universally populated attribute. |
| `pedestrian` | integer | 96.69 | road-user involvement | Very high missingness; should be treated as narrowly populated rather than broadly complete. |
| `parkedVehicle` | integer | 58.76 | impact / vehicle context | Conditional-use field for parked-vehicle-related crashes. |

---

### 6. Object, Roadside, and Collision Partner Fields

| Field | Type | Missing % | Project role | Interpretation note |
|---|---:|---:|---|---|
| `bridge` | integer | 58.76 | impact object | Conditional-use object / structure field. |
| `cliffBank` | integer | 58.76 | impact object / terrain | Conditional-use field. |
| `debris` | integer | 58.76 | impact / hazard context | Conditional-use field. |
| `ditch` | integer | 58.76 | impact object / terrain | Conditional-use field. |
| `fence` | integer | 58.76 | impact object | Conditional-use field. |
| `guardRail` | integer | 58.76 | impact object | Conditional-use field. |
| `houseOrBuilding` | integer | 58.76 | impact object | Conditional-use field. |
| `kerb` | integer | 58.76 | impact object | Conditional-use field. |
| `objectThrownOrDropped` | integer | 58.76 | impact object | Conditional-use field. |
| `otherObject` | integer | 58.76 | impact object | Catch-all conditional object field. |
| `overBank` | integer | 58.76 | terrain / impact context | Conditional-use field. |
| `phoneBoxEtc` | integer | 58.76 | impact object | Conditional-use field. |
| `postOrPole` | integer | 58.76 | impact object | Conditional-use field. |
| `slipOrFlood` | integer | 58.76 | environmental hazard | Conditional-use field. |
| `strayAnimal` | integer | 58.76 | impact object / hazard | Conditional-use field. |
| `trafficIsland` | integer | 58.76 | impact object / road feature | Conditional-use field. |
| `trafficSign` | integer | 58.76 | impact object / road feature | Conditional-use field. |
| `tree` | integer | 58.76 | impact object | Conditional-use field. |
| `waterRiver` | integer | 58.76 | terrain / impact context | Conditional-use field. |

---

## Fields With Highest Version 1 Reporting Importance
The following fields are the most important to the current reporting-readiness position.

### Core monitoring fields
- `crashYear`
- `crashFinancialYear`

### Core severity / outcome fields
- `crashSeverity`
- `fatalCount`
- `seriousInjuryCount`
- `minorInjuryCount`

### Core geographic interpretation fields
- `region`
- `tlaId`
- `tlaName`
- `areaUnitID`
- `meshblockId`
- `urban`

These fields matter most because version 1 is primarily framed around:
- annual monitoring
- financial-year monitoring
- severity and outcome review
- geographic caveat interpretation

---

## Fields Requiring Extra Caution
The following fields require extra caution because they are present but not broadly usable in the current extract:

### Fully missing in the reviewed extract
- `crashRoadSideRoad`
- `intersection`

These should not be treated as usable reporting fields in version 1.

### Very high missingness
- `temporarySpeedLimit` — 98.28%
- `pedestrian` — 96.69%
- `advisorySpeed` — 96.05%
- `holiday` — 94.48%

These may still contain information in relevant cases, but they should not be described as broadly complete fields.

### Conditional-use fields with substantial missingness
A large group of impact / object / roadside fields have around 58.76% missingness and appear to function as conditional-use attributes rather than universally populated variables.

Examples include:
- `bridge`
- `ditch`
- `fence`
- `guardRail`
- `otherObject`
- `parkedVehicle`
- `tree`
- `vehicle`
- `waterRiver`

These should be interpreted as situational fields, not completeness failures in the same way as core monitoring fields.

---

## Relationship to the Wider Workflow
This dictionary should be read alongside:
- `README.md`
- `docs/project_status.md`
- `docs/decision_log.md`
- `docs/executive_summary.md`
- `docs/final_reporting_position.md`
- `docs/stakeholder_brief.md`
- `docs/monitoring_summary.md`
- `docs/stakeholder_issue_register_final.md`
- `docs/methodology.md`
- `docs/assumptions_and_limitations.md`
- `docs/data_sources.md`

It also supports interpretation of outputs such as:
- `outputs/tables/field_inventory.csv`
- `outputs/tables/quality_issue_summary.csv`
- `outputs/tables/quality_issues_long.csv`
- `outputs/tables/record_quality_flags.csv`
- `outputs/tables/issue_type_monitoring_summary.csv`
- `outputs/tables/issue_register_v1.csv`
- `outputs/tables/exception_review_register.csv`
- `outputs/tables/annual_quality_monitoring_summary.csv`
- `outputs/tables/financial_year_quality_monitoring_summary.csv`
- `outputs/tables/stakeholder_quality_headlines.csv`

---

## Practical Version 1 Takeaway
This data dictionary is intended to explain how the reviewed extract’s fields function within the version 1 reporting-readiness workflow.

In practical terms:
- annual and financial-year interpretation rely most heavily on `crashYear` and `crashFinancialYear`
- severity review relies heavily on `crashSeverity`, `fatalCount`, `seriousInjuryCount`, and `minorInjuryCount`
- geographic caveat interpretation relies most heavily on `region`, `tlaId`, `tlaName`, `areaUnitID`, and `meshblockId`
- several context and impact fields are conditional-use rather than universally populated

These same field interpretation boundaries should remain consistent across summary documentation, static figures, README presentation, and other front-facing portfolio outputs.

This is consistent with the overall version 1 conclusion that the reviewed extract appears:

**fit for version 1 monitoring use, with targeted caveats rather than broad reliability concerns**