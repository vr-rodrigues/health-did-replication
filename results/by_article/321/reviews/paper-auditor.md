# Paper Auditor Report — Article 321 (Xu 2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Assessment

The paper auditor requires:
1. `pdf/{id}.pdf` to exist — `pdf/321.pdf` was not found in the replication package.
2. A numeric `beta_twfe` in `results/by_article/321/results.csv` — this exists (`-0.142352`).

Since condition (1) is not met, the paper auditor cannot perform numerical fidelity checks against the published paper (Table 2, Column 3).

Note: The metadata records `original_result.beta_twfe = -0.142` with `original_result.se_twfe = 0.041`, and the stored result is `beta_twfe = -0.142352` — a difference of 0.02%, which would be EXACT by standard tolerances. However, without the PDF this cannot be formally verified by the auditor tool.

**Verdict: NOT_APPLICABLE** (no PDF available; fidelity axis is F-NA)
