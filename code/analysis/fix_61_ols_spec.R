###############################################################################
# fix_61_ols_spec.R
# Re-estimate paper 61 (Evans-Garthwaite 2014) using the paper's ACTUAL
# OLS specification (no unit/time FEs) rather than the template's forced
# fips+year FEs.
#
# Paper's Stata: reg excel_vgood dd_treatment twoplus_kids eitc_expand
#                if educ<=2, cluster(fips)
# Paper target: beta_twfe = 0.0095
#
# Writes corrected values back to results/by_article/61/results.csv
# while preserving all other columns (CS-DID etc.).
###############################################################################
suppressPackageStartupMessages({
  library(haven)
  library(fixest)
})

base_dir <- getwd()
data_file <- file.path(base_dir, "data/raw/61/AEJ_Data_Programs/brfss/BRFSS_Final_Data.dta")
res_file  <- file.path(base_dir, "results/by_article/61/results.csv")

# Load data and apply sample filter
df <- read_dta(data_file)
cat(sprintf("Loaded %d rows, %d columns\n", nrow(df), ncol(df)))

# Sample filter per metadata: kids > 0 & educ <= 2
df_s <- df[df$kids > 0 & df$educ <= 2 & !is.na(df$kids) & !is.na(df$educ), ]
cat(sprintf("After sample filter (kids>0 & educ<=2): %d rows\n", nrow(df_s)))

# Paper's OLS specification (no FEs)
m_paper <- feols(excel_vgood ~ dd_treatment + twoplus_kids + eitc_expand,
                 data = df_s, cluster = ~fips)
cat("\n=== Paper's OLS spec (no FEs) — WITH controls ===\n")
print(summary(m_paper))

beta_twfe_new <- coef(m_paper)["dd_treatment"]
se_twfe_new   <- sqrt(vcov(m_paper)["dd_treatment", "dd_treatment"])
cat(sprintf("\n  β = %.6f   SE = %.6f\n", beta_twfe_new, se_twfe_new))

# No-controls version (same FE structure: none)
m_noctrl <- feols(excel_vgood ~ dd_treatment, data = df_s, cluster = ~fips)
cat("\n=== Paper's OLS spec (no FEs) — NO controls ===\n")
print(summary(m_noctrl))

beta_noctrl_new <- coef(m_noctrl)["dd_treatment"]
se_noctrl_new   <- sqrt(vcov(m_noctrl)["dd_treatment", "dd_treatment"])
cat(sprintf("\n  β_no_ctrls = %.6f   SE = %.6f\n", beta_noctrl_new, se_noctrl_new))

# Load existing results.csv and surgically update only the TWFE columns
res <- read.csv(res_file, stringsAsFactors = FALSE, check.names = FALSE)
cat("\n=== Before update ===\n")
print(res[, c("beta_twfe", "se_twfe", "beta_twfe_no_ctrls", "se_twfe_no_ctrls")])

res$beta_twfe          <- as.numeric(beta_twfe_new)
res$se_twfe            <- as.numeric(se_twfe_new)
res$beta_twfe_no_ctrls <- as.numeric(beta_noctrl_new)
res$se_twfe_no_ctrls   <- as.numeric(se_noctrl_new)

# Also fix the misleading cs_nt_with_ctrls_status: it was OK but value=0/NA,
# which is Pattern 42 collapse. Mark correctly.
if (!is.na(res$att_cs_nt_with_ctrls) && res$att_cs_nt_with_ctrls == 0 &&
    is.na(res$se_cs_nt_with_ctrls)) {
  res$cs_nt_with_ctrls_status <- "FAIL_collinear"
  cat("Updated cs_nt_with_ctrls_status OK -> FAIL_collinear (Pattern 42)\n")
}

write.csv(res, res_file, row.names = FALSE)
cat("\n=== After update ===\n")
print(res[, c("beta_twfe", "se_twfe", "beta_twfe_no_ctrls", "se_twfe_no_ctrls",
              "cs_nt_with_ctrls_status")])
cat(sprintf("\nSaved: %s\n", res_file))
cat(sprintf("Paper target β = 0.0095; our β = %.6f (gap = %.2f%%)\n",
            beta_twfe_new, 100 * (beta_twfe_new - 0.0095) / 0.0095))
