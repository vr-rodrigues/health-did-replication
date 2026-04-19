d <- read.csv("results/by_article/309/results.csv", stringsAsFactors=FALSE)
cat("=== Paper 309 — Johnson et al (2019) ===\n\n")
cat("Row count:", nrow(d), "| Columns:", length(d), "\n\n")

cat("TWFE (paper Table 2 Col 5 preferred):\n")
cat(sprintf("  with    controls:  beta = %10.5f   SE = %.5f\n", d$beta_twfe[1], d$se_twfe[1]))
cat(sprintf("  without controls:  beta = %10.5f   SE = %.5f\n\n", d$beta_twfe_no_ctrls[1], d$se_twfe_no_ctrls[1]))

cat("CS-NT dynamic:\n")
cat(sprintf("  without controls:  att  = %10.5f   SE = %.5f\n", d$att_nt_dynamic[1], d$se_nt_dynamic[1]))
cat(sprintf("  with    controls:  att  = %10.5f   SE = %.5f  status = %s\n\n",
            d$att_cs_nt_with_ctrls_dyn[1], d$se_cs_nt_with_ctrls_dyn[1],
            d$cs_nt_with_ctrls_status[1]))

cat("CS-NT simple (group-avg):\n")
cat(sprintf("  without controls:  att  = %10.5f   SE = %.5f\n", d$att_nt_simple[1], d$se_nt_simple[1]))
cat(sprintf("  with    controls:  att  = %10.5f   SE = %.5f\n\n",
            d$att_cs_nt_with_ctrls[1], d$se_cs_nt_with_ctrls[1]))

cat("CS-NYT (robustness):\n")
cat(sprintf("  without controls:  att = %10.5f  SE = %.5f\n", d$att_nyt_dynamic[1], d$se_nyt_dynamic[1]))
cat(sprintf("  with    controls:  att = %10.5f  SE = %.5f  status = %s\n\n",
            d$att_cs_nyt_with_ctrls_dyn[1], d$se_cs_nyt_with_ctrls_dyn[1],
            d$cs_nyt_with_ctrls_status[1]))

cat("=== Metadata note ===\n")
m <- jsonlite::fromJSON("data/metadata/309.json")
cat(sprintf("  N TWFE controls: %d\n", length(m$variables$twfe_controls)))
cat(sprintf("  N CS controls  : %d\n", length(m$variables$cs_controls)))
cat(sprintf("  Allow unbalanced: %s\n", m$panel_setup$allow_unbalanced))
