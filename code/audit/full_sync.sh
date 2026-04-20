#!/bin/bash
# Full sync: refresh overleaf/Figures + refresh health_did_replication/Figures
# and rebuild the working-paper main.tex from current chapters.
#
# Since Phase-2 consolidation (2026-04-18), the pipeline runs directly in the
# deposit (`Replication Package/`) — no Test staging copy is used. The old
# "Test → deposit" stage of this script has been removed; the deposit is the
# single working copy. Historical Test folder is preserved in
# `_archive/phase2_consolidation_20260418/`.
set -e

DEP="/c/Users/victo/OneDrive/Pesquisas/replication_analysis/Replication Package"
OV="$DEP/overleaf"
WP="$DEP/health_did_replication"
OUT="$DEP/output"
PROMOTE="$DEP/code/audit/promote_headings.sh"

# Cleanup orphan helper scripts that occasionally land in code/audit during
# iterative dev (one-shot diagnostics). Ignore missing files.
rm -f "$DEP/code/audit/inspect_aggte.R" \
      "$DEP/code/audit/inspect_305.R" \
      "$DEP/code/audit/early_spot_check.R" \
      "$DEP/code/audit/investigate_outliers.R" \
      "$DEP/code/audit/deep_dive.R" \
      "$DEP/code/audit/check_convergence.R" \
      "$DEP/code/audit/fix_meta_pattern49_v2.R" \
      "$DEP/code/audit/update_234_late.R" \
      "$DEP/code/audit/update_meta_pattern49.R" \
      "$DEP/code/audit/_tmp_"*.R 2>/dev/null || true
[ -f "$DEP/Rplots.pdf" ] && rm "$DEP/Rplots.pdf"

# ── 1. Refresh overleaf/Figures from output/figures ─────────────────
echo "=== 1/3 Refresh overleaf/Figures ==="
# Only sync figures actually referenced in the text (see
# code/audit/find_orphan_figures.sh to verify no orphans are being introduced).
declare -A MAP=(
  ["agregado/agregado_dynamic_v3.pdf"]="figure_4_1_aggregate_scatter_dynamic.pdf"
  ["agregado/density_z_dynamic.pdf"]="figure_4_2_density_z_dynamic.pdf"
  ["agregado/variacao_pct_dynamic.pdf"]="figure_4_3_variation_pct_dynamic.pdf"
  ["agregado/panel_es_6cases.pdf"]="figure_4_4_panel_event_study_6cases.pdf"
  ["agregado/panel_binning_76.pdf"]="figure_4_5_panel_binning_76.pdf"
  ["agregado/density_covariates_zscore.pdf"]="figure_4_7_density_covariates.pdf"
  ["agregado/panel_csdid_controls_133.pdf"]="figure_4_8_panel_controls_133.pdf"
  ["agregado/panel_graduated_sensitivity.pdf"]="figure_4_9_graduated_sensitivity.pdf"
  ["agregado/figure_4_1_aggregate_scatter_matched.pdf"]="figure_4_1_aggregate_scatter_matched.pdf"
  ["agregado/figure_4_1_signif_matrix.pdf"]="figure_4_1_signif_matrix.pdf"
)
for dst in "${!MAP[@]}"; do
  src="$OUT/figures/${MAP[$dst]}"
  [ -f "$src" ] && cp "$src" "$OV/Figures/$dst"
done
[ -f "$OUT/figures/figure_4_10_sensitivity_210.pdf" ] && \
  cp "$OUT/figures/figure_4_10_sensitivity_210.pdf" "$OV/Figures/sensitivity/event_study_sensitivity_210.pdf"

# Sync only the per-article event-study + HonestDiD figures actually
# referenced by AppendixB. Matches id_{num}_event_study.pdf and
# id_{num}_honest_did_v3.pdf strictly; variants (sensitivity, sem_binning,
# com_controles, exclusao) and unsampled papers (357, 382) are excluded.
USED=$(grep -rhoE 'Figures/(event_study|honestdid)/id_[0-9]+_[a-z_0-9]+\.pdf' \
       "$OV/../overleaf" "$WP" 2>/dev/null | sort -u)
for f in "$OUT"/figures/appendix_event_studies/*.pdf; do
  base=$(basename "$f")
  if echo "$USED" | grep -qxF "Figures/event_study/$base"; then
    cp "$f" "$OV/Figures/event_study/$base"
  fi
done
for f in "$OUT"/figures/appendix_honestdid/*.pdf; do
  base=$(basename "$f")
  if echo "$USED" | grep -qxF "Figures/honestdid/$base"; then
    cp "$f" "$OV/Figures/honestdid/$base"
  fi
done
# NOTE: bacon/ and esw/ subdirectories are intentionally NOT synced — the
# per-paper Bacon decomposition and ESW weights PDFs are not referenced in
# any .tex file. They remain available in results/by_article/{id}/ for
# readers consulting the replication package directly.
echo "  [OK] overleaf/Figures refreshed"

# ── 2. Refresh health_did_replication/Figures (mirror overleaf) ────
echo "=== 2/3 Refresh health_did_replication/Figures ==="
cp -r "$OV/Figures/"* "$WP/Figures/"
echo "  [OK] working-paper Figures synced"

# ── 3. Rebuild working-paper main.tex from updated chapters ────────
echo "=== 3/3 Rebuild health_did_replication/main.tex ==="
mkdir -p /tmp/wp_rebuild
for n in 1 2 3 4 5; do
  bash "$PROMOTE" "$OV/Chapters/Chapter$n.tex" "/tmp/wp_rebuild/Chapter$n.tex"
done
# Re-promote appendix files in place too
for letter in A B C D; do
  bash "$PROMOTE" "$OV/Appendices/Appendix$letter.tex" "$WP/Appendix$letter.tex"
done

# Extract preamble (everything before MAIN TEXT) and tail (REFERENCES onward)
awk '/^%.*MAIN TEXT/{exit} {print}' "$WP/main.tex" > /tmp/wp_rebuild/preamble.tex
awk '/^%.*REFERENCES/{flag=1} flag{print}'  "$WP/main.tex" > /tmp/wp_rebuild/tail.tex

{
  cat /tmp/wp_rebuild/preamble.tex
  echo ""
  echo "%======================================================================"
  echo "%  MAIN TEXT (chapters 1-5 of the dissertation, inlined)"
  echo "%======================================================================"
  echo ""
  for n in 1 2 3 4 5; do cat /tmp/wp_rebuild/Chapter$n.tex; printf "\n\n"; done
  cat /tmp/wp_rebuild/tail.tex
} > "$WP/main.tex"
# Tables also need to be in WP/Tables/ — already synced by 01_chapter_statistics.R
echo "  [OK] main.tex rebuilt ($(wc -l < "$WP/main.tex") lines)"

# Cleanup tmp
rm -rf /tmp/wp_rebuild

echo
echo "=== ALL DONE ==="
