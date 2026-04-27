###############################################################################
# 09_signif_matrix.R
# Deliverable D4 (Pedro review): 2x2 sign-by-significance matrix figure.
# Uses the official 3-level cascade (Spec A -> Spec B -> Spec C) — same
# composite as Figures 4.1 / 4.2 / 4.3.
#
# Output: output/figures/figure_4_1_signif_matrix.pdf (+ .png)
###############################################################################
suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(jsonlite)
})

base_dir <- getwd()
con <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"),
                stringsAsFactors = FALSE)

# n_twfe_controls from metadata
con$n_twfe_controls <- sapply(con$id, function(id) {
  p <- file.path(base_dir, "data", "metadata", paste0(id, ".json"))
  if (!file.exists(p)) return(0L)
  m <- fromJSON(p)
  if (is.null(m$variables$twfe_controls)) 0L else length(m$variables$twfe_controls)
})

# Composite 2-level cascade (mirrors 01_aggregate_scatter.R)
#   Spec A: matched (both with or both without controls).
#   Spec C: asymmetric fallback when matched DR Spec A is degenerate.
build_composite <- function(con) {
  df <- con %>% filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0)
  df$att_cs <- NA_real_; df$se_cs <- NA_real_
  df$spec <- NA_character_
  pick_cs_unc <- function(i) {
    # Prefer dynamic, fall back to group (static) when dynamic is NA.
    if (!is.na(df$att_nt_dynamic[i]) && !is.na(df$se_nt_dynamic[i]) && df$se_nt_dynamic[i] > 0)
      return(list(att = df$att_nt_dynamic[i], se = df$se_nt_dynamic[i]))
    if (!is.na(df$att_nyt_dynamic[i]) && !is.na(df$se_nyt_dynamic[i]) && df$se_nyt_dynamic[i] > 0)
      return(list(att = df$att_nyt_dynamic[i], se = df$se_nyt_dynamic[i]))
    if (!is.na(df$att_csdid_nt[i]) && !is.na(df$se_csdid_nt[i]) && df$se_csdid_nt[i] > 0)
      return(list(att = df$att_csdid_nt[i], se = df$se_csdid_nt[i]))
    if (!is.na(df$att_csdid_nyt[i]) && !is.na(df$se_csdid_nyt[i]) && df$se_csdid_nyt[i] > 0)
      return(list(att = df$att_csdid_nyt[i], se = df$se_csdid_nyt[i]))
    NULL
  }
  for (i in seq_len(nrow(df))) {
    if (df$n_twfe_controls[i] == 0) {
      cs <- pick_cs_unc(i)
      if (!is.null(cs)) {
        df$att_cs[i] <- cs$att; df$se_cs[i] <- cs$se
        df$spec[i] <- "A_no_ctrls"
      }
    } else {
      specA_ok <- !is.na(df$att_cs_nt_with_ctrls_dyn[i]) &&
                  abs(df$att_cs_nt_with_ctrls_dyn[i]) > 1e-9 &&
                  !is.na(df$se_cs_nt_with_ctrls_dyn[i]) && df$se_cs_nt_with_ctrls_dyn[i] > 0
      if (specA_ok) {
        df$att_cs[i] <- df$att_cs_nt_with_ctrls_dyn[i]
        df$se_cs[i]  <- df$se_cs_nt_with_ctrls_dyn[i]
        df$spec[i] <- "A_w_ctrls"
      } else {
        cs <- pick_cs_unc(i)
        if (!is.null(cs)) {
          df$att_cs[i] <- cs$att; df$se_cs[i] <- cs$se
          df$spec[i] <- "C"
        }
      }
    }
  }
  df %>% filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0)
}

df <- build_composite(con)
crit <- 1.96
df <- df %>%
  mutate(sig_twfe  = abs(beta_twfe / se_twfe) > crit,
         sig_cs    = abs(att_cs   / se_cs)   > crit,
         same_sign = sign(beta_twfe) == sign(att_cs),
         same_sig  = sig_twfe == sig_cs)

n_tot <- nrow(df)
cell_sp_sigOK <- sum( df$same_sign &  df$same_sig)
cell_sp_sigNO <- sum( df$same_sign & !df$same_sig)
cell_sr_sigOK <- sum(!df$same_sign &  df$same_sig)
cell_sr_sigNO <- sum(!df$same_sign & !df$same_sig)
stopifnot(cell_sp_sigOK + cell_sp_sigNO + cell_sr_sigOK + cell_sr_sigNO == n_tot)

