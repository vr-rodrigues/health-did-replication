suppressPackageStartupMessages({ library(dplyr); library(fixest) })

# Use the prepared analysis data (has exceedquota, post, gvar_CS, etc.)
df <- read.csv("data/raw/1094/analysis_data.csv", stringsAsFactors = FALSE)
cat("Rows:", nrow(df), "| Q4 obs:", sum(df$quarter == 4, na.rm = TRUE), "\n")
cat("Provinces:", length(unique(df$province)), "Industries:", length(unique(df$industry)),
    "provinceind:", length(unique(df$provinceind)), "\n")

# The data is already filtered to quarter==4 if provinces have it that way
# Paper Col 1: xi: areg exceedquota post i.year i.industry if quarter==4, absorb(province) cluster(province)

# Spec 1 (paper Col 1): province FE only, year+industry as dummies
f1 <- feols(exceedquota ~ post | province + year + industry,
            data = df, cluster = ~province)
cat("\n=== Paper Col 1 spec (province FE + year FE + industry FE) ===\n")
cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
            coef(f1)["post"], se(f1)["post"], nobs(f1)))

# Spec 2 (our current): provinceind FE + year + industry (redundant)
f2 <- feols(exceedquota ~ post | provinceind + year + industry,
            data = df, cluster = ~province)
cat("\n=== Our current spec (provinceind + year + industry) ===\n")
cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
            coef(f2)["post"], se(f2)["post"], nobs(f2)))

# Spec 3 (provinceind only, no additional industry)
f3 <- feols(exceedquota ~ post | provinceind + year,
            data = df, cluster = ~province)
cat("\n=== provinceind + year only ===\n")
cat(sprintf("  beta = %.5f, SE = %.5f, N = %d\n",
            coef(f3)["post"], se(f3)["post"], nobs(f3)))
