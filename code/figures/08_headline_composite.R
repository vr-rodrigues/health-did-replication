###############################################################################
# 08_headline_composite.R — New Figure 4.1 (headline composite)
#
# Two-panel headline figure, per QJE review Deliverable D4 (Sant'Anna 2026-04-17):
#   Panel A: 2x2 outcome matrix — sign (preserved/reversed) x significance
#            (preserved/lost). Cell counts shown on tile-shaded background.
#   Panel B: caterpillar plot of within-paper magnitude shifts,
#            with top and bottom outliers labelled.
#
# Input:  analysis/consolidated_results.csv (uses att_cs_dyn = dynamic aggregate)
# Output: output/figures/figure_4_1_headline_composite.pdf
#         output/figures/figure_4_1_headline_composite.png (for quick previews)
#
# Run from the replication package root.
###############################################################################

suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(tidyr); library(ggrepel)
  library(grid); library(patchwork); library(scales)
})

base_dir <- getwd()
out_dir  <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

set.seed(42)

# ============ LOAD ============
con <- read.csv(file.path(base_dir, "analysis", "consolidated_results.csv"),
                stringsAsFactors = FALSE)

# Use dynamic aggregate (headline in the paper), fallback to group aggregate
con <- con %>% mutate(
  att_cs   = coalesce(att_nt_dynamic, att_nyt_dynamic,
                       att_csdid_nt,   att_csdid_nyt),
  se_cs    = coalesce(se_nt_dynamic,  se_nyt_dynamic,
                       se_csdid_nt,    se_csdid_nyt)
)

# Classification inputs
crit <- 1.96
con <- con %>% mutate(
  has_twfe = !is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0,
  has_cs   = !is.na(att_cs)    & !is.na(se_cs)   & se_cs   > 0,
  z_twfe   = ifelse(has_twfe, beta_twfe / se_twfe, NA_real_),
  z_cs     = ifelse(has_cs,   att_cs    / se_cs,   NA_real_),
  sig_twfe = has_twfe & abs(z_twfe) > crit,
  sig_cs   = has_cs   & abs(z_cs)   > crit,
  same_sign = has_twfe & has_cs & sign(beta_twfe) == sign(att_cs),
  delta_pct = ifelse(has_twfe & has_cs & beta_twfe != 0,
                     100 * (att_cs - beta_twfe) / abs(beta_twfe), NA_real_)
)

# Drop papers missing either estimate from the 2x2 (keeps cells cleanly countable)
con_2x2 <- con %>% filter(has_twfe, has_cs)
cat(sprintf("Papers with both TWFE and CS-DID available: %d of %d\n",
            nrow(con_2x2), nrow(con)))

# ============ PANEL A: 2x2 MATRIX ============
cell_counts <- con_2x2 %>%
  mutate(
    sign_cat = ifelse(same_sign, "Sign preserved", "Sign reversed"),
    sig_cat  = case_when(
       sig_twfe &  sig_cs ~ "Significance preserved",
       sig_twfe & !sig_cs ~ "Significance lost",
      !sig_twfe &  sig_cs ~ "Significance gained",
      !sig_twfe & !sig_cs ~ "Both insignificant"
    )
  ) %>%
  group_by(sign_cat, sig_cat) %>%
  summarise(n = n(), .groups = "drop")

# Ensure all 2x4 cells exist (use 0 when empty)
all_cells <- expand.grid(
  sign_cat = c("Sign preserved", "Sign reversed"),
  sig_cat  = c("Significance preserved", "Significance lost",
               "Significance gained", "Both insignificant"),
  stringsAsFactors = FALSE
)
cell_counts <- all_cells %>%
  left_join(cell_counts, by = c("sign_cat", "sig_cat")) %>%
  mutate(n = coalesce(n, 0L))

# Fix ordering (rows: preserved on top; cols: preserved → lost → gained → both insig)
cell_counts$sign_cat <- factor(cell_counts$sign_cat,
                               levels = c("Sign preserved", "Sign reversed"))
cell_counts$sig_cat  <- factor(cell_counts$sig_cat,
                               levels = c("Significance preserved",
                                          "Significance lost",
                                          "Significance gained",
                                          "Both insignificant"))

# Add a "cell type" category for tile shading
cell_counts <- cell_counts %>% mutate(
  cell_type = case_when(
    sign_cat == "Sign preserved" & sig_cat == "Significance preserved" ~ "Concordant",
    sign_cat == "Sign preserved" & sig_cat == "Significance lost"     ~ "Weakened",
    sign_cat == "Sign preserved" & sig_cat == "Significance gained"   ~ "Strengthened",
    sign_cat == "Sign preserved" & sig_cat == "Both insignificant"    ~ "Both null",
    sign_cat == "Sign reversed"                                        ~ "Reversed"
  )
)

panel_A <- ggplot(cell_counts,
                  aes(x = sig_cat, y = sign_cat, fill = cell_type)) +
  geom_tile(color = "black", linewidth = 0.4, alpha = 0.5) +
  geom_text(aes(label = n), size = 9, fontface = "bold", color = "black") +
  scale_fill_manual(values = c(
    "Concordant"    = "#2ca02c",
    "Weakened"      = "#ff7f0e",
    "Strengthened"  = "#9ecae1",
    "Both null"     = "grey80",
    "Reversed"      = "#d62728"
  ), guide = "none") +
  scale_x_discrete(position = "top", labels = function(x)
    gsub(" ", "\n", x)) +
  labs(
    x = NULL,
    y = NULL,
    title = "A. Sign-by-significance matrix",
    subtitle = sprintf("TWFE vs CS-DID dynamic aggregate (n = %d)", nrow(con_2x2))
  ) +
  theme_minimal(base_size = 11) +
  theme(
    axis.text.x.top = element_text(face = "bold", lineheight = 0.9),
    axis.text.y     = element_text(face = "bold"),
    panel.grid      = element_blank(),
    plot.title      = element_text(face = "bold", size = 12),
    plot.subtitle   = element_text(size = 10, color = "grey30")
  )

