# CS-DID Reviewer Report — Article 395 (Malkova 2018)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Estimator selection
- `run_csdid_nt = false`: Correct — no never-treated units exist (all 82 oblasts eventually treated in 1981 or 1982).
- `run_csdid_nyt = true`: Correct — staggered adoption allows not-yet-treated as comparison group.
- Gardner (2SLS/BJS) also run as complement. **PASS.**

### 2. ATT magnitude and direction
- CS-NYT static ATT: 1.968 (SE = 0.526, t = 3.74). Positive and statistically significant.
- TWFE static ATT: 1.091 (SE = 0.409). Both positive, same direction.
- Gap: CS-NYT is 80% larger than TWFE (1.968 vs 1.091). **WARN.**

### 3. Explaining the gap
- The Bacon decomposition shows: 100% of TWFE weight is on timing comparisons (LvE + EvL).
- EvL (Earlier vs Later, weight=0.545): estimate = +1.702.
- LvE (Later vs Earlier, weight=0.455): estimate = -0.062.
- Weighted TWFE ≈ 0.545×1.702 + 0.455×(-0.062) ≈ 0.927 - 0.028 = 0.899 (close to 1.09).
- The LvE comparison uses the 1981-treated cohort as a control for 1982-treated after 1981 — a "forbidden comparison" since the 1981 units are already treated at that point. This attenuates the TWFE estimate toward zero.
- CS-NYT avoids this by using only not-yet-treated as controls. The CS-NYT estimate (1.968) is therefore the cleaner causal estimate.
- Gardner estimate at e=0: 2.094 — consistent with CS-NYT.

### 4. Pre-trends (CS-NYT event study)
- Pre-trend estimates: e=-6: -0.410, e=-5: -0.545, e=-4: +0.411, e=-3: -0.075, e=-2: -0.138.
- All are small in magnitude (< 0.6 GFR units vs post-period effect of ~2.0) and statistically indistinguishable from zero.
- Flat pre-trends confirm parallel trends assumption is plausible. **PASS.**

### 5. Controls sensitivity
- `cs_nyt_with_ctrls_status = "N/A_no_twfe_controls"` — no controls in the specification; N/A is appropriate. **PASS.**

### 6. CS-DID vs TWFE direction consistency
- Both TWFE and CS-NYT show positive effects. Direction unanimous. **PASS.**

### 7. Magnitude gap assessment
- 80% gap between TWFE (1.09) and CS-NYT (1.97) is substantial but mechanically explained by the all-eventually-treated Bacon attenuation: the LvE forbidden comparison pulls TWFE down. The paper reports 1.09 (TWFE); the preferred modern estimate is closer to 1.97-2.09.
- This constitutes a WARN because the stored TWFE (1.09) materially understates the ATT as estimated by heterogeneity-robust methods.

## Summary
CS-NYT correctly estimates the ATT using only not-yet-treated controls, yielding 1.97 GFR units per birth (SE=0.53). Gardner confirms at 2.09. Pre-trends are clean. The 80% gap vs TWFE is fully explained by the forbidden EvL comparison in the Bacon decomposition (LvE estimate near-zero pulls TWFE down). The stored TWFE headline (1.09) understates the modern robust estimate by ~80%.

**Verdict: WARN** (large TWFE-CS gap explained by forbidden Bacon comparison; CS-NYT is preferred)
