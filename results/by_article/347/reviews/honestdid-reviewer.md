# HonestDiD Reviewer Report — Article 347

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

## Applicability check
- `has_event_study == true`: YES
- `event_pre == 7` (>= 3 pre-periods): YES
- **Applicable.**

## Data source
- `honest_did_v3.csv`: sensitivity breakpoints (rm_Mbar values at which CI crosses zero).
- `honest_did_v3_sensitivity.csv`: full sensitivity table for TWFE and CS-NT across 3 targets (first, avg, peak) at Mbar = 0, 0.25, ..., 2.0.

## Results summary

### TWFE sensitivity (from honest_did_v3.csv)
| Target | rm_Mbar | ATT |
|--------|---------|-----|
| first | 0 | 0.105 (positive! wrong sign) |
| avg | 0 | -0.184 |
| peak | 0 | -0.414 |

**Critical finding:** The TWFE `first` target ATT at Mbar=0 (original HonestDiD output) = +0.105. This is **sign-reversed** relative to the overall TWFE ATT of -0.174. This indicates the first post-period effect in the event study is positive (or near-zero) and the average effect accumulates negative over time (growing effect pattern). This is consistent with a delayed treatment response, but raises a concern about the immediate first-period estimate.

### TWFE sensitivity table (from honest_did_v3_sensitivity.csv)
**Target: first**
- Mbar=0: CI = [-0.092, +0.303]. **Includes zero and is predominantly positive.**
- Mbar=0.25: CI = [-0.124, +0.364]
- Mbar=1.0: CI = [-0.234, +0.551]
- WARN: First-period effect is not robust at any Mbar value tested.

**Target: avg**
- Mbar=0: CI = [-0.338, -0.028]. **Excludes zero at Mbar=0.**
- Mbar=0.25: CI = [-0.465, +0.135]. Loses significance.
- **rm_avg_Mbar = 0 to 0.25 range — D-FRAGILE.**

**Target: peak**
- Mbar=0: CI = [-0.891, +0.064]. Includes zero.
- **rm_peak_Mbar = 0. D-FRAGILE.**

### CS-NT sensitivity
**Target: first**
- Mbar=0: CI = [-0.616, +0.145]. Includes zero.
- rm_first_Mbar = 0.

**Target: avg**
- Mbar=0: CI = [-0.640, -0.255]. Excludes zero.
- Mbar=0.25: CI = [-1.115, +0.200]. Loses significance.
- rm_avg_Mbar = 0 to 0.25. D-FRAGILE.

**Target: peak**
- Mbar=0: CI = [-0.992, -0.350]. Excludes zero.
- Mbar=0.25: CI = [-1.659, +0.507]. Loses significance.
- rm_peak_Mbar = 0 to 0.25. D-FRAGILE.

## Overall HonestDiD assessment
- **WARN (TWFE avg):** D-FRAGILE. The average ATT is significant only at Mbar=0 (exactly parallel pre-trends). Any deviation loses significance.
- **WARN (TWFE first):** First-period estimate is positive and not robust at any Mbar. Suggests initial null/positive effect before lagged negative impact accumulates.
- **WARN (CS-NT avg/peak):** D-FRAGILE — same structure, even more pronounced.
- The event study may show delayed treatment onset, which is substantively plausible (restaurants need time to post calories and consumers need time to adjust behavior) but it means the average ATT is sensitive to pre-trend assumptions.

## Design classification
**D-FRAGILE** — results robust only at Mbar=0 for avg/peak targets; first-period estimate sign-reversed.

**Verdict: WARN** (D-FRAGILE; avg ATT loses significance at any Mbar > 0; first-period positive)
