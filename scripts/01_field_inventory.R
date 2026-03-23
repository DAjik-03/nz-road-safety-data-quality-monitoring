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
# 1) Field inventory
# -----------------------------
field_inventory <- data.table(
  column_name = names(dt),
  data_type = sapply(dt, function(x) class(x)[1]),
  non_missing_count = sapply(dt, function(x) sum(!is.na(x))),
  missing_count = sapply(dt, function(x) sum(is.na(x))),
  total_rows = nrow(dt),
  missing_pct = round(sapply(dt, function(x) mean(is.na(x)) * 100), 2)
)

fwrite(field_inventory, file.path(output_dir, "field_inventory.csv"))

# -----------------------------
# 2) Missingness summary
# -----------------------------
missingness_summary <- copy(field_inventory)[
  order(-missing_pct),
  .(column_name, data_type, missing_count, total_rows, missing_pct)
]

fwrite(missingness_summary, file.path(output_dir, "missingness_summary.csv"))

# -----------------------------
# 3) Date range summary
# -----------------------------
candidate_date_cols <- names(dt)[grepl("date", names(dt), ignore.case = TRUE)]

safe_parse_date <- function(x) {
  x <- trimws(as.character(x))
  x[x == ""] <- NA_character_

  formats <- c(
    "%Y-%m-%d",
    "%d/%m/%Y",
    "%m/%d/%Y",
    "%d-%m-%Y",
    "%Y/%m/%d"
  )

  parsed <- rep(as.IDate(NA), length(x))

  for (fmt in formats) {
    idx <- is.na(parsed) & !is.na(x)
    if (any(idx)) {
      parsed[idx] <- suppressWarnings(as.IDate(x[idx], format = fmt))
    }
  }

  parsed
}

date_range_summary <- data.table(
  date_column = character(),
  min_date = character(),
  max_date = character(),
  non_missing_dates = integer()
)

for (col in candidate_date_cols) {
  parsed_dates <- safe_parse_date(dt[[col]])

  if (sum(!is.na(parsed_dates)) > 0) {
    date_range_summary <- rbind(
      date_range_summary,
      data.table(
        date_column = col,
        min_date = as.character(min(parsed_dates, na.rm = TRUE)),
        max_date = as.character(max(parsed_dates, na.rm = TRUE)),
        non_missing_dates = sum(!is.na(parsed_dates))
      ),
      fill = TRUE
    )
  }
}

fwrite(date_range_summary, file.path(output_dir, "date_range_summary.csv"))

# -----------------------------
# Console summary
# -----------------------------
cat("Field inventory complete.\n")
cat("Rows:", nrow(dt), "\n")
cat("Columns:", ncol(dt), "\n")
cat("Outputs saved to:", output_dir, "\n")