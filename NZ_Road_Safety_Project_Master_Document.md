# Project Master Document
## NZ Road Safety Data Quality & Monitoring Review
Conversation handoff and working blueprint for restarting in a new chat.

## 1) Purpose
This document preserves all confirmed decisions for the user's flagship portfolio project so the work can continue in a new chat without repeating discovery.

## 2) User Goal Summary
- Build one flagship portfolio project strong enough for LinkedIn, CV, GitHub, and interview use.
- Target roles: Junior Data Analyst first, then Graduate / Intern roles.
- Desired impression: hireable, real-world ready, able to contribute immediately.
- Preferred employers: NZ government, then banking / finance, then large corporates.
- Must feel like real work, not a student assignment.
- Must be fully factual. No invented results, no fake business impact.
- This should be a representative flagship piece, not a fast filler project.

## 3) Confirmed User Preferences
- Project purpose is combined: profile strengthening, skill proof, interview story, and portfolio evidence.
- The project should feel like practical operational work, not just a technical showcase.
- Main public home: GitHub.
- Preferred tools named by the user: R and Excel.
- SQL is acceptable as a supporting validation tool.
- English-based project.
- New Zealand data preferred.
- The user is willing to invest significant time and wants a high-quality representative piece.
- The user specifically wants to avoid anything that looks rushed, shallow, or obviously AI-generated.
- The user feels weakest on "why" questions, so the project should be easy to explain clearly.

## 4) What the Project Should Signal
- The user can work with real public datasets.
- The user can assess data reliability before making conclusions.
- The user can structure work for reporting and decision support.
- The user can document assumptions, risks, and limitations clearly.
- The user can translate technical work into business-friendly outputs.

## 5) Final Decision Log
- Domain: Road safety
- Country focus: New Zealand first
- Project type: Data quality and reporting project, not just descriptive analysis
- Tone: Public-sector style operational monitoring
- Main repository home: GitHub
- Tool stack: R + Excel, with SQL as support
- Timeline style: flagship project with deep effort
- Truth standard: facts only, no exaggeration

## 6) Chosen Project
**NZ Road Safety Data Quality & Monitoring Review**

Core framing:
An end-to-end public-sector style analytics project using New Zealand road safety data to assess data quality, produce monitoring outputs, and generate stakeholder-ready documentation.

## 7) Why This Project Was Chosen
- Strong fit for NZ public-sector and policy-adjacent roles.
- Feels like real operational work rather than a school assignment.
- Matches the user’s desired tools and GitHub-focused presentation.
- Naturally combines analysis, reporting, validation, and explanation.
- Supports strong interview answers about judgement, risk, and data trust.

## 8) Business Framing
Treat the project as if the user were supporting a transport reporting or policy team.
- Stakeholders: ministry staff, local council analysts, transport policy teams, or road safety reporting teams
- Use case: periodic review of crash data quality and trend monitoring
- Objective: determine what can be reported confidently, what needs caution, and what needs follow-up

## 9) Core Objectives
- Assess the reliability of the selected road safety dataset before drawing conclusions.
- Build a repeatable monitoring layer for key road safety indicators.
- Document source limitations, timing risks, and interpretation constraints.
- Produce outputs that non-technical stakeholders can understand.

## 10) Recommended Deliverables
- Professional GitHub repository with clear structure and handoff-ready documentation
- R scripts for ingestion, cleaning, quality checks, metric generation, and export
- Small SQL folder for validation and reconciliation queries
- Excel issue register to log data quality findings in a business-friendly way
- Executive summary, stakeholder brief, project charter, methodology, assumptions, and data dictionary

## 11) Target Repository Structure
- README.md
- data/raw, data/processed, data/reference
- scripts/01 to 06 for ingestion through summary export
- sql/validation_queries.sql and aggregation_checks.sql
- outputs/figures, outputs/tables, outputs/excel
- docs/project_charter.md, methodology.md, data_dictionary.md, assumptions_and_limitations.md, executive_summary.md, stakeholder_brief.md
- assets/repo_banner.png

## 12) Mandatory Documentation Standards
- README must explain context, purpose, methods, findings, limitations, and reproducibility.
- Project charter must define scope, users, success criteria, and what is out of scope.
- Data dictionary must explain key fields, derived metrics, and exclusions.
- Assumptions and limitations must clearly separate strong findings from cautious findings.
- The repository should be understandable even without verbal explanation from the user.

