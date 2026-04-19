# Paper fidelity audit: 242 — Moorthy, Shaloka (2025)

**Verdict:** FAIL
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Figure 2 / main DiD specification. Stata: reghdfe lnearns_gen1_a1499 ddtquartile1 c.medianhhinc1990#i.year ... [aw=pop2000] if balancesample==1, absorb(splay1_year_fe cntyfips2000) vce(cl cntyfips2000)."

The paper's primary outcome is mortality (IHS of deaths, Table 2), but the restricted NVSS mortality data are not in the public replication package. Per metadata notes (Outcome selection: Rule (ii) largest N), the pipeline substitutes log earnings (`lnearns_gen1_a1499`, all genders, ages 14-99) from the QWI database. This is the largest-N available public outcome.

The paper's Figure 2 shows gender-split earnings (Panel A male, Panel B female). The only all-gender earnings tabulation is **Table B.4 Col 3** (Men and Women combined; with 2000 pop. weights; omits ND & MT; no missing-county exclusion; N=6,422). This is the closest comparable reference for our all-gender TWFE.

Selected specification: Table B.4 Col 3 — all-gender log earnings, balanced sample omitting ND & MT, pop-weighted, 1990 controls x year interactions, absorb(play x year FE + county FE), cluster county.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table B.4 Col 3, all-gender earnings) | 0.027 | [0.008] | 6,422 | county | *** |
| Our stored results.csv (beta_twfe) | 0.01944 | 0.00756 | ~8,513 obs | county | ** |
| Relative Δ | -28.0% | -5.5% | | | |

Alternative reference points from the paper:

| Source | β | SE | rel_diff_beta |
|---|---|---|---|
| Fig 2 Panel A (male earnings, omits ND/MT, pop weights) | 0.028 | [0.008] | -30.6% |
| Fig 2 Panel B (female earnings, omits ND/MT, pop weights) | 0.020 | [0.007] | -2.8% |
| Table B.4 Col 1 (all-gender, no weights, includes ND/MT, N=8,513) | 0.046 | [0.011] | -57.7% |

## Notes

1. **Outcome substitution.** The paper's headline result is mortality (Table 2, Col 1: Top-Quartile x Post = -0.024 [0.0099], IHS of all-cause deaths, balanced sample omitting ND/MT). Our pipeline cannot replicate this because restricted NVSS microdata are absent from the public replication package. The earnings outcome is a deliberate substitute documented in metadata notes.

2. **Sample mismatch.** Our implementation uses `balancesample==1` with `year >= 2002 & year <= 2013`, yielding ~8,513 obs. The paper's balanced sample (Table B.4 Col 3) omits ND & MT, yielding N=6,422. Our pipeline does NOT drop ND & MT. Table B.4 Col 1 (no ND/MT exclusion, no weights) with N=8,513 reports 0.046 [0.011], which diverges even more from our 0.0194.

3. **Weight ambiguity.** Our metadata specifies `weight: pop2000`, matching the paper's population weights. The paper's Table B.4 Col 1 (no weights) gives 0.046; with weights (Col 2-3) gives 0.027. Our 0.0194 falls below even the weighted estimate.

4. **Gender scope.** `lnearns_gen1_a1499` is all-gender aggregate earnings. The paper presents gender-specific results in Figure 2 (male 0.028, female 0.020) and the all-gender breakdown only in robustness Table B.4. No single canonical all-gender number is highlighted in the main text.

5. **SE divergence.** Relative SE difference (-5.5%) is within the 30% tolerance threshold; SE is not a concern.

6. **Sign agreement.** Both signs are positive (fracking boom increases earnings). Sign is correct.

7. The FAIL verdict is driven by a 28% shortfall in the point estimate versus the closest comparable paper number (Table B.4 Col 3). The most likely source is that our pipeline includes ND and MT counties (which had exceptionally large positive earnings shocks per Wilson 2020) without the paper's ND/MT exclusion correction — but even the no-exclusion column (Col 1, no weights, N=8,513) gives 0.046, further from our estimate. This suggests an additional specification gap beyond the ND/MT issue, likely in how the balancesample restriction interacts with the QWI coverage years (2002-2013 vs the paper's full event-study balanced window).

## Verdict rationale

Our stored TWFE estimate (0.0194) diverges by 28% from the closest all-gender earnings reference in the paper (Table B.4 Col 3: 0.027), exceeding the 20% FAIL threshold; the divergence stems from sample construction differences (ND/MT inclusion, year range) compounded by the outcome being a public-data substitute for the paper's primary restricted-access mortality outcome.
