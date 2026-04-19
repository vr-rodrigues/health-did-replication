# TWFE Reviewer Report — Article 395 (Malkova 2018)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Point estimate fidelity
- Computed `beta_twfe = 1.09078`; metadata `original_result.beta_twfe = 1.091`.
- Absolute difference: 0.00022 (0.02%). **PASS.**

### 2. Standard error
- Computed `se_twfe = 0.4086`; metadata `se_twfe = 0.409`.
- Difference: 0.0004 (<0.1%). **PASS.**

### 3. Event study pre-trends (TWFE)
- Pre-trend coefficients: e=-6: +8.68, e=-5: +6.47, e=-4: +5.21, e=-3: +3.47, e=-2: +1.67.
- Monotonically decreasing toward zero at e=-1 (reference). This pattern looks like a pre-trend violation on the surface.
- **Critical context from design:** This is an all-eventually-treated design (82 oblasts, 2 cohorts: 1981 n=32, 1982 n=50). After 1982 ALL units are treated. TWFE year fixed effects for the post-period (1983-1986) are mechanically contaminated by treatment effects, causing the pre-period event-study dummies to absorb the post-treatment variation. This is a known artifact (documented in notes: "TWFE ES dummies explode (e+1=8.7, e+5=14.8)").
- Gardner event study for the same pre-periods shows flat pre-trends (-0.20 to +0.10), confirming no genuine pre-trend violation.
- **WARN:** Standard TWFE event-study diagnostics are misleading in this all-eventually-treated setting. Researchers relying solely on the TWFE event study would incorrectly conclude pre-trend failure.

### 4. Identification structure
- Staggered adoption, 2 cohorts (1981 and 1982), 82 units, 12 years (1975–1986).
- Treatment is absorbing and binary. Static ATT is identified from the timing difference between the two cohorts.
- The static TWFE estimate (1.09) is reliable per notes; it uses the pre-1981 period as baseline and the 1981-vs-1982 timing difference for identification.

### 5. Sample definition
- Sample filter: `Year >= 1975 & Year <= 1986` (12 years). No control units outside treated cohorts.
- Weight: `numwomen_79` (1979 female population count). Appropriate population weight.

### 6. Specification
- No controls. Unit and time FEs only. **PASS** (matches paper's baseline).

## Summary
The static TWFE ATT of 1.091 is correctly specified and reproduces the paper's result exactly. The event-study TWFE pre-trends show an explosive monotonic pattern that is entirely an artifact of the all-eventually-treated design (no clean post-period controls → contaminated year FEs → inflated pre-period dummies). Gardner's 2SLS pre-trends confirm the design is clean. The WARN reflects the misleading TWFE event-study pattern, not a genuine pre-trend violation.

**Verdict: WARN** (design artifact in event study; static ATT reliable)
