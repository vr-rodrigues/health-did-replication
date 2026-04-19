# CS-DID Reviewer Report: Article 68 — Tanaka (2014)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. CS-DID applicability
- [x] CS-DID is applicable: binary absorbing treatment, single cohort (gvar_CS = 94 for treated; 0 for never-treated), panel=FALSE (RCS mode) correctly specified.
- [x] Never-treated comparison group (clinic93=0 communities) used as control. No not-yet-treated comparison is appropriate here (single timing).
- [x] `run_csdid_nyt = false` correctly reflects single-timing design — no NYT estimator needed.

### 2. Numerical output
- att_csdid_nt = 0.5216 (SE = 0.3898; z = 1.34; p ≈ 0.18)
- att_nt_simple = 0.5216 (SE = 0.3832) — simple aggregation
- att_nt_dynamic = 0.5216 (SE = 0.3872) — dynamic aggregation (both collapse to single cohort-time cell with T=2)
- All three aggregations return identical point estimates (expected with T=2, single cohort, single post-period).

### 3. Divergence from TWFE
- TWFE: 0.5672 | CS-NT: 0.5216 | Divergence: -8.1%
- With T=2 and a single cohort, CS-DID (panel=FALSE) and TWFE should in theory be identical. The 8.1% gap arises from the RCS composition correction in CS-DID: CS-DID with panel=FALSE uses IPW/doubly-robust adjustments for cell composition, while TWFE uses cluster-level FE which is a different (though related) correction for the RCS structure.
- An 8.1% gap is within the expected range for RCS implementations without controls. This is not an alarming divergence; both estimators agree on sign and order of magnitude.

### 4. Standard errors comparison
- TWFE SE: 0.2412 | CS-NT SE: 0.3898 — CS-NT SE is 62% larger.
- This is expected for RCS data: CS-DID (panel=FALSE) cannot exploit within-individual variation, leading to larger SEs relative to the clustered TWFE which absorbs cluster fixed effects.
- CS-NT estimate is not statistically significant (p ≈ 0.18), while TWFE is significant (p ≈ 0.019). This discrepancy is noteworthy: the significance of the result is sensitive to the estimator choice, likely because CS-DID (panel=FALSE) is less efficient for this design.

### 5. Pre-trends
- Not assessable: T=2 provides 0 pre-periods. This is a fundamental data limitation. Pre-trend testing is impossible.
- This is recorded as a design constraint, not a CS-DID failure.

### 6. Controls sensitivity
- `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"` — correctly not attempted (no controls in TWFE specification).

### 7. Summary
CS-DID implementation is correct for this T=2 RCS single-cohort design. The 8.1% gap from TWFE is within expected RCS bounds. The key concern — which cannot be resolved within this audit — is that statistical significance depends on estimator choice (TWFE: sig; CS-NT: not sig), reflecting genuine SE uncertainty in RCS designs. This is a design characteristic, not an implementation failure.

**Verdict: PASS**
