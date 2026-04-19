# Paper Auditor Report — Article 133 (Hoynes et al. 2015)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability assessment
- PDF required: `pdf/133.pdf`
- PDF exists: NO (file not found at the expected path)
- results.csv has numeric beta_twfe: YES (-0.3868)

Since the PDF is not available, direct numerical comparison against paper-reported tables cannot be performed. The fidelity axis is not evaluable for this article.

## Quantitative note (for reference only)
From metadata's `original_result` field (values transcribed from the paper during profiling):
- Paper TWFE: beta = -0.3549, se = 0.0746
- Our TWFE: beta = -0.3868, se = 0.0826
- Absolute difference: 0.0320 pp; relative divergence: ~9.0%
- Paper CS-NT: ATT = -0.1799, se = 0.1274
- Our CS-NT: ATT = -0.4030, se = 0.0906
- CS-NT divergence: 0.2231 pp absolute (our estimate is ~2.2x the paper's)

These comparisons cannot be verified against the actual published tables without the PDF. The figures above rely on the metadata field `original_result`, which was populated during the profiling stage.

## Overall Paper Auditor verdict: NOT_APPLICABLE
