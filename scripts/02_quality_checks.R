library(data.table)

# -----------------------------
# File paths
# -----------------------------
raw_file <- "data/raw/Crash_Analysis_System_(CAS)_data.csv"
output_dir <- "outputs/tables"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# -----------------------------
# Read data
# -----------------------------
dt <- fread(raw_file, na.strings = c("", "NA", "NULL"))

# -----------------------------
# Basic setup
# -----------------------------
run_timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
current_year <- as.integer(format(Sys.Date(), "%Y"))

# Standardise blank character strings to NA
char_cols <- names(dt)[sapply(dt, is.character)]
for (col in char_cols) {
  set(dt, i = which(trimws(dt[[col]]) == ""), j = col, value = NA_character_)
}

# -----------------------------
# Required / core fields
# -----------------------------
core_fields <- c(
  "OBJECTID",
  "areaUnitID",
  "meshblockId",
  "X",
  "Y",
  "crashYear",
  "crashFinancialYear",
  "region",
  "tlaId",
  "tlaName",
  "crashLocation1",
  "crashLocation2",
  "crashSHDescription",
  "crashSeverity",
  "fatalCount",
  "seriousInjuryCount",
  "minorInjuryCount",
  "speedLimit",
  "NumberOfLanes",
  "roadCharacter",
  "roadLane",
  "roadSurface",
  "trafficControl",
  "urban",
  "flatHill",
  "light",
  "streetLight",
  "weatherA",
  "weatherB",
  "crashDirectionDescription",
  "directionRoleDescription"
)

required_fields <- c(
  "OBJECTID",
  "areaUnitID",
  "meshblockId",
  "X",
  "Y",
  "crashYear",
  "crashFinancialYear",
  "tlaId",
  "tlaName",
  "crashLocation1",
  "crashSeverity",
  "fatalCount",
  "seriousInjuryCount",
  "minorInjuryCount"
)

warning_missing_fields <- c(
  "region",
  "crashLocation2",
  "speedLimit",
  "NumberOfLanes",
  "directionRoleDescription"
)

location_fields <- c(
  "region",
  "tlaId",
  "tlaName",
  "crashLocation1",
  "crashLocation2",
  "crashSHDescription",
  "X",
  "Y",
  "areaUnitID",
  "meshblockId"
)

count_fields <- c("fatalCount", "seriousInjuryCount", "minorInjuryCount")

missing_core_columns <- setdiff(core_fields, names(dt))
if (length(missing_core_columns) > 0) {
  stop(
    "Missing expected core columns: ",
    paste(missing_core_columns, collapse = ", ")
  )
}

# -----------------------------
# Helper functions
# -----------------------------
add_issue <- function(issue_dt, subset_dt, issue_category, check_name, field_name, issue_level, issue_detail) {
  if (nrow(subset_dt) == 0) return(issue_dt)

  out <- data.table(
    OBJECTID = if ("OBJECTID" %in% names(subset_dt)) subset_dt$OBJECTID else NA,
    issue_category = issue_category,
    check_name = check_name,
    field_name = field_name,
    issue_level = issue_level,
    issue_detail = issue_detail
  )

  rbind(issue_dt, out, fill = TRUE)
}

missing_summary_table <- function(data, fields) {
  data.table(
    column_name = fields,
    missing_count = sapply(fields, function(col) sum(is.na(data[[col]]))),
    total_rows = nrow(data),
    missing_pct = round(sapply(fields, function(col) mean(is.na(data[[col]])) * 100), 2)
  )[order(-missing_pct, column_name)]
}

# -----------------------------
# Derived validation fields
# -----------------------------
dt[, crashFinancialYear_clean := gsub("\\s+", "", as.character(crashFinancialYear))]

dt[, fy_format_valid := grepl("^\\d{4}/\\d{4}$", crashFinancialYear_clean)]

dt[, fy_start_year := fifelse(
  fy_format_valid,
  as.integer(substr(crashFinancialYear_clean, 1, 4)),
  NA_integer_
)]

dt[, fy_end_year := fifelse(
  fy_format_valid,
  as.integer(substr(crashFinancialYear_clean, 6, 9)),
  NA_integer_
)]

dt[, fy_span_valid := !is.na(fy_start_year) & !is.na(fy_end_year) & (fy_end_year - fy_start_year == 1)]

dt[, crash_year_valid := !is.na(crashYear) & crashYear >= 1900 & crashYear <= current_year]

