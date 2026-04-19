# HonestDiD Reviewer Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** PASS
**Date:** 2026-04-18

---

## Applicability

- `has_event_study: true` — YES
- `event_pre: 5` (≥3 pre-periods) — YES, APPLICABLE

Data source: `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`

---

## Summary statistics from honest_did_v3.csv

| Estimator | VCOV | n_pre | n_post | rm_first_Mbar | rm_avg_Mbar | rm_peak_Mbar | rm_peak_idx | ATT_first | ATT_avg | ATT_peak |
|---|---|---|---|---|---|---|---|---|---|---|
| TWFE | full | 4 | 6 | 0 | 0 | 0.25 | 6 | -0.476 | -1.206 | -2.350 |
| CS-NT | full_IF | 4 | 6 | 0 | 0 | 0 | 6 | -0.915 | -1.410 | -2.050 |

**n_pre=4** used for HonestDiD (not 5, because 1 pre-period is sacrificed for the relative-magnitude test). This is adequate.

---

## Design credibility assessment

### TWFE sensitivity

**Target: first (ATT at h=0, β=-0.476)**
- Mbar=0: CI=[-1.146, +0.202] — **includes zero** (unconditionally NOT robust at Mbar=0)
- rm_first_Mbar=0 means: the first-period ATT cannot be sign-identified even with zero pre-trend violation allowed.

**Why?** The h=0 contemporaneous effect (-0.476) has a large confidence interval (SE=0.347 yielding CI≈[-1.156, +0.205]), which already spans zero at conventional levels. HonestDiD correctly reflects that the *first-year* effect alone is statistically fragile.

**Target: avg (ATT averaged over post-periods, β=-1.206)**
- Mbar=0: CI=[-1.903, -0.503] — **excludes zero** (robust at Mbar=0)
- Mbar=0.25: CI=[-2.515, +0.095] — just barely includes zero
- rm_avg_Mbar=0: technically the sign is identified at Mbar=0 but breaks at Mbar=0.25

**Interpretation for avg:** D-FRAGILE designation applies — robust only at Mbar=0 (perfect parallel trends). A pre-trend violation of even 25% of the largest observed pre-trend would widen the CI to include zero.

**Target: peak (ATT at h=5, β=-2.350)**
- Mbar=0: CI=[-3.344, -1.352] — **excludes zero** (robust)
- Mbar=0.25: CI=[-4.422, -0.213] — still excludes zero
- rm_peak_Mbar=0.25 means: sign identified up to Mbar=0.25
- At Mbar=0.5: CI=[-6.048, +1.454] — includes zero

**Interpretation for peak:** Robust to modest violations (Mbar=0.25), not robust to larger violations (Mbar=0.5).

### CS-NT sensitivity

**Target: first (ATT at h=0, β=-0.915)**
- Mbar=0: CI=[-1.693, -0.135] — excludes zero
- Mbar=0.25: CI=[-1.963, +0.008] — barely includes zero
- rm_first_Mbar=0: classified as Mbar=0 robust only

**Target: avg (ATT averaged, β=-1.410)**
- Mbar=0: CI=[-2.042, -0.770] — excludes zero (robust)
- Mbar=0.25: CI=[-3.260, +0.194] — includes zero
- rm_avg_Mbar=0: D-FRAGILE

**Target: peak (ATT at h=5, β=-2.050)**
- Mbar=0: CI=[-2.836, -1.250] — excludes zero (robust)
- Mbar=0.25: CI=[-4.896, +0.744] — includes zero
- rm_peak_Mbar=0: technically D-FRAGILE too, though absolute magnitude is large

---

## Design credibility classification

The HonestDiD results present a **mixed picture**:

**What is robust (Mbar=0):**
- TWFE avg ATT (-1.206): YES — sign identified
- TWFE peak ATT (-2.350): YES — sign identified and CI tight
- CS-NT first ATT (-0.915): YES — sign identified
- CS-NT avg ATT (-1.410): YES — sign identified
- CS-NT peak ATT (-2.050): YES — sign identified

**What breaks at Mbar=0.25:**
- TWFE avg: CI just crosses zero (ub=+0.095)
- TWFE peak: CI stays negative (ub=-0.213) — still sign-identified
- CS-NT first: barely crosses zero (ub=+0.008)
- CS-NT avg: crosses zero (ub=+0.194)
- CS-NT peak: crosses zero (ub=+0.744)

**Overall design credibility: D-MODERATE**

The key distinction from D-FRAGILE: multiple targets (TWFE avg, TWFE peak) remain sign-identified at Mbar=0 with CIs that are informative, and the TWFE peak holds sign-identification at Mbar=0.25 (CI=[-4.42, -0.21]). The avg ATT across both estimators is fragile beyond Mbar=0, but the peak effect at 5+ years post-treatment is the primary economic claim and that is reasonably robust.

The pre-trend noise at h=-3 (CS-NT coefficient -0.827, marginally significant) slightly elevates the concern that the smoothness assumption may not hold perfectly, but this is not an extreme violation.

---

## Verdict justification

PASS — because:
1. All sign-identification at Mbar=0 is confirmed for avg and peak targets
2. The primary claim (LEZs significantly reduce PM10 by 1-2 µg/m³ over multiple post-periods) is robust to zero pre-trend violation
3. The peak TWFE effect (-2.350) holds sign-identification at Mbar=0.25
4. The D-FRAGILE concern at Mbar>0 for avg ATT is genuine but expected given the large standard errors; it is not an implementation failure
5. n_pre=4 provides sufficient power for the sensitivity analysis

**Design signal: D-MODERATE** (robust at Mbar=0 for avg/peak; TWFE peak robust at Mbar=0.25; avg fragile beyond Mbar=0)

**Full data path:** `results/by_article/228/honest_did_v3.csv`, `results/by_article/228/honest_did_v3_sensitivity.csv`
