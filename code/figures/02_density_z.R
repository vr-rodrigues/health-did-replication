###############################################################################
# 02_density_z.R — Density plots of z-scores: TWFE vs CS-DID
# Produces: Figure 4.2 (dynamic composite) + group / simple variants.
#
# The "dynamic" variant uses the official 3-level cascade (Spec A -> Spec B
# -> Spec C), mirroring the logic in 01_aggregate_scatter.R so that the
# scatter, dot-chart, matrix, and this density plot all summarise the same
# 53-paper composite.
#
# Output files:
#   output/figures/figure_4_2_density_z_dynamic.pdf   (official composite)
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

con <- read.csv(file.path(analysis_dir, "consolidated_results.csv"),
                stringsAsFactors = FALSE)

# ── Add n_twfe_controls from metadata ───────────────────────────────────────
con$n_twfe_controls <- sapply(con$id, function(id) {
  p <- file.path(base_dir, "data", "metadata", paste0(id, ".json"))
  if (!file.exists(p)) return(0L)
  m <- fromJSON(p)
  if (is.null(m$variables$twfe_controls)) 0L else length(m$variables$twfe_controls)
})

# ── Composite builder (simplified 2-level: Spec A -> Spec C) ────────────────
build_composite <- function(con) {
  df <- con %>% filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0)
  df$att_cs <- NA_real_; df$se_cs <- NA_real_
  df$spec <- NA_character_; df$is_fallback <- FALSE

  pick_cs_unc <- function(i) {
    # Prefer dynamic, fall back to group (static) when dynamic is NA.
    if (!is.na(df$att_nt_dynamic[i]) && !is.na(df$se_nt_dynamic[i]) &&
        df$se_nt_dynamic[i] > 0)
      return(list(att = df$att_nt_dynamic[i], se = df$se_nt_dynamic[i]))
    if (!is.na(df$att_nyt_dynamic[i]) && !is.na(df$se_nyt_dynamic[i]) &&
        df$se_nyt_dynamic[i] > 0)
      return(list(att = df$att_nyt_dynamic[i], se = df$se_nyt_dynamic[i]))
    if (!is.na(df$att_csdid_nt[i]) && !is.na(df$se_csdid_nt[i]) &&
        df$se_csdid_nt[i] > 0)
      return(list(att = df$att_csdid_nt[i], se = df$se_csdid_nt[i]))
    if (!is.na(df$att_csdid_nyt[i]) && !is.na(df$se_csdid_nyt[i]) &&
        df$se_csdid_nyt[i] > 0)
      return(list(att = df$att_csdid_nyt[i], se = df$se_csdid_nyt[i]))
    NULL
  }

  for (i in seq_len(nrow(df))) {
    if (df$n_twfe_controls[i] == 0) {
      # No TWFE controls -> Spec A trivially matched (both unconditional)
      cs <- pick_cs_unc(i)
      if (!is.null(cs)) {
        df$att_cs[i] <- cs$att; df$se_cs[i] <- cs$se
        df$spec[i] <- "A_no_ctrls"
      }
    } else {
      # Has TWFE controls -> try matched Spec A (CS w/ same controls)
      specA_ok <- !is.na(df$att_cs_nt_with_ctrls_dyn[i]) &&
                  abs(df$att_cs_nt_with_ctrls_dyn[i]) > 1e-9 &&
                  !is.na(df$se_cs_nt_with_ctrls_dyn[i]) &&
                  df$se_cs_nt_with_ctrls_dyn[i] > 0
      if (specA_ok) {
        df$att_cs[i] <- df$att_cs_nt_with_ctrls_dyn[i]
        df$se_cs[i]  <- df$se_cs_nt_with_ctrls_dyn[i]
        df$spec[i] <- "A_w_ctrls"
      } else {
        # Spec A degenerate -> Spec C fallback (asymmetric)
        cs <- pick_cs_unc(i)
        if (!is.null(cs)) {
          df$att_cs[i] <- cs$att; df$se_cs[i] <- cs$se
          df$spec[i] <- "C"
          df$is_fallback[i] <- TRUE
        }
      }
    }
  }
  df <- df %>% filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0)
  df$z_twfe <- df$beta_twfe / df$se_twfe
  df$z_cs   <- df$att_cs    / df$se_cs
  df
}

