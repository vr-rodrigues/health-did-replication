# Skeptic report: 68 — Tanaka (2014)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (N/A — single timing), honestdid (N/A — no event study, T=2), dechaisemartin (NOT_NEEDED), paper-auditor (N/A — no PDF)

## Executive summary

Tanaka (2014) estimates the effect of user-fee abolition in post-apartheid South Africa on child nutritional status (weight-for-age z-score) using a 2x2 DiD with T=2 (1993 vs 1998) and RCS data from 62 clusters. The headline result is TWFE = +0.567 SD (SE = 0.241; p ≈ 0.019), indicating improved child nutrition in high-access clinic communities after the fee abolition. This is the cleanest possible DiD design — a single treatment cohort, two time periods, never-treated comparison group, absorbing binary treatment — and accordingly passes all applicable methodological reviewers without exception. The CS-DID ATT is +0.522 (SE = 0.390), directionally consistent but not statistically significant, reflecting the reduced efficiency of the RCS estimator without within-individual differencing. No PDF is available for numerical fidelity verification (F-NA), but the methodology axis alone supports a HIGH rating. The user should treat the stored beta_twfe = 0.567 as methodologically well-grounded; the main residual uncertainty is the untestable parallel-trends assumption (inherent to any T=2 design) and the RCS composition sensitivity, neither of which constitutes a disqualifying concern.

## Per-reviewer verdicts

### TWFE (PASS)
- 2x2 DiD with single cohort and T=2 is the canonical case for TWFE: no negative weights, no forbidden comparisons, no staggered-timing bias possible.
- FE override to `clustnum` is appropriate for RCS data; `postXhigh` correctly coded as `post * high`.
- beta_twfe = 0.567, SE = 0.241, z = 2.35, p ≈ 0.019 — significant, economically plausible direction.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-DID with panel=FALSE (RCS mode), single cohort (gvar=94), never-treated control correctly implemented.
- att_csdid_nt = 0.522 vs TWFE 0.567: 8.1% gap is within expected RCS bounds caused by IPW/DR composition correction vs cluster FE.
- CS-NT SE (0.390) is 62% larger than TWFE SE (0.241) — expected for RCS; CS-NT estimate is not significant (z = 1.34), while TWFE is significant (z = 2.35). This SE discrepancy is a genuine design-level uncertainty, not an implementation failure.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Skipped: `treatment_timing == "single"`. No staggered adoption; Bacon decomposition is not applicable.

### HonestDiD (N/A)
- Skipped: `has_event_study == false` and T=2 provides zero pre-periods. Pre-trend testing and sensitivity analysis are structurally impossible.

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single timing, no dose heterogeneity. DCD estimator would replicate TWFE exactly in this 2x2 setting.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Material findings (sorted by severity)

No FAIL items.

No WARN items.

Informational notes (not rating-affecting):
- SE sensitivity: TWFE p ≈ 0.019 (significant) vs CS-NT p ≈ 0.18 (not significant). Both are valid for this design; the CS-NT SE is expected to be larger under RCS. The paper's reliance on TWFE for its main significance claim is appropriate.
- Pre-trends untestable: T=2 is a binding constraint — parallel trends must be argued on substantive grounds (pre-policy similarity between high- and low-access communities). This is a design constraint shared by the original paper and our reanalysis.
- No fidelity verification: no PDF available. The numerical output cannot be cross-validated against the paper's reported coefficient.

## Recommended actions

- No action needed on methodology — this is a clean HIGH-rated paper.
- (Optional, for completeness) Locate the Tanaka (2014) published paper to verify that beta_twfe = 0.567 corresponds to the paper's main Table 2 or equivalent. If a match is found, upgrade to F-HIGH or F-MOD and record in skeptic_ratings.csv.
- No pattern-curator actions needed.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
