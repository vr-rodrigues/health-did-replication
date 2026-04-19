# Bacon Decomposition Reviewer Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check
- `treatment_timing`: staggered — condition met
- `data_structure`: panel — condition met
- `allow_unbalanced`: **true** — condition NOT met

The Bacon decomposition requires a balanced panel. The metadata specifies `allow_unbalanced: true`, and the analysis flag `run_bacon: false` confirms the decomposition was not run. This reviewer is not applicable.

Note: A single-observation bacon.csv exists in the results folder (1995 vs 99999 treated vs untreated, estimate=-2.67, weight=1.0), which appears to be a minimal or degenerate decomposition output rather than a meaningful decomposition. This is consistent with the unbalanced panel precluding a full decomposition.

**Verdict: NOT_APPLICABLE** — Unbalanced panel precludes Bacon decomposition.
