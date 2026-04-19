# Paper Auditor Report — Article 241 (Soliman 2025)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check
- PDF exists: NO (`pdf/241.pdf` not found).
- results.csv has numeric beta_twfe: YES (-33.65).

## Conclusion
No PDF available for fidelity comparison against the paper's published table. The fidelity axis cannot be evaluated from the PDF.

However, from metadata notes (which record the paper's reported value explicitly):
- Paper reports: beta_twfe = -31.52, SE = 5.767 (Table 1, Col 1, filtered sample)
- Our stored beta_twfe = -33.65, SE = 6.49 (unfiltered sample)
- Gap: (-33.65 - (-31.52)) / 31.52 = -6.76%

The gap is explained by the sample filter (rel_year ∈ [-3,3] applied in the paper but not in the template run). This is a known, documented divergence — not an implementation error. The estimate direction and rough magnitude are consistent; the paper's headline number requires the filtered sample to match exactly.

Fidelity score: F-NA (PDF not available for formal audit, but metadata confirms the divergence source).

**Overall:** NOT_APPLICABLE