cat(sprintf("N = %d comparable articles (composite)\n", n_tot))
cat(sprintf("  breakdown: A (w/ ctrls)=%d  A (no ctrls, trivial)=%d  C (asymmetric fallback)=%d\n\n",
            sum(df$spec == "A_w_ctrls"),
            sum(df$spec == "A_no_ctrls"),
            sum(df$spec == "C")))
cat(sprintf("%-38s | %4d | %s\n", "Sign preserved + sig stable",
            cell_sp_sigOK, sprintf("%.1f%%", 100*cell_sp_sigOK/n_tot)))
cat(sprintf("%-38s | %4d | %s\n", "Sign preserved + sig changed",
            cell_sp_sigNO, sprintf("%.1f%%", 100*cell_sp_sigNO/n_tot)))
cat(sprintf("%-38s | %4d | %s\n", "Sign reversed + sig stable",
            cell_sr_sigOK, sprintf("%.1f%%", 100*cell_sr_sigOK/n_tot)))
cat(sprintf("%-38s | %4d | %s\n", "Sign reversed + sig changed",
            cell_sr_sigNO, sprintf("%.1f%%", 100*cell_sr_sigNO/n_tot)))

row_sign_pres <- cell_sp_sigOK + cell_sp_sigNO
row_sign_rev  <- cell_sr_sigOK + cell_sr_sigNO
col_sig_stab  <- cell_sp_sigOK + cell_sr_sigOK
col_sig_chng  <- cell_sp_sigNO + cell_sr_sigNO

# Use blank labels (single-space variants kept distinct so factor levels
# remain unique) for the totals row/column instead of explicit "Row total" /
# "Col. total" text.
TOTAL_X <- " "
TOTAL_Y <- " "

# Main 2x2 cells
mat_df <- data.frame(
  sign_label = rep(c("Sign preserved", "Sign reversed"), each = 2),
  sig_label  = rep(c("Significance status\nstable (both sig. or\nboth insig.)",
                     "Significance status\nchanged (sig. lost\nor gained)"), 2),
  count      = c(cell_sp_sigOK, cell_sp_sigNO, cell_sr_sigOK, cell_sr_sigNO),
  is_total   = FALSE
)
# Row totals (rightmost column)
mat_df <- rbind(mat_df, data.frame(
  sign_label = c("Sign preserved", "Sign reversed"),
  sig_label  = rep(TOTAL_X, 2),
  count      = c(row_sign_pres, row_sign_rev),
  is_total   = TRUE
))
# Column totals (bottom row)
mat_df <- rbind(mat_df, data.frame(
  sign_label = rep(TOTAL_Y, 2),
  sig_label  = c("Significance status\nstable (both sig. or\nboth insig.)",
                 "Significance status\nchanged (sig. lost\nor gained)"),
  count      = c(col_sig_stab, col_sig_chng),
  is_total   = TRUE
))
# Grand total (bottom-right corner)
mat_df <- rbind(mat_df, data.frame(
  sign_label = TOTAL_Y,
  sig_label  = TOTAL_X,
  count      = n_tot,
  is_total   = TRUE
))

mat_df$share <- mat_df$count / n_tot
# Percentages shown on every cell (totals included).
mat_df$label <- sprintf("%d\n(%.1f%%)", mat_df$count, 100 * mat_df$share)

mat_df$sign_label <- factor(mat_df$sign_label,
                             levels = c("Sign preserved", "Sign reversed", TOTAL_Y))
mat_df$sig_label  <- factor(mat_df$sig_label,
                             levels = c("Significance status\nstable (both sig. or\nboth insig.)",
                                        "Significance status\nchanged (sig. lost\nor gained)",
                                        TOTAL_X))

p <- ggplot(mat_df, aes(x = sig_label, y = sign_label)) +
  geom_tile(aes(fill = ifelse(is_total, NA, share)),
            color = "white", linewidth = 1.4) +
  geom_text(aes(label = label),
            size = 6, fontface = "bold", color = "black") +
  scale_fill_gradient(low = "#f1f3f5", high = "#2b8cbe", guide = "none",
                      na.value = "grey85") +
  scale_y_discrete(limits = rev) +
  labs(x = NULL, y = NULL, title = NULL) +
  theme_minimal(base_size = 13) +
  theme(panel.grid = element_blank(),
        axis.text  = element_text(face = "bold", color = "black"),
        axis.text.x = element_text(size = 11, lineheight = 1.0),
        axis.text.y = element_text(size = 12))

out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
ggsave(file.path(out_dir, "figure_4_1_signif_matrix.pdf"), p, width = 8, height = 5)
ggsave(file.path(out_dir, "figure_4_1_signif_matrix.png"), p, width = 8, height = 5, dpi = 200)
cat(sprintf("\nSaved: figure_4_1_signif_matrix.pdf  (+ .png)\n"))
