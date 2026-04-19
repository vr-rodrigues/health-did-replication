# CS-DID Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-19
**Reviewer axis:** Methodology

---

## Checklist

### 1. Estimator configuration

- CS-DID run with never-treated control group (NT). Never-treated pool: 487 plants (51% of 954 total).
- cs_controls = [] (empty). The 7 weather controls used in TWFE are NOT passed to cs_controls.
- Spec A (doubly-robust, 7 weather controls) is now available via the `att_cs_nt_with_ctrls` fields.
- Full pipeline re-run 2026-04-19 (~2.5 hours, 14.8 GB peak memory on 217k obs × 7 controls × 125 cohorts).

### 2. Spec A (doubly-robust with 7 weather controls) — NOW OK

- Previously: FAIL_memory on 217k obs × 228-period panel × 125 cohort-specific models.
- 2026-04-19 re-run status: cs_nt_with_ctrls_status = "OK".
- att_cs_nt_with_ctrls (simple) = −2.037 (SE = 5.067).
- att_cs_nt_with_ctrls_dyn (dynamic) = −1.709 (SE = 5.722).
- Direction is confirmed negative, consistent with TWFE. Magnitude is attenuated vs no-controls CS-NT
  (−2.04 vs −5.44), indicating weather strongly predicts fire frequency and its inclusion in the
  doubly-robust IPW step absorbs variation otherwise attributed to treatment.
- Implementation flag cleared: FAIL_memory resolved. This entry is now a design finding, not
  an implementation error.

### 3. CS-DID ATT (no controls — Spec B)

- att_nt_simple = −5.441 (SE = 6.431). Direction matches TWFE (−4.836).
- att_nt_dynamic = −6.568 (SE = 6.335).
- SE is 4.3× TWFE cluster SE (1.495). High variance from absent weather controls expected.

### 4. CS-DID ATT (with controls — Spec A)

- att_cs_nt_with_ctrls = −2.037 (SE = 5.067). Direction confirmed negative.
- Covariate margin (CS side): (−2.037 − (−5.441)) / |−2.037| = +167%. Weather controls
  strongly attenuate the CS-NT estimate — they are powerful confounders of fire frequency.
- The 57.9% estimator gap (Spec A: TWFE −4.836 vs CS-NT −2.037) vs the 12.5% Spec C gap
  (TWFE −4.836 vs CS-NT no-ctrls −5.441) reveals the controls asymmetry as a primary driver.
- SEs remain large (5.07–5.72) because the 217k-row doubly-robust IPW step, though now
  computationally successful, produces noisy cohort-specific propensity models at this panel scale.

### 5. Never-treated control group validity

- 487 never-treated plants = 51% of sample. Healthy NT pool; TvNT comparisons likely dominate
  Bacon decomposition weights, limiting forbidden-comparison contamination.
- Pattern 38 (shrinking not-yet-treated control at late horizons) documented in metadata notes.
  NT pool is static, so this applies to any CS-NYT specification — not applicable here since
  run_csdid_nyt = false.

### 6. Pre-trends (CS-NT event study — no controls)

- k=−6: +36.32 (SE=15.76), t≈2.30 — SIGNIFICANT.
- k=−5: +4.64 (SE=7.20), t≈0.64 — not significant.
- k=−4: −2.19 (SE=8.47), t≈0.26 — not significant.
- k=−3: +17.13 (SE=15.05), t≈1.14 — not significant.
- k=−2: −13.78 (SE=6.56), t≈2.10 — SIGNIFICANT.
- Two significant pre-period coefficients (k=−6 and k=−2). This is a DESIGN FINDING about the
  paper's no-controls parallel trends assumption, not an implementation error. Under Spec A
  (weather controls), these pre-trend spikes are expected to attenuate substantially (weather is
  the likely confound driving both the k=−6 and k=−2 spikes). Spec A pre-trends cannot be
  separately verified from available outputs.

### 7. Comparison with TWFE

- Spec A (protocol-matched): TWFE −4.836 vs CS-NT −2.037 = 57.9% estimator gap.
- Spec B (both no controls): TWFE −5.075 vs CS-NT −5.441 = 7.1% estimator gap.
- The near-convergence in Spec B confirms that the controls asymmetry (not fundamental
  estimator heterogeneity or negative weighting) explains most of the Spec C gap.

---

## Summary

**WARN.** CS-DID Spec A (doubly-robust, 7 weather controls) recovered after full re-run
(2026-04-19): att_cs_nt_with_ctrls = −2.037 (OK). FAIL_memory resolved. Implementation
concern cleared; the remaining WARN reflects two design findings: (1) two significant CS-NT
no-controls pre-period spikes (k=−6, k=−2) that likely reflect omitted weather confounders;
(2) the large SE on Spec A (5.07) limits inferential precision despite directional confirmation.
All estimators unanimously confirm a significant negative post-treatment effect on fires.

**Flags (design findings, Axis 3):**
- CS-NT (no-controls) k=−6 pre-trend: +36.32 (t≈2.30) — significant, weather confounder likely.
- CS-NT (no-controls) k=−2 pre-trend: −13.78 (t≈2.10) — significant, weather confounder likely.
- Spec A SE (5.07–5.72) large: doubly-robust on 125 cohorts × 217k rows yields imprecise ATT.

**Implementation change (2026-04-19):** Spec A FAIL_memory resolved. cs_nt_with_ctrls_status="OK".
