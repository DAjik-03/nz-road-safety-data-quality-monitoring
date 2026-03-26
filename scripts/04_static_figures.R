suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(forcats)
  library(ggplot2)
  library(scales)
  library(patchwork)
})

theme_set(
  theme_minimal(base_size = 12) +
    theme(
      plot.title.position = "plot",
      legend.position = "bottom",
      panel.grid.minor = element_blank()
    )
)

tables_dir  <- "outputs/tables"
figures_dir <- "outputs/figures"

dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)

read_required <- function(path) {
  if (!file.exists(path)) {
    stop("Missing file: ", path, call. = FALSE)
  }
  read_csv(path, show_col_types = FALSE, progress = FALSE)
}

check_cols <- function(df, cols, file_label) {
  missing_cols <- setdiff(cols, names(df))
  if (length(missing_cols) > 0) {
    stop(
      file_label, " is missing required columns: ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }
}

pick_break_idx <- function(n, target = 8) {
  unique(round(seq(1, n, length.out = min(n, target))))
}

save_fig <- function(plot_obj, file_name, width = 12, height = 7, dpi = 300) {
  ggsave(
    filename = file.path(figures_dir, file_name),
    plot = plot_obj,
    width = width,
    height = height,
    dpi = dpi,
    bg = "white"
  )
}

# -------------------------------------------------
# Read inputs
# -------------------------------------------------

issue_register <- read_required(file.path(tables_dir, "issue_register_v1.csv"))
annual_summary <- read_required(file.path(tables_dir, "annual_quality_monitoring_summary.csv"))
fy_summary     <- read_required(file.path(tables_dir, "financial_year_quality_monitoring_summary.csv"))
geo_year       <- read_required(file.path(tables_dir, "priority_field_completeness_by_year.csv"))
geo_fy         <- read_required(file.path(tables_dir, "priority_field_completeness_by_financial_year.csv"))

exception_register_path <- file.path(tables_dir, "exception_review_register.csv")
exception_n <- 0L
if (file.exists(exception_register_path)) {
  exception_register <- read_required(exception_register_path)
  exception_n <- nrow(exception_register)
}

check_cols(
  issue_register,
  c("issue_category", "check_name", "field_name", "issue_level",
    "issue_n", "issue_pct_of_rows", "affected_records_n"),
  "issue_register_v1.csv"
)

check_cols(
  annual_summary,
  c("crashYear", "distinct_issue_records_pct"),
  "annual_quality_monitoring_summary.csv"
)

check_cols(
  fy_summary,
  c("crashFinancialYear", "distinct_issue_records_pct"),
  "financial_year_quality_monitoring_summary.csv"
)

check_cols(
  geo_year,
  c("period_type", "period_value", "field_name", "missing_pct"),
  "priority_field_completeness_by_year.csv"
)

check_cols(
  geo_fy,
  c("period_type", "period_value", "field_name", "missing_pct"),
  "priority_field_completeness_by_financial_year.csv"
)

# -------------------------------------------------
# Figure 2
# Validation Outcome Summary by Check Family
# -------------------------------------------------

map_issue_family <- function(issue_category, check_name, field_name, issue_level) {
  key <- str_to_lower(paste(issue_category, check_name, field_name, issue_level))

  case_when(
    str_detect(key, "duplicate|uniqueness") ~ "Duplicate / uniqueness",
    str_detect(key, "financial") & str_detect(key, "format|invalid|pattern") ~ "Financial-year format",
    str_detect(key, "financial") & str_detect(key, "align|mismatch|consisten") ~ "Year / FY consistency",
    str_detect(key, "crashyear|year") & !str_detect(key, "financial") ~ "Crash year validity",
    str_detect(key, "fatal|serious|minor|injury|severity") ~ "Severity sanity",
    str_detect(key, "tlaid|tlaname|areaunitid|meshblockid|region|crashlocation|location_bundle") ~ "Geographic completeness",
    issue_level == "warning" ~ "Warning-level completeness",
    str_detect(key, "required|missing|completeness") ~ "Required completeness",
    TRUE ~ "Residual monitored exceptions"
  )
}

family_order <- c(
  "Duplicate / uniqueness",
  "Crash year validity",
  "Financial-year format",
  "Year / FY consistency",
  "Severity sanity",
  "Required completeness",
  "Warning-level completeness",
  "Geographic completeness",
  "Residual monitored exceptions"
)

fig2_df <- issue_register %>%
  mutate(
    issue_family = map_issue_family(issue_category, check_name, field_name, issue_level)
  ) %>%
  group_by(issue_family) %>%
  summarise(
    worst_level = case_when(
      any(issue_level == "error", na.rm = TRUE)   ~ "error",
      any(issue_level == "warning", na.rm = TRUE) ~ "warning",
      TRUE                                        ~ "none"
    ),
    affected_records_n = max(coalesce(affected_records_n, 0), na.rm = TRUE),
    issue_pct_of_rows  = max(coalesce(issue_pct_of_rows, 0), na.rm = TRUE),
    .groups = "drop"
  )

fig2_df <- tibble::tibble(issue_family = family_order) %>%
  left_join(fig2_df, by = "issue_family") %>%
  mutate(
    worst_level = if_else(is.na(worst_level), "none", worst_level),
    affected_records_n = if_else(is.na(affected_records_n), 0, affected_records_n),
    issue_pct_of_rows  = if_else(is.na(issue_pct_of_rows), 0, issue_pct_of_rows),
    outcome_profile = case_when(
      issue_family == "Geographic completeness" & affected_records_n > 0 ~ "Targeted geographic caveat",
      issue_family == "Residual monitored exceptions" & exception_n > 0  ~ "Low-volume issue to monitor",
      worst_level == "warning"                                           ~ "Warning-level gap",
      worst_level == "error" & issue_pct_of_rows > 0                     ~ "Low-volume issue to monitor",
      TRUE                                                               ~ "Stable for v1 monitoring"
    ),
    detail_label = case_when(
      issue_family == "Severity sanity" & affected_records_n > 0 ~ paste0(comma(affected_records_n), " records retained for monitoring review"),
      issue_family == "Residual monitored exceptions" & exception_n > 0 ~ paste0(exception_n, " monitored exception items"),
      affected_records_n > 0 ~ paste0(comma(affected_records_n), " affected records"),
      TRUE ~ "No material issue identified"
    ),
    issue_family = factor(issue_family, levels = rev(family_order))
  )

fig2_plot <- ggplot(fig2_df, aes(x = 1, y = issue_family, fill = outcome_profile)) +
  geom_tile(width = 0.92, height = 0.84, color = "white", linewidth = 0.8) +
  geom_text(aes(label = detail_label), fontface = "bold", size = 3.3) +
  scale_x_continuous(NULL, breaks = NULL) +
  scale_fill_manual(
    values = c(
      "Stable for v1 monitoring"    = "#4E79A7",
      "Warning-level gap"           = "#F28E2B",
      "Low-volume issue to monitor" = "#C97B63",
      "Targeted geographic caveat"  = "#76B7B2"
    )
  ) +
  labs(
    title = "Validation Outcome Summary by Check Family",
    subtitle = "Most flagged items are warning-level gaps or low-volume monitored exceptions; geographic completeness remains the main targeted caveat.",
    caption = "Materiality-based summary for v1 monitoring. Tile text shows affected-record volume from issue_register_v1 where available.",
    fill = NULL
  ) +
  theme(
    axis.text.y = element_text(face = "bold"),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )

save_fig(fig2_plot, "fig_02_validation_outcome_summary.png", width = 11, height = 7)

# -------------------------------------------------
# Figure 3
# Quality Monitoring View: Annual and Financial-Year Issue Coverage
# Uses distinct_issue_records_pct from monitoring summaries
# -------------------------------------------------

annual_plot_df <- annual_summary %>%
  arrange(crashYear) %>%
  mutate(
    crashYear = as.numeric(crashYear)
  )

fy_plot_df <- fy_summary %>%
  mutate(
    crashFinancialYear = as.character(crashFinancialYear),
    fy_sort = parse_number(crashFinancialYear)
  ) %>%
  arrange(fy_sort, crashFinancialYear) %>%
  mutate(
    idx = row_number()
  )

annual_breaks <- annual_plot_df$crashYear[pick_break_idx(nrow(annual_plot_df), target = 8)]
fy_break_idx  <- pick_break_idx(nrow(fy_plot_df), target = 8)

y_max <- max(
  annual_plot_df$distinct_issue_records_pct,
  fy_plot_df$distinct_issue_records_pct,
  na.rm = TRUE
) * 1.08

p3_annual <- ggplot(annual_plot_df, aes(x = crashYear, y = distinct_issue_records_pct)) +
  geom_col(fill = "#4E79A7", width = 0.7) +
  scale_x_continuous(breaks = annual_breaks) +
  scale_y_continuous(
    limits = c(0, y_max),
    labels = label_number(suffix = "%")
  ) +
  labs(
    title = "Annual reporting view",
    x = "Crash year",
    y = "Share of records with any flagged issue"
  )

p3_fy <- ggplot(fy_plot_df, aes(x = idx, y = distinct_issue_records_pct)) +
  geom_col(fill = "#76B7B2", width = 0.7) +
  scale_x_continuous(
    breaks = fy_break_idx,
    labels = fy_plot_df$crashFinancialYear[fy_break_idx]
  ) +
  scale_y_continuous(
    limits = c(0, y_max),
    labels = label_number(suffix = "%")
  ) +
  labs(
    title = "Financial-year reporting view",
    x = "Crash financial year",
    y = NULL
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

fig3_plot <- p3_annual + p3_fy +
  plot_annotation(
    title = "Quality Monitoring View: Annual and Financial-Year Issue Coverage",
    subtitle = "Illustrative annual and financial-year view of records captured by the v1 quality-monitoring layer.",
    caption = "This figure shows the reporting frame used in the monitoring layer. It should not be read as operational reporting or as a headline trend on dataset reliability."
  )

save_fig(fig3_plot, "fig_03_quality_monitoring_annual_fy_issue_coverage.png", width = 14, height = 6.5)

# -------------------------------------------------
# Figure 4
# Geographic Completeness Caveat by Reporting Use Case
# Interpretation-oriented caveat matrix
# -------------------------------------------------

fig4_use_cases <- tibble::tribble(
  ~use_case,                           ~status,
  "National annual summaries",         "Suitable without material concern",
  "National financial-year summaries", "Suitable without material concern",
  "Broad national monitoring",         "Suitable without material concern",
  "Regional comparison",               "Suitable with stated caveat",
  "TLA-level reporting",               "Suitable with stated caveat",
  "Area-unit reporting",               "Use with extra caution",
  "Meshblock-linked analysis",         "Use with extra caution",
  "Map-based interpretation",          "Use with extra caution"
)

status_levels <- c(
  "Suitable without material concern",
  "Suitable with stated caveat",
  "Use with extra caution"
)

fig4_matrix <- expand.grid(
  use_case = fig4_use_cases$use_case,
  status = status_levels,
  stringsAsFactors = FALSE
) %>%
  as_tibble() %>%
  left_join(fig4_use_cases, by = "use_case", suffix = c("_grid", "_selected")) %>%
  mutate(
    selected = status_grid == status_selected,
    fill_group = case_when(
      selected & status_grid == "Suitable without material concern" ~ "Suitable without material concern",
      selected & status_grid == "Suitable with stated caveat" ~ "Suitable with stated caveat",
      selected & status_grid == "Use with extra caution" ~ "Use with extra caution",
      TRUE ~ "Not selected"
    ),
    use_case = factor(use_case, levels = rev(fig4_use_cases$use_case)),
    status_grid = factor(status_grid, levels = status_levels)
  )

fig4_plot <- ggplot(fig4_matrix, aes(x = status_grid, y = use_case, fill = fill_group)) +
  geom_tile(color = "white", linewidth = 1.1, width = 0.94, height = 0.86) +
  geom_text(
    data = fig4_matrix %>% filter(selected),
    aes(label = "●"),
    size = 7,
    color = "black",
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c(
      "Suitable without material concern" = "#4E79A7",
      "Suitable with stated caveat" = "#76B7B2",
      "Use with extra caution" = "#F28E2B",
      "Not selected" = "#F3F4F6"
    ),
    breaks = c(
      "Suitable without material concern",
      "Suitable with stated caveat",
      "Use with extra caution"
    )
  ) +
  labs(
    title = "Geographic Completeness Caveat by Reporting Use Case",
    subtitle = "Geographic reference gaps are not material for national monitoring, but they should be stated for more detailed local-area interpretation.",
    x = NULL,
    y = NULL,
    fill = NULL,
    caption = "Interpretation-oriented summary only. This figure positions the geographic completeness caveat by reporting use case rather than showing spatial distribution."
  ) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(face = "bold"),
    axis.text.y = element_text(face = "bold"),
    legend.position = "bottom"
  )

save_fig(fig4_plot, "fig_04_geographic_completeness_caveat_matrix.png", width = 12.5, height = 6.8)

cat("Static figures exported to:", figures_dir, "\n")
cat("- fig_02_validation_outcome_summary.png\n")
cat("- fig_03_national_annual_fy_monitoring_view.png\n")
cat("- fig_04_geographic_reference_completeness_summary.png\n")
