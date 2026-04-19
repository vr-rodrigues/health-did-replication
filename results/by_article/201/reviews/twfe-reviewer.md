# TWFE Reviewer Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** WARN

**Date:** 2026-04-18

## Checklist

### 1. Is TWFE the paper's primary specification?
NO. The paper's main estimator is Gardner (did2s). TWFE appears only in Appendix Table 10 as one of five robustness alternatives (Gardner, BJS, Wooldridge, Stacked DiD, TWFE). This is notable: the authors are already aware of heterogeneous-treatment-effects bias and deliberately use a bias-robust estimator as their primary specification.

### 2. Specification correctness
- Fixed effects: state (fips) + time (month×year) — correct two-way.
- Controls: 19 individual- and state-level covariates. Standard for this literature.
- Weight: ATUS final survey weights (wt06) — correct.
- Cluster: fips (state level) — appropriate given state-level treatment.
- Treatment variable: pslm_state_lag2 (2-year lag) — matches paper's specification exactly.
- Sample: hh_child==1 (households with children) — matches paper's stated sample.

### 3. Coefficient estimate
Our TWFE: 4.609 (SE=1.799). Paper's Gardner main result: 4.45 (SE=1.76). Our TWFE is directionally consistent with the paper's main result and numerically very close. The paper states TWFE results are "very similar" to Gardner results.

### 4. Pre-trend assessment
TWFE event study (monthly data, yearly-equivalent at h=-2 to h=-7 beyond reference):
- t=-2: -21.02 (SE=15.52) — large negative, but imprecise
- t=-3: +10.83 (SE=17.27)
- t=-4: -14.84 (SE=20.60)
- t=-5: -34.59 (SE=11.36) — large, borderline significant in magnitude
- t=-6: -31.15 (SE=15.12) — large
- t=-7: -4.27 (SE=8.71)
- t=-8: -14.59 (SE=6.26)

Pre-trends are noisy but show substantial variance. The paper acknowledges ATUS sample sizes are small and declining; the authors interpret pre-period coefficients as "relatively small in magnitude." This is defensible for the paper's Gardner event study (Figure 2 shows essentially flat pre-trends for Gardner), but the TWFE event-study pre-trends are more volatile. The 7 pre-period dummies spanning monthly data encoded as yearly-equivalent exhibit high noise.

### 5. Staggered heterogeneity concern
Standard TWFE with staggered adoption mechanically relies on "forbidden comparisons" (using already-treated units as controls). With 6 cohorts (2014, 2017, 2018, 2019, 2020, 2022) across 10 states, heterogeneous treatment effects across cohorts will contaminate the TWFE ATT. The Bacon decomposition (bacon.csv) confirms:
- Cohort 163 (2017, Treated vs Untreated): ATT=-3.97, weight=47.7% — largest weight
- Cohort 194 (2020, Treated vs Untreated): ATT=+10.12, weight=33.9%
- Cohort 228 (2022, Treated vs Untreated): ATT=-21.49, weight=10.4%
- Later vs Earlier Treated comparisons: weights ~0.4-1.6%, small but potentially negative-weight generating

The positive TWFE = 4.609 is driven by the large weight on Cohort 2020 (ATT=+10.12), which is plausibly confounded with COVID-19 (2-year lag maps a 2018 mandate adoption to 2020 activation period).

### 6. Controls availability for CS
WARN: The 19 TWFE controls (fam_med, pto_state, poverty, pop, female, age, etc.) are individual-level and state-level variables from the monthly ATUS microdata. When CS-DID is run on the yearly-collapsed panel, these controls become unavailable. This creates a specification mismatch between TWFE (with controls) and CS-NT (without controls). The CS-NT without controls estimates: simple=-1.92 (ns), dynamic=-3.04 (ns).

### 7. Sign reversal
TWFE=+4.61** vs CS-NT simple=-1.92 (ns). This is a material sign reversal. The TWFE positive effect is not confirmed by CS-DID. Given COVID contamination of Cohort 2020 in TWFE, the CS-NT result is arguably more credible for identifying the pure PSL mandate effect.

## Summary
WARN issued because:
1. TWFE positive estimate (+4.61) is driven by COVID-contaminated Cohort 2020 (ATT=+10.12, weight=34%); sign reversal relative to CS-NT is material.
2. TWFE pre-trends in event study are substantially non-flat (large negative coefficients at t=-5, t=-6), though this is partly a ATUS small-sample issue.
3. Staggered adoption with heterogeneous ATTs across cohorts (range: -21 to +10) creates substantial heterogeneity that TWFE cannot resolve.

Note: The paper itself is NOT naive — it uses Gardner as its primary estimator and explicitly acknowledges TWFE limitations. The WARN applies to the TWFE estimate in our stored results, not to the paper's overall methodology.

## Reference
Full data: `results/by_article/201/results.csv`, `results/by_article/201/bacon.csv`, `results/by_article/201/event_study_data.csv`
