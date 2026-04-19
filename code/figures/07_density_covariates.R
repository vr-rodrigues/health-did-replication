###############################################################################
# density_covariates_zscore.R
# Overlapping density: TWFE (with controls) z-scores vs unconditional CS-DID
# Shows the two distributions are nearly identical — style of density_z_dynamic
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(jsonlite); library(tidyr)
})

# Run from replication package root.
base_dir <- getwd()

# ============ LOAD ALL RESULTS ============
results_root <- file.path(base_dir, "results", "by_article")
all_dirs <- list.dirs(results_root, recursive = FALSE, full.names = TRUE)
ids <- basename(all_dirs)
ids <- ids[grepl("^[0-9]+$", ids)]
ids <- sort(as.integer(ids))
ids <- ids[!ids %in% c(357, 382, 438, 234, 242, 380)]   # 2026-04-19 paper-auditor FAIL excluded

rows <- list()
for (id in ids) {
  dir <- file.path(results_root, id)
  meta_file <- file.path(dir, "metadata.json")
  res_file  <- file.path(dir, "results.csv")
  if (!file.exists(meta_file) || !file.exists(res_file)) next

  meta <- tryCatch(fromJSON(meta_file), error = function(e) NULL)
  if (is.null(meta)) next
  res <- tryCatch(read.csv(res_file, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(res)) next

  gcol <- function(name) {
    if (name %in% names(res)) as.numeric(res[[name]][1]) else NA_real_
  }

  # Check if TWFE has controls
  tw_ctrls <- meta$variables$twfe_controls
  add_fes  <- meta$variables$additional_fes
  if (is.null(tw_ctrls)) tw_ctrls <- character(0)
  if (is.null(add_fes))  add_fes  <- character(0)
  std_fes <- c(meta$variables$unit_id, meta$variables$time)
  extra_fes <- setdiff(add_fes, std_fes)
  n_ctrls <- length(tw_ctrls) + length(extra_fes)

  if ("estimator" %in% names(res)) {
    twfe_row  <- res[res$estimator == "TWFE", ]
    csnt_row  <- res[res$estimator == "CS-NT", ]
    csnyt_row <- res[res$estimator == "CS-NYT", ]
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label,
      beta_twfe = if (nrow(twfe_row) > 0) as.numeric(twfe_row$att[1]) else NA,
      se_twfe   = if (nrow(twfe_row) > 0) as.numeric(twfe_row$se[1])  else NA,
      att_nt_dynamic = NA, se_nt_dynamic = NA,
      att_nyt_dynamic = NA, se_nyt_dynamic = NA,
      att_nt_group  = if (nrow(csnt_row) > 0)  as.numeric(csnt_row$att[1])  else NA,
      se_nt_group   = if (nrow(csnt_row) > 0)  as.numeric(csnt_row$se[1])   else NA,
      att_nyt_group = if (nrow(csnyt_row) > 0) as.numeric(csnyt_row$att[1]) else NA,
      se_nyt_group  = if (nrow(csnyt_row) > 0) as.numeric(csnyt_row$se[1])  else NA,
      has_controls = n_ctrls > 0, n_controls = n_ctrls,
      stringsAsFactors = FALSE
    )
  } else {
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label,
      beta_twfe = gcol("beta_twfe"), se_twfe = gcol("se_twfe"),
      att_nt_dynamic  = gcol("att_nt_dynamic"),  se_nt_dynamic  = gcol("se_nt_dynamic"),
      att_nyt_dynamic = gcol("att_nyt_dynamic"), se_nyt_dynamic = gcol("se_nyt_dynamic"),
      att_nt_group    = gcol("att_csdid_nt"),    se_nt_group    = gcol("se_csdid_nt"),
      att_nyt_group   = gcol("att_csdid_nyt"),   se_nyt_group   = gcol("se_csdid_nyt"),
      has_controls = n_ctrls > 0, n_controls = n_ctrls,
      stringsAsFactors = FALSE
    )
  }
}

df <- bind_rows(rows) %>%
  filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0) %>%
  mutate(
    att_cs = coalesce(att_nt_dynamic, att_nyt_dynamic, att_nt_group, att_nyt_group),
    se_cs  = coalesce(se_nt_dynamic, se_nyt_dynamic, se_nt_group, se_nyt_group)
  ) %>%
  filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0) %>%
  filter(has_controls)

cat(sprintf("Articles with TWFE controls and valid CS-DID: %d\n", nrow(df)))

