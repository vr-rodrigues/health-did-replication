# Paper Auditor Report — Article 76 (Lawler & Yewell 2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check

- PDF at `pdf/76.pdf`: DOES NOT EXIST
- `results/by_article/76/results.csv` has numeric `beta_twfe`: YES (0.03832)

**Standard fidelity audit (PDF comparison) is NOT_APPLICABLE** because the article PDF is not present in the replication package.

## Fallback: metadata-based fidelity check

The metadata (`data/metadata/76.json`) contains `original_result` fields populated from the paper:

| Field | Paper value | Our estimate | Pct gap |
|-------|-------------|-------------|---------|
| beta_twfe | 0.0383 | 0.03832 | 0.06% |
| se_twfe | 0.0095 | 0.009499 | 0.005% |
| att_csdid_nt | 0.018 | 0.00774 (no ctrls) | 57% |
| att_csdid_nyt | 0.0212 | 0.00781 (no ctrls) | 63% |

### TWFE fidelity: EXACT
The TWFE beta and SE match to within rounding error. The metadata notes document the two-part fix (month formula + styr_pergt64 omission) that achieved this exact match. This is a calibration article (F=1 in the dissertation).

### CS-DID fidelity: DIVERGENT but EXPLAINED
The stored CS-DID estimates diverge from the paper's Stata CSDID values by 57–63%. This is fully explained by the i.fips covariate limitation (Pattern 25): the paper's Stata specification includes ~50 county fixed effects as covariates in the doubly-robust estimator, which cannot be replicated in R's `att_gt()` for repeated cross-section data without singularity. The with-controls CS-DID gap is documented as 8.2% (0.01652 vs 0.01799), which is the relevant comparison for methodology assessment.

### Fidelity score
Because the PDF is absent, formal F-score cannot be assigned. Based on metadata-referenced values:
- TWFE: EXACT (0.06% gap)
- CS-DID: Explained divergence (structural limitation, documented)

**Verdict: NOT_APPLICABLE** (PDF absent; metadata-based check shows EXACT TWFE fidelity with CS-DID gap fully explained by documented structural limitation)
