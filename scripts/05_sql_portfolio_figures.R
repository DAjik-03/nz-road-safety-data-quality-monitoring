suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(forcats)
  library(ggplot2)
  library(scales)
  library(stringr)
})

sql_dir <- "outputs/sql"
assets_dir <- "assets"

dir.create(assets_dir, recursive = TRUE, showWarnings = FALSE)

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

save_figure <- function(plot_obj, file_name, width = 12, height = 6.75) {
  ggsave(
    filename = file.path(assets_dir, file_name),
    plot = plot_obj,
    width = width,
    height = height,
    dpi = 220,
    bg = "white"
  )
}

theme_sql_portfolio <- theme_minimal(base_size = 13) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", colour = "#17202A", size = 18),
    plot.subtitle = element_text(colour = "#4B5563", margin = margin(b = 14)),
    plot.caption = element_text(colour = "#6B7280", hjust = 0),
    axis.title = element_text(colour = "#374151"),
    axis.text = element_text(colour = "#374151"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "#E5E7EB", linewidth = 0.45),
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.margin = margin(18, 34, 16, 18)
  )

quality <- read_required(
  file.path(sql_dir, "power_bi_quality_check_summary.csv")
)

check_cols(
  quality,
  c("check_id", "check_name", "status", "records_checked", "failed_records"),
  "power_bi_quality_check_summary.csv"
)

quality_exceptions <- quality |>
  filter(failed_records > 0) |>
  mutate(
    check_label = paste0(check_id, "  ", str_wrap(check_name, width = 34)),
    check_label = fct_reorder(check_label, failed_records),
    label_x = failed_records * if_else(failed_records >= 1000, 1.10, 1.22),
    status = factor(status, levels = c("REVIEW", "MONITOR"))
  )

if (nrow(quality_exceptions) < 4) {
  stop("At least four non-zero quality checks are required for the comparison figure.", call. = FALSE)
}

quality_plot <- ggplot(
  quality_exceptions,
  aes(x = failed_records, y = check_label)
) +
  geom_segment(
    aes(x = 1, xend = failed_records, yend = check_label),
    colour = "#CBD5E1",
    linewidth = 1.1
  ) +
  geom_point(
    aes(fill = status, shape = status),
    colour = "#17202A",
    size = 4.4,
    stroke = 0.55
  ) +
  geom_text(
    aes(x = label_x, label = comma(failed_records)),
    hjust = 0,
    colour = "#17202A",
    fontface = "bold",
    size = 4
  ) +
  scale_x_log10(
    breaks = c(1, 10, 100, 1000),
    labels = comma,
    limits = c(0.8, 6500)
  ) +
  scale_fill_manual(values = c(REVIEW = "#1F4E79", MONITOR = "#D39C2F")) +
  scale_shape_manual(values = c(REVIEW = 21, MONITOR = 24)) +
  labs(
    title = "SQL quality checks with recorded exceptions",
    subtitle = "Five of 12 rules recorded exceptions across 913,464 records; horizontal axis uses a log scale.",
    x = "Failed records (log scale)",
    y = NULL,
    caption = "Source: outputs/sql/power_bi_quality_check_summary.csv | DuckDB SQL output"
  ) +
  theme_sql_portfolio +
  theme(panel.grid.major.y = element_blank())

save_figure(quality_plot, "sql_quality_check_exceptions.png")

annual <- read_required(
  file.path(sql_dir, "power_bi_annual_crash_monitoring.csv")
)

check_cols(
  annual,
  c("crash_year", "period_status", "crash_count"),
  "power_bi_annual_crash_monitoring.csv"
)

annual_complete <- annual |>
  filter(period_status == "complete_period") |>
  arrange(crash_year)

if (nrow(annual_complete) < 8) {
  stop("At least eight complete periods are required for the annual trend figure.", call. = FALSE)
}

start_point <- annual_complete |>
  slice_head(n = 1) |>
  mutate(
    label = paste0(crash_year, ": ", comma(crash_count)),
    label_x = crash_year + 0.45,
    label_hjust = 0
  )

end_point <- annual_complete |>
  slice_tail(n = 1) |>
  mutate(
    label = paste0(crash_year, ": ", comma(crash_count)),
    label_x = crash_year - 0.45,
    label_hjust = 1
  )

endpoints <- bind_rows(start_point, end_point)

annual_plot <- ggplot(
  annual_complete,
  aes(x = crash_year, y = crash_count)
) +
  geom_line(colour = "#1F4E79", linewidth = 1.25) +
  geom_point(
    shape = 21,
    fill = "white",
    colour = "#1F4E79",
    size = 2.7,
    stroke = 0.9
  ) +
  geom_point(
    data = endpoints,
    aes(x = crash_year, y = crash_count),
    inherit.aes = FALSE,
    shape = 21,
    fill = "#D39C2F",
    colour = "#17202A",
    size = 4.2,
    stroke = 0.55
  ) +
  geom_text(
    data = endpoints,
    aes(
      x = label_x,
      y = crash_count,
      label = label,
      hjust = label_hjust
    ),
    inherit.aes = FALSE,
    nudge_y = 1750,
    colour = "#17202A",
    fontface = "bold",
    size = 3.8
  ) +
  scale_x_continuous(
    breaks = seq(2000, 2025, by = 5),
    expand = expansion(mult = c(0.025, 0.035))
  ) +
  scale_y_continuous(
    limits = c(0, 46000),
    breaks = seq(0, 45000, by = 5000),
    labels = comma,
    expand = expansion(mult = c(0, 0.01))
  ) +
  labs(
    title = "Annual crash records in complete calendar years",
    subtitle = "Calendar years 2000-2025; the 2026 partial snapshot (2,940 records) is excluded from trend comparison.",
    x = "Crash year",
    y = "Crash records",
    caption = "Source: outputs/sql/power_bi_annual_crash_monitoring.csv | DuckDB SQL output"
  ) +
  theme_sql_portfolio +
  theme(legend.position = "none")

save_figure(annual_plot, "sql_annual_crash_monitoring.png")

message("Created SQL-connected figures in ", assets_dir)
