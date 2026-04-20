base_dir <- getwd()
df <- read.csv(file.path(base_dir, "analysis/skeptic_ratings.csv"), stringsAsFactors=FALSE, check.names=FALSE)
i <- which(df$id == 311)
cat("Before:\n")
print(df[i, c("id","rating","fidelity","implementation","impl_axis","n_impl_warn")])

# After running Bacon (TvT=3.8% clean), the only remaining Axis-2 WARN is the
# one-way vs two-way clustering mismatch. 1 WARN -> I-MOD -> F-HIGH x I-MOD = MODERATE.
df$implementation[i]          <- "I-MOD"
df$impl_axis[i]               <- "MOD"
df$rating[i]                  <- "MODERATE"
df$bacon[i]                   <- "PASS"
df$n_impl_warn[i]             <- 1
df$date[i]                    <- "2026-04-20"
df$design_signal_bacon_tvt[i] <- "TvT=3.8% (D-ROBUST signal)"
df$design_credibility[i]      <- "D-MODERATE"
df$short_summary[i]           <- "TWFE=0.6625 EXACT (0.07%); Bacon post-fix: TvT=3.8% clean; remaining WARN=two-way clustering template limit; F-HIGH x I-MOD = MODERATE [fix 2026-04-20]"

write.csv(df, file.path(base_dir, "analysis/skeptic_ratings.csv"), row.names=FALSE)
cat("\nAfter:\n")
print(df[i, c("id","rating","fidelity","implementation","impl_axis","n_impl_warn")])

cat("\n=== Final distribution ===\n")
print(table(df$rating))
