# CS-DID Reviewer Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Design context for CS-DID
- Treatment timing: single cohort, single adoption date (2007). All 28 treated provinces (top tertile of Transcrime Mafia Index) adopt simultaneously.
- For a single-cohort design, CS-DID collapses to a simple 2×2 DiD comparing the treated cohort to never-treated units across pre/post periods. There is no decomposition problem, no negative weighting from heterogeneous timing.
- This is the ideal setting for CS-DID: it provides a clean comparison group and unambiguous ATT identification.

### 2. Comparison group
- `run_csdid_nt = true` (never-treated comparison). The never-treated group consists of provinces with `mafia_n3 == 0` (bottom two tertiles of mafia index) that never adopt treatment.
- `run_csdid_nyt = false` — not-yet-treated not applicable (single cohort; no one is "not yet treated" after 2007 who later becomes treated).
- PASS: Correct comparison group given design.

### 3. ATT estimates
- att_csdid_nt (simple aggregate) = 0.04636 (SE = 0.01824)
- att_nt_simple = 0.04636 (SE = 0.01890)
- att_nt_dynamic = 0.04636 (SE = 0.01957)
- All three aggregation schemes return the same point estimate (0.04636), which is expected for a single cohort — there is only one group-time ATT, so simple, dynamic, and calendar-time aggregations are identical.
- PASS: Internal consistency of CS aggregations.

### 4. Comparison of CS-NT vs TWFE
- TWFE: 0.04053; CS-NT: 0.04636. Difference = +0.00583 (+14.4% relative).
- In a single-cohort design, TWFE and CS-DID should be numerically very close or identical if controls are the same. The small divergence here is attributable to the control covariate asymmetry: TWFE includes 18 controls; CS uses no controls (cs_controls = []).
- The unconditional CS-DID yields a slightly larger ATT than the covariate-adjusted TWFE. This is consistent — covariates that negatively correlate with treatment or positively correlate with outcome will shrink the TWFE estimate.
- PASS: Divergence is explainable and quantitatively modest.

### 5. Event study — CS-NT
- Pre-periods: t=-4: -0.0030 (SE 0.0171); t=-3: 0.0164 (SE 0.0185); t=-2: 0.0197 (SE 0.0170).
- Post-periods: 0.0164, 0.0315, 0.0336, 0.0526, 0.0608, 0.0745, 0.0551.
- CONCERN: Pre-period coefficients at t=-3 and t=-2 are 0.016 and 0.020 — non-trivial relative to the overall ATT of 0.046. While not statistically significant, they represent a rising pre-trend in treated provinces relative to never-treated. This pattern warrants caution.
- The t=-2 coefficient (0.0197, SE=0.0170) is 1.16 SE from zero — not individually significant, but noteworthy.
- WARN: CS pre-trends show a mild upward drift in t=-3, t=-2 that, while not individually significant, suggests possible anticipation or differential pre-trends between mafia and non-mafia provinces before 2007.

### 6. SA event study comparison
- SA coefficients are identical to CS-NT at all time points, as expected for a single-cohort design where SA reduces to CS.
- PASS: SA and CS-NT agree exactly.

### 7. Control variable asymmetry
- TWFE uses 18 controls; CS uses zero controls. This is a design choice documented in metadata.
- Implication: CS estimates do not condition on population, tourism, banking, social capital etc. These may confound the CS estimate if treated/control provinces differ on these dimensions.
- WARN: The absence of controls in CS estimation means the CS-NT ATT is less precisely identified than the TWFE estimate. Ideally, the CS estimation should include the same time-varying controls.

## Summary
CS-DID is well-specified for this single-cohort design. The ATT of 0.046 is directionally consistent with TWFE (0.041). SA and CS-NT agree exactly. Two WARN items: (1) mild pre-trend rise at t=-3, t=-2 in CS event study, and (2) absence of controls in CS estimation vs. rich controls in TWFE. Neither is a disqualifying concern for a single-cohort design, but both deserve mention.

**Overall: WARN**
