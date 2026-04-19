# HonestDiD Reviewer Report: Article 25 — Carrillo, Feres (2019)

**Verdict:** PASS
**Date:** 2026-04-18

## Setup
- Pre-periods available: t=-5, t=-4, t=-3, t=-2 (4 total; t=-1 omitted reference)
- n_pre used in HonestDiD: 3
- n_post: 5
- Estimators: TWFE and CS-NT

## Sensitivity Results

### TWFE
| Target | rm_Mbar | Interpretation |
|---|---|---|
| first (t=0 effect) | 0 | Not robust even at zero pre-trend change |
| avg (average post-ATT) | 1.0 | Robust through Mbar=1.0; breaks at 1.25 |
| peak (t=4: +0.1331) | 1.75 | Highly robust; breaks at Mbar=2.0 |

Key CIs (TWFE):
- avg Mbar=0: [+0.040, +0.059] — excludes zero
- avg Mbar=1.0: [+0.005, +0.093] — excludes zero (barely)
- avg Mbar=1.25: [-0.005, +0.096] — spans zero
- peak Mbar=1.75: [+0.007, +0.160] — excludes zero (barely)
- peak Mbar=2.0: [-0.010, +0.160] — spans zero

### CS-NT
| Target | rm_Mbar | Interpretation |
|---|---|---|
| first (t=0 effect) | 0 | Not robust even at zero pre-trend change |
| avg (average post-ATT) | 1.0 | Robust through Mbar=1.0; breaks at 1.25 |
| peak (t=4: +0.1127) | 1.5 | Robust through Mbar=1.5; breaks at 1.75 |

## Assessment

### 1. Contemporaneous Effect (first target)
- rm_first_Mbar = 0 for both TWFE and CS-NT
- Immediate effect at t=0 is small (+0.003 to +0.004) — CI spans zero even at Mbar=0
- NOT a concern: policy has gradual diffusion mechanism (physicians relocate over time)
- The relevant headline targets are avg and peak

### 2. Average ATT
- rm_avg_Mbar = 1.0 (both estimators) → D-MODERATE
- At Mbar=1.0: TWFE [+0.005, +0.093]; CS-NT [+0.001, +0.091] — both exclude zero (barely)
- Robust to realistic pre-trend assumptions (pre-trends max = 0.011 in abs value)

### 3. Peak ATT
- TWFE: rm_peak_Mbar = 1.75 → D-ROBUST
- CS-NT: rm_peak_Mbar = 1.5 → D-MODERATE-HIGH
- Strong robustness for the peak policy effect

### 4. Pre-Trends Context
- n_pre = 3 — sufficient for HonestDiD
- Pre-trend magnitudes ≤ 0.011 in absolute value — small scale
- Mbar=1.0 threshold represents a large buffer relative to observed pre-trends

### 5. Internal Consistency
- TWFE and CS-NT sensitivity results are consistent with each other
- rm_avg_Mbar identical (1.0); rm_peak_Mbar TWFE slightly more robust (1.75 vs 1.5)
- Growing effects pattern fully compatible with parallel trend extrapolation

## Design Signal
- D-MODERATE for avg ATT (rm_avg_Mbar = 1.0 → breaks at 1.25)
- D-ROBUST for peak ATT (TWFE rm_peak = 1.75; CS-NT rm_peak = 1.5)
- Overall design credibility: **D-MODERATE** (headline avg target)

## Key Findings
- Average ATT robust through Mbar=1.0 (D-MODERATE) for both TWFE and CS-NT
- Peak ATT highly robust through Mbar=1.75/1.5 (D-ROBUST)
- Contemporaneous effect fragility is expected given gradual policy mechanism
- HonestDiD consistent across TWFE and CS-NT specifications
- 3 pre-periods (sufficient); pre-trend magnitudes small (≤0.011)
