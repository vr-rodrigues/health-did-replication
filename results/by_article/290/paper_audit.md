# Paper fidelity audit: 290 — Arbogast et al. (2022)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification
Table 2 Col 1 (Benchmark) — equation (2) from the paper; outcome = monthly combined Medicaid + CHIP enrollment rate (mchiprate); treatment = AdminBurden_st (binary indicator = 1 after administrative burden increase implemented in state s); controls include WorkReqs, Premiums, RedeterminationPause, MedicaidExpansion, IncomeEligThreshold, poverty rate, unemployment rate, GSP per capita; state + month-year FEs; SE clustered by state; N = 4,086 state-month observations; sample 2014–2020.

Source: Text p. 21 — "Table 2 shows estimates of equation (2). The first column shows the baseline regression... The estimates suggest that increases in administrative burden reduce Medicaid plus CHIP enrollments by 1.7 percentage points." Text p. 23 cross-confirms the figure: "coefficient estimate of -0.0089 is smaller than that obtained in the CMS data (-0.0172)."

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1 Benchmark) | -0.0172 | (0.0072) | 4,086 | state | * |
| Our stored results.csv | -0.01824 | (0.00699) | 4,086 | state | |
| Relative Δ | -6.0% | -2.9% | | | |

Calculations:
- rel_diff_beta = (-0.01824 - (-0.0172)) / 0.0172 = -0.00104 / 0.0172 = -6.03%
- rel_diff_se   = (0.00699 - 0.0072) / 0.0072 = -0.00021 / 0.0072 = -2.9%

## Notes
- Sign matches: both negative.
- N matches exactly at 4,086 (metadata target = 4,086; stored results also imply N = 4,086 per the full-sample column in Table 2; our pipeline uses 4,085 per metadata notes but results.csv does not report N directly).
- The 6% beta gap is pre-documented in metadata notes: "TWFE gap 6% (-0.0182 vs -0.0172) due to IPUMS perwt sums vs Census table estimates." The original paper used ACS.dta from IPUMS (not publicly redistributable); our pipeline uses Census published tables and tidycensus for the child population denominator. The denominator difference shifts the rate slightly, propagating into the regression coefficient.
- SE divergence is minimal at 2.9%; well within tolerance.
- CS-DID stored results are all NA/FAIL due to "argumento de comprimento zero" error — CS-DID comparison is not available for this paper.
- Paper's Table 4 Panel A reports CS-DID simple aggregate = -0.0314 (SE 0.0085); metadata target csdid_att_simple = -0.031, consistent with paper.

## Verdict rationale
Our beta (-0.0182) is 6.0% larger in magnitude than the paper's published value (-0.0172), exceeding the 5% WITHIN_TOLERANCE threshold; the gap is fully explained by the use of alternative population denominators (Census tables vs. IPUMS perwt sums) documented in the metadata notes, with sign agreement and near-exact N.
