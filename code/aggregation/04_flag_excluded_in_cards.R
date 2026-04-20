###############################################################################
# 04_flag_excluded_in_cards.R
# Adds an `excluded_from_sample` boolean column to article_cards.csv based on
# the metadata flag. Cards for excluded papers (234, 242, 380) get TRUE +
# the exclusion_reason copied from metadata; all other rows get FALSE + NA.
###############################################################################
suppressPackageStartupMessages({ library(jsonlite) })
base_dir <- getwd()

cards <- read.csv(file.path(base_dir, "analysis", "article_cards.csv"),
                  stringsAsFactors = FALSE, check.names = FALSE)
cat("Cards loaded:", nrow(cards), "\n")

cards$excluded_from_sample <- FALSE
cards$exclusion_reason     <- NA_character_

for (i in seq_len(nrow(cards))) {
  id <- cards$id[i]
  meta_path <- file.path(base_dir, "data", "metadata", paste0(id, ".json"))
  if (!file.exists(meta_path)) next
  meta <- tryCatch(fromJSON(meta_path), error = function(e) NULL)
  if (is.null(meta)) next
  if (isTRUE(meta$excluded_from_sample)) {
    cards$excluded_from_sample[i] <- TRUE
    if (!is.null(meta$exclusion_reason))
      cards$exclusion_reason[i] <- meta$exclusion_reason
  }
}

cat("Excluded papers flagged:", sum(cards$excluded_from_sample), "\n")
print(cards[cards$excluded_from_sample, c("id", "author_label")], row.names = FALSE)

write.csv(cards, file.path(base_dir, "analysis", "article_cards.csv"),
          row.names = FALSE)
cat("Saved analysis/article_cards.csv\n")
