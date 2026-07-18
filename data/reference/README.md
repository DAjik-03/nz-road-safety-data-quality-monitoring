# R baseline controls

These small CSV files are selected outputs from the existing R workflow. They let the DuckDB implementation prove that it preserves the established results rather than merely producing plausible-looking numbers.

The SQL validation layer compares:

- annual crash counts
- financial-year crash counts
- core-field missing counts
- severity-group crash and casualty totals
- duplicate-ID and known-exception controls

The files apply only to the 913,464-row snapshot identified in `data/README.md`. Refresh them whenever the source snapshot or the R methodology changes.
