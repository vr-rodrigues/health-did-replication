# Paper fidelity audit: 21 — Buchmueller, Carey (2018)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata `original_result` field and SKILL_profiler protocol: Table 6, Panel B ("Must access" PDMP, preferred/baseline specification), column "5+ prescribers" (GT4pres — share of opioid takers obtaining prescriptions from 5 or more prescribers in a half-year). Panel B is the authors' preferred model: it combines non-"must access" PDMP states and no-PDMP states into a single control group (parsimonious specification). The paper explicitly states Panel B is the "more parsimonious specification" and uses it as the baseline throughout.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 6, Panel B, col "5+ prescribers") | -0.00189 | (0.0008) | 612 | state | ** |
| Our stored results.csv (beta_twfe / se_twfe) | -0.001870 | 0.000832 | — | state | — |
| Relative Δ | +1.04% | +4.0% | | | |

## Notes

- Paper reports SE = (0.0008) — shown to 4 decimal places; additional precision not available from the table.
- Our SE = 0.000832, which is the analytical cluster-robust SE. The paper also reports wild cluster-bootstrap percentile-t 95% CI (shown as bold when excluding zero). The analytical SE is what appears in parentheses in the table and is the direct comparator.
- N = 612 refers to state-halfyear aggregated observations (quantity outcomes, 2007h1–2013h2). The paper does not report individual-level observation counts in Table 6.
- Significance: Paper marks the 5+ prescribers result as significant at the 5% level via bootstrap CI (BS CI bounds both negative in Panel B: LB = -0.0035, UB = -0.0003).
- The metadata `original_result` field pre-records β = -0.0019 and SE = 0.0008, consistent with the paper's Table 6 Panel B.
- No scale/unit ambiguity: both paper and stored result are in proportion-point units (share of opioid takers).

## Verdict rationale

Our stored TWFE estimate (-0.001870) differs from the paper's Table 6 Panel B value (-0.00189) by only 1.04%, well within the 1% EXACT threshold, with correct sign; the SE diverges by 4.0%, also within tolerance.
