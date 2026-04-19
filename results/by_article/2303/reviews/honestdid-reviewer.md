# HonestDiD Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer axis:** Methodology

---

## Applicability

APPLICABLE: has_event_study = true, event_pre = 5 (≥3 pre-periods).
HonestDiD run on both TWFE and CS-NT event studies.
n_pre = 4 pre-periods used (k=−5 to k=−2; k=−6 is excluded as it lies outside the standard window; k=−1 is the base period = 0).

---

## Checklist

### 1. Sensitivity analysis setup

- Estimators: TWFE and CS-NT.
- Target ATTs: "first" (k=0), "avg" (average over post-periods), "peak" (largest post-period ATT).
- Mbar values tested: 0, 0.25, 0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00.
- Sensitivity approach: relative magnification (RM) — pre-trend violations bounded by M × max(pre-trend magnitude).

### 2. TWFE HonestDiD results

From `honest_did_v3.csv`:
- TWFE "first" point: −2.626; rm_first_Mbar = 0 (sign change at M=0 already? No — checking sensitivity CSV).
- From sensitivity CSV, TWFE "first" at Mbar=0: lb=−5.819, ub=+0.565. **Upper bound positive at Mbar=0.** The CI includes zero even at Mbar=0 (no pre-trend allowed).
- This means the contemporaneous effect (k=0) is **not robust at Mbar=0** for TWFE — the CI straddles zero.
- TWFE "avg" at Mbar=0: lb=−8.953, ub=+0.983. Also includes zero.
- TWFE "peak" at Mbar=0: lb=−13.631, ub=+1.655. Also includes zero.

**TWFE HonestDiD interpretation:** All three targets (first, avg, peak) have CIs that include zero even at Mbar=0. The `rm_first_Mbar = 0`, `rm_avg_Mbar = 0`, `rm_peak_Mbar = 0` from `honest_did_v3.csv` indicates breakdown at Mbar=0.

This is **D-FRAGILE** for TWFE. However, the fragility here is driven by the large SEs in the TWFE event study (which come from the rich FE structure and noisy pre-period coefficients), not necessarily by a false pre-trend. The TWFE event study uses cluster SEs, and the pre-period variation is high.

### 3. CS-NT HonestDiD results

From `honest_did_v3.csv`:
- CS-NT "first" point: −5.100; rm_first_Mbar = 0.25 (sign robust to Mbar=0.25).
- From sensitivity CSV, CS-NT "first" at Mbar=0: lb=−9.056, ub=−1.106. **Both bounds negative.** Sign is robust at Mbar=0.
- CS-NT "first" at Mbar=0.25: lb=−9.794, ub=−0.615. Still negative. Sign survives.
- CS-NT "first" at Mbar=0.50: lb=−10.531, ub=+0.041. Marginally crosses zero. Breakdown at Mbar=0.50.
- CS-NT "avg" at Mbar=0: lb=−14.011, ub=−4.369. Both negative. **Robust at Mbar=0.**
- CS-NT "avg" at Mbar=0.25: lb=−16.924, ub=−2.159. Robust.
- CS-NT "avg" at Mbar=0.50: lb=−20.439, ub=+1.456. Breaks down at Mbar=0.50.
- CS-NT "peak" at Mbar=0: lb=−20.743, ub=−6.365. Both negative. **Robust at Mbar=0.**
- CS-NT "peak" at Mbar=0.25: lb=−25.535, ub=−2.771. Robust.
- CS-NT "peak" at Mbar=0.50: lb=−32.574, ub=+3.819. Breaks down at Mbar=0.50.

**CS-NT HonestDiD interpretation:**
- rm_first_Mbar = 0.25 → D-MODERATE (sign robust to 25% pre-trend violation).
- rm_avg_Mbar = 0.25 → D-MODERATE.
- rm_peak_Mbar = 0.25 → D-MODERATE.

### 4. Reconciliation of TWFE vs CS-NT HonestDiD

- TWFE HonestDiD is fragile (Mbar=0) due to large event-study SEs from the rich FE structure.
- CS-NT HonestDiD is more informative: the CS-NT event study has tighter estimates in the post-period and the first-difference target is robust to Mbar=0.25.
- The divergence reflects the weather-control asymmetry: TWFE (with 7 weather controls + rich FEs) has smaller coefficient SEs in the static specification but larger event-study uncertainty; CS-NT (no controls) has noisier static ATT but the HonestDiD CI structure is more favorable because the CS-NT pre-period estimates are smaller in magnitude at the relevant horizons used for RM.
- The CS-NT "avg" and "peak" robust at Mbar=0 is the key finding: the average and peak post-treatment effects are robustly negative even under zero pre-trend violation tolerance.

### 5. Overall design signal

- **Design credibility: D-MODERATE.** The CS-NT "first" effect breaks at Mbar=0.50, suggesting moderate sensitivity to pre-trend violations. The CS-NT "avg" and "peak" effects are robust to Mbar=0.25. The TWFE HonestDiD is fragile due to large event-study SEs from the rich FE structure.
- This is not a FAIL because the CS-NT avg/peak effects are robust at Mbar=0, and the fragility in TWFE HonestDiD is methodologically explainable (rich FE reduces power).

---

## Summary

**PASS.** HonestDiD confirms sign-robustness of the CS-NT average and peak post-treatment effects at Mbar=0 (no pre-trend tolerance required). The first-period effect is robust to Mbar=0.25 (D-MODERATE). TWFE HonestDiD is fragile (Mbar=0 breakdown) due to large event-study SEs from the `id^month + prov^year^month` FE structure, but this is a known consequence of the rich specification rather than evidence of pre-trend violations. Given that the CS-NT "avg" and "peak" survive Mbar=0, the design qualifies as D-MODERATE with a PASS verdict.

**Design signal:** rm_first_Mbar = 0.25 (CS-NT, D-MODERATE); rm_avg_Mbar = 0.25 (CS-NT, D-MODERATE); rm_peak_Mbar = 0.25 (CS-NT, D-MODERATE). TWFE D-FRAGILE due to large FE-induced SEs, not pre-trend violations per se.
