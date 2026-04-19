# Paper Auditor Report: Article 401 — Rossin-Slater (2017)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Check

- PDF file `pdf/401.pdf`: NOT FOUND
- results.csv has numeric beta_twfe: YES (-0.0285386)

Condition for applicability: `pdf/{id}.pdf` must exist AND results.csv has numeric beta_twfe.

First condition fails — no PDF available for this article.

## Informational Note (not scored)

Despite no PDF, the metadata records the paper's original result:
- original_result.beta_twfe = -0.0281 (Table 3, col 5)
- original_result.se_twfe = 0.0088
- Our estimate: beta_twfe = -0.0285, se_twfe = 0.0076

Difference = 0.0004 (1.4% of original). If scored, this would be WITHIN_TOLERANCE (< 5% threshold). The SE gap (0.0076 vs 0.0088) is explained by the paper including state-specific linear time trends (tt_state_*) that we do not replicate per metadata notes.

**Fidelity axis: F-NA** — not factored into the combined rating.

## References
- Metadata: `data/metadata/401.json` (original_result section)