## 13) Recommended Analysis Modules
- Ingestion and schema review
- Cleaning and transformation
- Data quality checks
- Metric creation and monitoring
- Figure generation
- Executive interpretation and reporting export

## 14) Data Quality Framework
- Completeness
- Validity
- Consistency
- Uniqueness
- Timeliness
- Change / drift

## 15) Suggested KPI Layer
- Total crashes
- Fatal crashes
- Injury crashes
- Non-injury crashes
- Severity mix
- Regional comparisons
- Road user / vehicle category trends
- Contributing factor trends
- Month-over-month and year-over-year changes

## 16) Planned Visual Outputs
- Monthly total crash trend
- Crash severity trend
- Regional comparison for the latest complete year
- Data completeness heatmap
- Latest period caution view
- Classification or source change annotation view

## 17) Planned Excel Artifact
**data_quality_issue_register.xlsx**

Suggested sheets:
- Issue Log
- Validation Summary
- Field Completeness
- Period Checks
- Business Notes

Suggested Issue Log columns:
- Issue ID
- Check Category
- Field / Metric
- Description
- Severity
- Period Affected
- Recommended Action
- Status
- Analyst Note

## 18) Interview Story Design
The project should make "why" answers easy.
- Why this project: it reflects how analysts support real reporting and decisions, not just charts.
- Why this domain: road safety has public-interest, policy, and operational relevance.
- Why data quality focus: unreliable data leads to unreliable reporting.
- Why documentation: the work should be handover-ready and independently understandable.
- Why caution matters: recent data or classification changes may affect interpretation.

## 19) Four-Week Flagship Plan
### Week 1 - Scope and Source Understanding
- Set up repository skeleton
- Obtain dataset and review fields
- Define scope, core columns, and initial documentation

### Week 2 - Cleaning and Validation Design
- Build cleaning steps and validation rules
- Create initial SQL checks
- Draft the Excel issue register and identify first quality issues

### Week 3 - Monitoring and Insight Layer
- Create KPIs and core charts
- Test trends and interpretation rules
- Draft executive summary and stakeholder brief

### Week 4 - Final Polish and Career Packaging
- Finalize documentation and visual outputs
- Polish the GitHub landing experience
- Prepare CV bullets, LinkedIn description, and interview talking points

## 20) Non-Negotiable Rules
- Do not overclaim policy impact
- Do not imply employment by a government agency
- Do not present incomplete recent data as confirmed final truth
- Do not rely on one notebook only
- Do not publish a bare repository without documentation
- Do not use filler visuals just to make the project look bigger

## 21) Draft Career Packaging Line
Built an end-to-end road safety data quality and monitoring project focused on validation rules, reporting reliability, and stakeholder-ready trend insights.

## 22) What Phase 1 Will Cover Next
- Finalize working GitHub folder structure
- Draft the full README
- Draft the project charter
- Define exact core columns, exclusions, and first analysis scope

## 23) Ready-to-Use Handoff Prompt for a New Chat
Paste this into a new chat:

I am building a flagship GitHub portfolio project for Junior Data Analyst and Graduate Data Analyst roles in New Zealand, especially government and finance oriented roles.
The confirmed project direction is: NZ Road Safety Data Quality & Monitoring Review.
The project should be presented as a public-sector style data quality and reporting project, not a simple student analysis.
Main tools: R and Excel, with SQL allowed as a supporting validation tool.
Main public home: GitHub.
The project must feel like real operational work, be fully factual, and avoid any exaggerated claims.
I want the repository to include documentation, validation logic, an Excel issue register, and stakeholder-ready summaries.
We already completed discovery and project selection. Continue directly from Phase 1: repository structure, README draft, and project charter.

## 24) Quick Restart Checklist
- Create the repository
- Add the folder skeleton
- Write README version 1
- Write project_charter.md
- Obtain and inspect the dataset
- Lock the initial field scope before deeper analysis

## 25) Final Working Principle
This project should always be treated as a high-trust flagship piece.
Core message:
"I do not just analyse data - I assess whether it is reliable enough to support reporting and decisions."
