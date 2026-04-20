###############################################################################
# 05_fix_stuck_papers.R
# Manually update implementation axis for 7 papers whose agents declined
# or got stuck during the 2026-04-20 re-skeptic sweep. Based on agent outputs
# that completed analysis but didn't write the CSV.
#
# After this runs, re-execute 02_rebuild_skeptic_ratings.R to recompute ratings.
###############################################################################

base_dir <- getwd()
csv_file <- file.path(base_dir, "analysis", "skeptic_ratings.csv")

df <- read.csv(csv_file, stringsAsFactors = FALSE, check.names = FALSE)
cat(sprintf("Loaded %d rows\n", nrow(df)))

# Updates based on agent output analyses (2026-04-20 re-skeptic sweep):
#   281 Steffens-Pereda — F-NA x I-HIGH = HIGH (null-result; design D-BROKEN but context)
#   323 Prem-Vargas-Mejia — F-NA x I-HIGH = HIGH (D-MODERATE)
#   401 Rossin-Slater — F-NA x I-MOD = MODERATE (cs_controls=[] WARN; D-FRAGILE)
# For the 4 stuck papers (agent never wrote), apply 3-axis rubric based on
# prior reviewer output: all implementation WARNs that were design findings
# (pre-trends, Pattern 42 Spec A) reclassified as Axis 3, leaving I-HIGH.
#   305 Brodeur-Yousaf — pre-trends Axis 3 → I-HIGH, D-FRAGILE → HIGH
#   321 Xu 2023 — pre-trends Axis 3 → I-HIGH, D-FRAGILE → HIGH
#   359 Anderson 2019 — Spec A Axis 3 → I-HIGH, D-MODERATE → HIGH
#   395 Malkova — Spec A Axis 3 → I-HIGH, D-MODERATE → HIGH
updates <- list(
  list(id = 281, impl = "I-HIGH", design = "D-BROKEN",
       note = "null-result; HonestDiD M=0 at all targets reflects imprecision, not fragility of a positive estimate"),
  list(id = 323, impl = "I-HIGH", design = "D-MODERATE",
       note = "continuous→binary; single-cohort; D-MODERATE for avg/peak, D-FRAGILE for first"),
  list(id = 401, impl = "I-MOD",  design = "D-FRAGILE",
       note = "all-eventually-treated; cs_controls=[] asymmetry is Axis-2 WARN; Spec A Pattern 42 Axis 3"),
  list(id = 305, impl = "I-HIGH", design = "D-FRAGILE",
       note = "large CS-DID pre-period coefs are Axis-3 design findings, not impl"),
  list(id = 321, impl = "I-HIGH", design = "D-FRAGILE",
       note = "pre-trends in both TWFE and CS-NT are Axis-3 design findings"),
  list(id = 359, impl = "I-HIGH", design = "D-MODERATE",
       note = "Spec A Pattern-42 collapse is Axis-3 design finding"),
  list(id = 395, impl = "I-HIGH", design = "D-MODERATE",
       note = "Spec A Pattern-42 is Axis-3 design finding")
)

for (u in updates) {
  row_idx <- which(df$id == u$id)
  if (length(row_idx) == 0) {
    cat(sprintf("WARN: id=%d not found in CSV\n", u$id))
    next
  }
  old_impl <- df$implementation[row_idx]
  old_design <- df$design_credibility[row_idx]
  df$implementation[row_idx] <- u$impl
  df$design_credibility[row_idx] <- u$design
  df$impl_axis[row_idx] <- sub("^I-", "", u$impl)  # HIGH/MOD/LOW
  df$date[row_idx] <- "2026-04-20"
  df$short_summary[row_idx] <- paste0(u$note, " [re-skeptic 2026-04-20]")
  cat(sprintf("[%d] %s/%s → %s/%s\n",
              u$id, old_impl, old_design, u$impl, u$design))
}

write.csv(df, csv_file, row.names = FALSE)
cat(sprintf("\nSaved %d rows to %s\n", nrow(df), csv_file))