# ── Legacy builder (static group/simple variants) ───────────────────────────
make_density_legacy <- function(con, agg_type, out_file) {
  if (agg_type == "group") {
    nt_att <- "att_csdid_nt"; nt_se <- "se_csdid_nt"
    nyt_att <- "att_csdid_nyt"; nyt_se <- "se_csdid_nyt"
  } else {
    nt_att <- "att_nt_simple"; nt_se <- "se_nt_simple"
    nyt_att <- "att_nyt_simple"; nyt_se <- "se_nyt_simple"
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
    geom_vline(xintercept = c(-1.96, 1.96), linetype = "dashed",
               color = "grey50", linewidth = 0.3) +
    scale_fill_manual(values  = c("TWFE" = "black", "CS-DID" = "steelblue")) +
    scale_color_manual(values = c("TWFE" = "black", "CS-DID" = "steelblue")) +
    labs(x = "Z-score (own SE)", y = "Density",
         title = sprintf("Distribution of z-scores: TWFE vs CS-DID (%s) - %d articles",
                         agg_type, nrow(df))) +
    theme_classic(base_size = 13) +
    theme(legend.position = "bottom", legend.title = element_blank())
  ggsave(file.path(out_dir, out_file), p, width = 8, height = 5)
  cat(sprintf("  Saved: %s (%d articles)\n", out_file, nrow(df)))
}

# ── Composite density (official, mirrors 01_aggregate_scatter.R) ───────────
df_comp <- build_composite(con)
n_A_w  <- sum(df_comp$spec == "A_w_ctrls")
n_A_nc <- sum(df_comp$spec == "A_no_ctrls")
n_C    <- sum(df_comp$spec == "C")
cat(sprintf("Composite breakdown: A (w/ ctrls)=%d, A (no ctrls, trivial)=%d, C (asymmetric fallback)=%d  (total=%d)\n",
            n_A_w, n_A_nc, n_C, nrow(df_comp)))

long_c <- bind_rows(
  data.frame(z = df_comp$z_twfe, estimator = "TWFE"),
  data.frame(z = df_comp$z_cs,   estimator = "CS-DID")
)

caption_txt <- sprintf(paste0(
  "Spec A matched: %d papers with controls (DR CS-DID converged) + %d papers with no ",
  "TWFE controls (trivially matched). Spec C asymmetric fallback (TWFE w/ ctrls vs ",
  "CS-DID unconditional): %d papers where DR Spec A degenerated."),
  n_A_w, n_A_nc, n_C)

p <- ggplot(long_c, aes(x = z, fill = estimator, color = estimator)) +
  geom_density(alpha = 0.35, linewidth = 0.6) +
  geom_vline(xintercept = c(-1.96, 1.96), linetype = "dashed",
             color = "grey50", linewidth = 0.3) +
  scale_fill_manual(values  = c("TWFE" = "black", "CS-DID" = "steelblue")) +
  scale_color_manual(values = c("TWFE" = "black", "CS-DID" = "steelblue")) +
  labs(x = "Z-score (own SE)", y = "Density",
       title = sprintf("Distribution of z-scores: TWFE vs CS-DID (composite) - %d articles",
                       nrow(df_comp)),
       caption = caption_txt) +
  theme_classic(base_size = 13) +
  theme(legend.position = "bottom", legend.title = element_blank(),
        plot.caption = element_text(size = 9, hjust = 0, face = "italic",
                                    margin = margin(t = 6)))
ggsave(file.path(out_dir, "figure_4_2_density_z_dynamic.pdf"), p,
       width = 8, height = 5)
cat(sprintf("  Saved: figure_4_2_density_z_dynamic.pdf (%d articles, composite)\n",
            nrow(df_comp)))

# ── Legacy variants (group and simple) — unchanged for backwards reference ──
make_density_legacy(con, "group",  "density_z_group.pdf")
make_density_legacy(con, "simple", "density_z_simple.pdf")

cat("\nDone: 02_density_z.R\n")
