###############################################################################
# 02_density_z.R — Density plots of z-scores: TWFE vs CS-DID
# Produces: Figure 4.2 (dynamic) and group/simple variants
#
# Output files:
#   output/figures/figure_4_2_density_z_dynamic.pdf
#   output/figures/density_z_group.pdf
#   output/figures/density_z_simple.pdf
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(jsonlite)
})

base_dir     <- getwd()
analysis_dir <- file.path(base_dir, "analysis")
out_dir      <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Load consolidated results
con <- read.csv(file.path(analysis_dir, "consolidated_results.csv"),
                stringsAsFactors = FALSE)

make_density <- function(con, agg_type, out_file) {
  if (agg_type == "group") {
    nt_att <- "att_csdid_nt"; nt_se <- "se_csdid_nt"
    nyt_att <- "att_csdid_nyt"; nyt_se <- "se_csdid_nyt"
  } else if (agg_type == "simple") {
    nt_att <- "att_nt_simple"; nt_se <- "se_nt_simple"
    nyt_att <- "att_nyt_simple"; nyt_se <- "se_nyt_simple"
  } else {
    nt_att <- "att_nt_dynamic"; nt_se <- "se_nt_dynamic"
    nyt_att <- "att_nyt_dynamic"; nyt_se <- "se_nyt_dynamic"
  }

  df <- con %>%
    filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0) %>%
    mutate(
      att_cs = ifelse(!is.na(.data[[nt_att]]), .data[[nt_att]], .data[[nyt_att]]),
      se_cs  = ifelse(!is.na(.data[[nt_se]]),  .data[[nt_se]],  .data[[nyt_se]])
    ) %>%
    filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0) %>%
    mutate(z_twfe = beta_twfe / se_twfe, z_cs = att_cs / se_cs)

  long <- bind_rows(
    data.frame(z = df$z_twfe, estimator = "TWFE"),
    data.frame(z = df$z_cs,   estimator = "CS-DID")
  )

  p <- ggplot(long, aes(x = z, fill = estimator, color = estimator)) +
    geom_density(alpha = 0.35, linewidth = 0.6) +
    geom_vline(xintercept = c(-1.96, 1.96), linetype = "dashed", color = "grey50", linewidth = 0.3) +
    scale_fill_manual(values = c("TWFE" = "black", "CS-DID" = "steelblue")) +
    scale_color_manual(values = c("TWFE" = "black", "CS-DID" = "steelblue")) +
    labs(x = "Z-score (own SE)", y = "Density",
         title = sprintf("Distribution of z-scores: TWFE vs CS-DID (%s) — %d articles",
                         agg_type, nrow(df))) +
    theme_classic(base_size = 13) +
    theme(legend.position = "bottom", legend.title = element_blank())

  ggsave(file.path(out_dir, out_file), p, width = 8, height = 5)
  cat(sprintf("  Saved: %s (%d articles)\n", out_file, nrow(df)))
}

make_density(con, "dynamic", "figure_4_2_density_z_dynamic.pdf")
make_density(con, "group",   "density_z_group.pdf")
make_density(con, "simple",  "density_z_simple.pdf")

cat("\nDone: 02_density_z.R\n")
