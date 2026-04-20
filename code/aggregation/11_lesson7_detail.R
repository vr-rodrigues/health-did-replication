suppressPackageStartupMessages({ library(jsonlite) })
base_dir <- getwd()

ids <- gsub("\\.json$", "", list.files(file.path(base_dir, "data/metadata"),
                                       pattern="^[0-9]+\\.json$"))

# Also exclude the 3 structurally-excluded papers
excluded <- c("234", "242", "380")
ids <- setdiff(ids, excluded)

has_twfe_ctrls <- logical(length(ids))
has_cs_ctrls   <- logical(length(ids))
has_addl_fes   <- logical(length(ids))

for (i in seq_along(ids)) {
  f <- file.path(base_dir, "data/metadata", paste0(ids[i], ".json"))
  m <- fromJSON(f)
  tc <- m$variables$twfe_controls
  cc <- m$variables$cs_controls
  af <- m$variables$additional_fes
  has_twfe_ctrls[i] <- isTRUE(length(tc) > 0 && any(nchar(as.character(tc)) > 0))
  has_cs_ctrls[i]   <- isTRUE(length(cc) > 0 && any(nchar(as.character(cc)) > 0))
  has_addl_fes[i]   <- isTRUE(length(af) > 0 && any(nchar(as.character(af)) > 0))
}

cat("=== Chapter 4 Lesson 7 counts (N =", length(ids), " comparable) ===\n\n")
cat("Papers with TWFE controls:                ", sum(has_twfe_ctrls), "\n")
cat("Papers with CS-DID controls (metadata):   ", sum(has_cs_ctrls), "\n")
cat("Papers with additional_fes:               ", sum(has_addl_fes), "\n")
cat("Papers with TWFE ctrls OR additional_fes: ",
    sum(has_twfe_ctrls | has_addl_fes), "\n\n")

cat("Of papers WITH TWFE controls:\n")
cat("  Also have cs_controls set in metadata:", sum(has_twfe_ctrls & has_cs_ctrls), "\n")
cat("  CS-DID run unconditionally (cs_controls=[]):",
    sum(has_twfe_ctrls & !has_cs_ctrls), "\n")
