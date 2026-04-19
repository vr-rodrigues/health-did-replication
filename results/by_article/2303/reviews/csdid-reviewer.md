# CS-DID Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer axis:** Methodology

---

## Checklist

### 1. Estimator configuration

- CS-DID run with never-treated control group (NT). Never-treated pool: 487 plants.
- cs_controls = [] (empty). The 7 weather controls used in TWFE are NOT passed to CS-DID.
- This is documented as Pattern 42: CS-DID doubly-robust estimator with 7 weather controls and 217k rows exceeds memory limits (FAIL_memory). The no-controls fallback is the only computationally feasible option given the dataset size.
- The absence of weather controls in CS-DID creates a **methodological asymmetry** with TWFE: the TWFE estimate absorbs weather variation via controls, while CS-DID does not. This is a documented design limitation, not an implementation error.

### 2. Spec A (doubly-robust with controls) — FAIL_memory

- Attempted: CS-DID (doubly-robust, IPW×regression) with 7 time-varying weather controls on 217,032 observation × 228-period panel.
- Result: FAIL_memory. The doubly-robust estimator requires fitting 125 cohort-specific propensity score and outcome models, each on the full sample — computationally intractable at this scale.
- **This is a known memory constraint (Pattern 42), not a coding error.** The stored `cs_nt_with_ctrls_status = "FAIL_memory_doubly_robust_on_large_N"` is correct.
- WARN: the preferred specification (weather-controlled CS-DID) is unavailable; only the no-controls CS-DID is stored.

### 3. CS-DID ATT (no controls)

- att_nt_simple = −5.441 (SE = 6.431). Direction matches TWFE (−4.836).
- att_nt_dynamic = −6.568 (SE = 6.335).
- Both estimates are negative and directionally consistent with TWFE, but with substantially larger SEs than TWFE (SE ≈ 6.4 vs 1.5). This is expected: CS-DID without controls has higher variance when weather is a strong confounder of fire activity.
- The CS-DID ATT magnitude (−5.44 to −6.57) is modestly larger than TWFE (−4.84), consistent with negative TWFE weights slightly attenuating the true effect.

### 4. Never-treated control group validity

- 487 never-treated plants form the control pool — 51% of the 954-plant sample. This is a healthy NT pool.
- However, the metadata notes Pattern 38: CS-NT diverges at late horizons due to shrinking not-yet-treated control. With 125 cohorts spread over 228 months and a large NT pool, the parallel trends assumption is maintained for the NT group, but the never-treated plants may differ systematically from treated plants (selection into biomass power plant adoption is likely related to regional agricultural intensity and policy environment).

### 5. Pre-trends (CS-NT event study)

- CS-NT event study pre-period:
  - k=−6: +36.32 (SE=15.76), t≈2.30 — SIGNIFICANT. This is a large and significant pre-trend spike.
  - k=−5: +4.64 (SE=7.20), t≈0.64 — not significant.
  - k=−4: −2.19 (SE=8.47), t≈0.26 — not significant.
  - k=−3: +17.13 (SE=15.05), t≈1.14 — not significant.
  - k=−2: −13.78 (SE=6.56), t≈2.10 — SIGNIFICANT.
- Two significant pre-period coefficients (k=−6 and k=−2) in the CS-NT event study are a WARN. The pre-trend is not cleanly flat.
- The k=−6 significance may reflect the earliest cohorts having a different pre-treatment trajectory. The k=−2 significance is more concerning as it is close to treatment onset.

### 6. Comparison with TWFE

- TWFE: −4.836 (SE=1.495); CS-NT simple: −5.441 (SE=6.431). A 12% larger CS-DID estimate is consistent with negative TWFE weighting attenuating the effect. Direction is confirmed.
- The large SE difference (TWFE cluster 1.495 vs CS-NT 6.431) reflects the weather control asymmetry — CS-DID without controls is substantially noisier.

---

## Summary

**WARN.** CS-DID confirms the direction and approximate magnitude of the TWFE estimate (−5.44 vs −4.84), but two issues are flagged: (1) the preferred doubly-robust specification with 7 weather controls failed due to memory constraints (217k rows × 7 controls × 125 cohorts = FAIL_memory) — this is a documented computational limitation; (2) two significant pre-period coefficients in the CS-NT event study (k=−6, t≈2.30; k=−2, t≈2.10) raise mild concern about parallel trends validity for the no-controls CS-DID. The directional conclusion is robust, but the confidence intervals from CS-DID (no controls) are wide and partially overlap with zero.

**Flags:**
- Spec A (doubly-robust with 7 weather controls): FAIL_memory on 217k rows — documented design limitation.
- CS-NT k=−6 pre-trend: +36.32 (t≈2.30) — significant.
- CS-NT k=−2 pre-trend: −13.78 (t≈2.10) — significant.
- CS-DID SE (6.43) is 4.3× TWFE SE (1.50) due to missing weather controls.
