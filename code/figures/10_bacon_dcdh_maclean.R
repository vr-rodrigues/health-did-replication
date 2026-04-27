###############################################################################
# 10_bacon_dcdh_maclean.R
# Side-by-side Bacon + dCdH weight-vs-estimate panel for Maclean & Pabilonia
# (2025) — article id 201. Demonstrates Lesson 2's central claim that the
# sign reversal here is cohort-weighting (size-weighted vs uniform) rather
# than negative weights: Bacon shows TvT < 8%, dCdH shows zero cells with
# w_{g,t} < 0 across 484 informative group-time comparisons.
#
# Inputs:
#   results/by_article/201/bacon.csv     — 9 pseudo-panel 2x2 rows
#   data/metadata/201.json               — data path, variable names, sample filter
#   <ATUS data>                           — resolved from metadata
#
# Output:
#   results/by_article/201/dcdh_cells.csv — per-cell dCdH weights
#   output/figures/figure_4_X_bacon_dcdh_maclean.pdf — side-by-side plot
###############################################################################
suppressPackageStartupMessages({
  library(jsonlite); library(dplyr); library(ggplot2); library(patchwork)
  library(haven); library(TwoWayFEWeights); library(ggrepel)
})

base_dir <- getwd()
id <- "201"

meta_f <- file.path(base_dir, "data", "metadata", paste0(id, ".json"))
meta   <- fromJSON(meta_f)

# ─── Load data ─────────────────────────────────────────────────────────────
data_f <- meta$data$file
if (!grepl("^[A-Z]:", data_f) && !grepl("^/", data_f))
  data_f <- file.path(base_dir, data_f)
stopifnot(file.exists(data_f))

df <- read_dta(data_f)

sf <- meta$data$sample_filter
if (!is.null(sf) && nzchar(trimws(sf))) {
  df <- df %>% filter(!!rlang::parse_expr(sf))
}
for (expr in meta$preprocessing$construct_vars) eval(parse(text = expr))

yname <- meta$variables$outcome
idn   <- meta$variables$unit_id
tn    <- meta$variables$time
dn    <- meta$variables$treatment_twfe

df[[idn]] <- as.numeric(as.factor(df[[idn]]))
df[[tn]]  <- as.numeric(df[[tn]])
df[[dn]]  <- as.numeric(df[[dn]])
df[[yname]] <- as.numeric(df[[yname]])
df <- df[complete.cases(df[, c(yname, idn, tn, dn)]), ]
cat("Rows:", nrow(df), "  States:", length(unique(df[[idn]])),
    "  Periods:", length(unique(df[[tn]])), "\n")

# ─── Compute dCdH cell weights ─────────────────────────────────────────────
out <- twowayfeweights(
  data = as.data.frame(df),
  Y    = yname,
  G    = idn,
  T    = tn,
  D    = dn,
  type = "feTR"
)
cat("dCdH:\n")
cat("  TWFE beta (2020 pseudo-TWFE):", out$beta, "\n")
cat("  N cells with weight  :", out$nr_weights, "(non-zero)\n")
cat("  N positive           :", out$nr_plus, "\n")
cat("  N negative           :", out$nr_minus, "\n")
cat("  Sum positive         :", out$sum_plus, "\n")
cat("  Sum negative         :", out$sum_minus, "\n")

cells <- out$dat_result
cells <- cells[cells$weight != 0, , drop = FALSE]
stopifnot(nrow(cells) == out$nr_weights)

# Attach cohort year for each (G, T) cell (used as y-axis in Panel B).
# gvar_CS is the calendar period of first treatment per fips (mapped via
# the refactored numeric unit id above).
cohort_map <- df %>%
  group_by(.data[[idn]]) %>%
  summarise(cohort_raw = first(gvar_CS), .groups = "drop")
names(cohort_map) <- c("G", "cohort_raw")
cells <- cells %>% left_join(cohort_map, by = "G")

# time variable in the paper is months since 2000-01 approx; convert cohort
# month → calendar year for labelling. ATUS fips & time are monthly integers
# starting at 2004-01; map cohort_raw (a "time" value) to its calendar year.
t_min_year <- 2004
cells$cohort_year <- t_min_year + floor((cells$cohort_raw - 1) / 12)
cells$cohort_lab  <- ifelse(cells$cohort_year <= t_min_year,
                             "Never treated",
                             sprintf("Cohort %d", cells$cohort_year))

