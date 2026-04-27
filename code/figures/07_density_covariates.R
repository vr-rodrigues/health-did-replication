###############################################################################
# 07_density_covariates.R — Figure 4.7: 2-panel aggregate scatter restricted
# to the 10 papers where all three specs are computed and non-degenerate.
#
# Panel A: TWFE (w/ ctrls)  vs  CS-DID (w/ ctrls, Spec A matched)
# Panel B: TWFE (w/ ctrls)  vs  CS-DID (unconditional, no controls on CS side)
#
# Compares how much each CS-DID spec diverges from the paper's own TWFE,
# on the same N=10 papers so the contrast is internal-consistent.
#
# Output: output/figures/figure_4_7_density_covariates.pdf
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(jsonlite); library(cowplot)
})

base_dir <- getwd()
con <- read.csv(file.path(base_dir, "analysis", "consolidated_results.csv"),
                stringsAsFactors = FALSE)

# ── Filter: 10 papers where all three specs exist ─────────────────────────
df <- con %>%
  filter(
    !is.na(beta_twfe),                 !is.na(se_twfe),                 se_twfe > 0,
    !is.na(att_cs_nt_with_ctrls_dyn),  !is.na(se_cs_nt_with_ctrls_dyn), se_cs_nt_with_ctrls_dyn > 0,
    abs(att_cs_nt_with_ctrls_dyn) > 1e-9,
    !is.na(att_nt_dynamic),            !is.na(se_nt_dynamic),           se_nt_dynamic > 0
  )

cat(sprintf("Papers with all three specs valid: %d\n", nrow(df)))
cat("IDs:", paste(df$id, collapse = ", "), "\n\n")

# ── Common axis: TWFE z on X, CS-DID z (scaled by TWFE SE) on Y ───────────
# Same convention as Figure 4.1 scatter (CS-DID numerator, TWFE SE denominator)
# so units are comparable across panels.
df <- df %>% mutate(
  z_twfe    = beta_twfe                / se_twfe,
  z_cs_A    = att_cs_nt_with_ctrls_dyn / se_twfe,
  z_cs_unc  = att_nt_dynamic           / se_twfe,
  # For concordance classification we still use each CS's own SE
  z_cs_A_own   = att_cs_nt_with_ctrls_dyn / se_cs_nt_with_ctrls_dyn,
  z_cs_unc_own = att_nt_dynamic           / se_nt_dynamic,
  short_label  = gsub(" et al\\.", "", author_label)
)
df$short_label <- gsub(" \\(\\d{4}[a-z]?\\)", "", df$short_label)

crit <- 1.96

classify <- function(beta_t, se_t, att_c, se_c) {
  sig_t <- abs(beta_t / se_t) > crit
  sig_c <- abs(att_c / se_c) > crit
  ss    <- sign(beta_t) == sign(att_c)
  case_when(
    !ss &  (sig_t | sig_c)          ~ "Sign\nreversal",
    !ss &  !sig_t & !sig_c          ~ "Sign reversal\n(insig)",
    ss  &   sig_t &  sig_c          ~ "Concordant",
    ss  &   sig_t & !sig_c          ~ "Significance\nloss",
    ss  &  !sig_t &  sig_c          ~ "Significance\ngain",
    ss  &  !sig_t & !sig_c          ~ "Both\ninsignificant",
    TRUE                             ~ "Other"
  )
}

df$cat_A   <- classify(df$beta_twfe, df$se_twfe,
                       df$att_cs_nt_with_ctrls_dyn, df$se_cs_nt_with_ctrls_dyn)
df$cat_unc <- classify(df$beta_twfe, df$se_twfe,
                       df$att_nt_dynamic,           df$se_nt_dynamic)

cat_colors <- c(
  "Concordant"            = "black",
  "Significance\nloss"    = "steelblue",
  "Significance\ngain"    = "forestgreen",
  "Sign\nreversal"        = "firebrick",
  "Sign reversal\n(insig)"= "grey50",
  "Both\ninsignificant"   = "grey50")
cat_shapes <- c(
  "Concordant"            = 16,
  "Significance\nloss"    = 17,
  "Significance\ngain"    = 15,
  "Sign\nreversal"        = 4,
  "Sign reversal\n(insig)"= 4,
  "Both\ninsignificant"   = 1)
cat_levels <- names(cat_colors)

# Axis limits — common for both panels
lim <- ceiling(max(abs(c(df$z_twfe, df$z_cs_A, df$z_cs_unc)), na.rm = TRUE) * 1.1)

# Union of categories that appear in either panel — both panels use the
# same factor levels + breaks so the legend extracted from one works for both.
cats_shown <- intersect(cat_levels, union(unique(df$cat_A), unique(df$cat_unc)))

make_panel <- function(df, y_var, cat_var, subtitle, show_y_axis = TRUE) {
  df$y   <- df[[y_var]]
  df$cat <- factor(df[[cat_var]], levels = cats_shown)
  p <- ggplot(df, aes(x = z_twfe, y = y, color = cat, shape = cat)) +
    geom_hline(yintercept = 0,    color = "grey70", linetype = "dashed", linewidth = 0.3) +
    geom_vline(xintercept = 0,    color = "grey70", linetype = "dashed", linewidth = 0.3) +
    geom_abline(slope = 1, intercept = 0,
                color = "grey55", linetype = "dashed", linewidth = 0.4) +
    geom_point(size = 3) +
    scale_color_manual(values = cat_colors, breaks = cats_shown,
                       drop = FALSE, name = NULL) +
    scale_shape_manual(values = cat_shapes, breaks = cats_shown,
                       drop = FALSE, name = NULL) +
    scale_x_continuous(limits = c(-lim, lim)) +
    scale_y_continuous(limits = c(-lim, lim)) +
    coord_fixed(ratio = 1) +
    labs(title = subtitle,
         x = "TWFE z-score (with controls)",
         y = "CS-DID estimate / TWFE SE") +
    theme_classic(base_size = 12) +
    theme(plot.title = element_text(size = 12, face = "bold"),
          legend.text = element_text(size = 9, lineheight = 0.9),
          legend.key.size = unit(0.5, "cm"))
  p
}

pA <- make_panel(df, "z_cs_A",   "cat_A",
                 "(a) TWFE  vs  CS-DID with controls")
pB <- make_panel(df, "z_cs_unc", "cat_unc",
                 "(b) TWFE  vs  CS-DID without controls")

# Extract a single shared legend from pA, strip legends from both panels,
# then arrange with cowplot so both panels keep their full axes (including
# Y on the right panel) and we have exactly one legend at the bottom.
legend_b <- cowplot::get_legend(
  pA + theme(legend.position = "bottom",
             legend.box.margin = margin(t = 0, b = 0)))

row <- cowplot::plot_grid(
  pA + theme(legend.position = "none"),
  pB + theme(legend.position = "none"),
  ncol = 2, align = "h", axis = "tb")

panel <- cowplot::plot_grid(row, legend_b,
                             ncol = 1, rel_heights = c(1, 0.08))

out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(out_dir, "figure_4_7_density_covariates.pdf")
ggsave(out_path, panel, width = 13, height = 6.5)
cat(sprintf("\nSaved: %s\n", out_path))
