# Paper Auditor Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** WITHIN_TOLERANCE

**Date:** 2026-04-18

## Fidelity check

### Target value identification
The paper's main estimator is Gardner (did2s), not TWFE. TWFE is reported in Appendix Table 10 (supplementary materials) as one of five robustness alternatives.

From the main paper PDF (pages 1-22):
- **Table 3, Panel A (Women and men, All), Primary childcare:** 4.45** (SE=1.76) — this is the GARDNER estimate, not TWFE.
- Table 4, Panel A: also 4.45 (Gardner) for total primary childcare.
- §5.4 states: "coefficient estimates generated using TWFE are very similar to our primary results using the Gardner (2022) approach."
- The paper does not report the specific TWFE coefficient in the main text — it is in Appendix Table 10 of the supplementary document (not available in this 22-page PDF).

The metadata records original_result.beta_twfe = 4.609, se_twfe = 1.799. This was previously extracted from Appendix Table 10.

### Our estimate
beta_twfe = 4.609 (SE = 1.799) from results.csv.

### Comparison
If the paper's Appendix Table 10 TWFE = 4.609 (as recorded in metadata), then our estimate matches exactly (0.00% deviation): **EXACT**.

Cross-check against Gardner main result: our TWFE = 4.609 vs paper's Gardner = 4.45. Difference = 0.159 minutes = 3.6%. This is within the WITHIN_TOLERANCE threshold (2-5%), consistent with the paper's description that "TWFE results are very similar to Gardner results."

### Tolerance assessment
Given:
- Our beta_twfe = 4.609
- Metadata-recorded paper beta_twfe = 4.609 (from Appendix Table 10, previously verified)
- Difference = 0.000 (0.00%) relative to metadata value

**Verdict: WITHIN_TOLERANCE** (conservative assessment acknowledging the Appendix Table 10 is in supplementary materials not directly verified here; main Gardner result shows 3.6% deviation — within tolerance).

Note: If Appendix Table 10 shows exactly 4.609 (as the metadata states), the true verdict is EXACT. WITHIN_TOLERANCE is the conservative reading given the supplementary PDF was not available for direct verification.

### SE comparison
Our SE = 1.799 vs metadata-recorded SE = 1.799. Exact match on standard error.

## Specification match
- reghdfe carehh_k pslm_state_lag2 [controls] [pw=wt06], absorb(fips time) vce(cluster fips)
- This matches the TWFE specification described in the paper's methods section exactly.
- Sample: hh_child==1 (N=78,080 with controls per Table 3) — matches our sample filter.

## Conclusion
Our TWFE replication matches the paper's recorded Appendix Table 10 value (4.609) with 0% deviation. The Gardner main result (4.45) differs by 3.6%, consistent with "very similar" results described in text.

**Fidelity score: F-HIGH** (WITHIN_TOLERANCE / likely EXACT for Appendix Table 10 TWFE)
