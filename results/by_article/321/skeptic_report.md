# Skeptic report: 321 — Xu (2023)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A — single timing), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

## Executive summary

Xu (2023) estimates that towns with Indian district magistrates (DMs) in 1918 experienced roughly 14% lower pandemic mortality (TWFE beta=-0.142, SE=0.041, t=-3.47, p<0.01; source: Table 2, Column 3). All three applicable methodology reviewers return WARN, yielding a methodology score of M-LOW. The primary concern is a persistent and statistically significant pre-trend: event-study coefficients at t=-4 and t=-3 are both statistically significant (|t|>2.6) in the TWFE, and three consecutive pre-periods (t=-4, t=-3, t=-2) are significant in CS-DiD, raising a genuine parallel trends violation. HonestDiD confirms the fragility: the average ATT loses robustness at Mbar=0.25 for both estimators — a Mbar value directly implied by the observed pre-trend magnitudes (~0.11-0.16 log points). CS-NT is directionally consistent (-0.110) but loses statistical significance and is 22% smaller than TWFE. The Gardner/BJS estimator is additionally attenuated (peak estimate -0.221 vs TWFE -0.312 at t=1). The stored TWFE value reproduces the paper's Table 2 col 3 exactly, but the fidelity axis is F-NA (no PDF). Users should treat the stored consolidated result with caution: the direction of the effect is plausible and consistent across estimators, but the magnitude and significance are not robust to pre-trend violations of realistic magnitude.

## Per-reviewer verdicts

### TWFE (WARN)
- TWFE beta=-0.142352 reproduces paper's -0.142 within 0.02% — exact match.
- Pre-trend coefficients at t=-4 (-0.155, t=-2.87) and t=-3 (-0.149, t=-2.66) are statistically significant, violating the parallel trends assumption underlying the TWFE estimator.
- Gardner/BJS event-study estimates are systematically attenuated vs TWFE (t=0: -0.082 vs -0.180; t=1: -0.221 vs -0.312), suggesting TWFE picks up level differences correlated with pre-treatment outcome trajectory.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT=-0.110 (SE=0.079, t=-1.40) — directionally consistent but 22% smaller than TWFE and not statistically significant.
- Three of four CS-NT pre-period coefficients are statistically significant (t=-4: t=-2.20; t=-3: t=-2.23; t=-2: t=-2.15), a stronger pre-trend signal than TWFE.
- Loss of significance in CS-NT (despite same direction) means the causal claim depends heavily on the TWFE specification, which itself has pre-trend concerns.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single treatment timing — no staggered adoption, no Bacon decomposition applicable.
- No negative-weighting concern from heterogeneous treatment timing.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE avg ATT: rm_Mbar=0.25 (D-FRAGILE) — robust only to 0.25 units of pre-trend deviation; breaks at Mbar=0.50.
- CS-NT avg ATT: rm_Mbar=0.25 (D-FRAGILE) — same fragility threshold.
- Peak ATT is more robust: TWFE rm_peak_Mbar=0.75 (D-MODERATE); CS-NT rm_peak_Mbar=0.50.
- Given observed pre-trend magnitudes of 0.11-0.16 log points, the realistic Mbar is right at the threshold where average effects become non-robust.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary treatment with single timing. The de Chaisemartin & D'Haultfoeuille estimator adds no additional information for this design type.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF (`pdf/321.pdf` not found). Numerical fidelity against the published paper cannot be formally verified. Metadata records original beta=-0.142 / SE=0.041; stored results match within 0.02% — would be EXACT if verifiable.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

- **[WARN — Pre-trends, structural]** Three of four CS-NT pre-period coefficients statistically significant (t=-4, t=-3, t=-2 all |t|>2.2); two TWFE pre-periods significant (t=-4, t=-3). This is the primary credibility-undermining finding. Pre-treatment differences in log-mortality trajectories between Indian-DM and non-Indian-DM towns are not consistent with parallel trends.
- **[WARN — Sensitivity fragility]** HonestDiD avg ATT loses robustness at Mbar=0.25 for both TWFE and CS-NT. With observed pre-trend magnitudes of 0.11-0.16, Mbar=0.25 is a realistic upper bound, placing the average ATT in D-FRAGILE territory.
- **[WARN — Estimator divergence]** CS-NT ATT=-0.110 (not sig) vs TWFE=-0.142 (sig). Gardner/BJS avg post-period estimate (~-0.10 to -0.15) also weaker than TWFE. The significance of the paper's headline result depends on the parametric TWFE specification.

## Recommended actions

- **For the repo-custodian agent**: Flag this paper as having substantive pre-trend concerns in the metadata (`notes` field). Consider adding `"pre_trend_warning": true` to the metadata.
- **For the pattern-curator**: Examine whether the pre-trend pattern (significant dip at t=-3/-4, partial recovery at t=-2) is consistent with a confounding event affecting Indian-DM towns in the years immediately before 1918 (e.g., differential recruitment of ICS officers, pre-existing mortality differentials). Consider adding a pattern for "single-cohort DiD with persistent significant pre-trends where CS-NT confirms the pre-trend signal."
- **For the user (methodological judgement call)**: The direction of the effect is consistent across all estimators (all negative), and the peak effect at t=1 is robust to Mbar=0.75 under HonestDiD. However, the average ATT is fragile. Before relying on the headline -14% figure, investigate whether any pre-1918 event could create differential trends between Indian-DM and non-Indian-DM towns. If the paper does not provide a compelling explanation for the pre-trends, the causal interpretation is at risk.
- **For the user**: The stored TWFE result (-0.142) should be flagged as LOW credibility in any meta-analysis or comparative table, noting that the pre-trend concern is the binding constraint, not staggered-timing or negative weighting.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
