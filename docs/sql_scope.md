# SQL extension scope

## Purpose

Add a reproducible DuckDB validation and reporting layer to the existing NZ Road Safety project. The extension demonstrates how SQL can load a large public extract, profile it, apply traceable quality rules, expose monitoring-ready views and reconcile results with an independent R workflow.

## In scope

- one-command DuckDB execution
- typed staging of the 913,464-row, 72-column CAS snapshot
- structural and core-field profiling
- at least eight reporting-relevant quality rules
- record-level exception traceability
- annual, financial-year, severity and geographic monitoring views
- four to six representative business questions
- exact reconciliation to selected R baseline controls
- compact CSV outputs suitable for Power BI import or GitHub review

## Out of scope

- replacing all R analysis with SQL
- claiming SQL Server, Azure, Databricks or production database experience
- building a cloud pipeline, orchestration platform or live operational feed
- treating every source null as a defect
- changing the existing national-monitoring conclusion without evidence

## Completion criteria

The extension is complete when `sql/run_all.sql` executes without error in DuckDB 1.5.x, all release-blocking tests pass, review-status exceptions remain traceable, documented outputs are generated, and the SQL, R and Power BI descriptions make consistent claims.
