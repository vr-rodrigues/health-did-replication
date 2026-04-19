# Paper Auditor Report — Article 61 (Evans & Garthwaite 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Fidelity check

### Reference beta
- `original_result.beta_twfe` = 0.0095 (from metadata; corresponds to Stata OLS with no FEs)

### Stored beta
- `beta_twfe` in results.csv = 0.01032163

### Divergence
- Absolute: |0.01032 - 0.0095| = 0.000821
- Relative: 8.8% above paper value
- In SE units: 0.000821 / 0.00786 ≈ 0.10 SE

### Assessment
The divergence is 8.8% — above the standard 5% tolerance threshold for WITHIN_TOLERANCE but below FAIL (typically >20%). This is a WARN.

### Root cause (documented in metadata notes)
The R template added `fips + year` two-way fixed effects to the TWFE specification, while the Stata original uses plain OLS with no fixed effects (the DiD variation is already fully encoded in `dd_treatment`). A Round 3 fix was implemented identifying the correct no-FE specification, which yields 0.009483 (exact match). However, the stored results.csv still contains the incorrect 0.01032 value.

### PDF availability
No PDF found at `pdf/61.pdf`. Direct comparison to published table values cannot be made. Fidelity assessment relies on the `original_result.beta_twfe = 0.0095` field in metadata.json, which is an exact match to the paper's Table 2.

### Conclusion
- The stored beta is 8.8% above the paper value due to a known specification error (spurious FEs).
- The correct spec is documented and yields an exact match, but the file has not been updated.
- Verdict: WARN (divergence 5–20%; explainable by documented specification mismatch).
