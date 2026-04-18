#!/bin/bash
# Restore original per-article files from /replication_analysis/results/{id}/
# to Replication Package/results/by_article/{id}/. Preserves metadata.json
# (the canonical one is in data/metadata/) and only overwrites computed artefacts:
#   results.csv, event_study_data.csv, bacon.csv, honest_did_v3.csv,
#   honest_did_v3_sensitivity.csv, honest_did_v3_data.rds, event_study.pdf,
#   honest_did_v3.pdf, bacon_decomposition.pdf
set -e

ORIG="/c/Users/victo/OneDrive/Pesquisas/replication_analysis/results"
DEP="/c/Users/victo/OneDrive/Pesquisas/replication_analysis/Replication Package/results/by_article"

# Also back up current state in case we need to compare
BACKUP="/tmp/by_article_backup_$(date +%s)"
echo "Backing up current state to $BACKUP"
cp -r "$DEP" "$BACKUP"

files_to_restore=(
  "results.csv"
  "event_study_data.csv"
  "bacon.csv"
  "honest_did_v3.csv"
  "honest_did_v3_sensitivity.csv"
  "honest_did_v3_data.rds"
  "event_study.pdf"
  "honest_did_v3.pdf"
  "bacon_decomposition.pdf"
)

restored=0
skipped=0
for id_dir in "$DEP"/*/; do
  id=$(basename "$id_dir")
  orig_dir="$ORIG/$id"
  if [ ! -d "$orig_dir" ]; then
    echo "  [SKIP] ID $id has no original in $orig_dir"
    skipped=$((skipped+1))
    continue
  fi
  n=0
  for f in "${files_to_restore[@]}"; do
    if [ -f "$orig_dir/$f" ]; then
      cp "$orig_dir/$f" "$id_dir/$f"
      n=$((n+1))
    fi
  done
  restored=$((restored+1))
done
echo
echo "Restored: $restored articles   Skipped: $skipped"
echo "Backup: $BACKUP"
