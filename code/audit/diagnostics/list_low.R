d <- read.csv("analysis/skeptic_ratings.csv", stringsAsFactors=FALSE, check.names=FALSE)
low <- d[d$rating == "LOW", c("id","author_label","fidelity_verdict")]
low <- low[order(low$id), ]
for (i in seq_len(nrow(low))) {
  cat(sprintf("%2d. id=%5s | %-35s | fid=%s\n",
              i, low$id[i],
              substr(gsub('"','',low$author_label[i]), 1, 35),
              low$fidelity_verdict[i]))
}
cat("Total:", nrow(low), "LOW papers\n")