dt[, year_in_financial_year_window := !is.na(crashYear) &
     !is.na(fy_start_year) &
     !is.na(fy_end_year) &
     crashYear %in% c(fy_start_year, fy_end_year)]

dt[, crashSeverity_lower := tolower(as.character(crashSeverity))]

# -----------------------------
# Initialise issue register
# -----------------------------
quality_issues <- data.table(
  OBJECTID = integer(),
  issue_category = character(),
  check_name = character(),
  field_name = character(),
  issue_level = character(),
  issue_detail = character()
)

# -----------------------------
# 1) Duplicate / uniqueness checks
# -----------------------------
duplicate_objectid_summary <- dt[, .N, by = OBJECTID][N > 1][order(-N, OBJECTID)]

if (nrow(duplicate_objectid_summary) > 0) {
  dup_rows <- dt[OBJECTID %in% duplicate_objectid_summary$OBJECTID]
  quality_issues <- add_issue(
    quality_issues,
    dup_rows,
    "uniqueness",
    "duplicate_OBJECTID",
    "OBJECTID",
    "error",
    "OBJECTID appears more than once"
  )
}

exact_duplicate_flag <- duplicated(dt) | duplicated(dt, fromLast = TRUE)
exact_duplicate_rows <- dt[exact_duplicate_flag == TRUE]

if (nrow(exact_duplicate_rows) > 0) {
  quality_issues <- add_issue(
    quality_issues,
    exact_duplicate_rows,
    "uniqueness",
    "exact_duplicate_row",
    "ROW",
    "error",
    "Entire row is duplicated"
  )
}

duplicate_summary <- data.table(
  metric = c(
    "duplicate_objectid_n",
    "duplicate_objectid_rows_n",
    "exact_duplicate_rows_n"
  ),
  value = c(
    nrow(duplicate_objectid_summary),
    if (nrow(duplicate_objectid_summary) == 0) 0 else dt[OBJECTID %in% duplicate_objectid_summary$OBJECTID, .N],
    nrow(exact_duplicate_rows)
  )
)

# -----------------------------
# 2) Completeness checks
# -----------------------------
for (col in required_fields) {
  missing_rows <- dt[is.na(get(col))]
  if (nrow(missing_rows) > 0) {
    quality_issues <- add_issue(
      quality_issues,
      missing_rows,
      "completeness",
      "required_field_missing",
      col,
      "error",
      paste(col, "is missing")
    )
  }
}

for (col in warning_missing_fields) {
  missing_rows <- dt[is.na(get(col))]
  if (nrow(missing_rows) > 0) {
    quality_issues <- add_issue(
      quality_issues,
      missing_rows,
      "completeness",
      "core_field_missing",
      col,
      "warning",
      paste(col, "is missing")
    )
  }
}

coord_x_missing <- dt[is.na(X) & !is.na(Y)]
coord_y_missing <- dt[!is.na(X) & is.na(Y)]

quality_issues <- add_issue(
  quality_issues,
  coord_x_missing,
  "completeness",
  "coordinate_pair_incomplete",
  "X",
  "error",
  "Y is present but X is missing"
)

quality_issues <- add_issue(
  quality_issues,
  coord_y_missing,
  "completeness",
  "coordinate_pair_incomplete",
  "Y",
  "error",
  "X is present but Y is missing"
)

primary_location_bundle_missing <- dt[
  is.na(tlaId) | is.na(tlaName) | is.na(crashLocation1)
]

quality_issues <- add_issue(
  quality_issues,
  primary_location_bundle_missing,
  "completeness",
  "primary_location_bundle_incomplete",
  "location_bundle",
  "error",
  "One or more primary location fields are missing"
)

# -----------------------------
# 3) Missingness summaries
# -----------------------------
core_field_missingness_summary <- missing_summary_table(dt, core_fields)
location_completeness_summary <- missing_summary_table(dt, location_fields)

# -----------------------------
# 4) Value validity checks
# -----------------------------
invalid_crash_year <- dt[is.na(crash_year_valid) | crash_year_valid == FALSE]
quality_issues <- add_issue(
  quality_issues,
  invalid_crash_year,
  "validity",
  "invalid_crashYear",
  "crashYear",
  "error",
  "crashYear is missing or outside the plausible range"
)

invalid_fy_format <- dt[is.na(fy_format_valid) | fy_format_valid == FALSE]
quality_issues <- add_issue(
  quality_issues,
  invalid_fy_format,
  "validity",
  "invalid_crashFinancialYear_format",
  "crashFinancialYear",
  "error",
  "crashFinancialYear is not in YYYY/YYYY format"
)

