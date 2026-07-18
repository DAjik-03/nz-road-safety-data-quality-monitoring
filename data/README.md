# Data setup

## Source

This project uses the public NZ Transport Agency Waka Kotahi Crash Analysis System (CAS) extract.

- Official context: https://www.nzta.govt.nz/partners/data-and-tools/crash-analysis-system/
- Public feature service: https://spatial.nzta.govt.nz/portal/rest/services/Hosted/CAS_Data_Public/FeatureServer/0
- Local filename: `data/raw/Crash_Analysis_System_(CAS)_data.csv`

The reviewed snapshot contains 913,464 rows and 72 columns. It was retained locally on 16 March 2026 and is the same extract used by the existing R analysis.

SHA-256:

```text
DA1F3E993C4482D679E2F798ED9D4F0AD855E24C04E2C6AC90894043A0F227F0
```

## Prepare the input

1. Obtain the public CAS CSV from the NZTA open-data source.
2. Save it as `data/raw/Crash_Analysis_System_(CAS)_data.csv`.
3. Compare the file profile and checksum with the values above.
4. If the source has been refreshed, treat row-count, year-range or schema differences as a new data version and regenerate the R baseline before expecting exact reconciliation.

The raw CSV is intentionally excluded from Git because it is approximately 256 MB. Only small R baseline control tables in `data/reference/` are versioned.

## Publication boundary

The source is public, non-personal CAS data. This repository remains an independent portfolio project and is not official NZTA analysis or operational sign-off on source-system quality.
