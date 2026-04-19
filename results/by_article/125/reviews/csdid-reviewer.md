# CS-DID Reviewer Report — Article 125
**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Grouping variable construction
- `gvar_CS` constructed by identifying first year each state had `law==1`, then setting gvar=0 for never-treated.
- 5 distinct treatment cohorts: 2003, 2005, 2006, 2007, 2008. Never-treated states serve as comparison group for NT estimator.
- Construction logic appears correct.

### 2. CS-NT (never-treated) results
- ATT simple (no ctrls): +0.00200 (SE=0.01069) — positive, non-significant.
- ATT dynamic (no ctrls): -0.00888 (SE=0.00730) — negative, non-significant.
- ATT simple WITH controls: -0.03584 (SE=0.01602) — negative, marginally significant (|z|=2.24).
- ATT dynamic WITH controls: -0.02675 (SE=0.01515) — negative, |z|=1.77.

**Warning flag: The CS-NT estimate shifts dramatically from +0.002 (no controls) to -0.036 (with controls).** This is a factor-of-18 change in magnitude and a sign reversal. In a repeated-cross-section design, time-varying individual-level controls (`married`, `student`, `female`, `ur`, `povratio`) absorb composition shifts that are partially collinear with the treatment. This large control sensitivity in a RCS design is a known methodological issue (Pattern 25 / Pattern 24 class). The metadata intentionally sets `cs_controls=[]` to match the paper's preferred CS-DID spec (paper authors' note on sensitivity), but the stored consolidated result (`att_cs_nt_with_ctrls=-0.0358`) uses controls, which is the source of the reported -1,112% proportional shift from TWFE (-0.000452).

### 3. CS-NYT (not-yet-treated) results
- ATT simple (no ctrls): -0.00227 (SE=0.00816).
- ATT dynamic (no ctrls): -0.00682 (SE=0.00729).
- ATT simple WITH controls: -0.03491 (SE=0.01665).
- ATT dynamic WITH controls: -0.02640 (SE=0.01669).
- Same pattern: large shift upon adding controls.

### 4. NT vs NYT comparison
- Without controls, NT and NYT are nearly identical (±0.005 range, all non-significant).
- With controls, both show ~-0.035 (marginally significant). The parallel shift suggests the controls are absorbing a time-varying composition effect common to the RCS sample.

### 5. Pre-trend assessment (event study)
- CS-NT pre-periods (t=-4 to t=-2): -0.00033, -0.00749, -0.00613. All small and non-significant (max |coef| = 0.0075).
- CS-NYT pre-periods: -0.00111, -0.00662, -0.00638. Similar pattern.
- No systematic pre-trend detected for either estimator without controls.

### 6. RCS-specific concerns
- Data is a repeated cross-section at individual level. CS-DID in this setting aggregates individual-level observations to cohort-year cells. The `bjs_aggregate_to_panel=true` flag handles this.
- The large control-sensitivity gap is the dominant concern, not pre-trends or estimator mechanics.

### 7. Interpretation of proportional shifts
- The -1,112% proportional shift flagged in consolidated results reflects the CS-NT-with-controls estimate (-0.0358) relative to the TWFE (-0.000452). This ratio is misleading because the denominator is effectively zero. The paper's metadata notes explicitly state "The +1865% ratio is meaningless (both ≈0)."
- The correct interpretation: all estimators (TWFE, CS-NT no-ctrls, CS-NYT no-ctrls) return estimates indistinguishable from zero. The with-controls CS estimates appear to find a negative effect, but this is driven by control-variable collinearity in the RCS structure.

## Summary
CS-DID mechanics are correctly implemented. Pre-trends are clean. The WARN is issued solely for the large and unexplained divergence between no-controls (+0.002) and with-controls (-0.036) CS-NT estimates in a RCS design — a factor-18 sensitivity that warrants scrutiny. The base (no-controls) CS estimates confirm the paper's null finding.

**Verdict: WARN**
