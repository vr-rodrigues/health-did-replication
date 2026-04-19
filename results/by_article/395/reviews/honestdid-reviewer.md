# HonestDiD Reviewer Report — Article 395 (Malkova 2018)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability
- `has_event_study = true`, `event_pre = 5` (≥ 3 pre-periods). **Applicable.**
- Note: event study truncated to e ≤ 0. After 1982, all units are treated and post-period event study is contaminated. Pre-periods e=-5 through e=-1 (5 free pre-periods with e=-1 as reference, so 4 informative pre-periods).

### 2. TWFE HonestDiD results
- `rm_first_Mbar = 0, rm_avg_Mbar = 0, rm_peak_Mbar = 0`: The TWFE CI at Mbar=0 is [-1.379, +1.992] — **includes zero**. Not robust to any pre-trend deviation.
- At Mbar=0.50: [-3.116, +2.299]. Wider, still includes zero.
- **Design signal: D-FRAGILE** for TWFE.
- Critical caveat: The TWFE pre-trend coefficients are contaminated artifacts of the all-eventually-treated design (inflated TWFE event study dummies from contaminated year FEs). The HonestDiD sensitivity for TWFE is computed on these contaminated pre-trends, making the TWFE HonestDiD uninformative.

### 3. CS-NYT HonestDiD results
- `rm_first_Mbar = 1.5, rm_avg_Mbar = 1.5, rm_peak_Mbar = 1.5`.
- At Mbar=0: CI = [+1.210, +3.012] — **excludes zero**. Effect is robust even under the assumption of no pre-trend deviation.
- At Mbar=0.25: [+1.138, +3.121] — excludes zero.
- At Mbar=0.50: [+1.046, +3.263] — excludes zero.
- At Mbar=0.75: [+0.901, +3.466] — excludes zero.
- At Mbar=1.00: [+0.701, +3.703] — excludes zero.
- At Mbar=1.25: [-0.192, +4.191] — lb crosses zero (sign loss at this threshold).
- At Mbar=1.50: [-0.495, +4.494] — includes zero.
- **Design signal: D-MODERATE** (robust to Mbar=1.0; sign loss at 1.25).

### 4. Sensitivity interpretation
- The CS-NYT HonestDiD is the relevant diagnostic because the TWFE event-study pre-trends are artifactually contaminated (design artifact, not genuine violation).
- Under the CS-NYT pre-trends (which are clean: max magnitude ~0.54 GFR units), the HonestDiD shows the effect is robust to violations of size up to 1× the pre-trend slope. This is meaningful robustness for a design with flat pre-trends.
- The TWFE HonestDiD at Mbar=0 includes zero, which is uninformative given that the TWFE pre-trends themselves are contaminated artifacts.

### 5. Pre-trend quality
- CS-NYT pre-trends: e=-6: -0.410, e=-5: -0.545, e=-4: +0.411, e=-3: -0.075, e=-2: -0.138. Max absolute value ~0.55 GFR. Post-period effect ~1.97. Pre-trend-to-effect ratio ≈ 0.28 — modest.
- Gardner pre-trends confirm: e=-6: +0.050, e=-5: -0.196, e=-4: +0.100, e=-3: +0.013, e=-2: -0.028. All <0.20 GFR. Very clean.

### 6. Verdict justification
- TWFE HonestDiD is uninformative (D-FRAGILE) but the reason is the design artifact, not a genuine sensitivity failure.
- CS-NYT HonestDiD is robust to Mbar=1.0 (D-MODERATE). The effect holds under meaningful pre-trend violations.
- WARN is warranted because (a) the TWFE HonestDiD shows D-FRAGILE and (b) sign loss occurs at Mbar=1.25 for CS-NYT, which is above 1× the observed pre-trends but not comfortably above.

## Summary
TWFE HonestDiD is D-FRAGILE due to contaminated all-eventually-treated event-study dummies — not a genuine pre-trend failure. CS-NYT HonestDiD is D-MODERATE: effect is positive and significant at Mbar=0 through Mbar=1.0, with sign loss at Mbar=1.25. Gardner pre-trends confirm the underlying design is clean. The WARN reflects the need to rely on CS-NYT rather than TWFE for valid HonestDiD inference.

**Verdict: WARN** (TWFE HonestDiD uninformative due to design artifact; CS-NYT D-MODERATE robust to Mbar=1.0)
