library(data.table)

# -----------------------------
# File paths
# -----------------------------
raw_file <- "data/raw/Crash_Analysis_System_(CAS)_data.csv"
quality_issues_file <- "outputs/tables/quality_issues_long.csv"
quality_issue_summary_file <- "outputs/tables/quality_issue_summary.csv"
record_flags_file <- "outputs/tables/record_quality_flags.csv"
output_dir <- "outputs/tables"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

required_files <- c(
  raw_file,
  quality_issues_file,
  quality_issue_summary_file,
  record_flags_file
)

missing_files <- required_files[!file.exists(required_files)]

if (length(missing_files) > 0) {
  stop(
    "Missing required input files: ",
    paste(missing_files, collapse = ", "),
    "\nRun scripts/02_quality_checks.R first."
  )
}

# -----------------------------
# Read data
# -----------------------------
dt <- fread(raw_file, na.strings = c("", "NA", "NULL"))
issues_dt <- fread(quality_issues_file, na.strings = c("", "NA", "NULL"))
issue_summary_dt <- fread(quality_issue_summary_file, na.strings = c("", "NA", "NULL"))
record_flags_dt <- fread(record_flags_file, na.strings = c("", "NA", "NULL"))

if (nrow(issues_dt) == 0) {
  stop("quality_issues_long.csv is empty. Run scripts/02_quality_checks.R again.")
}

# -----------------------------
# Basic setup
# -----------------------------
run_timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

char_cols <- names(dt)[sapply(dt, is.character)]
for (col in char_cols) {
  set(dt, i = which(trimws(dt[[col]]) == ""), j = col, value = NA_character_)
}

if (!"issue_pct_of_rows" %in% names(issue_summary_dt)) {
  issue_summary_dt[, issue_pct_of_rows := round(issue_n / nrow(dt) * 100, 4)]
}

# -----------------------------
# Helper functions
# -----------------------------
safe_min <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA)
  suppressWarnings(min(x))
}

safe_max <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA)
  suppressWarnings(max(x))
}

collapse_examples <- function(x, n = 5) {
  x <- unique(as.character(x[!is.na(x)]))
  if (length(x) == 0) return(NA_character_)
  paste(head(sort(x), n), collapse = " | ")
}

top_issue_label <- function(issue_dt, target_level) {
  sub <- issue_dt[issue_level == target_level][order(-issue_n, check_name, field_name)]
  if (nrow(sub) == 0) return(NA_character_)
  paste0(sub$check_name[1], " [", sub$field_name[1], "]")
}

build_completeness_monitor <- function(data, period_col, fields) {
  working_dt <- copy(data)
  working_dt[, period_value := get(period_col)]

  out <- rbindlist(
    lapply(fields, function(field) {
      working_dt[
        ,
        .(
          total_records_n = .N,
          missing_records_n = sum(is.na(get(field))),
          non_missing_records_n = sum(!is.na(get(field))),
          missing_pct = round(sum(is.na(get(field))) / .N * 100, 4)
        ),
        by = period_value
      ][
        ,
        `:=`(
          period_type = period_col,
          field_name = field
        )
      ][]
    }),
    fill = TRUE
  )

  setcolorder(
    out,
    c(
      "period_type",
      "period_value",
      "field_name",
      "total_records_n",
      "missing_records_n",
      "non_missing_records_n",
      "missing_pct"
    )
  )

  out[order(period_type, period_value, -missing_pct, field_name)]
}

# -----------------------------
# Enrich issue-level records with raw context
# -----------------------------
context_fields <- c(
  "OBJECTID",
  "crashYear",
  "crashFinancialYear",
  "crashSeverity",
  "region",
  "tlaId",
  "tlaName",
  "areaUnitID",
  "meshblockId",
  "crashLocation1",
  "crashLocation2",
  "speedLimit",
  "NumberOfLanes",
  "directionRoleDescription"
)

available_context_fields <- intersect(context_fields, names(dt))

record_context_dt <- unique(
  dt[, ..available_context_fields],
  by = "OBJECTID"
)

issue_detail_enriched <- merge(
  copy(issues_dt),
  record_context_dt,
  by = "OBJECTID",
  all.x = TRUE
)

