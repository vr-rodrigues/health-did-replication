suppressPackageStartupMessages({ library(jsonlite); library(dplyr) })
base_dir <- getwd()

consol <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"),
                   stringsAsFactors=FALSE)

has_twfe_ctrls <- sapply(as.character(consol$id), function(id) {
  f <- file.path(base_dir, "data/metadata", paste0(id, ".json"))
  if (!file.exists(f)) return(NA)
  m <- fromJSON(f)
  v <- m$variables$twfe_controls
  isTRUE(length(v) > 0 && any(nchar(as.character(v)) > 0))
})

cat("=== Counts for Chapter 4 Lesson 7 text ===\n\n")
cat("Total comparable subsample:        ", nrow(consol), "\n")
cat("Papers WITH twfe_controls:         ", sum(has_twfe_ctrls, na.rm=TRUE), "\n")
cat("Papers WITHOUT twfe_controls:      ", sum(!has_twfe_ctrls, na.rm=TRUE), "\n\n")

idx_ctrls <- which(has_twfe_ctrls)
clean_a <- !is.na(consol$cs_nt_with_ctrls_status[idx_ctrls]) &
           consol$cs_nt_with_ctrls_status[idx_ctrls] == "OK" &
           !is.na(consol$att_cs_nt_with_ctrls_dyn[idx_ctrls]) &
           abs(consol$att_cs_nt_with_ctrls_dyn[idx_ctrls]) > 1e-9 &
           !is.na(consol$se_cs_nt_with_ctrls_dyn[idx_ctrls]) &
           consol$se_cs_nt_with_ctrls_dyn[idx_ctrls] > 0

cat("Of those WITH controls:\n")
cat("  Spec A clean (status=OK, att!=0, SE valid):",
    sum(clean_a, na.rm=TRUE), "\n")
cat("  Spec A failed (collapse / collinear / memory / NA):",
    sum(!clean_a, na.rm=TRUE), "\n\n")

cat("Matched figure (Figure 4.1b) includes:\n")
cat("  Clean Spec A (with ctrls):            ", sum(clean_a, na.rm=TRUE), "\n")
cat("  Papers without ctrls (matched triv.): ", sum(!has_twfe_ctrls, na.rm=TRUE), "\n")
cat("  TOTAL:                                ",
    sum(clean_a, na.rm=TRUE) + sum(!has_twfe_ctrls, na.rm=TRUE), "\n")
cat("  EXCLUDED (Spec A failed):             ",
    sum(!clean_a, na.rm=TRUE), "\n")
