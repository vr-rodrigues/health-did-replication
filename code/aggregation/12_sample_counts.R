suppressPackageStartupMessages({ library(jsonlite) })
base_dir <- getwd()

ids <- gsub("\\.json$", "", list.files(file.path(base_dir, "data/metadata"),
                                       pattern="^[0-9]+\\.json$"))
excl <- c("234", "242", "380")
ids <- setdiff(ids, excl)

tt <- character(length(ids))
ds <- character(length(ids))
es <- logical(length(ids))
for (i in seq_along(ids)) {
  m <- fromJSON(file.path(base_dir, "data/metadata", paste0(ids[i], ".json")))
  tt[i] <- as.character(m$panel_setup$treatment_timing)
  ds[i] <- as.character(m$panel_setup$data_structure)
  es[i] <- isTRUE(m$analysis$has_event_study)
}
cat("N total reanalyzed:", length(ids), "\n\n")
cat("Treatment timing:\n"); print(table(tt))
cat("\nData structure:\n"); print(table(ds))
cat("\nHas event study:", sum(es), "/", length(ids), "\n")