# -----------------------------
# Build issue-type monitoring summary
# -----------------------------
issue_type_monitoring_summary <- issue_detail_enriched[
  ,
  .(
    issue_row_n = .N,
    affected_records_n = uniqueN(OBJECTID),
    affected_record_pct_of_rows = round(uniqueN(OBJECTID) / nrow(dt) * 100, 4),
    affected_year_n = uniqueN(crashYear[!is.na(crashYear)]),
    affected_financial_year_n = uniqueN(crashFinancialYear[!is.na(crashFinancialYear)]),
    first_crashYear = safe_min(crashYear),
    last_crashYear = safe_max(crashYear),
    example_regions = collapse_examples(region, 3),
    example_tlas = collapse_examples(tlaName, 3),
    sample_issue_detail = collapse_examples(issue_detail, 1)
  ),
  by = .(issue_category, check_name, field_name, issue_level)
][order(-affected_records_n, issue_level, issue_category, check_name, field_name)]

# -----------------------------
# Build v1 issue register
# -----------------------------
issue_register_v1 <- merge(
  copy(issue_summary_dt),
  issue_type_monitoring_summary,
  by = c("issue_category", "check_name", "field_name", "issue_level"),
  all.x = TRUE
)

issue_register_v1[
  ,
  stakeholder_register_status := fifelse(
    issue_level == "error",
    "core_issue_register",
    fifelse(
      issue_pct_of_rows >= 1,
      "core_issue_register",
      fifelse(
        issue_pct_of_rows >= 0.1,
        "secondary_watch_register",
        "watch_list_only"
      )
    )
  )
]

issue_register_v1[
  ,
  recommended_treatment := fifelse(
    stakeholder_register_status == "core_issue_register",
    "Include in stakeholder issue register and monitor trend over time",
    fifelse(
      stakeholder_register_status == "secondary_watch_register",
      "Retain as a secondary monitoring item with brief caveat",
      "Monitor internally and only escalate if volume or spread increases"
    )
  )
]

issue_register_v1[
  ,
  reporting_implication := fifelse(
    issue_level == "error",
    "Affected records may reduce confidence in production reporting unless reviewed or caveated",
    "Suitable for monitored reporting, but trend interpretation should include caution where relevant"
  )
]

issue_register_v1[
  ,
  evidence_file := fifelse(
    issue_category == "uniqueness",
    "duplicate_summary.csv",
    fifelse(
      issue_category == "validity",
      "year_financial_year_summary.csv",
      fifelse(
        issue_category == "consistency",
        "severity_sanity_summary.csv",
        fifelse(
          field_name %in% c("region", "tlaId", "tlaName", "crashLocation1", "crashLocation2", "areaUnitID", "meshblockId", "location_bundle"),
          "location_completeness_summary.csv",
          "core_field_missingness_summary.csv"
        )
      )
    )
  )
]

setcolorder(
  issue_register_v1,
  c(
    "issue_category",
    "check_name",
    "field_name",
    "issue_level",
    "issue_n",
    "issue_row_n",
    "issue_pct_of_rows",
    "affected_records_n",
    "affected_record_pct_of_rows",
    "affected_year_n",
    "affected_financial_year_n",
    "first_crashYear",
    "last_crashYear",
    "stakeholder_register_status",
    "recommended_treatment",
    "reporting_implication",
    "evidence_file",
    "example_regions",
    "example_tlas",
    "sample_issue_detail"
  )
)

# -----------------------------
# Build low-volume error exception review register
# -----------------------------
low_volume_error_pct_threshold <- 0.5

exception_review_register <- copy(
  issue_register_v1[
    issue_level == "error" & issue_pct_of_rows <= low_volume_error_pct_threshold
  ]
)

if (nrow(exception_review_register) > 0) {
  exception_review_register[
    ,
    review_priority := fifelse(
      issue_pct_of_rows <= 0.05,
      "highest",
      fifelse(issue_pct_of_rows <= 0.25, "high", "standard")
    )
  ]

  exception_review_register[
    ,
    recommended_review_action := fifelse(
      check_name == "required_field_missing" &
        field_name %in% c("tlaId", "tlaName", "areaUnitID", "meshblockId"),
      "Review whether missing geography references are concentrated in specific periods or locations and document reporting tolerance",
      fifelse(
        check_name == "coordinate_pair_incomplete",
        "Review whether incomplete coordinate pairs materially affect map-based or area-based reporting use",
        fifelse(
          check_name == "required_field_missing" &
            field_name %in% c("fatalCount", "seriousInjuryCount", "minorInjuryCount"),
          "Check whether missing injury counts are isolated data-entry gaps or unsupported source cases",
          fifelse(
            check_name %in% c(
              "fatal_severity_without_fatalCount",
              "fatalCount_without_fatal_severity",
              "non_injury_with_fatal_or_serious_counts"
            ),
            "Review source interpretation and confirm whether issue should remain error-level in the monitoring layer",
            "Review targeted records and document treatment decision in the issue register"
          )
        )
      )
    )
  ]

  exception_review_register[
    ,
    review_owner_note := "Analyst review required before final stakeholder packaging"
  ]

  exception_review_register <- exception_review_register[
    order(review_priority, -issue_n, issue_category, check_name, field_name)
  ]
} else {
  exception_review_register <- data.table(
    note = "No low-volume error issues met the configured exception review threshold."
  )
}

