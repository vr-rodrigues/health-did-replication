#!/bin/bash
# Delete orphan figures in overleaf/Figures and health_did_replication/Figures
# using `git rm` (tracked, reversible via git revert).

set -e
cd "$(dirname "$0")/../.."

REF=$(mktemp)
grep -rhoE 'includegraphics(\[[^]]*\])?\{[^}]+\}' \
    overleaf/Chapters/ overleaf/Appendices/ overleaf/main_dry_en.tex \
    health_did_replication/ 2>/dev/null \
  | grep -oE '\{[^}]+\}' | tr -d '{}' | sort -u > "$REF"

TOTAL=0
for BASE in overleaf health_did_replication; do
  [ -d "$BASE/Figures" ] || continue

  DISK=$(mktemp)
  find "$BASE/Figures" -type f \( -name '*.pdf' -o -name '*.png' -o -name '*.jpg' \) \
    | sed "s|^$BASE/||" | sort > "$DISK"

  USED=$(mktemp)
  while IFS= read -r ref; do
    grep -xF "$ref" "$DISK" >> "$USED" 2>/dev/null || true
    if [[ "$ref" != *.pdf ]]; then
      grep -xF "${ref}.pdf" "$DISK" >> "$USED" 2>/dev/null || true
    fi
  done < "$REF"
  sort -u "$USED" > "${USED}.sorted"
  mv "${USED}.sorted" "$USED"

  ORPHANS=$(comm -23 "$DISK" "$USED")
  N=$(echo -n "$ORPHANS" | grep -c '^' || true)
  echo "[$BASE] $N orphans"
  if [ -n "$ORPHANS" ]; then
    while IFS= read -r rel; do
      git rm --quiet "$BASE/$rel" 2>/dev/null || rm -f "$BASE/$rel"
    done <<< "$ORPHANS"
  fi
  TOTAL=$((TOTAL + N))
  rm -f "$DISK" "$USED"
done

rm -f "$REF"
echo ""
echo "Total removed: $TOTAL"
