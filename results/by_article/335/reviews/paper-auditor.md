# Paper Auditor Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Assessment

Paper-auditor requires:
- `pdf/{id}.pdf` exists: NO — `pdf/335.pdf` not found.
- `results/by_article/335/results.csv` has numeric `beta_twfe`: YES (0.04053).

Since the PDF is absent, numerical fidelity to the paper cannot be verified by reading the original table. Fidelity axis: F-NA.

## Available fidelity check (from metadata)
- Original result (from metadata): beta_twfe = 0.0405, SE = 0.0107
- Source: Table 2, Column 5 (new_std_ln, complete model). Conley HAC SEs. N=924.
- Our estimate: beta_twfe = 0.04053, SE = 0.01274 (clustered)
- Coefficient match: |0.04053 - 0.0405| = 0.00003 — essentially exact.
- SE divergence: clustered (0.01274) > Conley (0.0107) — documented and expected.

Note: While the coefficient matches exactly based on metadata-recorded values, formal paper auditing (reading the PDF table directly) is not possible without the PDF file.
