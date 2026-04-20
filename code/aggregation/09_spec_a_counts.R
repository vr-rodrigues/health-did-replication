base_dir <- getwd()
res <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"),
                stringsAsFactors=FALSE)

cat("Total rows:", nrow(res), "\n\n")

cat("=== Spec A status ===\n")
print(table(res$cs_nt_with_ctrls_status, useNA="ifany"))

# Papers with TWFE controls (beta_twfe != beta_twfe_no_ctrls or SE differs)
diff_twfe <- (!is.na(res$beta_twfe) & !is.na(res$beta_twfe_no_ctrls) &
              (abs(res$beta_twfe - res$beta_twfe_no_ctrls) > 1e-10 |
               abs(res$se_twfe - res$se_twfe_no_ctrls) > 1e-10))
cat("\nPapers with TWFE controls (beta_ctrls != beta_no_ctrls):",
    sum(diff_twfe, na.rm=TRUE), "\n")

# Papers where Spec A produced a valid estimate
spec_a_ok <- !is.na(res$att_cs_nt_with_ctrls) & res$att_cs_nt_with_ctrls != 0 &
             !is.na(res$se_cs_nt_with_ctrls)
cat("Papers where Spec A att != 0 and SE not NA:", sum(spec_a_ok), "\n")

# Spec A status
spec_a_status_ok <- res$cs_nt_with_ctrls_status == "OK" &
                    !is.na(res$att_cs_nt_with_ctrls) & res$att_cs_nt_with_ctrls != 0 &
                    !is.na(res$se_cs_nt_with_ctrls)
cat("Spec A status=OK AND att!=0 AND SE not NA:",
    sum(spec_a_status_ok, na.rm=TRUE), "\n")
