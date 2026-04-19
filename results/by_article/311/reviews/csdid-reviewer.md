# CS-DID Reviewer Report — Article 311

**Verdict:** PASS

**Reviewer:** csdid-reviewer
**Date:** 2026-04-19 (updated; supersedes 2026-04-18 FAIL)
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Update note (2026-04-19)

The 2026-04-18 report recorded FAIL because `allow_unbalanced = false` caused `did_standarization` balancing to produce an NA ATT on a panel with 84.8% fill rate. On 2026-04-19, `allow_unbalanced` was toggled to `true`. CS-DID now runs successfully and all fields in results.csv are populated. This report reflects the updated metadata and output.

---

## Checklist

### 1. CS-DID execution
- `run_csdid_nt = true` in metadata.
- Results from results.csv: `att_csdid_nt = 0.7135` (se = 0.0331), `att_nt_simple = 0.6813` (se = 0.0344), `att_nt_dynamic = 0.6975` (se = 0.0373).
- **PASS:** CS-DID (never-treated) produced a valid, statistically significant ATT.

### 2. `allow_unbalanced` flag
- `allow_unbalanced = true` in metadata (as of 2026-04-19 fix).
- With 84.8% fill rate across 6,746 country×product units over 14 years, allowing the `did` package to handle the unbalanced panel natively is the correct approach. Forced balancing would retain only units observed in all 14 years, creating a highly selected and potentially unrepresentative sample.
- The unbalanced-panel approach introduces a mild implementation complexity: the `did` package uses within-cohort variation and does not require a balanced panel when `allow_unbalanced = TRUE`. The ATT estimates remain valid under the standard CS assumptions.
- **PASS:** flag correctly set to `true` for this data structure.

### 3. Magnitude and direction relative to TWFE
- TWFE β = 0.6625; CS-NT ATT = 0.7135. Gap = +7.7% (CS-NT > TWFE).
- Direction consistent. Sign unanimous.
- Magnitude gap of +7.7% is within normal range for staggered DiD with 84.6% never-treated: when the never-treated pool dominates, TWFE and CS-NT estimates should be close, as is the case here.
- The slight upward revision in CS-NT relative to TWFE is consistent with TWFE's well-known downward bias from forbidden comparisons (already-treated as control for later-treated). With 84.6% never-treated, this bias is minor.

### 4. gvar_CS construction
- gvar_CS constructed via preprocessing: units with MPP=1 get the minimum year of treatment; units with MPP=0 (never-treated) get gvar_CS = 0. This is correct Callaway-Sant'Anna convention.
- 7 treatment cohorts: 2011–2017.
- No controls (`cs_controls = []`), so the "unconditional parallel trends" assumption is invoked. This is consistent with the paper's no-covariates specification.

### 5. Controls decomposition
- `twfe_controls = []` and `cs_controls = []` → no three-way controls decomposition required.
- `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"` — confirmed correct.

### 6. CS-NYT
- `run_csdid_nyt = false` — correct, as this is a single-absorbing-binary treatment (not-yet-treated estimator is optional for absorbing designs, and never-treated is the more conservative choice with 84.6% never-treated share).

### 7. Consistency with HonestDiD auxiliary analysis
- The 2026-04-18 honestdid-reviewer noted CS-NT att_avg ≈ 0.644 from the `honest_did_v3.csv`. The main results.csv now records att_csdid_nt = 0.7135 (aggregated ATT) and att_nt_dynamic = 0.6975 (dynamic average). The HonestDiD entry uses att_avg = 0.644, which is the weighted average ATT across post-periods — a slightly different aggregation. Both are internally consistent.

---

## Summary

CS-DID (never-treated) now runs correctly and produces a valid ATT of 0.7135 (se = 0.0331). The direction matches TWFE (0.6625), with a +7.7% magnitude premium consistent with TWFE's minor downward bias from forbidden comparisons in an 84.6%-never-treated sample. The fix — setting `allow_unbalanced = true` — is methodologically appropriate for this panel structure. No implementation concerns remain.

**Verdict: PASS** (CS-NT ATT = 0.7135, direction consistent with TWFE, allow_unbalanced correctly set to true)
