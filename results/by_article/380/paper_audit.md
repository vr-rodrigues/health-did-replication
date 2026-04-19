# Paper fidelity audit: 380 — Kuziemko, Meckel, Rossin-Slater (2018)

**Verdict:** FAIL
**Date:** 2026-04-19

## Selected specification
From metadata `original_result.source`: "Table 3 (after on Black mortality, with county-year controls)"
Applied SKILL_profiler protocol: Table 3, Column 3 is the preferred specification (authors' stated preferred spec,
explicitly identified in the text as "we take columns 3 and 4 as our preferred specification").
Outcome: Black infant mortality (blan_mort scaled ×100). Treatment: `MMC_ymc` (conceived after MMC). Controls:
log population, log per capita income, log per capita transfers, unemployment rate (county × year × month level).
FEs: conception year × month + county FEs + county-specific linear time trends.
Cluster: county.

## Comparison

| Source | β | SE | N (cells) | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 3 — Black w/ controls) | 0.179 | [0.0786] | 12,833 cells / 296,589 indiv. obs | county | ** |
| Our stored results.csv (beta_twfe) | 0.0683 | 0.0733 | not reported in results.csv | tx_code | n.s. |
| Relative Δ | −61.8% | −6.8% | | | |

## Notes
- Sign is the same (positive, black mortality increases under MMC), so this is not a sign flip.
- The relative beta difference of −61.8% firmly exceeds the 20% FAIL threshold.
- The metadata `notes` field documents the root cause explicitly: "Paper uses year+month+year-month FEs
  [i.e., conception year FEs, month-of-year FEs, AND year×month interaction FEs]; template uses
  time_int (integer months) as single time FE — simplified vs paper's multi-dimensional time FEs."
- The paper's equation (1) includes three time dimensions: γ_y (year FEs) × ν_m (month FEs), effectively
  a year×month interaction FE, plus county-specific linear time trends (μ_c × f(t)). Our template
  uses a single integer-month time FE without the county linear trends structure of the paper.
- The county linear trend (μ_c × f(t)) is a particularly important absorber of confounding variation
  and its omission alone would be expected to substantially inflate the TWFE estimate.
- SE divergence is modest (−6.8%), within tolerance; clustering structure is aligned (county).
- The 15 percentage-point gap (0.179 vs 0.068) is consistent with the identified FE simplification.
- No scale/unit mismatch: both paper and our stored result use mortality ×100 (percentage points).

## Verdict rationale
Our beta_twfe (0.0683) is 61.8% below the paper's headline estimate (0.179 in Table 3 Col 3),
driven by the template's use of a single integer-month time FE instead of the paper's
year × month two-way FEs plus county-specific linear time trends; verdict is FAIL.
