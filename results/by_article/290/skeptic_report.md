# Skeptic report: 290 -- Arbogast et al. (2022)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation; upgraded from LOW on 2026-04-19)*
**Design credibility:** FRAGILE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=WARN -- data-substitute 6%), csdid (impl=PASS -- CS-DID validated after allow_unbalanced fix), bacon (impl=PASS, TvT share=11.8%), honestdid (impl=PASS, M_avg=0, M_peak=0.25 TWFE), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF)

## Executive summary

Arbogast et al. (2022) study the effect of administrative burden in Medicaid enrollment processes on child Medicaid enrollment rates, using a staggered DiD design across 15 treated states with 12 distinct treatment cohorts over 2014-2020. The paper reports a headline TWFE estimate of -0.0172 (SE=0.0072) and a CS-DID ATT of -0.031.

A critical metadata fix on 2026-04-19 -- toggling allow_unbalanced from false to true -- resolved the previous CS-DID estimation failure. With all units retained (previously 13 states were dropped during panel-balancing, leaving cohorts too small for att_gt()), CS-NT simple ATT = -0.0298 (3.7% gap vs paper target -0.031) and CS-NYT = -0.0296. CS-DID now validates the TWFE direction and is within tolerance of the paper reported CS estimate. Our TWFE of -0.0182 remains 6% above the paper -0.0172, a documented data-substitute gap (IPUMS ACS not redistributable; replaced with Census/CMS/KFF reconstructed data) that is stable and explained.

The stored consolidated result is credible and can be used. The remaining methodological concern is a Design finding about the paper: SA pre-trends are highly significant at t=-4 (t-stat=-4.3) and t=-5 (t-stat=-5.3), and HonestDiD shows the average ATT loses significance at any non-zero smoothness allowance (Mbar=0.25). These are informative characterisations of the paper design credibility, not demerits against our reanalysis.

## Per-reviewer verdicts

### TWFE (WARN -- data-substitute gap)
- Point estimate -0.0182 vs paper -0.0172 (6% gap); within 10% tolerance. SE 0.00699 vs paper 0.0072 (2.9% gap). N=4085 vs 4086. Implementation PASS on fixed effects, clustering, and filter.
- The 6% gap is fully explained by the data-substitute note (IPUMS perwt sums vs Census table estimates) and is stable across re-runs. This is an Axis-1 Fidelity signal, not an Axis-2 implementation error.
- SA pre-trends highly significant (t=-5: t-stat=-5.3; t=-4: t-stat=-4.3). Monotonic negative drift across all 5 pre-periods in both TWFE and SA. Design finding (Axis 3).

Full report: reviews/twfe-reviewer.md

### CS-DID (PASS -- validated 2026-04-19)
- All CS-DID variants now estimate successfully with allow_unbalanced=true.
- CS-NT simple ATT = -0.0298 (SE=0.00637) -- 3.7% gap vs paper target -0.031. WITHIN_TOLERANCE.
- CS-NYT simple ATT = -0.0296 (SE=0.00657) -- directionally consistent, 4.5% gap. PASS.
- NT/NYT convergence: 0.8% -- very tight, consistent with large never-treated pool (~35 states).
- CS-NT pre-trends non-significant at all lags (|t-stat| < 1.5 throughout), unlike SA/TWFE.
- cs_controls=[] in metadata; doubly-robust with-controls cell returns zero (documented template behaviour with empty xformla, not an implementation error).

Full report: reviews/csdid-reviewer.md

### Bacon (WARN -- Design finding only; no Axis-2 concern)
- TVU (clean: Treated vs Untreated) = 88.2% -- very healthy. TvT forbidden share = 11.8%, below the 30% concern threshold.
- TVT share < 30% signals D-ROBUST on the forbidden-comparison dimension.
- Cohort heterogeneity: TVU estimates range from -0.062 (cohort 60) to +0.005 (cohort 67) -- 6.7pp spread relative to -0.018 aggregate. Design finding (Axis 3).
- WARN reflects Axis-3 cohort heterogeneity only; no Axis-2 implementation concerns in the Bacon run.

Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN -- Design finding)
- TWFE average ATT: robust at Mbar=0 only (CI=[-0.0086, -0.0016]); breaks at Mbar=0.25 (upper bound crosses zero). D-FRAGILE.
- TWFE peak ATT: survives to Mbar=0.25 (CI=[-0.0133, -0.0007]). D-MODERATE.
- CS-NT all targets: include zero even at Mbar=0. D-FRAGILE throughout.
- Given SA pre-trends with |t-stat|>4 at t=-4/-5, Mbar=0 is implausible; Mbar=0.25 is the relevant benchmark, at which TWFE average ATT loses significance.
- Design finding (Axis 3), not an implementation error.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption across 15 treated states, 12 cohorts. CS-DiD is the appropriate tool; de Chaisemartin adds no additional diagnostic value.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)
- No PDF at pdf/290.pdf. Fidelity axis is formally non-evaluable (F-NA).
- Metadata records paper targets: twfe_beta=-0.0172, csdid_att_simple=-0.031. Our stored TWFE=-0.0182 (6% gap) and CS-NT=-0.0298 (3.7% gap) are both within tolerance against these manually extracted targets.

