###############################################################################
# 09_signif_matrix.R
# Deliverable D4 (Pedro review): 2×2 sign-by-significance matrix figure
# Rows    = sign preserved (TWFE & CS same sign) or reversed
# Columns = significance status preserved (both sig or both insig) or changed
# Cells   = count and share of 53 comparable articles
#
# Output: output/figures/figure_4_1_signif_matrix.pdf (+ .png)
###############################################################################
suppressPackageStartupMessages({ library(dplyr); library(ggplot2) })

base_dir <- getwd()
consol   <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"),
                     stringsAsFactors = FALSE)

# NOTE: part of Deliverable D4 (Pedro review). Complements Figure 4.1 /
# 4.1b (scatter plots) with a compact 2x2 summary of the same sample.

# CS dynamic aggregate: NT preferred, NYT fallback, group as last resort
consol$att_cs <- with(consol,
  ifelse(!is.na(att_nt_dynamic),  att_nt_dynamic,
  ifelse(!is.na(att_nyt_dynamic), att_nyt_dynamic,
         coalesce(att_csdid_nt, att_csdid_nyt))))
consol$se_cs <- with(consol,
  ifelse(!is.na(se_nt_dynamic),   se_nt_dynamic,
  ifelse(!is.na(se_nyt_dynamic),  se_nyt_dynamic,
         coalesce(se_csdid_nt, se_csdid_nyt))))

# Classification
crit <- 1.96
df <- consol %>%
  filter(!is.na(beta_twfe), !is.na(att_cs), !is.na(se_twfe), !is.na(se_cs)) %>%
  mutate(sig_twfe  = abs(beta_twfe / se_twfe) > crit,
         sig_cs    = abs(att_cs   / se_cs)   > crit,
         same_sign = sign(beta_twfe) == sign(att_cs),
         same_sig  = sig_twfe == sig_cs)

# 2x2 counts
n_tot <- nrow(df)
cell_sp_sigOK  <- sum( df$same_sign &  df$same_sig)  # sign preserved, sig status stable
cell_sp_sigNO  <- sum( df$same_sign & !df$same_sig)  # sign preserved, sig status changed
cell_sr_sigOK  <- sum(!df$same_sign &  df$same_sig)  # sign reversed, sig status stable
cell_sr_sigNO  <- sum(!df$same_sign & !df$same_sig)  # sign reversed, sig status changed

stopifnot(cell_sp_sigOK + cell_sp_sigNO + cell_sr_sigOK + cell_sr_sigNO == n_tot)

cat(sprintf("N = %d comparable articles\n\n", n_tot))
cat(sprintf("%-38s | %4d | %s\n",
            "Sign preserved + significance stable", cell_sp_sigOK,
            sprintf("%.1f%%", 100*cell_sp_sigOK/n_tot)))
cat(sprintf("%-38s | %4d | %s\n",
            "Sign preserved + significance changed", cell_sp_sigNO,
            sprintf("%.1f%%", 100*cell_sp_sigNO/n_tot)))
cat(sprintf("%-38s | %4d | %s\n",
            "Sign reversed + significance stable", cell_sr_sigOK,
            sprintf("%.1f%%", 100*cell_sr_sigOK/n_tot)))
cat(sprintf("%-38s | %4d | %s\n",
            "Sign reversed + significance changed", cell_sr_sigNO,
            sprintf("%.1f%%", 100*cell_sr_sigNO/n_tot)))

# ── Build tile plot ──────────────────────────────────────────────────────
mat_df <- data.frame(
  sign_label = rep(c("Sign preserved", "Sign reversed"), each = 2),
  sig_label  = rep(c("Significance status\nstable (both sig. or\nboth insig.)",
                     "Significance status\nchanged (sig. lost\nor gained)"), 2),
  count      = c(cell_sp_sigOK, cell_sp_sigNO, cell_sr_sigOK, cell_sr_sigNO)
)
mat_df$share <- mat_df$count / n_tot
mat_df$label <- sprintf("%d\n(%.1f%%)", mat_df$count, 100 * mat_df$share)
mat_df$sign_label <- factor(mat_df$sign_label,
                             levels = c("Sign preserved", "Sign reversed"))
mat_df$sig_label  <- factor(mat_df$sig_label,
                             levels = c("Significance status\nstable (both sig. or\nboth insig.)",
                                        "Significance status\nchanged (sig. lost\nor gained)"))

p <- ggplot(mat_df, aes(x = sig_label, y = sign_label, fill = share)) +
  geom_tile(color = "white", linewidth = 1.4) +
  geom_text(aes(label = label), size = 6.5, fontface = "bold", color = "black") +
  scale_fill_gradient(low = "#f1f3f5", high = "#2b8cbe", guide = "none") +
  scale_y_discrete(limits = rev) +
  labs(x = NULL, y = NULL,
       title = NULL,
       caption = sprintf(
         "N = %d articles. \"Sign preserved\" means sign(beta_TWFE) = sign(ATT_CS); otherwise reversed. \"Significance status stable\" means the TWFE and CS-DID z-ratios fall on the same side of 1.96 in absolute value.",
         n_tot)) +
  theme_minimal(base_size = 13) +
  theme(panel.grid = element_blank(),
        axis.text  = element_text(face = "bold", color = "black"),
        axis.text.x = element_text(size = 11, lineheight = 1.0),
        axis.text.y = element_text(size = 12),
        plot.caption = element_text(size = 9, hjust = 0, color = "grey30",
                                     margin = margin(t = 10)))

out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

outfile_pdf <- file.path(out_dir, "figure_4_1_signif_matrix.pdf")
outfile_png <- file.path(out_dir, "figure_4_1_signif_matrix.png")
ggsave(outfile_pdf, plot = p, width = 8, height = 5)
ggsave(outfile_png, plot = p, width = 8, height = 5, dpi = 200)
cat(sprintf("\nSaved: %s\n", outfile_pdf))
cat(sprintf("Saved: %s\n", outfile_png))
