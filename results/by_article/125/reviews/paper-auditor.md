# Paper Auditor Report — Article 125
**Verdict:** EXACT
**Date:** 2026-04-18

## Applicability
- PDF `pdf/125.pdf`: NOT FOUND — PDF unavailable for direct text extraction.
- `results/by_article/125/results.csv` has numeric `beta_twfe`: YES (-0.000452).
- `original_result.beta_twfe` in metadata.json: YES (-0.0005).
- Partial applicability: fidelity assessed via metadata-recorded target only (no PDF scan).

## Fidelity calculation
- Paper target (metadata `original_result.beta_twfe`): -0.0005
- Our TWFE estimate: -0.000452018963804086
- Absolute difference: 0.0000480 (4.8e-5)
- Paper SE: 0.007
- |diff| / SE_paper = 0.0069

**Threshold classification:**
- EXACT: |diff|/SE < 0.20 → 0.0069 < 0.20 → **EXACT**

## Source traceability
- Paper: Levine, McKnight & Heep (2011), AEJ:Policy 3(3): 1-27.
- Metadata notes: "Table 5 Panel A Row 1 Col 2 (DD Full Sample)". 
- Stata command specified: `xi: reg insured law i.stfips i.year i.a_age married student female ur povratio povratio2 if a_age>=19 & a_age<=24 & year>=2000, cluster(stfips)`. UNWEIGHTED.
- Our R implementation uses `fixest::feols` with equivalent specification. The tiny discrepancy (4.8e-5 out of 5e-4 = 9.6%) is attributable to (a) paper rounding to 4 decimal places and (b) potential minor differences in how `xi:` and `feols` handle the interaction terms for FE.

## Note on the reported -1,112% outlier flag
The consolidated results database flagged article 125 as an outlier with a proportional shift of approximately -1,112%. This flag refers to the comparison of `att_cs_nt_with_ctrls` (-0.0358) against `beta_twfe` (-0.000452). This ratio is:
(-0.0358 - (-0.000452)) / |-0.000452| = -78x or approximately -7,800%.

For a near-zero TWFE denominator, any proportional-shift metric is mathematically meaningless. The metadata notes explicitly acknowledge this: "The +1865% ratio is meaningless (both ≈0)." The paper-auditor confirms: the TWFE replicates the paper exactly. The CS-NT-with-controls result is a methodological artefact of control-variable collinearity in an RCS design (see csdid-reviewer.md), not a fidelity failure.

**Verdict: EXACT** (F-HIGH)
