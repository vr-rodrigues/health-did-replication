# TWFE Reviewer Report — Article 267
# Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** WARN

**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- Paper spec: `xtreg lnMMRt1 i.year quotaRes, fe cluster(ccode)` (country + year FE, no controls, clustered SE at country level).
- Stored TWFE beta = -0.0821278, SE = 0.0506623.
- Paper reports beta = -0.082, SE = 0.051.
- Difference: |(-0.0821278 - (-0.082))| / 0.051 = 0.025% of SE — exact match within numerical precision.
- **Specification fidelity: PASS.**

### 2. Staggered timing / heterogeneous treatment effects
- Design is staggered: 22 reserved-seat quota countries adopting 1989–2013 (effectively 7 cohorts within sample, gvar years: 2000, 2002, 2003, 2005, 2010, 2012, 2013).
- TWFE is subject to heterogeneity bias when treatment effects vary across cohorts or over time.
- Bacon decomposition confirms the problem: the "Treated vs Untreated" component shows mixed signs — cohorts 2002 (-0.095), 2003 (-0.354), 2000 (-0.154) are negative; cohorts 2012 (+0.159), 2010 (+0.084), 2005 (+0.102) are positive.
- Positive Bacon weights for later adopters imply that TWFE is attenuating the negative true effect: CS-NT ATT = -0.112 (36% larger in magnitude than TWFE -0.082).
- The sign problem is in the Treated vs Untreated component, with late adopters (2010, 2012, 2005) showing positive coefficients, consistent with late-adopter post-periods being used as controls for earlier cohorts (heterogeneous timing contamination).
- **Staggered timing bias: WARN — TWFE understates the ATT by approximately 27–36% relative to modern estimators.**

### 3. Pre-trends (TWFE event study)
- TWFE pre-period coefficients (relative to t=-1):
  - t=-6: -0.006 (SE=0.043) — not significant
  - t=-5: +0.014 (SE=0.026) — not significant
  - t=-4: +0.010 (SE=0.020) — not significant
  - t=-3: +0.013 (SE=0.017) — not significant
  - t=-2: +0.002 (SE=0.013) — not significant
- All pre-trends are small and statistically zero. **Pre-trends: PASS.**

### 4. Post-period dynamics
- Monotonically growing negative post-period effects: h=0 (-0.012), h=1 (-0.026), h=2 (-0.034), h=3 (-0.054), h=4 (-0.080), h=5 (-0.124).
- This gradual build-up is policy-plausible (political representation → health policy → maternal mortality takes time).
- Growing effects are consistent across all 5 estimators.
- **Post-period dynamics: PASS (plausible, consistent).**

### 5. Sample and clustering
- 178 countries in TWFE (full unbalanced panel), 119/178 balanced.
- Clustering at country level (ccode) — correct and consistent with paper.
- Only 22 treated clusters — this is a modest number for cluster-robust inference. With 22 treated and ~156 untreated, cluster-robust SE may be slightly liberal. Paper acknowledges this.
- **Clustering: marginal concern (22 treated clusters); not sufficient for FAIL.**

## Summary of findings
- TWFE exactly matches the paper's published coefficient (-0.082).
- Staggered timing contamination is confirmed: late-adopter Bacon components positive, attenuating the overall TWFE estimate.
- Pre-trends are clean.
- The WARN is driven by the known TWFE attenuation from heterogeneous timing (quantified by Bacon), not a misspecification of the TWFE itself.

## References to data
- `results/by_article/267/results.csv`: beta_twfe = -0.0821278
- `results/by_article/267/bacon.csv`: mixed Bacon signs confirming heterogeneity
- `results/by_article/267/event_study_data.csv`: TWFE pre/post coefficients
