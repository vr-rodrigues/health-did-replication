# Paper Auditor Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check
- `results/by_article/147/results.csv` has numeric `beta_twfe` = 8.01 — condition met.
- `pdf/147.pdf` — FILE DOES NOT EXIST.

Without the PDF, the fidelity axis (numerical comparison of our replicated estimate against the paper's reported table value) cannot be assessed. The metadata `original_result` field records `beta_twfe: 8.01, se_twfe: 12.59` which appears to have been manually extracted from the paper during the profiling stage.

## Partial assessment from metadata
Using the metadata-recorded original result as a proxy:
- Paper (metadata): beta = 8.01, SE = 12.59
- Our replication: beta = 8.015, SE = 11.926
- Point estimate difference: 0.005 (~0.06%) — essentially exact.
- SE difference: 0.664 (~5.3%) — within tolerance, attributable to feols singleton removal vs Stata (documented).

If the PDF were available for direct table verification, this would likely receive a WITHIN_TOLERANCE verdict for the point estimate and a WARN for the SE. However, without direct PDF verification, the formal verdict is NOT_APPLICABLE.

**Verdict: NOT_APPLICABLE** — PDF not present in `pdf/147.pdf`; fidelity axis cannot be formally evaluated. Metadata proxy suggests near-exact point estimate match.
