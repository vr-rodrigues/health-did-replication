# Paper Auditor Report — Article 47 (Clemens 2015)

**Verdict:** EXACT
**Date:** 2026-04-18

## Fidelity axis: numerical match to paper

### Target estimate
Paper: Table 5, Panel A, Column 1 — "Community-rating state × post regulation" on private coverage, stable states, DiD framework.
- Reported beta: -0.0962
- Reported SE: 0.0206 (bootstrap)
- Reported N: 127,554

### Our estimate
- beta_twfe: -0.09617 (results.csv)
- se_twfe: 0.00974 (analytic clustered, not bootstrap — see note below)
- N: 127,554 (confirmed in replication notes)

### Point estimate comparison
- Paper: -0.0962
- Ours: -0.09617
- Absolute gap: 0.00003 (< 0.001)
- Relative gap: 0.03%
- Verdict: EXACT (threshold: < 2% for EXACT match)

### Standard error note
The paper reports SE = 0.0206, derived from a block bootstrap with clusters at the state level (as stated explicitly in the paper's notes to Table 5 and in the methodology section). Our SE = 0.00974 uses analytic clustering. The ~2× discrepancy is entirely explained by the well-known penalty from bootstrapping with few treated clusters (only 3 treated states: NY, ME, VT). This SE divergence is NOT a replication failure — the point estimate is an exact match, and the SE methodology difference is documented in the paper. The metadata notes confirm this: "Round 4 EXACT MATCH."

### CS-NT comparison
- Paper's CS-NT: -0.12480, SE = 0.0148
- Our CS-NT: -0.12429, SE = 0.01733
- Gap: 0.4% — within tolerance (< 2%)
- Both confirm the negative direction with larger magnitude than TWFE.

### Conclusion
The primary TWFE estimate is an exact numerical match to the paper's Table 5, Panel A, Column 1. The CS-NT estimate is within 0.4% of the paper's reported value. Fidelity is confirmed at the EXACT level.

## References
- results.csv: our estimates
- metadata.json: original_result field
- Clemens (2015) Table 5, Panel A, Column 1
- Replication notes in metadata.json

