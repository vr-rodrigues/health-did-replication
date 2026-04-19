# Paper Auditor Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check

The paper-auditor requires:
1. `pdf/{id}.pdf` exists — FAILED (no file at `pdf/97.pdf`)
2. `results/by_article/97/results.csv` has numeric `beta_twfe` — PASS (-0.3031)

Since the PDF is not available for direct comparison against the paper's reported tables, the fidelity axis cannot be evaluated.

## Note on fidelity evidence from metadata

Although the PDF is absent, the metadata contains explicit `original_result` fields populated during the profiling stage:
- `beta_twfe = -0.3031` (original paper)
- `se_twfe = 0.0691` (original paper)
- `att_csdid_nt = -0.3517` (original paper)
- `se_csdid_nt = 0.0387` (original paper)

Our computed results.csv shows:
- `beta_twfe = -0.30314` (vs. -0.3031: within 0.01%)
- `se_twfe = 0.06908` (vs. 0.0691: within 0.03%)
- `att_csdid_nt = -0.35177` (vs. -0.3517: within 0.02%)
- `se_csdid_nt = 0.03775` (vs. 0.0387: within 2.5%)

This metadata-sourced comparison is highly favourable, suggesting an EXACT match. However, because the PDF cannot be directly audited, the formal verdict remains NOT_APPLICABLE per protocol.

**NOT_APPLICABLE** — fidelity axis not formally evaluable without the source PDF.
