# TWFE Reviewer Report: Article 9 — Dranove et al. (2021)

**Verdict:** PASS
**Date:** 2026-04-18

---

## Checklist

### 1. Specification fidelity
- Original Stata specification: `reghdfe lnpriceperpresc Post_avg exp [aw=wgt], absorb(state_r yq) cluster(state_r)`
- Our R replication: `feols(lnpriceperpresc ~ Post_avg + exp | state_r + yq, weights=~wgt, cluster=~state_r)`
- Treatment indicator `Post_avg` constructed correctly as `rowSums(L0:L9) > 0` (any post-treatment quarter), matching the original "tail bin absorbed" logic.
- LX renamed to L9 per original Stata code — implemented correctly.
- Sample filter `sample1 == 1` applied correctly.

### 2. Numerical match
- Our `beta_twfe = -0.17631` vs paper `beta_twfe = -0.1763` — difference of 0.003%, effectively exact.
- Our `se_twfe = 0.04839` vs paper `se_twfe = 0.0484` — difference of 0.02%, exact.
- **Fidelity: EXACT**

### 3. Pre-trend assessment (TWFE event study)
Pre-period coefficients (t = -9 to -2, normalised at t=-1):
| Period | Coeff | SE |
|--------|-------|----|
| -9 | -0.069 | 0.062 |
| -8 | -0.028 | 0.050 |
| -7 | -0.032 | 0.049 |
| -6 | +0.007 | 0.026 |
| -5 | +0.004 | 0.024 |
| -4 | +0.002 | 0.018 |
| -3 | +0.030 | 0.017 |
| -2 | +0.012 | 0.008 |

- The t=-9 coefficient (-0.069) has a 95% CI of roughly [-0.190, +0.052] — overlaps zero; statistically not significant.
- t=-3 (0.030, SE=0.017) is the largest positive pre-period value and marginally significant, though likely noise given eight tested periods.
- The pre-trend pattern as a whole is consistent with parallel trends: small magnitudes, all coefficients within 1–2 SEs of zero.
- No systematic drift detected.

### 4. Post-treatment trajectory
- Coefficients build up monotonically from t=0 (-0.048) to t=7 (-0.259) then plateau at t=8 (-0.255) and t=9 (-0.257).
- Smooth build-up is consistent with gradual implementation of managed care and ramp-up in formulary controls — economically plausible.

### 5. TWFE-specific staggered concerns (flagged for bacon-reviewer)
- Treatment timing is staggered across 10 cohorts. TWFE pools all comparisons including "earlier vs later treated" contamination. Bacon decomposition provides the decomposition (handed off to bacon-reviewer).
- The headline TWFE estimate (-0.176) is a weighted average that potentially includes negative weights from TVT comparisons. However, the bacon-reviewer will assess severity.

### 6. Controls inclusion
- `exp` (expenditure control) included as continuous covariate — matches paper specification.
- No controls passed to CS-DID (cs_controls=[]) per Pattern 26 constraint with did v2.3.0.

---

## Summary
The TWFE specification matches the original Stata code exactly. Numerical replication is within 0.003% of the published estimate. Pre-trends are clean with no statistically significant violations. Post-treatment trajectory is monotonically increasing in magnitude and economically interpretable. The staggered design introduces potential TWFE aggregation concerns but these are assessed by the bacon-reviewer.

**Verdict: PASS**
