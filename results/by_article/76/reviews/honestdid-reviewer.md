# HonestDiD Reviewer Report — Article 76 (Lawler & Yewell 2023)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability check
- `has_event_study`: true — YES
- Pre-periods available: 4 (t = -5, -4, -3, -2, relative to t=-1 reference) — ≥3 — YES
- APPLICABLE.

## HonestDiD sensitivity analysis summary

Data from `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`.

### Key statistics (Mbar = 0, i.e., zero pre-trend violation assumed)

| Estimator | Target | Point est | 95% CI (Mbar=0) |
|-----------|--------|-----------|-----------------|
| TWFE | first period (t=0) | +0.00422 | [-0.0173, +0.0258] |
| TWFE | avg post-treatment | +0.0343 | [+0.0109, +0.0577] |
| TWFE | peak (t=2) | +0.0548 | [+0.0347, +0.0749] |
| CS-NYT | first period (t=0) | -0.000139 | [-0.0269, +0.0264] |
| CS-NYT | avg post-treatment | +0.0209 | [-0.000222, +0.0420] |
| CS-NYT | peak (t=3) | +0.0496 | [+0.0156, +0.0831] |

### Robustness thresholds (Mbar at which CI first includes zero)

**TWFE:**
- **First period target**: Mbar=0 already has CI straddling zero ([-0.0173, +0.0258]). The first-period effect is statistically fragile even under the no-violation assumption.
- **Average ATT target**: Robust at Mbar=0 (CI = [+0.0109, +0.0577], excludes zero). Loses robustness at Mbar≈0.25 (CI at Mbar=0.25: [+0.0041, +0.0621]) and by Mbar=0.5, CI = [-0.0075, +0.0722] includes zero. `rm_avg_Mbar = 0.25` (from honest_did_v3.csv header column).
- **Peak ATT target**: Robust at Mbar=0 (CI = [+0.0347, +0.0749], excludes zero). At Mbar=0.25: [+0.0272, +0.0799]; at Mbar=0.5: [+0.0147, +0.0915]; at Mbar=0.75: [-0.0006, +0.1065] — first includes zero. `rm_peak_Mbar = 0.5`.

**CS-NYT:**
- **First period target**: Mbar=0 CI includes zero — not robust.
- **Average ATT target**: Mbar=0 CI = [-0.000222, +0.0420] barely includes zero. `rm_avg_Mbar = 0` — the average ATT is fragile even with zero pre-trend violation assumption.
- **Peak ATT target**: Mbar=0 CI = [+0.0156, +0.0831], excludes zero. At Mbar=0.25: [-0.000348, +0.0998] — barely includes zero. `rm_peak_Mbar = 0.25`.

### Pre-trend inspection (key input to HonestDiD)
TWFE pre-periods:
- t=-5: +0.00195 (SE 0.00778)
- t=-4: +0.00631 (SE 0.00559)
- t=-3: +0.00109 (SE 0.01020)
- t=-2: -0.00178 (SE 0.00755)

The pre-trends show a slight upward drift from t=-5 to t=-4, then decline. No pre-period coefficient exceeds 1.2× its SE. Visually flat, though the Mbar=0 sensitivity analysis uses the full pre-trend vector to bound post-treatment violations.

CS-NYT pre-periods show a more notable pattern:
- t=-4: +0.0207 (SE 0.0062) — approximately 3.3 SEs — this is the main concern.
- This elevated pre-period is the reason CS-NYT is less robust than TWFE.

### Assessment

**TWFE HonestDiD:**
- The aggregate average ATT is robust only to Mbar=0.25 (a modest restriction — violations in post-treatment trends can be at most 25% of the maximum pre-trend deviation).
- The peak effect (t=2) is robust to Mbar=0.5 — moderate robustness.
- The first-period effect is not identified even at Mbar=0.

**CS-NYT HonestDiD:**
- The average ATT is fragile at Mbar=0 (CI barely includes zero).
- The peak is fragile at Mbar=0.25.
- This is driven by the elevated CS-NYT pre-period at t=-4.

### WARN rationale
The TWFE average ATT loses robustness at Mbar=0.25 — a low threshold suggesting the design provides moderate but not strong support against violations of parallel trends. The CS-NYT estimator shows a statistically concerning pre-period (t=-4 ≈ 3.3 SE), making the CS-NYT sensitivity bounds additionally fragile. While the peak effect remains robust to Mbar=0.5, the overall design credibility is D-MODERATE: the headline result depends on assuming that post-treatment trend violations are at most ~25% of the largest pre-treatment deviation.

**Verdict: WARN** (average ATT robust only to Mbar=0.25; CS-NYT avg fragile at Mbar=0; elevated t=-4 pre-period in CS-NYT)