Full report: reviews/paper-auditor.md

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | -0.0182 (SE=0.00699) | 0 / NA | FAIL_cs_empty_xformla (cs_controls=[] collapses DR estimator) |
| (B) both without controls | -0.0180 (SE=0.00669) | -0.0298 (SE=0.00637) | OK |
| (C) TWFE with, CS without -- current headline | -0.0182 (SE=0.00699) | -0.0298 (SE=0.00637) | OK |

Key ratios:
- Estimator margin, protocol-matched Spec (B): (-0.0180 - (-0.0298)) / |-0.0180| = +65.6% -- CS-DID is 66% larger in magnitude when both run without controls.
- Covariate margin, TWFE side: (-0.0182 - (-0.0180)) / |-0.0182| = 1.1% -- 8 state-level controls barely move the TWFE estimate.
- Covariate margin, CS side: not computable (Spec A CS returns zero due to empty cs_controls).
- Total gap, current headline (C): (-0.0182 - (-0.0298)) / |-0.0182| = 63.7%.

Verbal interpretation: The 66% estimator margin in Spec (B) confirms the TWFE vs CS-DID gap is driven by the estimator choice (differential cohort weighting), not by covariates. TWFE controls contribute only 1.1% to the estimate. The gap is a Bacon-coherent finding: equal-weighted CS-DID aggregation puts more weight on large-effect cohorts (cohort 60 ATT=-0.062) than TWFE variance-weighted averaging does.

## Material findings (sorted by severity)

**Design findings (Axis 3 -- informative about the paper; not demerits against our reanalysis):**
- SA pre-trends statistically significant at t=-4 (t-stat=-4.3) and t=-5 (t-stat=-5.3): a pre-existing downward enrollment trend predates treatment adoption and violates parallel trends at conventional significance levels for the SA estimator.
- HonestDiD average ATT (TWFE) loses significance at Mbar=0.25, a plausible smoothness allowance given observed SA pre-trends. The aggregate conclusion is fragile to moderate trend violations.
- Cohort heterogeneity: TVU estimates range -0.062 (cohort 60) to +0.005 (cohort 67). Aggregate TWFE (-0.018) and CS-DID (-0.030) mask substantial cross-cohort variation; some states show null or opposite-sign enrollment effects post-burden.
- CS-NT pre-trends individually non-significant (all |t-stat| < 1.5) but show the same monotonic negative drift as TWFE; CS-DID does not independently confirm fully clean parallel trends.

**WARN (Axis 1 -- Fidelity, documented and stable):**
- TWFE 6% gap vs metadata target (-0.0182 vs -0.0172): stable and fully explained by data-substitute (IPUMS perwt sums vs Census table estimates). No PDF for formal verification (F-NA). Not an implementation error.

## Recommended actions

- No action needed on CS-DID. The allow_unbalanced=true fix resolved the estimation failure. CS-NT = -0.0298 validates the paper -0.031 within 3.7%. The stored result is usable.
- For the user (methodological judgement): SA pre-trend violations at t=-4/-5 (|t-stat|>4) are substantial. Whether the original paper addresses this in its robustness section and whether a pre-trend-adjusted specification changes the conclusion is a substantive design question about the paper.
- For the user: CS-DID is 66% larger in magnitude than TWFE in the protocol-matched Spec (B). This estimand difference is driven by cohort weighting heterogeneity, not controls. CS-DID (-0.030) should be highlighted as the preferred robustness check; it aligns closely with the paper own CS-DID target (-0.031).
- No new pattern-curator entry needed: the argumento-comprimento-zero failure was already documented; this run confirms the resolution rule (allow_unbalanced=true when a short panel with many cohorts leaves cells too small after balancing).

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
