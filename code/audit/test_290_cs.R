suppressPackageStartupMessages({
  library(haven); library(dplyr); library(did); library(jsonlite)
})

base_dir <- getwd()
meta <- fromJSON(file.path(base_dir, "data/metadata/290.json"))
df_full <- haven::read_dta(file.path(base_dir, meta$data$file))
cat("Raw rows:", nrow(df_full), "cols:", ncol(df_full), "\n")

# Apply sample filter
df <- df_full %>% filter(year >= 2014 & year <= 2020)
cat("After year filter:", nrow(df), "\n")
cat("Columns used:\n")
cat("  st (unit):"); print(table(is.na(df$st)))
cat("  newdate (time): range ", range(df$newdate, na.rm=TRUE), " | unique ", length(unique(df$newdate)), "\n")
cat("  newpolicydate (gvar):"); print(table(df$newpolicydate, useNA="ifany"))
cat("  Adminburden (treat):"); print(table(df$Adminburden, useNA="ifany"))
cat("  mchiprate NA:"); print(sum(is.na(df$mchiprate)))

# Coerce numeric
df$st           <- as.numeric(df$st)
df$newdate      <- as.numeric(df$newdate)
df$newpolicydate<- as.numeric(df$newpolicydate)

# Check panel balance
cat("\nObs per (st, newdate) cell:\n")
cells <- df %>% count(st, newdate)
print(summary(cells$n))

cat("\n=== Attempt: CS-DID no controls ===\n")
res <- tryCatch({
  att_gt(yname = "mchiprate", tname = "newdate", idname = "st",
         gname = "newpolicydate",
         data = as.data.frame(df),
         control_group = "nevertreated",
         panel = TRUE,
         allow_unbalanced_panel = FALSE,
         base_period = "universal")
}, error = function(e) list(error = conditionMessage(e)))

if (!is.null(res$error)) {
  cat("ERROR:", res$error, "\n")
} else {
  cat("SUCCESS — ATT count:", length(res$att), "\n")
  cat("Simple agg:\n")
  a <- tryCatch(aggte(res, type="simple", na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  if (!is.null(a$err)) cat("aggte error:", a$err, "\n") else cat("  overall.att:", a$overall.att, "\n")
}