invalid_fy_span <- dt[fy_format_valid == TRUE & fy_span_valid == FALSE]
quality_issues <- add_issue(
  quality_issues,
  invalid_fy_span,
  "validity",
  "invalid_crashFinancialYear_span",
  "crashFinancialYear",
  "error",
  "crashFinancialYear does not span exactly one year"
)

year_fy_misalignment <- dt[
  fy_format_valid == TRUE &
  fy_span_valid == TRUE &
  year_in_financial_year_window == FALSE
]
quality_issues <- add_issue(
  quality_issues,
  year_fy_misalignment,
  "consistency",
  "year_financial_year_misalignment",
  "crashYear / crashFinancialYear",
  "warning",
  "crashYear is not one of the years in crashFinancialYear"
)

for (col in count_fields) {
  neg_rows <- dt[!is.na(get(col)) & get(col) < 0]
  if (nrow(neg_rows) > 0) {
    quality_issues <- add_issue(
      quality_issues,
      neg_rows,
      "validity",
      "negative_injury_count",
      col,
      "error",
      paste(col, "is negative")
    )
  }

  non_integer_rows <- dt[!is.na(get(col)) & (get(col) %% 1 != 0)]
  if (nrow(non_integer_rows) > 0) {
    quality_issues <- add_issue(
      quality_issues,
      non_integer_rows,
      "validity",
      "non_integer_injury_count",
      col,
      "error",
      paste(col, "is not a whole number")
    )
  }
}

invalid_speed_limit <- dt[!is.na(speedLimit) & speedLimit < 0]
quality_issues <- add_issue(
  quality_issues,
  invalid_speed_limit,
  "validity",
  "invalid_speedLimit_negative",
  "speedLimit",
  "error",
  "speedLimit is negative"
)

invalid_lane_count <- dt[!is.na(NumberOfLanes) & NumberOfLanes < 0]
quality_issues <- add_issue(
  quality_issues,
  invalid_lane_count,
  "validity",
  "invalid_NumberOfLanes_negative",
  "NumberOfLanes",
  "error",
  "NumberOfLanes is negative"
)

# -----------------------------
# 5) Severity sanity checks
# -----------------------------
fatal_severity_without_fatalcount <- dt[
  grepl("fatal", crashSeverity_lower) & fatalCount < 1
]
quality_issues <- add_issue(
  quality_issues,
  fatal_severity_without_fatalcount,
  "consistency",
  "fatal_severity_without_fatalCount",
  "crashSeverity / fatalCount",
  "error",
  "Severity suggests fatal crash but fatalCount is less than 1"
)

fatalcount_without_fatal_severity <- dt[
  fatalCount >= 1 & !grepl("fatal", crashSeverity_lower)
]
quality_issues <- add_issue(
  quality_issues,
  fatalcount_without_fatal_severity,
  "consistency",
  "fatalCount_without_fatal_severity",
  "crashSeverity / fatalCount",
  "error",
  "fatalCount is at least 1 but crashSeverity does not indicate fatal"
)

non_injury_with_fatal_or_serious_counts <- dt[
  grepl("non", crashSeverity_lower) &
  grepl("inj", crashSeverity_lower) &
  (
    (!is.na(fatalCount) & fatalCount > 0) |
    (!is.na(seriousInjuryCount) & seriousInjuryCount > 0)
  )
]

quality_issues <- add_issue(
  quality_issues,
  non_injury_with_fatal_or_serious_counts,
  "consistency",
  "non_injury_with_fatal_or_serious_counts",
  "crashSeverity / injuryCounts",
  "error",
  "Severity suggests non-injury but fatalCount or seriousInjuryCount is above zero"
)

non_injury_with_minor_only_count <- dt[
  grepl("non", crashSeverity_lower) &
  grepl("inj", crashSeverity_lower) &
  (is.na(fatalCount) | fatalCount == 0) &
  (is.na(seriousInjuryCount) | seriousInjuryCount == 0) &
  (!is.na(minorInjuryCount) & minorInjuryCount > 0)
]

quality_issues <- add_issue(
  quality_issues,
  non_injury_with_minor_only_count,
  "consistency",
  "non_injury_with_minor_only_count",
  "crashSeverity / injuryCounts",
  "warning",
  "Severity suggests non-injury but minorInjuryCount is above zero; source definition review required"
)

