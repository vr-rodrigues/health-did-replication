base_dir <- getwd()
df <- read.csv(file.path(base_dir, "analysis/skeptic_ratings.csv"), stringsAsFactors=FALSE, check.names=FALSE)
i <- which(df$id == 61)
cat("Before:\n")
print(df[i, c("id","rating","fidelity","implementation","impl_axis")])

df$implementation[i]     <- "I-HIGH"
df$impl_axis[i]          <- "HIGH"
df$fidelity[i]           <- "F-HIGH"
df$fidelity_verdict[i]   <- "EXACT"
df$rating[i]             <- "HIGH"
df$date[i]               <- "2026-04-20"
df$n_impl_warn[i]        <- 0
df$design_credibility[i] <- "D-NA"
df$short_summary[i]      <- "TWFE re-estimated WITHOUT forced FEs; beta=0.00948 vs paper 0.0095 EXACT 0.18pct gap; F-HIGH x I-HIGH = HIGH [fix 2026-04-20]"

write.csv(df, file.path(base_dir, "analysis/skeptic_ratings.csv"), row.names=FALSE)
cat("\nAfter:\n")
print(df[i, c("id","rating","fidelity","implementation","impl_axis")])
cat("\nFinal distribution:\n")
print(table(df$rating))
