# Paper Auditor Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-19

**Verdict:** EXACT

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | -0.037 | (0.010) | 24,002 | teacher | *** |
| Our stored results.csv | -0.037180 | 0.010253 | 24,002 | teacher (clave) | *** |
| Relative Δ | -0.49% | +2.53% | — | — | — |

## Notes

- Paper reports coefficient rounded to three decimal places (-0.037); our stored value -0.037180 matches to four significant figures.
- SE divergence of 2.53% is negligible; both cluster at the teacher level.
- N = 24,002 consistent with sample filter `sample_turnover == 1 & age < 55`.
- No unit-of-measurement mismatch: both in linear probability model (percentage points).
- Section 3.3 of the paper confirms: "it reduces the probability that the teacher leaves the school after one year by 3.7 percentage points."

## Verdict rationale

Our stored beta_twfe of -0.03718 differs from the paper's -0.037 by only 0.49% with matching sign, SE, and N, placing this firmly in the EXACT category (threshold: <1% relative delta).

Note: A prior cached version of this report (2026-04-18) returned NOT_APPLICABLE because the PDF was not available at that time and `original_result` was empty. The fidelity was established on 2026-04-19 via direct PDF inspection (paper_audit.md). This cached review is updated accordingly.