# -----------------------------
# Exception review record extract
# -----------------------------
if (
  nrow(exception_review_register) > 0 &&
  !("note" %in% names(exception_review_register))
) {
  exception_keys <- exception_review_register[
    ,
    .(issue_category, check_name, field_name, issue_level)
  ]

  exception_review_records <- merge(
    issue_detail_enriched,
    unique(exception_keys),
    by = c("issue_category", "check_name", "field_name", "issue_level"),
    all = FALSE
  )[
    order(issue_category, check_name, field_name, crashYear, OBJECTID)
  ]
} else {
  exception_review_records <- data.table(
    note = "No exception review records extracted."
  )
}

# -----------------------------
# Annual monitoring summary
# -----------------------------
annual_base <- dt[
  ,
  .(total_records_n = .N),
  by = crashYear
][order(crashYear)]

annual_issue_metrics <- issue_detail_enriched[
  ,
  .(
    issue_rows_n = .N,
    distinct_issue_records_n = uniqueN(OBJECTID),
    error_issue_rows_n = sum(issue_level == "error"),
    warning_issue_rows_n = sum(issue_level == "warning"),
    error_record_n = uniqueN(OBJECTID[issue_level == "error"]),
    warning_record_n = uniqueN(OBJECTID[issue_level == "warning"])
  ),
  by = crashYear
]

annual_quality_monitoring_summary <- merge(
  annual_base,
  annual_issue_metrics,
  by = "crashYear",
  all.x = TRUE
)

metric_cols <- c(
  "issue_rows_n",
  "distinct_issue_records_n",
  "error_issue_rows_n",
  "warning_issue_rows_n",
  "error_record_n",
  "warning_record_n"
)

for (col in metric_cols) {
  annual_quality_monitoring_summary[is.na(get(col)), (col) := 0L]
}

annual_quality_monitoring_summary[
  ,
  `:=`(
    records_without_issue_n = total_records_n - distinct_issue_records_n,
    distinct_issue_records_pct = round(distinct_issue_records_n / total_records_n * 100, 4),
    error_record_pct = round(error_record_n / total_records_n * 100, 4),
    warning_record_pct = round(warning_record_n / total_records_n * 100, 4)
  )
]

annual_quality_monitoring_summary <- annual_quality_monitoring_summary[
  order(crashYear)
]

# -----------------------------
# Financial-year monitoring summary
# -----------------------------
financial_year_base <- dt[
  ,
  .(total_records_n = .N),
  by = crashFinancialYear
][order(crashFinancialYear)]

financial_year_issue_metrics <- issue_detail_enriched[
  ,
  .(
    issue_rows_n = .N,
    distinct_issue_records_n = uniqueN(OBJECTID),
    error_issue_rows_n = sum(issue_level == "error"),
    warning_issue_rows_n = sum(issue_level == "warning"),
    error_record_n = uniqueN(OBJECTID[issue_level == "error"]),
    warning_record_n = uniqueN(OBJECTID[issue_level == "warning"])
  ),
  by = crashFinancialYear
]

financial_year_quality_monitoring_summary <- merge(
  financial_year_base,
  financial_year_issue_metrics,
  by = "crashFinancialYear",
  all.x = TRUE
)

for (col in metric_cols) {
  financial_year_quality_monitoring_summary[is.na(get(col)), (col) := 0L]
}

financial_year_quality_monitoring_summary[
  ,
  `:=`(
    records_without_issue_n = total_records_n - distinct_issue_records_n,
    distinct_issue_records_pct = round(distinct_issue_records_n / total_records_n * 100, 4),
    error_record_pct = round(error_record_n / total_records_n * 100, 4),
    warning_record_pct = round(warning_record_n / total_records_n * 100, 4)
  )
]

financial_year_quality_monitoring_summary <- financial_year_quality_monitoring_summary[
  order(crashFinancialYear)
]

# -----------------------------
# Priority field completeness monitoring
# -----------------------------
priority_fields <- c(
  "tlaId",
  "tlaName",
  "areaUnitID",
  "meshblockId",
  "fatalCount",
  "seriousInjuryCount",
  "minorInjuryCount",
  "region",
  "crashLocation2",
  "speedLimit",
  "NumberOfLanes",
  "directionRoleDescription"
)

