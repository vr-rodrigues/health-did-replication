# TWFE Reviewer Report — Article 60 (Schmitt 2018)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification alignment
- Paper uses: `areg lnprnonmed post lncmi pctmcaid lnbeds fp hhi sysoth i.year [aw=dis_tot], absorb(h) cluster(h) if indirect==0`
- Our implementation: TWFE with unit+year FE, 6 time-varying controls, aweights=dis_tot, cluster by h, sample filter `indirect==0`. PASS.
- Binary post-indicator treatment variable (`post`). Standard absorbing adoption. PASS.

### 2. Point estimate
- beta_twfe = 0.0702, SE = 0.0172, t-stat ≈ 4.09. Statistically significant positive price effect.
- No original numeric result stored in metadata (`original_result = {}`), so fidelity to paper is not auditable here. NOTE: paper-auditor axis is NOT_APPLICABLE.

### 3. Pre-trend assessment (TWFE event study, 4 pre-periods used; t=-5 is extra)
| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=-5 | -0.0006 | 0.0262 | -0.02 |
| t=-4 | -0.0587 | 0.0559 | -1.05 |
| t=-3 | -0.0264 | 0.0252 | -1.05 |
| t=-2 | +0.0057 | 0.0200 | +0.29 |

- No single pre-period exceeds |t|=1.65. Jointly the pre-trends show a downward tilt at t=-4/-3 (both ~-1.05) but with large SEs.
- The t=-4 coefficient (-0.059) is sizeable in absolute terms relative to the post-treatment effect (0.070), representing ~84% of the ATT in magnitude. This drift is flagged in the metadata notes as "slight pre-trend drift at h=-4."
- Verdict: individually insignificant but the systematic negative drift at h=-4 and h=-3 is a mild concern. Not a FAIL (no period exceeds |t|=2), but warrants a WARN under conservative interpretation.

### 4. Post-treatment path
- Coefficients at t=0,1,2,3,4: 0.042, 0.068, 0.067, 0.061, 0.057.
- Effect is immediate, peaks at t=1, and stabilizes — consistent with a real treatment effect, no evidence of mean-reversion or anticipation.

### 5. Controls
- 6 time-varying controls: lncmi, pctmcaid, lnbeds, fp, hhi, sysoth. All included as in original paper.
- No additional FEs beyond unit and year.
- Controls-vs-no-controls comparison: beta_twfe_with_ctrls=0.0702 vs beta_twfe_no_ctrls=0.0639. Gap of 10%, modest and expected direction. PASS.

### 6. Negative-weight risk
- Staggered adoption with 11 cohorts (2000–2010). TWFE aggregates across all cohorts using potentially negative weights.
- However, Bacon decomposition shows TVU weight = 93.8% and LvE/EvL weight only 6.2%. The forbidden-comparison contamination is very small.
- TVU weighted mean = 0.053, consistent with CS-DID estimates. Low negative-weight risk.

## Summary
TWFE implementation is faithful to the original specification. The pre-trend at t=-4 shows a -0.059 negative drift that is individually insignificant (t=-1.05) but warrants attention given its magnitude relative to the ATT. Post-treatment path is stable and plausible. Negative-weight contamination is minimal (LvE/EvL = 6.2%). Upgrade from FAIL to WARN: the pre-trend pattern is a mild methodological concern, not a fundamental flaw.

**Verdict: WARN** (pre-trend drift at t=-4; individually insignificant but pattern merits disclosure)
