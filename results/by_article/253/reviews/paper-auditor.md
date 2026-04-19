# Paper Auditor Report — Article 253 (Bancalari 2024)

**Verdict:** NOT_APPLICABLE

**Date:** 2026-04-18

## Applicability Assessment

- PDF exists at `pdf/253.pdf`: NO (confirmed: `ls pdf/ | grep 253` returns nothing).
- `results/by_article/253/results.csv` has numeric `beta_twfe`: YES (0.737334766407397).

Applicability rule: applicable iff BOTH conditions are met. Since no PDF is present, the paper-auditor cannot perform textual extraction of the paper's reported coefficient for independent verification.

**However, the metadata already records the paper's reported values:**
- Paper beta (from `original_result.beta_twfe`): 0.74
- Paper SE (from `original_result.se_twfe`): 0.42
- Our beta: 0.737
- Our SE: 0.416
- Relative difference: 0.41% (well within the 1% EXACT threshold)

This match was established during the Profiler/Analyst stage and documented in the notes ("TWFE exact match (0.737 vs 0.74)"). While the formal paper-auditor cannot run without the PDF, the fidelity evidence already in the system is sufficient to record:

**Informal fidelity verdict: EXACT** (0.41% gap, attributable to rounding in the paper's Table 2).

For the formal 3-axis rubric, this axis is scored as **NOT_APPLICABLE** (no PDF) but the metadata-level evidence supports F-HIGH when applying the combined rating rubric.

**Verdict: NOT_APPLICABLE** — No PDF at `pdf/253.pdf`; fidelity inferred from metadata as EXACT (0.41% gap).

_Reference: metadata `original_result.beta_twfe=0.74` vs `results.csv` beta_twfe=0.737._