out_dir <- file.path(base_dir, "results", "by_article", id)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
write.csv(cells, file.path(out_dir, "dcdh_cells.csv"), row.names = FALSE)
cat("Saved dcdh_cells.csv (", nrow(cells), "rows )\n")

# ─── Bacon data ────────────────────────────────────────────────────────────
bacon <- read.csv(file.path(out_dir, "bacon.csv"), stringsAsFactors = FALSE)
bacon$type_clean <- dplyr::recode(bacon$type,
  "Treated vs Untreated"       = "Never-treated vs timing",
  "Earlier vs Later Treated"   = "Timing groups",
  "Later vs Earlier Treated"   = "Timing groups")

# Map cohort codes (monthly "time" values when first treated) to calendar
# year labels. Bacon aggregates the ATUS pseudo-panel to state x year, so
# only a few cohort codes appear here (typically 3 treated cohorts).
bacon$cohort_treated   <- t_min_year + floor((bacon$treated - 1) / 12)
bacon$cohort_untreated <- ifelse(
  bacon$untreated == 99999,
  "NT",
  as.character(t_min_year + floor((bacon$untreated - 1) / 12))
)
bacon$label_2x2 <- sprintf("%d vs %s", bacon$cohort_treated, bacon$cohort_untreated)

# ─── Panel A: Bacon ────────────────────────────────────────────────────────
pa <- ggplot(bacon, aes(x = weight, y = estimate, shape = type_clean)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey40") +
  geom_point(size = 3.2) +
  geom_text_repel(aes(label = label_2x2),
                  size = 2.7, min.segment.length = 0,
                  segment.size = 0.2, segment.colour = "grey50",
                  box.padding = 0.35, point.padding = 0.25,
                  max.overlaps = Inf, seed = 42) +
  scale_shape_manual(values = c(
    "Never-treated vs timing" = 4,   # cross
    "Timing groups"           = 1    # circle
  )) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.15))) +
  labs(
    x = "Bacon weight",
    y = expression(paste("2 "%*%" 2 DiD estimate")),
    shape = NULL,
    title = "(a) Goodman-Bacon (9 components)"
  ) +
  theme_classic(base_size = 10) +
  theme(
    legend.position     = "bottom",
    legend.margin       = margin(0, 0, 0, 0),
    legend.box.margin   = margin(-6, 0, 0, 0),
    plot.title          = element_text(face = "bold", hjust = 0, size = 11)
  )

# ─── Panel B: dCdH ─────────────────────────────────────────────────────────
cohort_order <- cells %>% filter(cohort_year > t_min_year) %>%
  distinct(cohort_year) %>% arrange(cohort_year) %>% pull(cohort_year)
cells$cohort_lab <- factor(cells$cohort_lab,
  levels = c("Never treated", sprintf("Cohort %d", cohort_order)))

n_pos <- sum(cells$weight > 0)
n_neg <- sum(cells$weight < 0)

pb <- ggplot(cells, aes(x = weight, y = cohort_lab)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
  geom_jitter(height = 0.2, alpha = 0.55, size = 1.3, colour = "black") +
  labs(
    x = expression(paste("dCdH weight ", omega[g*","*t])),
    y = NULL,
    title = "(b) de Chaisemartin-d'Haultfoeuille (484 cells)"
  ) +
  annotate("text",
    x = max(cells$weight) * 0.55,
    y = 1,
    label = sprintf("Positive: %d\nNegative: %d",
                    n_pos, n_neg),
    hjust = 0, size = 3.2) +
  theme_classic(base_size = 10) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0, size = 11)
  )

# ─── Combine ───────────────────────────────────────────────────────────────
p <- pa + pb + plot_layout(widths = c(1, 1.1))

out_pdf <- file.path(base_dir, "output", "figures",
                     "figure_4_X_bacon_dcdh_maclean.pdf")
dir.create(dirname(out_pdf), recursive = TRUE, showWarnings = FALSE)
ggsave(out_pdf, p, width = 10, height = 4.4, device = cairo_pdf)
cat("\nSaved:", out_pdf, "\n")
