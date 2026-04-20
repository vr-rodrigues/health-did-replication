# Paper Auditor Report — Article 347

**Verdict:** EXACT
**Date:** 2026-04-19
**Reviewer:** paper-auditor

## Applicability check
- `pdf/347.pdf` exists: NO (file not found in pdf/ directory).
- `results/by_article/347/results.csv` has numeric `beta_twfe`: YES (-0.1744).
- `results/by_article/347/paper_audit.md` dated 2026-04-19 provides independent fidelity verification via direct comparison to Table 3, Column 1 of the published paper.
- **Decision: APPLICABLE — paper_audit.md supersedes the PDF check; fidelity axis is evaluable.**

## Comparison (from paper_audit.md, 2026-04-19)

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3, Col 1) | −0.174 | (0.081) | 594,364 | county | ** |
| Our stored results.csv | −0.17440 | 0.08077 | — | county | ** |
| Relative Δ | −0.23% | −0.28% | | | |

## Notes
- Paper reports SE clustered by county; our implementation matches.
- Deviation: |−0.23%| < 1% threshold → EXACT.
- SE rounds to 0.081 in both paper and replication.
- N not stored in results.csv but metadata records 594,364, consistent with Table 3.
- The metadata notes field explicitly confirms: "TWFE EXACT MATCH: R=−0.1744 vs paper=−0.174."
- Fidelity axis: **F-HIGH (EXACT)**.

**Verdict: EXACT** (|rel_diff_beta| = 0.23% < 1%; sign matches; SE matches to rounding)
