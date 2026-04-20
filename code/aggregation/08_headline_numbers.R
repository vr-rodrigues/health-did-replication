###############################################################################
# 08_headline_numbers.R — compute headline numbers from consolidated_results.csv
###############################################################################

base_dir <- getwd()
res <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"), stringsAsFactors=FALSE)
cat("=== Headline numbers (N =", nrow(res), "papers) ===\n\n")

# Pick the estimator available per paper: CS-NT preferred, else CS-NYT
res$att_cs <- ifelse(!is.na(res$att_csdid_nt), res$att_csdid_nt, res$att_csdid_nyt)
res$se_cs  <- ifelse(!is.na(res$se_csdid_nt),  res$se_csdid_nt,  res$se_csdid_nyt)

both_valid <- !is.na(res$beta_twfe) & !is.na(res$att_cs) & res$beta_twfe != 0
cat("Papers with both TWFE and CS valid:", sum(both_valid), "\n\n")

# ── Sign preservation (exclude zero-sign cases)
s_twfe <- sign(res$beta_twfe[both_valid])
s_cs   <- sign(res$att_cs[both_valid])
n_pres <- sum(s_twfe == s_cs)
n_rev  <- sum(s_twfe != s_cs & s_twfe != 0 & s_cs != 0)
cat("--- Sign concordance ---\n")
cat("  Sign preserved:", n_pres, "/", sum(both_valid), "\n")
cat("  Sign reversed: ", n_rev, "\n\n")

# ── SE rise
se_rise_ratio <- (res$se_cs / res$se_twfe)[both_valid]
se_rise_pct   <- (se_rise_ratio - 1) * 100
cat("--- SE change ---\n")
cat("  Median SE rise (CS vs TWFE):", round(median(se_rise_pct, na.rm=TRUE), 1), "%\n")
cat("  Mean   SE rise:",              round(mean(se_rise_pct,   na.rm=TRUE), 1), "%\n\n")

# ── Magnitude shift
delta_pct <- ((res$att_cs - res$beta_twfe) / abs(res$beta_twfe))[both_valid]
cat("--- Magnitude shift |Δ%| ---\n")
cat("  > 20%:  ", sum(abs(delta_pct) > 0.20, na.rm=TRUE), "/", length(delta_pct),
    sprintf(" (%.0f%%)", 100*mean(abs(delta_pct)>0.20, na.rm=TRUE)), "\n")
cat("  > 50%:  ", sum(abs(delta_pct) > 0.50, na.rm=TRUE), "/", length(delta_pct),
    sprintf(" (%.0f%%)", 100*mean(abs(delta_pct)>0.50, na.rm=TRUE)), "\n")
cat("  > 100%: ", sum(abs(delta_pct) > 1.00, na.rm=TRUE), "/", length(delta_pct),
    sprintf(" (%.0f%%)", 100*mean(abs(delta_pct)>1.00, na.rm=TRUE)), "\n")
cat("  range:  [", round(min(delta_pct, na.rm=TRUE)*100, 1), "%, ",
    round(max(delta_pct, na.rm=TRUE)*100, 1), "%]\n\n", sep="")

# Named extremes
idx_min <- which.min(delta_pct)
idx_max <- which.max(delta_pct)
papers_valid <- res[both_valid, ]
cat("  min Δ%: ", papers_valid$author_label[idx_min],
    sprintf(" (%.1f%%)\n", 100*delta_pct[idx_min]))
cat("  max Δ%: ", papers_valid$author_label[idx_max],
    sprintf(" (%.1f%%)\n", 100*delta_pct[idx_max]))

# ── Significance lost
p_twfe <- 2 * pnorm(-abs(res$beta_twfe / res$se_twfe))
p_cs   <- 2 * pnorm(-abs(res$att_cs   / res$se_cs))
orig_sig  <- p_twfe < 0.05 & !is.na(p_twfe)
lost <- orig_sig & (p_cs >= 0.05 | is.na(p_cs))
cat("\n--- Significance ---\n")
cat("  Originally sig (p<0.05 TWFE):", sum(orig_sig, na.rm=TRUE), "\n")
cat("  Sig lost in CS:              ", sum(lost, na.rm=TRUE), "\n")
