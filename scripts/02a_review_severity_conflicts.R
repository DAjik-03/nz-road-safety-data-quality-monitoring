library(data.table)

# -----------------------------
# File paths
# -----------------------------
raw_file <- "data/raw/Crash_Analysis_System_(CAS)_data.csv"
issues_file <- "outputs/tables/quality_issues_long.csv"
output_dir <- "outputs/tables"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

if (!file.exists(raw_file)) {
  stop("Raw file not found: ", raw_file)
}

if (!file.exists(issues_file)) {
  stop("Issue file not found: ", issues_file)
}

# -----------------------------
# Read data
# -----------------------------
dt <- fread(raw_file, na.strings = c("", "NA", "NULL"))
issues_dt <- fread(issues_file, na.strings = c("", "NA", "NULL"))

# -----------------------------
# Pull severity conflict OBJECTIDs
# -----------------------------
severity_conflict_ids <- unique(
  issues_dt[
    check_name == "non_injury_severity_with_injury_counts",
    OBJECTID
  ]
)

if (length(severity_conflict_ids) == 0) {
  cat("No severity conflict records found.\n")
  quit(save = "no")
}

# -----------------------------
# Filter raw data to conflict records
# -----------------------------
conflict_dt <- dt[OBJECTID %in% severity_conflict_ids]

# -----------------------------
# Derived review fields
# -----------------------------
conflict_dt[, total_injury_count := rowSums(
  .SD,
  na.rm = TRUE
), .SDcols = c("fatalCount", "seriousInjuryCount", "minorInjuryCount")]

conflict_dt[, highest_injury_signal := fifelse(
  fatalCount > 0, "fatalCount_present",
  fifelse(
    seriousInjuryCount > 0, "seriousInjuryCount_present",
    fifelse(
      minorInjuryCount > 0, "minorInjuryCount_present",
      "no_injury_count_present"
    )
  )
)]

conflict_dt[, review_priority := fifelse(
  fatalCount > 0, "highest",
  fifelse(
    seriousInjuryCount > 0, "high",
    fifelse(
      minorInjuryCount > 0, "medium",
      "check_logic"
    )
  )
)]

# -----------------------------
# Review export fields
# -----------------------------
preferred_fields <- c(
  "OBJECTID",
  "crashYear",
  "crashFinancialYear",
  "crashSeverity",
  "fatalCount",
  "seriousInjuryCount",
  "minorInjuryCount",
  "totalInjured",
  "total_injury_count",
  "highest_injury_signal",
  "review_priority",
  "region",
  "tlaId",
  "tlaName",
  "areaUnitID",
  "meshblockId",
  "crashLocation1",
  "crashLocation2",
  "crashSHDescription",
  "X",
  "Y",
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

available_fields <- intersect(preferred_fields, names(conflict_dt))
severity_conflict_records <- conflict_dt[, ..available_fields]

# -----------------------------
# Summary outputs
# -----------------------------
severity_conflict_summary <- conflict_dt[, .(
  records_n = .N
), by = .(
  crashSeverity,
  fatalCount,
  seriousInjuryCount,
  minorInjuryCount,
  highest_injury_signal,
  review_priority
)][order(-records_n, crashSeverity)]

severity_conflict_by_year <- conflict_dt[, .(
  records_n = .N
), by = crashYear][order(crashYear)]

if ("region" %in% names(conflict_dt)) {
  severity_conflict_by_region <- conflict_dt[, .(
    records_n = .N
  ), by = region][order(-records_n, region)]
} else {
  severity_conflict_by_region <- data.table(
    note = "region column not available in raw extract"
  )
}

if ("tlaName" %in% names(conflict_dt)) {
  severity_conflict_by_tla <- conflict_dt[, .(
    records_n = .N
  ), by = tlaName][order(-records_n, tlaName)]
} else {
  severity_conflict_by_tla <- data.table(
    note = "tlaName column not available in raw extract"
  )
}

severity_conflict_overview <- data.table(
  metric = c(
    "severity_conflict_record_n",
    "records_with_fatalCount_gt_0",
    "records_with_seriousInjuryCount_gt_0",
    "records_with_minorInjuryCount_gt_0"
  ),
  value = c(
    nrow(conflict_dt),
    conflict_dt[fatalCount > 0, .N],
    conflict_dt[seriousInjuryCount > 0, .N],
    conflict_dt[minorInjuryCount > 0, .N]
  )
)

# -----------------------------
# Export CSVs
# -----------------------------
fwrite(
  severity_conflict_records,
  file.path(output_dir, "severity_conflict_records.csv")
)

fwrite(
  severity_conflict_summary,
  file.path(output_dir, "severity_conflict_summary.csv")
)

fwrite(
  severity_conflict_by_year,
  file.path(output_dir, "severity_conflict_by_year.csv")
)

fwrite(
  severity_conflict_by_region,
  file.path(output_dir, "severity_conflict_by_region.csv")
)

fwrite(
  severity_conflict_by_tla,
  file.path(output_dir, "severity_conflict_by_tla.csv")
)

fwrite(
  severity_conflict_overview,
  file.path(output_dir, "severity_conflict_overview.csv")
)

# -----------------------------
# Console summary
# -----------------------------
cat("Severity conflict review export complete.\n")
cat("Conflict records:", nrow(conflict_dt), "\n")
cat("Outputs saved to:", output_dir, "\n")