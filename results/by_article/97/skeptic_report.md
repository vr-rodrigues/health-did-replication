# Skeptic report: 97 — Bhalotra et al. (2021)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (N/A)

## Executive summary

Bhalotra et al. (2021) study the effect of urban water disinfection on under-5 infant mortality in Brazil, finding a TWFE estimate of -0.303 (SE 0.069) and a CS-NT estimate of -0.352 (SE 0.039) — both large and statistically significant reductions in infant mortality rates. Three independent methodological reviewers all return WARN verdicts. The dominant concern is a large, structured positive pre-trend in the event study: treated municipalities show infant mortality rates rising (relative to the never-treated cohort) by up to +0.335 units at t=-4, which is comparable in magnitude to the headline treatment effect (-0.303). These pre-trends are present identically in both TWFE and CS-NT event studies, confirming they are structural to the dual-cohort data design rather than TWFE-specific artefacts. HonestDiD sensitivity analysis shows the average ATT survives violations up to Mbar=0.25 (25% of the largest observed pre-trend), and the peak ATT survives to Mbar=0.5, but the first-post coefficient (t=0) is not significant even under the baseline assumption. The Gardner (BJS) estimator shows a constant ~0.146 level shift relative to TWFE/CS-NT/SA (Pattern 47), attributable to the dual-cohort structure's asymmetric untreated sample in the first stage. The stored consolidated TWFE result (-0.303) and CS-NT result (-0.352) are numerically faithful to the paper's reported estimates and correctly implemented, but should be interpreted cautiously given the strong pre-trend evidence.

## Per-reviewer verdicts

### TWFE (WARN)
- Implementation is correct: composite treatment indicator, additional `treated2` FE, proper clustering at `mun_reg`. Numerical match to paper is exact.
- Pre-trend evidence is severe: t=-4 coefficient is +0.335 (6.8 standard errors from zero), with a rising pattern from t=-6 through t=-4 followed by deceleration — a structured, non-random pre-trend.
- Gardner divergence (Pattern 47) is documented and understood: the dual-cohort structure causes BJS's first-stage to estimate year FEs from an asymmetric never-treated sample, producing a constant ~0.146 level shift. Dynamics are preserved.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT is correctly specified for a single-cohort repeated cross-section design with composite unit IDs. Numerical match to the paper is near-exact (< 0.02% divergence).
- CS-NT and TWFE event-study paths are numerically identical, confirming the pre-trend is structural to the data, not a TWFE weighting artefact.
- The 16% divergence between TWFE (-0.303) and CS-NT (-0.352) static ATTs is within expected range and likely reflects the TWFE controls partially absorbing treatment variation.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Not applicable: treatment timing is single (all treated units adopt in 1991), and data structure is repeated cross-section. No staggered decomposition is possible or relevant.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- Average ATT (-0.352) is robust to pre-trend violations at Mbar=0.25 (CI: [-0.427, -0.277] for TWFE); peak ATT survives to Mbar=0.5.
- First-post coefficient (t=0: -0.035) is not significant even at Mbar=0 — the immediate post-treatment impact is not credibly estimated.
- The observed pre-trends are so large (+0.335 at peak) that the RM sensitivity analysis starts from a compromised baseline; the allowable confound at Mbar=0.25 is ~0.084 units, which is not negligible in practical terms.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Treatment is binary, absorbing, with single adoption timing and no dose heterogeneity. The de Chaisemartin estimator addresses non-absorbing, continuous, or heterogeneous-dose designs — none of which apply here.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Material findings (sorted by severity)

**WARN — Large, structured pre-trends (all three applicable estimators):**
Pre-period coefficients rise to +0.335 at t=-4 before declining toward zero at t=-1. This pattern is identical across TWFE, CS-NT, and SA, and is present in 4 of 5 pre-periods at conventional significance. Parallel trends assumption is visually violated.

**WARN — HonestDiD: first-post ATT not significant at baseline:**
The t=0 coefficient (-0.035, SE 0.048) is not distinguishable from zero even without any pre-trend allowance. Only the cumulative average and peak effects (post-years 1–4) are significant.

**WARN — Gardner (BJS) level divergence (Pattern 47):**
BJS estimates are systematically ~0.146 units more negative than TWFE/CS-NT/SA across all periods (pre and post). Root cause is the dual-cohort structure's asymmetric first-stage sample; dynamics are preserved. This is a known pattern, not a coding error.

## Recommended actions

- **For the user (methodological judgement):** The strong pre-trends require explanation before the headline result can be taken at face value. The authors should explain (or the reader should check) whether the positive pre-trend reflects a real compositional change in the never-treated cohort (e.g., treated municipalities had rising baseline mortality before reform) or a data artefact of the dual-cohort panel construction.

- **For the user (scope of inference):** Trust the average and peak ATTs (post-years 1–4) more than the immediate first-year impact (t=0), which is insignificant. The -0.352 CS-NT average effect is the more credible summary statistic.

- **For the pattern-curator:** Confirm Pattern 47 (Gardner divergence in dual-cohort asymmetric untreated samples) is fully documented in `knowledge/failure_patterns.md` with the level-shift mechanism and the condition (asymmetric untreated sample in first-stage FE estimation).

- **No metadata update needed:** The specification is correctly implemented as documented.

## Rating derivation

| Axis | Score |
|---|---|
| Methodology (3 WARNs, 0 FAILs, from 3 active reviewers) | M-LOW (≥ 2 WARN) |
| Fidelity (paper-auditor: NOT_APPLICABLE — no PDF) | F-NA |
| Combined (M-LOW × F-NA → use methodology alone) | **LOW** |

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
