suppressPackageStartupMessages({ library(haven); library(dplyr); library(fixest) })

# Try to replicate paper Table 2 Col 1 exactly
# Stata: xi: areg exceedquota post i.year i.industry if quarter==4, absorb(province) cluster(province)

# Start from the original Stata data
df <- haven::read_dta("data/raw/1094/APP2016-0008_data/data_aej.dta")
cat("Raw rows:", nrow(df), "cols:", ncol(df), "\n")
cat("Has quarter:", "quarter" %in% names(df), "\n")
cat("Has exceedquota pre-construct:", "exceedquota" %in% names(df), "\n")
cat("Has qrate:", "qrate" %in% names(df), "\n")

# Build exceedquota as the paper does (line 626)
# gen exceedquota = qrate>1 if qrate~=. & quarter==4
df_q4 <- df %>% filter(quarter == 4 & !is.na(qrate))
df_q4$exceedquota <- as.integer(df_q4$qrate > 1)
cat("Q4 obs with qrate:", nrow(df_q4), "\n")
cat("Provinces:", length(unique(df_q4$province)), "Industries:", length(unique(df_q4$industry)), "\n")

# Col 1 spec
f1 <- tryCatch(
  feols(exceedquota ~ post | province + year + industry,
        data = df_q4, cluster = ~province),
  error = function(e) list(err = conditionMessage(e))
)
if (!is.null(f1$err)) cat("ERR Col 1 alt:", f1$err, "\n") else {
  cat("Col 1 alternative (province + year + industry as FEs):\n")
  cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
              coef(f1)["post"], se(f1)["post"], nobs(f1)))
}

# Try with province + i.year + i.industry as factors (Stata-style)
f1b <- tryCatch(
  feols(exceedquota ~ post + factor(year) + factor(industry) | province,
        data = df_q4, cluster = ~province),
  error = function(e) list(err = conditionMessage(e))
)
if (!is.null(f1b$err)) cat("ERR Col 1 exact:", f1b$err, "\n") else {
  cat("Col 1 exact Stata (absorb province, factors year industry):\n")
  cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
              coef(f1b)["post"], se(f1b)["post"], nobs(f1b)))
}
