# TWFE Reviewer Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

---

## Specification summary

- Outcome: `GT4pres` (share of prescriptions with >= 4 prescribers per beneficiary)
- Treatment: `Post_avg` (binary absorbing indicator for must-access PDMP adoption)
- Unit FE: state (`ssastate`); Time FE: half-year (`halfyear`)
- Clustering: state level
- Weights: `takers` (Medicare beneficiary count)
- Controls: none (group `escalonada_sem_controles`)
- Cohort structure: 4 adoption cohorts — Oklahoma (halfyear 102), Delaware/Ohio (104), Kentucky/New Mexico/West Virginia (105), never-treated (0)
- Panel: staggered, unbalanced (`allow_unbalanced = true`)

---

## Checklist

### 1. Treatment variable construction — PASS
`Post_avg` correctly flags post-adoption periods for must-access states only (`evermustaccess == 1 AND eventhalfyear >= 0`). Never-treated states correctly receive 0. The preprocessing fix ensuring `eventhalfyear = NA` for never-treated states in the event study is correctly implemented.

### 2. Parallel pre-trends — WARN
Event study coefficients (TWFE, binned window -5 to +2):

| Period | Coefficient | SE |
|--------|------------|-----|
| t=-5 | +0.000897 | 0.000814 |
| t=-4 | -0.000105 | 0.000619 |
| t=-3 | -0.001711 | 0.000838 |
| t=-2 | -0.001295 | 0.000855 |
| t=-1 | 0 (omitted) | — |
| t=0 | -0.003526 | 0.001268 |

The t=-3 coefficient (-0.00171) is 91% of the post-treatment ATT in magnitude, and t=-2 (-0.00130) is 69% of the ATT. These magnitudes are economically substantial. The pattern is non-monotonic (near-zero at t=-4, large dip at t=-3 and t=-2), which is consistent with either pre-adoption anticipatory behaviour or a violation of parallel trends. This raises meaningful concern about the identifying assumption.

### 3. Bacon decomposition — PASS (low contamination)
Weights from Bacon decomposition:

| Comparison type | Weight |
|---|---|
| Treated vs Never-treated | ~89.2% |
| Later vs Earlier treated | ~5.5% |
| Earlier vs Later treated | ~5.3% |

The large majority of TWFE weight (~89%) falls on clean treated-vs-never-treated comparisons. Contamination from timing-based "bad" comparisons (later/earlier treated serving as controls) is minimal (~11%), and those comparisons have very small individual weights (max 0.006). This substantially limits the scope for negative weighting bias in this design.

### 4. Treatment effect dynamics — WARN
Post-treatment effects show significant decay: t=0 (-0.00353) → t=1 (-0.00175) → t=2 (-0.00125). The effect at t=2 is only 35% of the effect at t=0. This strong dynamic pattern means the static TWFE coefficient (-0.00187) is an average that conflates the immediate large effect with smaller later effects. Interpretation of the static estimate requires care.

### 5. Staggered adoption bias — PASS (low risk)
The 4 cohorts are temporally concentrated (halfyear 102–105, spanning only ~1.5 years). With cohorts this close in adoption timing, the scope for cohort-heterogeneity bias in TWFE is limited. The Bacon decomposition confirms this — later-vs-earlier weighted comparisons contribute trivially.

### 6. Standard errors — PASS
Clustering at the state level is appropriate for a state-level policy intervention. N = ~51 states; clustering with ~50 clusters is at the lower bound of asymptotic reliability but conventional for state-panel designs.

---

## Summary

The TWFE specification is defensible in structure: the treatment indicator is correctly constructed, the Bacon decomposition shows minimal timing contamination, and clustering is appropriate. The primary concern is the large pre-trend coefficients at t=-3 and t=-2 (91% and 69% of ATT magnitude respectively), which raise questions about the parallel trends assumption in the periods immediately prior to adoption. The strong post-adoption effect decay further complicates interpretation of the static ATT.

**Verdict: WARN** — pre-trend pattern at t=-3 and t=-2 is the dominant concern; Bacon weights are clean.
