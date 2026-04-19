# Skeptic report: 68 — Tanaka (2014)

**Overall rating:** HIGH
**Design credibility:** D-NA (T=2; zero pre-periods; parallel trends structurally untestable)
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (N/A — single timing), honestdid (N/A — no event study; T=2; zero pre-periods), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT — Col 2 community FEs; β gap = −0.66%)

## Executive summary

Tanaka (2014) estimates the effect of user-fee abolition in post-apartheid South Africa on child nutritional status (weight-for-age z-score, WAZ) using a 2×2 DiD with T=2 (1993 vs 1998) and repeated cross-section (RCS) data from 62 clusters. Our stored TWFE estimate is β = +0.567 SD (SE = 0.241; p ≈ 0.019), indicating improved child nutrition in high-access clinic communities after the fee abolition. This is the cleanest possible DiD design — a single treatment cohort, two time periods, never-treated comparison group, absorbing binary treatment — and passes all applicable methodological reviewers without exception.

**Fidelity correction (2026-04-19).** The prior audit (2026-04-18) compared our stored estimate to Table 3 Col 1 (pooled OLS baseline, β = 0.522), which produced an 8.7% gap and a WARN verdict (F-MOD). That comparison was wrong: our implementation uses `twfe_fe_override = "clustnum"` (community fixed effects), which structurally corresponds to the paper's equation (2) specification — Table 3 Col 2 (β = 0.571, community FEs, no controls). The metadata `original_result` field was updated on 2026-04-19 to record the correct target. Against Col 2, our stored estimate (0.5672) is within 0.66% of the paper's value, comfortably within the 1% EXACT threshold. The paper-auditor verdict is EXACT, and fidelity is now F-HIGH. The earlier rating was already HIGH (the design is clean and all methodology reviewers passed), but the fidelity axis was incorrectly classified as F-NA. The corrected audit is F-HIGH × I-HIGH = **HIGH**.

The CS-DID ATT is +0.522 (SE = 0.390), directionally consistent but not statistically significant, reflecting the reduced efficiency of the RCS estimator without within-individual differencing. The user should treat the stored beta_twfe = 0.567 as a faithful reproduction of Table 3 Col 2 of the published paper, and as methodologically well-grounded. The main residual uncertainty is the untestable parallel-trends assumption (inherent to any T=2 design) and the RCS composition sensitivity, neither of which constitutes a disqualifying concern.

## Per-reviewer verdicts

### TWFE (PASS)
- 2×2 DiD with single cohort and T=2 is the canonical case for TWFE: no negative weights, no forbidden comparisons, no staggered-timing bias possible.
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
- Absorbing binary treatment, single timing, no dose heterogeneity. DCD estimator would replicate TWFE exactly in this 2×2 setting.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (EXACT)
- Target: Table 3 Col 2, equation (2) with community fixed effects and cohort fixed effects, no household or community controls. N = 1,071.
- Paper: β = 0.571 (SE = 0.256). Stored: β = 0.5672 (SE = 0.2412). Relative Δ = −0.66% (beta); −5.8% (SE).
- Both gaps are within EXACT thresholds (beta < 1%; SE < 30%). Verdict: EXACT. Fidelity: F-HIGH.
- Prior WARN verdict (F-MOD) was against Col 1 (pooled OLS, β = 0.522), which does not match our community-FE implementation. Corrected on 2026-04-19.
- Full report: [`paper_audit.md`](../paper_audit.md)

## Three-way controls decomposition

N/A — paper has no original covariates; unconditional comparison only. `twfe_controls` is empty; the metadata group label is `unica_sem_controles`. Specs A and B collapse to the same estimate as Spec C.

## Material findings (sorted by severity)

No FAIL items.

No WARN items.

Informational notes (not rating-affecting):

- SE sensitivity: TWFE p ≈ 0.019 (significant) vs CS-NT p ≈ 0.18 (not significant). Both are valid for this design; the CS-NT SE is expected to be larger under RCS. The paper's reliance on TWFE for its main significance claim is appropriate.
- Pre-trends untestable: T=2 is a binding constraint — parallel trends must be argued on substantive grounds (pre-policy similarity between high- and low-access communities). This is a design constraint shared by the original paper and our reanalysis.
- Fidelity footnote: the earlier paper-auditor WARN (8.7% gap vs Col 1) was an auditing error — comparing a community-FE estimator to a pooled-OLS column. Corrected via metadata update on 2026-04-19.

## Recommended actions

- No action needed on methodology or fidelity — this is a clean HIGH-rated paper with an EXACT reproduction.
- Ensure `original_result.beta_twfe = 0.571` and `table_reference = "Table 3 Col 2 (community FEs, no controls)"` are committed to the metadata file (already updated 2026-04-19).
- No pattern-curator actions needed.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`paper_audit.md`](../paper_audit.md)
