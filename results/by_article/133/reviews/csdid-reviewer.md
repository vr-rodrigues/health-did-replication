# CS-DID Reviewer Report — Article 133 (Hoynes et al. 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Group variable (gvar_CS) construction
- `gvar_CS = ifelse(parvar >= 2, 1994, 0)`: assigns first-treated year 1994 to high-parity mothers (treatment group) and 0 (never-treated) to low-parity mothers (control group).
- Single cohort: only one treatment group (first treated in 1994). This makes CS-DID equivalent to a simple 2×2 DID for this design. **PASS**

### 2. Comparison group
- Never-treated (NT) only (`run_csdid_nyt: false`), appropriate since treatment timing is single — there are no not-yet-treated units in a single-cohort design. **PASS**

### 3. Controls in att_gt()
- `cs_controls: []` — no controls passed to att_gt() via xformla.
- The metadata notes document a critical implementation detail: `racemiss == 0` for ALL parvar==1 (control) units, which causes R to fail when racemiss is included in xformla. The fix is to exclude racemiss from cs_controls. The empty cs_controls list avoids this collinearity issue. **PASS** (issue documented and resolved)
- Note: att_cs_nt_with_ctrls = 0 (status "OK" but value is 0, likely a placeholder or failed with controls). The primary CS-NT estimate without controls is used.

### 4. CS-DID ATT estimate vs. paper
- Our CS-NT (simple, no controls): ATT = -0.4030 (se = 0.0906)
- Our CS-NT (dynamic): ATT = -0.4030 (se = 0.0937) — identical, consistent with single cohort
- Paper's reported CS-NT: ATT = -0.1799 (se = 0.1274)
- Divergence: 0.2231 pp absolute; our estimate is more than 2x the paper's in magnitude.
- This is a substantial divergence. Possible explanations: (a) the paper uses a different aggregation (dynamic vs. simple), (b) base_period differences ('universal' vs. 'varying'), (c) control for racemiss affecting the Stata vs. R implementation differently.
- The metadata notes confirm: "base_period='universal' required to match Stata long2 pre-period estimates" and "racemiss=0 for ALL parvar==1 (control) units → must exclude from xformla". Despite this, we do not replicate the paper's CS-NT = -0.180. **WARN** (large divergence from original CS-NT estimate)

### 5. Single-cohort consistency check
- With only one treatment cohort, CS-DID and TWFE should be mechanically similar.
- TWFE: -0.3868; CS-NT: -0.4030 — difference of 0.016 pp, consistent with a single-cohort design. **PASS**
- The paper's values (TWFE = -0.355, CS-NT = -0.180) are internally inconsistent for a single-cohort design — this suggests the paper's CS-NT uses a different specification (likely with controls that are implemented differently in Stata).

### 6. Event study coherence
- CS-NT pre-trends: t=-3: +0.224 (se=0.090, t≈2.49); t=-2: +0.144 (se=0.067, t≈2.14)
- Both pre-trend CS-NT coefficients are statistically significant and positive — this is a concern for the parallel trends assumption when using CS-DID without controls.
- Post-period pattern is monotonically increasing in magnitude (t=0: -0.160, t=4: -0.668), consistent with TWFE. **PASS** for post-period coherence.
- Pre-trends in CS-NT (no controls) are statistically significant. **WARN** (the no-controls CS-NT shows pre-trends, suggesting controls matter for parallel trends)

### 7. att_cs_nt_with_ctrls anomaly
- att_cs_nt_with_ctrls = 0 (with status "OK") — this suggests the with-controls CS-NT either returned 0 or was not properly computed. This is unexpected and reduces confidence in the controls-based CS-NT. **WARN**

## Summary of flags
- WARN: Our CS-NT ATT (-0.403) diverges substantially from paper's reported value (-0.180).
- WARN: CS-NT (no controls) shows statistically significant positive pre-trends at t=-3 and t=-2.
- WARN: att_cs_nt_with_ctrls = 0 anomaly in results.

## Overall CS-DID verdict: WARN
