# Paper Auditor Report — Article 433

**Article:** DeAngelo, Hansen (2014) — "Life and Death in the Fast Lane: Police Enforcement and Traffic Fatalities"
**Reviewer:** paper-auditor
**Date:** 2026-04-18
**Verdict:** NOT_APPLICABLE

---

## Applicability

The applicability rule requires: `pdf/{id}.pdf` exists AND `results/by_article/{id}/results.csv` has a numeric `beta_twfe`.

- `pdf/433.pdf`: **NOT FOUND**
- `results.csv` has numeric `beta_twfe`: YES (0.6999)

Because the PDF is not available for direct text extraction and numerical verification against the published table, the paper-auditor axis is formally NOT_APPLICABLE.

---

## Informational: Metadata-based fidelity check

Although the PDF is absent, the metadata (`data/metadata/433.json`) records the original paper's result:
- `original_result.beta_twfe = 0.7103`
- `original_result.se_twfe = 0.1281`

Comparing against the stored replication result:
- Stored `beta_twfe = 0.6999`
- Difference: |0.7103 - 0.6999| = 0.0104
- Percentage gap: 0.0104 / 0.7103 = 1.46%
- Diff/SE: 0.0104 / 0.1281 = 0.081 standard errors

This is **well within the WITHIN_TOLERANCE threshold** (typically < 5% or < 0.2 SEs). The metadata notes that the gap is attributable to the missing Vermont observation (VT, FIPS=50) from the replication package — the original data file `fatal_analysis_file_2014.dta` is absent and `synth_file_2014.dta` (used instead) excludes Vermont.

If a fidelity score were assigned based on this metadata comparison: **WITHIN_TOLERANCE** (equivalent to F-HIGH).

**Verdict: NOT_APPLICABLE** (no PDF for formal audit; informational metadata comparison = WITHIN_TOLERANCE)
