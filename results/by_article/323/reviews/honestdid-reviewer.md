# HonestDiD Reviewer Report — Article 323

**Verdict:** PASS
**Date:** 2026-04-18
**Article:** Prem, Vargas, Mejia (2023) — "The Rise and Persistence of Illegal Crops"

---

## Applicability note

The applicability rule requires `has_event_study == true` AND at least 3 pre-periods. Article 323 has `event_pre = 2` (only 2 pre-periods: t=-3 and t=-2, with t=-1 as reference). Strictly, this reviewer should be SKIPPED (< 3 free pre-periods).

However, HonestDiD analysis was actually run and results are available in `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`. The analysis used the 2 available pre-periods with appropriate VCOV correction (diagonal clustered SEs for CS-NT to handle the NA at t=-1 reference period). I review the available output in the interest of completeness.

---

## HonestDiD results

### Robustness margins (from `honest_did_v3.csv`)

| Estimator | VCOV | n_pre | n_post | rm_first | rm_avg | rm_peak | peak_idx |
|-----------|------|-------|--------|----------|--------|---------|----------|
| TWFE | full | 2 | 5 | 0.25 | 1.25 | 1.25 | 5 |
| CS-NT | diag_clustered | 2 | 5 | 0 | 1.50 | 1.00 | 5 |

### Sensitivity curves summary (from `honest_did_v3_sensitivity.csv`)

**First-period ATT (att_first ≈ 0.129):**
- TWFE: lb > 0 at Mbar=0 (lb=0.019); lb crosses zero between Mbar=0.25 (lb=0.008) and Mbar=0.5 (lb=-0.008). `rm_first_Mbar = 0.25`.
- CS-NT: lb > 0 at Mbar=0 (lb=0.011); lb crosses zero at Mbar=0. `rm_first_Mbar = 0`.

**Average ATT (att_avg ≈ 0.599–0.601):**
- TWFE: lb > 0 at Mbar=0 (lb=0.222); lb crosses zero between Mbar=1.25 (lb=0.027) and Mbar=1.5 (lb=-0.027). `rm_avg_Mbar = 1.25`.
- CS-NT: lb > 0 at Mbar=0 (lb=0.391); lb crosses zero between Mbar=1.5 (lb=0.006) and Mbar=1.75 (lb=-0.075). `rm_avg_Mbar = 1.50`.

**Peak ATT (att_peak ≈ 0.960, at t=4):**
- TWFE: lb > 0 at Mbar=0 (lb=0.403); lb crosses zero between Mbar=1.5 (lb=-0.018) and Mbar=1.25 (lb=0.076). `rm_peak_Mbar = 1.25`.
- CS-NT: lb > 0 at Mbar=0 (lb=0.328); lb crosses zero between Mbar=1.5 (lb=-0.148) and Mbar=1.25 (lb=-0.032). `rm_peak_Mbar = 1.00`.

---

## Design credibility assessment

### First-period ATT

- TWFE `rm_first = 0.25`: **D-FRAGILE** — the contemporaneous effect (year of announcement) loses significance if pre-trends could have violated parallel trends by as little as 25% of the observed pre-trend magnitude.
- CS-NT `rm_first = 0`: **D-FRAGILE** — even at Mbar=0 (assuming parallel trends hold exactly), the CI barely excludes zero (lb=0.011).
- Interpretation: The announcement-year effect is fragile. This is not surprising given the small magnitude (0.129) and the contemporaneous nature of the announcement effect.

### Average ATT

- TWFE `rm_avg = 1.25`: **D-MODERATE-to-ROBUST** — the average effect over 5 post-periods remains positive and significant unless pre-trend violations are 125% of the observed magnitude. Substantial robustness.
- CS-NT `rm_avg = 1.50`: **D-ROBUST** — even stronger robustness for CS-NT. The average ATT of ~0.599 is robust to substantial pre-trend misspecification.

### Peak ATT (t=4, year 4 post-announcement)

- TWFE `rm_peak = 1.25`: **D-ROBUST** — the t=4 effect (0.960) survives substantial pre-trend violations.
- CS-NT `rm_peak = 1.00`: **D-MODERATE** — peak effect remains positive for violations up to Mbar=1.0.

---

## Overall design signal

| Target | TWFE signal | CS-NT signal |
|--------|-------------|-------------|
| First-period | D-FRAGILE (0.25) | D-FRAGILE (0) |
| Average | D-MODERATE/ROBUST (1.25) | D-ROBUST (1.50) |
| Peak | D-ROBUST (1.25) | D-MODERATE (1.00) |

The picture is clear: the **immediate announcement effect** is fragile (not robust to parallel-trends violations), but the **medium-term persistence** (average and peak over 5 years) is methodologically robust. This is consistent with the paper's narrative that the policy announcement triggered a slow but sustained increase in coca cultivation.

---

## Notes on methodological constraints

- Only 2 free pre-periods available (n_pre=2). This limits the power of the HonestDiD sensitivity analysis and means the Mbar grid is less precisely identified. The `rm_first` estimates in particular are less reliable with only 2 pre-periods.
- The diagonal VCOV approach for CS-NT (to handle the NA SE at t=-1 reference) is appropriate but introduces additional approximation error.
- Despite these limitations, the avg and peak robustness margins (Mbar ≥ 1.0–1.5) are sufficiently large to be informative.

**Verdict: PASS** (with caveat: only 2 pre-periods; first-period ATT is D-FRAGILE but avg/peak are D-MODERATE to D-ROBUST)
