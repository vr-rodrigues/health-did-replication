#!/bin/bash
# Find orphan figures in overleaf/Figures and health_did_replication/Figures
# (files present on disk but not referenced by any \includegraphics in the .tex sources).

set -e
cd "$(dirname "$0")/../.."

echo "=== Building set of referenced figures from all .tex sources ==="
# Collect all \includegraphics{...} references
REF=$(mktemp)
grep -rhoE 'includegraphics(\[[^]]*\])?\{[^}]+\}' \
    overleaf/Chapters/ overleaf/Appendices/ overleaf/main_dry_en.tex \
    health_did_replication/ 2>/dev/null \
  | grep -oE '\{[^}]+\}' | tr -d '{}' | sort -u > "$REF"
echo "  $(wc -l < "$REF") unique references"

for BASE in overleaf health_did_replication; do
  echo ""
  echo "=== $BASE/Figures ==="
  if [ ! -d "$BASE/Figures" ]; then
    echo "  (no such directory)"
    continue
  fi

  # List all files actually on disk
  DISK=$(mktemp)
  find "$BASE/Figures" -type f \( -name '*.pdf' -o -name '*.png' -o -name '*.jpg' \) \
    | sed "s|^$BASE/||" | sort > "$DISK"

  USED=$(mktemp)
  while IFS= read -r ref; do
    # Match either exact path or with/without .pdf extension
    grep -xF "$ref" "$DISK" >> "$USED" 2>/dev/null || true
    if [[ "$ref" != *.pdf ]]; then
      grep -xF "${ref}.pdf" "$DISK" >> "$USED" 2>/dev/null || true
    fi
  done < "$REF"
  sort -u "$USED" > "${USED}.sorted"
  mv "${USED}.sorted" "$USED"

  echo "  Total files on disk: $(wc -l < "$DISK")"
  echo "  Referenced:          $(wc -l < "$USED")"
  echo "  Orphans:             $(comm -23 "$DISK" "$USED" | wc -l)"
  echo ""
  echo "  --- Orphan list ---"
  comm -23 "$DISK" "$USED"
  rm -f "$DISK" "$USED"
done

rm -f "$REF"