# ============ SCALED BETAS (both / TWFE SE) ============
df <- df %>% mutate(
  z_twfe = beta_twfe / se_twfe,
  z_cs   = att_cs / se_twfe        # same denominator: TWFE SE
)

# ============ STATISTICS ============
r <- cor(df$z_twfe, df$z_cs)
ratio_att  <- df$att_cs / df$beta_twfe
same_sign  <- sign(df$att_cs) == sign(df$beta_twfe)
med_ratio  <- median(ratio_att[same_sign & is.finite(ratio_att)], na.rm = TRUE)
mean_abs_diff <- mean(abs(df$z_twfe - df$z_cs))

cat(sprintf("Correlation (both / TWFE SE): %.3f\n", r))
cat(sprintf("Median CS/TWFE ratio (same sign): %.2f\n", med_ratio))
cat(sprintf("Mean |z_twfe - z_cs|: %.2f\n", mean_abs_diff))

# ============ RESHAPE FOR DENSITY ============
long <- df %>%
  select(id, z_twfe, z_cs) %>%
  pivot_longer(cols = c(z_twfe, z_cs),
               names_to = "estimator", values_to = "z") %>%
  mutate(estimator = factor(
    ifelse(estimator == "z_twfe",
           "TWFE (with controls)", "CS-DID (unconditional)"),
    levels = c("TWFE (with controls)", "CS-DID (unconditional)")
  ))

# ============ DENSITY PLOT ============
p <- ggplot(long, aes(x = z, fill = estimator, color = estimator)) +
  # Significance band (no border lines)
  annotate("rect", xmin = -1.96, xmax = 1.96, ymin = -Inf, ymax = Inf,
           fill = "grey90", alpha = 0.35) +
  geom_vline(xintercept = 0, color = "grey70", linewidth = 0.3) +
  # Density curves
  geom_density(alpha = 0.2, linewidth = 0.7) +
  # Rug marks
  geom_rug(alpha = 0.4, linewidth = 0.3, length = unit(0.02, "npc")) +
  # x-axis includes ±1.96
  scale_x_continuous(breaks = sort(unique(c(seq(-15, 15, by = 5), -1.96, 1.96)))) +
  # Annotation: correlation and ratio
  annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 1.5,
           label = sprintf("r = %.3f\nMedian ATT ratio = %.2f", r, med_ratio),
           size = 4, fontface = "italic", color = "grey30") +
  # Scales
  scale_fill_manual(
    values = c("TWFE (with controls)" = "grey40",
               "CS-DID (unconditional)" = "steelblue"),
    name = NULL
  ) +
  scale_color_manual(
    values = c("TWFE (with controls)" = "grey30",
               "CS-DID (unconditional)" = "steelblue4"),
    name = NULL
  ) +
  labs(
    x = "Estimate / TWFE SE",
    y = "Density",
    title = sprintf("TWFE with controls vs. unconditional CS-DID — %d articles", nrow(df)),
    subtitle = sprintf("Both scaled by TWFE SE  |  r = %.3f  |  Median ATT ratio = %.2f",
                        r, med_ratio)
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.5, "cm"),
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 10.5, color = "grey40"),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 11)
  )

out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(out_dir, "figure_4_7_density_covariates.pdf")
ggsave(out_path, p, width = 8, height = 5)
cat(sprintf("\nSaved: %s\n", out_path))

# ============ SUMMARY ============
cat("\n=== SUMMARY ===\n")
cat(sprintf("n = %d articles with TWFE controls\n", nrow(df)))
cat(sprintf("Correlation (both / TWFE SE): %.3f\n", r))
cat(sprintf("Median scaled beta TWFE: %.2f\n", median(df$z_twfe)))
cat(sprintf("Median scaled beta CS:   %.2f\n", median(df$z_cs)))
cat(sprintf("Mean |diff|: %.2f\n", mean_abs_diff))
cat(sprintf("Median CS/TWFE ratio (same sign): %.2f\n", med_ratio))

# CS-DID controls check
cat("\n=== CS-DID CONTROLS CHECK ===\n")
cat("Only 3/59 articles pass covariates to CS-DID xformla:\n")
cat("  ID 420 (Bailey & Goodman-Bacon): urban bin FE\n")
cat("  ID 76  (Lawler & Yewell): 8 demographics\n")
cat("  ID 79  (Carpenter & Lawler): 2 demographics\n")
cat("All other articles use xformla = ~1 (unconditional)\n")
cat("No article passes geographic FEs to CS-DID\n")