severity_sanity_summary <- data.table(
  metric = c(
    "fatal_severity_without_fatalCount_n",
    "fatalCount_without_fatal_severity_n",
    "non_injury_with_fatal_or_serious_counts_n",
    "non_injury_with_minor_only_count_n"
  ),
  value = c(
    nrow(fatal_severity_without_fatalcount),
    nrow(fatalcount_without_fatal_severity),
    nrow(non_injury_with_fatal_or_serious_counts),
    nrow(non_injury_with_minor_only_count)
  )
)

severity_distribution_summary <- dt[, .(
  records_n = .N,
  fatalCount_sum = sum(fatalCount, na.rm = TRUE),
  seriousInjuryCount_sum = sum(seriousInjuryCount, na.rm = TRUE),
  minorInjuryCount_sum = sum(minorInjuryCount, na.rm = TRUE)
), by = crashSeverity][order(-records_n)]

# -----------------------------
# 6) Year / financial-year summaries
# -----------------------------
year_financial_year_summary <- data.table(
  metric = c(
    "invalid_crashYear_n",
    "invalid_crashFinancialYear_format_n",
    "invalid_crashFinancialYear_span_n",
    "year_financial_year_misalignment_n"
  ),
  value = c(
    nrow(invalid_crash_year),
    nrow(invalid_fy_format),
    nrow(invalid_fy_span),
    nrow(year_fy_misalignment)
  )
)

year_summary <- dt[, .(records_n = .N), by = crashYear][order(crashYear)]
financial_year_summary <- dt[, .(records_n = .N), by = crashFinancialYear][order(crashFinancialYear)]

# -----------------------------
# 7) Consolidated outputs
# -----------------------------
quality_issues <- unique(quality_issues)

quality_issue_summary <- quality_issues[, .(
  issue_n = .N
), by = .(issue_category, check_name, field_name, issue_level)][
  order(-issue_n, issue_category, check_name, field_name)
]

quality_issue_summary[, issue_pct_of_rows := round(issue_n / nrow(dt) * 100, 4)]

record_quality_flags <- quality_issues[, .(
  quality_issue_count = .N
), by = OBJECTID]

record_quality_flags_export <- merge(
  dt[, .(OBJECTID, crashYear, crashFinancialYear, crashSeverity, region, tlaName)],
  record_quality_flags,
  by = "OBJECTID",
  all.x = TRUE
)

record_quality_flags_export[is.na(quality_issue_count), quality_issue_count := 0L]
record_quality_flags_export[, quality_issue_flag := quality_issue_count > 0]

run_metadata <- data.table(
  run_timestamp = run_timestamp,
  source_file = raw_file,
  row_count = nrow(dt),
  column_count = ncol(dt)
)

# -----------------------------
# 8) Export CSVs
# -----------------------------
fwrite(run_metadata, file.path(output_dir, "quality_check_run_metadata.csv"))

fwrite(core_field_missingness_summary, file.path(output_dir, "core_field_missingness_summary.csv"))
fwrite(location_completeness_summary, file.path(output_dir, "location_completeness_summary.csv"))

fwrite(duplicate_summary, file.path(output_dir, "duplicate_summary.csv"))
fwrite(duplicate_objectid_summary, file.path(output_dir, "duplicate_objectid_summary.csv"))
fwrite(exact_duplicate_rows, file.path(output_dir, "exact_duplicate_rows.csv"))

fwrite(year_financial_year_summary, file.path(output_dir, "year_financial_year_summary.csv"))
fwrite(year_summary, file.path(output_dir, "year_summary.csv"))
fwrite(financial_year_summary, file.path(output_dir, "financial_year_summary.csv"))

fwrite(severity_sanity_summary, file.path(output_dir, "severity_sanity_summary.csv"))
fwrite(severity_distribution_summary, file.path(output_dir, "severity_distribution_summary.csv"))

fwrite(quality_issue_summary, file.path(output_dir, "quality_issue_summary.csv"))
fwrite(quality_issues, file.path(output_dir, "quality_issues_long.csv"))
fwrite(record_quality_flags_export, file.path(output_dir, "record_quality_flags.csv"))

# -----------------------------
# Console summary
# -----------------------------
cat("Quality checks complete.\n")
cat("Rows:", nrow(dt), "\n")
cat("Columns:", ncol(dt), "\n")
cat("Distinct records with at least one issue:", uniqueN(record_quality_flags$OBJECTID), "\n")
cat("Outputs saved to:", output_dir, "\n")