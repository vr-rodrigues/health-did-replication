# HonestDiD Reviewer Report — Article 263

**Article:** Axbard, Deng (2024) — "Informed Enforcement: Lessons from Pollution Monitoring in China"
**Reviewer:** honestdid-reviewer
**Date:** 2026-04-18

**Verdict:** WARN

---

## Applicability check
- `has_event_study == true`: PASS
- Pre-periods: t=-5, t=-4, t=-3, t=-2 (4 pre-periods excluding reference t=-1). Requirement: ≥3 pre-periods. PASS.
- HonestDiD data available: `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv` exist.

---

## Checklist

### 1. Pre-trend magnitude assessment (rm_*Mbar = 0 baseline)

From `honest_did_v3.csv`:

**TWFE (Mbar=0):**
- first: ATT=0.000801, CI=[-0.00129, 0.00291] — includes zero, borderline
- avg: ATT=0.002655, CI=[0.000791, 0.004532] — excludes zero, significant
- peak: ATT=0.004116, CI=[0.002065, 0.006152] — excludes zero, significant

**CS-NT (Mbar=0):**
- first: ATT=0.000588, CI=[-0.00134, 0.00251] — includes zero
- avg: ATT=0.001952, CI=[0.000349, 0.003540] — excludes zero
- peak: ATT=0.002794, CI=[0.000703, 0.004877] — excludes zero

At zero deviation (pure parallel trends), avg and peak targets are robust for both TWFE and CS-NT.

### 2. Sensitivity to pre-trend violations (Mbar sweep)

**TWFE — avg target (key test):**
- Mbar=0: CI=[0.000791, 0.004532] — positive, excludes zero
- Mbar=0.25: CI=[-0.000251, 0.005767] — crosses zero
- Mbar=0.5+: CI includes zero

The TWFE avg-ATT result is robust to Mbar=0 (no pre-trend violations) but breaks at Mbar=0.25 — meaning even a 25% violation of parallel trends in the pre-period relative to observed pre-trends would render the result insignificant.

**CS-NT — avg target:**
- Mbar=0: CI=[0.000349, 0.003540] — positive, excludes zero
- Mbar=0.25: CI=[-0.000150, 0.004371] — crosses zero
- Similar fragility to TWFE.

**TWFE — peak target:**
- Mbar=0: CI=[0.002065, 0.006152] — positive
- Mbar=0.25: CI=[-0.000234, 0.008366] — crosses zero at Mbar=0.25

**TWFE — first target:**
- Mbar=0: CI=[-0.00129, 0.00291] — already includes zero at baseline (t=0 estimate barely positive)
- The first-period effect is inherently uncertain.

### 3. Breakdown value assessment

The breakdown Mbar (smallest violation that renders the CI insignificant) is approximately 0.25 for the avg target in both TWFE and CS-NT. This means:

- The result is fragile to modest violations of parallel trends.
- If the pre-period trend violated parallel trends by 25% of the observed pre-trend magnitude, the average ATT would become statistically indistinguishable from zero.
- However, the pre-trend coefficients are very small in magnitude (max 0.0013 for TWFE at t=-3), so a 25% violation in absolute terms is tiny (~0.0003 additional slope).

### 4. Pre-trend quality

TWFE pre-periods (t=-5 to t=-2):
- All four coefficients are small and statistically insignificant.
- The largest is t=-3: 0.001306 (SE=0.001214), t-stat ≈ 1.08.
- No systematic pre-trend gradient visible.
- Pre-trend quality is good; the HonestDiD exercise bounds the inference rather than revealing a flaw.

CS-NT pre-periods (t=-5 to t=-2):
- All four coefficients are very small and insignificant (largest: 0.00058 at t=-3).
- Pre-trends are clean.

### 5. Conclusion on robustness

The HonestDiD analysis reveals a fragility: the avg-ATT result loses significance at Mbar≈0.25. However:
- The absolute magnitude of the breakdown violation is tiny (≈0.0003), because pre-trends are very small.
- The peak ATT is more robust in absolute terms (CI excludes zero up to Mbar≈0.25 as well).
- The result is consistent across TWFE and CS-NT.

The fragility at Mbar=0.25 is characteristic of a study where the effect is real but modest in magnitude, and the pre-period benchmark is low. This is a soft warning rather than a fatal flaw.

---

## Summary

HonestDiD analysis confirms clean pre-trends for both TWFE and CS-NT. At zero smoothness restriction (Mbar=0), the avg and peak ATTs exclude zero. However, the result breaks at Mbar=0.25 — a mild parallel trends violation would render results insignificant. This fragility is a concern but is contextualised by the very small absolute pre-trend magnitudes. The breakdown does not suggest the result is spurious; it reflects the inherent difficulty of proving parallel trends with a small effect size in a demanding FE specification.

**Verdict: WARN** (avg-ATT robust at Mbar=0 but fragile at Mbar=0.25; clean pre-trends but low breakdown tolerance due to small effect size)
