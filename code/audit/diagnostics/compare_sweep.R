###############################################################################
# compare_sweep.R — diff pre/post sweep for the 22 papers
###############################################################################
ids <- c(21,47,61,65,76,79,80,97,125,147,201,210,213,228,233,254,267,337,401,437,525,1094)

backup_dir <- "C:/Users/victo/AppData/Local/Temp/res_backup"
if (!dir.exists(backup_dir)) backup_dir <- "/tmp/res_backup"
if (!dir.exists(backup_dir)) {
  # Try Windows-style path used by Git Bash
  backup_dir <- file.path(Sys.getenv("TEMP"), "res_backup")
}
if (!dir.exists(backup_dir)) {
  message("Trying alternative paths..."); backup_dir <- normalizePath("/tmp/res_backup", mustWork=FALSE)
}
cat("Backup dir:", backup_dir, "(exists:", dir.exists(backup_dir), ")\n")
res_dir    <- "results/by_article"

read_one <- function(path) {
  if (!file.exists(path)) return(NULL)
  d <- read.csv(path, stringsAsFactors=FALSE)
  list(
    beta_twfe   = if ("beta_twfe"    %in% names(d)) d$beta_twfe[1]    else NA,
    se_twfe     = if ("se_twfe"      %in% names(d)) d$se_twfe[1]      else NA,
    att_nt      = if ("att_csdid_nt" %in% names(d)) d$att_csdid_nt[1] else NA,
    se_nt       = if ("se_csdid_nt"  %in% names(d)) d$se_csdid_nt[1]  else NA,
    att_nyt     = if ("att_csdid_nyt"%in% names(d)) d$att_csdid_nyt[1] else NA,
    se_nyt      = if ("se_csdid_nyt" %in% names(d)) d$se_csdid_nyt[1]  else NA,
    att_nt_dyn  = if ("att_nt_dynamic" %in% names(d)) d$att_nt_dynamic[1] else NA,
    cs_w_ctrls  = if ("att_cs_nt_with_ctrls" %in% names(d)) d$att_cs_nt_with_ctrls[1] else NA
  )
}

cat(sprintf("%5s | %12s %12s %12s | %12s %12s %12s | %s\n",
            "id","β_TWFE_old","β_TWFE_new","β_diff%",
            "ATT_NT_old","ATT_NT_new","NT_diff%","NOTE"))
cat(strrep("-", 130), "\n")

results <- data.frame()
for (id in ids) {
  old <- read_one(file.path(backup_dir, sprintf("%s_results.csv", id)))
  new <- read_one(file.path(res_dir, id, "results.csv"))
  if (is.null(old) || is.null(new)) {
    cat(sprintf("%5d | MISSING\n", id)); next
  }
  bd <- if (!is.na(old$beta_twfe) && !is.na(new$beta_twfe) && abs(old$beta_twfe) > 1e-12)
        100 * (new$beta_twfe - old$beta_twfe) / abs(old$beta_twfe) else NA
  nd <- if (!is.na(old$att_nt) && !is.na(new$att_nt) && abs(old$att_nt) > 1e-12)
        100 * (new$att_nt - old$att_nt) / abs(old$att_nt) else NA

  note <- ""
  if (!is.na(old$att_nt) && is.na(new$att_nt)) note <- "*** CS-NT BROKE (was non-NA, now NA)"
  if (is.na(old$att_nt) && !is.na(new$att_nt)) note <- "+++ CS-NT recovered (was NA, now numeric)"
  if (!is.na(bd) && abs(bd) > 1) note <- paste(note, sprintf("β_TWFE shift %.1f%%", bd))
  if (!is.na(nd) && abs(nd) > 5) note <- paste(note, sprintf("ATT_NT shift %.1f%%", nd))
  if (!is.na(old$att_nt) && !is.na(new$att_nt) && sign(old$att_nt) != sign(new$att_nt))
    note <- paste(note, "*** SIGN FLIP")

  cat(sprintf("%5d | %12.5f %12.5f %12s | %12s %12s %12s | %s\n",
              id,
              old$beta_twfe, new$beta_twfe,
              if (is.na(bd)) "—" else sprintf("%+.2f%%", bd),
              if (is.na(old$att_nt)) "NA" else sprintf("%.5f", old$att_nt),
              if (is.na(new$att_nt)) "NA" else sprintf("%.5f", new$att_nt),
              if (is.na(nd)) "—" else sprintf("%+.2f%%", nd),
              note))

  results <- rbind(results, data.frame(
    id=id, beta_old=old$beta_twfe, beta_new=new$beta_twfe, beta_diff_pct=bd,
    att_nt_old=old$att_nt, att_nt_new=new$att_nt, att_nt_diff_pct=nd,
    note=note, stringsAsFactors=FALSE))
}

write.csv(results, "/tmp/sweep_comparison.csv", row.names=FALSE)
cat("\nSaved /tmp/sweep_comparison.csv\n")

cat("\n=== SUMMARY ===\n")
cat(sprintf("Papers where CS-NT broke (became NA): %d\n",
            sum(!is.na(results$att_nt_old) & is.na(results$att_nt_new))))
cat(sprintf("Papers with sign flip on ATT_NT: %d\n",
            sum(!is.na(results$att_nt_old) & !is.na(results$att_nt_new) &
                sign(results$att_nt_old) != sign(results$att_nt_new))))
cat(sprintf("Papers with |ATT_NT shift| > 5%%: %d\n",
            sum(!is.na(results$att_nt_diff_pct) & abs(results$att_nt_diff_pct) > 5)))
cat(sprintf("Papers with |β_TWFE shift| > 1%%: %d\n",
            sum(!is.na(results$beta_diff_pct) & abs(results$beta_diff_pct) > 1)))