priority_fields <- intersect(priority_fields, names(dt))

priority_field_completeness_by_year <- build_completeness_monitor(
  data = dt,
  period_col = "crashYear",
  fields = priority_fields
)

priority_field_completeness_by_financial_year <- build_completeness_monitor(
  data = dt,
  period_col = "crashFinancialYear",
  fields = priority_fields
)

# -----------------------------
# Stakeholder headline metrics
# -----------------------------
record_issue_status <- issue_detail_enriched[
  ,
  .(
    has_error = any(issue_level == "error"),
    has_warning = any(issue_level == "warning")
  ),
  by = OBJECTID
]

records_with_error_n <- record_issue_status[has_error == TRUE, .N]
warning_only_records_n <- record_issue_status[has_error == FALSE & has_warning == TRUE, .N]

core_issue_register_items_n <- issue_register_v1[
  stakeholder_register_status == "core_issue_register",
  .N
]

secondary_watch_items_n <- issue_register_v1[
  stakeholder_register_status == "secondary_watch_register",
  .N
]

watch_list_only_items_n <- issue_register_v1[
  stakeholder_register_status == "watch_list_only",
  .N
]

flagged_record_n <- record_flags_dt[quality_issue_flag == TRUE, .N]

stakeholder_quality_headlines <- data.table(
  metric = c(
    "run_timestamp",
    "dataset_row_count",
    "dataset_column_count",
    "flagged_record_n",
    "flagged_record_pct",
    "records_with_error_n",
    "warning_only_records_n",
    "issue_type_count",
    "core_issue_register_items_n",
    "secondary_watch_items_n",
    "watch_list_only_items_n",
    "top_error_issue_type",
    "top_warning_issue_type"
  ),
  value = c(
    run_timestamp,
    as.character(nrow(dt)),
    as.character(ncol(dt)),
    as.character(flagged_record_n),
    as.character(round(flagged_record_n / nrow(dt) * 100, 4)),
    as.character(records_with_error_n),
    as.character(warning_only_records_n),
    as.character(nrow(issue_register_v1)),
    as.character(core_issue_register_items_n),
    as.character(secondary_watch_items_n),
    as.character(watch_list_only_items_n),
    top_issue_label(issue_register_v1, "error"),
    top_issue_label(issue_register_v1, "warning")
  )
)

# -----------------------------
# Run metadata
# -----------------------------
monitoring_layer_run_metadata <- data.table(
  run_timestamp = run_timestamp,
  source_file = raw_file,
  issues_file = quality_issues_file,
  issue_summary_file = quality_issue_summary_file,
  record_flags_file = record_flags_file,
  row_count = nrow(dt),
  column_count = ncol(dt),
  low_volume_error_pct_threshold = low_volume_error_pct_threshold
)

# -----------------------------
# Export CSVs
# -----------------------------
fwrite(
  monitoring_layer_run_metadata,
  file.path(output_dir, "monitoring_layer_run_metadata.csv")
)

fwrite(
  issue_type_monitoring_summary,
  file.path(output_dir, "issue_type_monitoring_summary.csv")
)

fwrite(
  issue_register_v1,
  file.path(output_dir, "issue_register_v1.csv")
)

fwrite(
  exception_review_register,
  file.path(output_dir, "exception_review_register.csv")
)

fwrite(
  exception_review_records,
  file.path(output_dir, "exception_review_records.csv")
)

fwrite(
  annual_quality_monitoring_summary,
  file.path(output_dir, "annual_quality_monitoring_summary.csv")
)

fwrite(
  financial_year_quality_monitoring_summary,
  file.path(output_dir, "financial_year_quality_monitoring_summary.csv")
)

fwrite(
  priority_field_completeness_by_year,
  file.path(output_dir, "priority_field_completeness_by_year.csv")
)

fwrite(
  priority_field_completeness_by_financial_year,
  file.path(output_dir, "priority_field_completeness_by_financial_year.csv")
)

fwrite(
  stakeholder_quality_headlines,
  file.path(output_dir, "stakeholder_quality_headlines.csv")
)

# -----------------------------
# Console summary
# -----------------------------
cat("Exception review and monitoring layer complete.\n")
cat("Rows:", nrow(dt), "\n")
cat("Columns:", ncol(dt), "\n")
cat("Issue types in v1 register:", nrow(issue_register_v1), "\n")

if (!("note" %in% names(exception_review_register))) {
  cat("Low-volume error exception review items:", nrow(exception_review_register), "\n")
} else {
  cat("Low-volume error exception review items: 0\n")
}

cat("Outputs saved to:", output_dir, "\n")