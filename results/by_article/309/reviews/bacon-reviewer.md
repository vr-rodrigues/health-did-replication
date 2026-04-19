# Bacon Decomposition Reviewer Report — Article 309

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19
**Reviewer:** bacon-reviewer
**Update:** Supersedes 2026-04-18 report. Applicability gate triggered by allow_unbalanced change.

---

## Applicability gate

- treatment_timing: staggered — YES
- data_structure: panel — YES
- allow_unbalanced (current metadata): TRUE — FAIL gate (rule requires allow_unbalanced == false)

**Applicability verdict: NOT_APPLICABLE** per current metadata (allow_unbalanced=true).

---

## Context note

bacon.csv was computed under the prior metadata configuration (allow_unbalanced=false,
balanced to full-coverage states). The Bacon decomposition is formally valid only on a
balanced panel; with allow_unbalanced=true the panel used for CS-DID estimation is the
full unbalanced panel, and Bacon weights computed on the balanced subset do not directly
characterise the unbalanced TWFE estimand.

For reference, the key findings from the 2026-04-18 balanced-panel Bacon run are
reproduced below as contextual design information only (NOT counted in the Implementation
axis since applicability gate fails):

**Weight structure (balanced panel, 2026-04-18 run):**
- TvU (treated vs untreated): ~46.7% of total weight
- LvA (later vs always-treated 1979 cohort): ~26.2% of total weight
- TvT (LvE + EvL): ~27.1% of total weight — below 30% threshold

**Key design signal:**
- Cohort 1989 has sign-reversed TvU estimate (+0.316), opposite to all 9 other cohorts.
  This single cohort's positive contribution in the balanced-panel run is the leading
  candidate explanation for the TWFE/CS-DID magnitude divergence observed after the
  allow_unbalanced fix (TWFE=-0.137 vs CS-NT=-0.033). CS-DID weights the 1989 cohort's
  ATT under a clean never-treated comparison group; TWFE weights it with contaminated
  comparisons that amplify its positive contribution to the overall weighted average.
- EvL (forbidden) pairs present at ~5% weight with large 1989-anchored values (e.g.,
  1989 vs 1980 = +0.811).

These are retained as Axis-3 design evidence but are not counted in the Implementation
axis.

**Verdict: NOT_APPLICABLE**