# ============ PANEL B: CATERPILLAR OF MAGNITUDE SHIFTS ============
# delta_pct = 100 * (att_cs - beta_twfe) / |beta_twfe|
# Winsorize for plotting but label the real values
winsorize <- function(x, lo = -300, hi = 300) pmin(pmax(x, lo), hi)

cat_data <- con_2x2 %>%
  filter(!is.na(delta_pct)) %>%
  arrange(delta_pct) %>%
  mutate(
    rank = row_number(),
    delta_plot = winsorize(delta_pct),
    is_outlier = abs(delta_pct) > 100,
    bar_color = case_when(
      delta_pct >  100 ~ "High positive",
      delta_pct >   50 ~ "Medium positive",
      delta_pct >=   0 ~ "Low positive",
      delta_pct >= -50 ~ "Low negative",
      delta_pct >= -100 ~ "Medium negative",
      TRUE ~ "High negative"
    )
  )

# Label top 5 and bottom 5
labels_top <- cat_data %>%
  arrange(desc(delta_pct)) %>% head(5) %>%
  mutate(label = sprintf("%s (%+.0f%%)", author_label, delta_pct))
labels_bot <- cat_data %>%
  arrange(delta_pct) %>% head(5) %>%
  mutate(label = sprintf("%s (%+.0f%%)", author_label, delta_pct))
labels_df <- bind_rows(labels_top, labels_bot)

panel_B <- ggplot(cat_data, aes(x = rank, y = delta_plot, color = bar_color)) +
  geom_hline(yintercept = 0, linetype = "solid",  color = "grey20") +
  geom_hline(yintercept = c(-100, -50, 50, 100),
             linetype = "dashed", color = "grey70", linewidth = 0.3) +
  geom_segment(aes(xend = rank, yend = 0), linewidth = 0.6) +
  geom_point(size = 1.3) +
  geom_text_repel(data = labels_df, aes(label = label),
                  size = 2.4, max.overlaps = Inf,
                  box.padding = 0.35,
                  segment.size = 0.2,
                  show.legend = FALSE) +
  scale_y_continuous(
    limits = c(-300, 300),
    breaks = c(-300, -100, -50, 0, 50, 100, 300),
    labels = function(x) ifelse(abs(x) == 300, paste0("\u00b1300+"), paste0(x, "%"))
  ) +
  scale_color_manual(values = c(
    "High positive"    = "#08519c",
    "Medium positive"  = "#3182bd",
    "Low positive"     = "#9ecae1",
    "Low negative"     = "#fcae91",
    "Medium negative"  = "#de2d26",
    "High negative"    = "#a50f15"
  ), guide = "none") +
  labs(
    x = sprintf("Paper rank (sorted by %% change in point estimate)"),
    y = expression(paste("%", Delta, " = 100",
                        "(", hat(beta)[CS] - hat(beta)[TWFE], ") / |",
                        hat(beta)[TWFE], "|")),
    title = "B. Within-paper magnitude shift (CS vs TWFE)",
    subtitle = sprintf("n = %d (papers with both estimates available); axis winsorized at \u00b1300%%",
                       nrow(cat_data))
  ) +
  theme_minimal(base_size = 11) +
  theme(
    axis.text.x  = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title    = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 10, color = "grey30")
  )

# ============ COMBINE ============
combined <- (panel_A / panel_B) +
  plot_layout(heights = c(1, 1.3)) +
  plot_annotation(
    caption = paste0(
      "Headline patterns of the reanalysis. ",
      "Panel~A: joint distribution of sign and significance outcomes when ",
      "moving from TWFE to CS-DID dynamic aggregate. ",
      "Panel~B: within-paper proportional change in the point estimate. ",
      "See Box~4.1 (pre-submission DiD checklist) and Section~4.9 for the ",
      "sensitivity of this classification to the aggregation rule."),
    theme = theme(plot.caption = element_text(size = 8, hjust = 0,
                                              color = "grey30"))
  )

ggsave(file.path(out_dir, "figure_4_1_headline_composite.pdf"),
       combined, width = 8.5, height = 10, device = cairo_pdf)
ggsave(file.path(out_dir, "figure_4_1_headline_composite.png"),
       combined, width = 8.5, height = 10, dpi = 150)

# ============ SUMMARY TO STDOUT ============
cat("\n=== Figure 4.1 headline composite ===\n")
cat(sprintf("Panel A: 2x2 matrix (n=%d). Cell counts:\n", nrow(con_2x2)))
print(cell_counts %>% select(sign_cat, sig_cat, n))
cat(sprintf("\nPanel B: %d papers with delta_pct available.\n", nrow(cat_data)))
cat(sprintf("  median delta_pct: %+.1f%%\n", median(cat_data$delta_pct, na.rm = TRUE)))
cat(sprintf("  |delta_pct| > 100%%: %d (%.1f%%)\n",
            sum(abs(cat_data$delta_pct) > 100, na.rm = TRUE),
            100 * mean(abs(cat_data$delta_pct) > 100, na.rm = TRUE)))
cat(sprintf("  range: %+.1f%% to %+.1f%%\n",
            min(cat_data$delta_pct, na.rm = TRUE),
            max(cat_data$delta_pct, na.rm = TRUE)))

cat("\nSaved:\n")
cat(" ", file.path(out_dir, "figure_4_1_headline_composite.pdf"), "\n")
cat(" ", file.path(out_dir, "figure_4_1_headline_composite.png"), "\n")
cat("\nDone: 08_headline_composite.R\n")
