# HonestDiD Reviewer Report — Article 347

**Verdict:** PASS (implementation) / D-FRAGILE (design finding)
**Date:** 2026-04-19
**Reviewer:** honestdid-reviewer

## Axis separation note
HonestDiD results are entirely a Design finding (Axis 3). The computation is correct. D-FRAGILE reflects properties of the paper's design, not our implementation.

## Applicability check
- `has_event_study == true`: YES
- `event_pre == 7` (>= 3 pre-periods): YES
- **Applicable.**

## Implementation check
- honest_did_v3.csv and honest_did_v3_sensitivity.csv present and correctly structured.
- Computed for both TWFE and CS-NT estimators across first/avg/peak targets at Mbar = 0, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0.
- **Implementation verdict: PASS.** HonestDiD computed correctly.

## Design findings (Axis 3)

### TWFE sensitivity (from honest_did_v3.csv)
| Target | ATT at Mbar=0 | rm_Mbar | Classification |
|--------|--------------|---------|----------------|
| first  | +0.105 (sign-reversed) | 0 (never robust) | D-FRAGILE |
| avg    | −0.184 | 0 (loses sig at 0.25) | D-FRAGILE |
| peak   | −0.414 | 0 (CI includes zero) | D-FRAGILE |

**Critical design finding:** The TWFE `first` target ATT = +0.105 — sign-reversed relative to the overall TWFE ATT of −0.174. First post-period CI at Mbar=0: [−0.092, +0.303]. Predominantly positive, never statistically significant for negative effect.

**avg ATT:**
- Mbar=0: CI = [−0.338, −0.028]. Excludes zero — marginally significant.
- Mbar=0.25: CI = [−0.465, +0.135]. Loses significance.
- rm_avg_Mbar = 0 to 0.25 range — D-FRAGILE.

**peak ATT:**
- Mbar=0: CI = [−0.891, +0.064]. Includes zero even at Mbar=0.
- rm_peak_Mbar = 0. D-FRAGILE.

### CS-NT sensitivity
| Target | ATT at Mbar=0 | rm_Mbar | Classification |
|--------|--------------|---------|----------------|
| first  | −0.235 | 0 (CI includes zero) | D-FRAGILE |
| avg    | −0.448 | 0 (loses sig at 0.25) | D-FRAGILE |
| peak   | −0.669 | 0 (loses sig at 0.25) | D-FRAGILE |

**avg ATT:** Mbar=0: CI = [−0.640, −0.255] (significant). Mbar=0.25: CI = [−1.115, +0.200] (loses significance). D-FRAGILE.
**peak ATT:** Mbar=0: CI = [−0.992, −0.350] (significant). Mbar=0.25: CI = [−1.659, +0.507] (loses significance). D-FRAGILE.

### Substantive interpretation
The first-period sign reversal (+0.105 TWFE) is consistent with a delayed treatment response: restaurants take time to post calories and consumers take time to adjust. However, this means the headline average ATT is sensitive to whether the first post-year is treated as a pre-trend violation or a genuine delayed effect. The result breaks at any M̄ > 0, confirming D-FRAGILE classification.

The CS-NT avg/peak ATTs are larger in magnitude (−0.448/−0.669 vs TWFE −0.174/−0.414) but equally fragile — both lose significance at Mbar=0.25.

## Overall HonestDiD assessment
**D-FRAGILE** — all targets (TWFE and CS-NT) lose significance at Mbar=0.25 or earlier; first-period estimate sign-reversed; design is sensitive to even small pre-trend violations.

**Verdict: PASS** (implementation correct) / Design credibility: **D-FRAGILE** (Axis 3 finding only — not an implementation failure)
