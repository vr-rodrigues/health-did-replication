suppressPackageStartupMessages({ library(haven); library(dplyr); library(fixest) })

# Port Stata do-file exactly
# Start: data_aej.dta — master
df <- haven::read_dta("data/raw/1094/APP2016-0008_data/data_aej.dta")
cat("data_aej rows:", nrow(df), "\n")

# Merge nopromotion: brings in effective_year
np <- haven::read_dta("data/raw/1094/APP2016-0008_data/nopromotion.dta")
cat("nopromotion rows:", nrow(np), "\n")

# Stata: sort province; merge province using nopromotion; drop if _m==2
# _m==2 means "in using only" → drop provinces not in master
# _m==1 means "in master only"
# Using inner_join (_m==3 = matched) or equivalent: drop provinces from np that aren't in df
df2 <- df %>% left_join(np, by = "province")
cat("After left_join rows:", nrow(df2), "\n")

# Build post = year > effective_year (strict)
df2 <- df2 %>% mutate(post = as.integer(year > effective_year))
cat("Post=1 obs:", sum(df2$post == 1, na.rm = TRUE), "\n")
cat("Post NA (never-treated, no effective_year):", sum(is.na(df2$post)), "\n")

# For never-treated: post = 0 (effective_year NA → year > NA is NA → need to replace with 0)
df2$post[is.na(df2$post)] <- 0
# Equivalently, Stata's `g post=year>effective_year` returns missing if effective_year missing
# Check: if effective_year missing, does Stata set post=0 or post missing?
# Actually g post=year>effective_year when effective_year missing → Stata returns 1 (year > missing is treated as 1? or NA? Stata treats . as the largest number so year > . is FALSE = 0)
# Wait Stata: . > anything = TRUE for `>` (since . is +Inf), so year > . → 0 (since year < .)
# So g post = year > effective_year when effective_year missing → 0
# That matches my code (post=0 for never-treated).

# Build exceedquota = qrate > 1 if qrate != missing
df2 <- df2 %>% mutate(exceedquota = if_else(!is.na(qrate), as.integer(qrate > 1), NA_integer_))
cat("Obs with qrate:", sum(!is.na(df2$qrate)), "\n")
cat("exceedquota=1:", sum(df2$exceedquota == 1, na.rm = TRUE),
    " | exceedquota=0:", sum(df2$exceedquota == 0, na.rm = TRUE), "\n")

# Spec: Q4 only
df_q4 <- df2 %>% filter(quarter == 4 & !is.na(qrate))
cat("Q4 obs with qrate:", nrow(df_q4), "\n")

# Paper Col 1: xi: areg exceedquota post i.year i.industry if quarter==4, absorb(province) cluster(province)
f1 <- feols(exceedquota ~ post | province + year + industry,
            data = df_q4, cluster = ~province)
cat("\n=== Col 1 (province FE + year FE + industry FE) ===\n")
cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
            coef(f1)["post"], se(f1)["post"], nobs(f1)))

# Try with year+industry as factor covariates (Stata's i.year i.industry + absorb(province))
f2 <- feols(exceedquota ~ post + factor(year) + factor(industry) | province,
            data = df_q4, cluster = ~province)
cat("\n=== Col 1 exact Stata (i.year i.industry as covars, absorb province) ===\n")
cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
            coef(f2)["post"], se(f2)["post"], nobs(f2)))
