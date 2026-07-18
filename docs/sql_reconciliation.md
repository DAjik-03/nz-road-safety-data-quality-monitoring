# R-SQL reconciliation

## Overall result

**Ready to share.** All 12 release tests passed against the reviewed 913,464-row, 72-column CAS snapshot.

## Verified controls

| Control | Expected | SQL result | Status |
|---|---:|---:|---|
| Source row count | 913,464 | 913,464 | PASS |
| Distinct `OBJECTID` count | 913,464 | 913,464 | PASS |
| Annual totals with any mismatch | 0 years | 0 years | PASS |
| Financial-year totals with any mismatch | 0 periods | 0 periods | PASS |
| Core missingness controls with any mismatch | 0 fields | 0 fields | PASS |
| Severity/casualty groups with any mismatch | 0 groups | 0 groups | PASS |
| Blocking quality checks | 0 | 0 | PASS |
| Documented 2005 Auckland injury-count exception | 1 record | 1 record | PASS |

## Data-quality disposition

- `PASS`: seven rules had no failed records.
- `REVIEW`: five TLA records, four fine-geography records, 56 non-injury/minor-count records and one required-injury-count record require documented interpretation.
- `MONITOR`: 3,474 records have a missing region value, equal to approximately 0.3803% of the extract.
- `FAIL`: no blocking checks failed.

The same source record can appear under more than one rule, so rule-failure counts should not be summed and presented as a count of unique affected crashes.

## Reproducible evidence

Detailed comparisons are generated in:

- `outputs/sql/reconciliation_year.csv`
- `outputs/sql/reconciliation_financial_year.csv`
- `outputs/sql/reconciliation_missingness.csv`
- `outputs/sql/reconciliation_severity.csv`
- `outputs/sql/validation_results.csv`

Any source refresh must be treated as a new version. Exact reconciliation should only be expected after the R controls are regenerated from the same snapshot.

The 2026 crash year and 2025/2026 financial year are incomplete snapshot periods. They reconcile exactly to R, but they are labelled as partial and are not used for complete-period YoY interpretation.
