# TWFE Reviewer Report — Article 210 (Li et al. 2026)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- [x] Estimator: reghdfe with unit FE (id) + time FE (yearmonth). Matches metadata and paper (Table 3 Col 3).
- [x] Controls: 9 time-varying controls (GDPadj, old, POP, NumHos, NumPhy, NumBed, GovExp, inten, InsurExp_Urban) — matches Stata spec.
- [x] Clustering: at clusterid (province-level). Matches paper.
- [x] Outcome: lnprice. Correct.
- [x] Treatment indicator: treat1 (binary absorbing). Correct.

### 2. Numerical fidelity to paper
- Our beta_twfe = 0.01854 vs paper = 0.019. Deviation: **2.44%** — within tolerance (EXACT/WITHIN_TOLERANCE band).
- Our SE = 0.00574 vs paper SE = 0.006. Deviation: 4.3% — within tolerance.
- VERDICT: TWFE estimate reproducible.

### 3. Pre-trend test (event study, t=-12 to t=-2)
**CRITICAL FAILURE — all 11 pre-period coefficients are statistically significant and negative:**

| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=-12 | -0.0356 | 0.0140 | **-2.54** |
| t=-11 | -0.0326 | 0.0109 | **-2.99** |
| t=-10 | -0.0286 | 0.0102 | **-2.80** |
| t=-9  | -0.0280 | 0.0093 | **-3.00** |
| t=-8  | -0.0274 | 0.0083 | **-3.32** |
| t=-7  | -0.0187 | 0.0077 | **-2.45** |
| t=-6  | -0.0138 | 0.0067 | **-2.05** |
| t=-5  | -0.0137 | 0.0050 | **-2.75** |
| t=-4  | -0.0085 | 0.0040 | **-2.11** |
| t=-3  | -0.0065 | 0.0026 | **-2.50** |
| t=-2  | -0.0049 | 0.0016 | **-2.99** |

All pre-period estimates are monotonically converging from large negative (t=-12: -0.036) toward zero at t=-1. This is a textbook **anticipation or differential pre-trend pattern**: treated provinces had systematically lower drug prices relative to control provinces in the years before the policy — and this difference was shrinking. The pattern is consistent with either: (a) pre-existing price convergence trends absorbed into the post-period "effect"; (b) anticipation effects; or (c) contamination from using already-treated cohorts as implicit controls (all-eventually-treated design with unbalanced panel).

### 4. All-eventually-treated design with TWFE
- There are NO never-treated units. TWFE with `treat1` uses only relative timing variation.
- In unbalanced panels, this means late-treated units serve as controls for early-treated units *before* their own treatment, and vice versa. This creates the well-documented "forbidden comparisons" problem.
- The large negative pre-trend is the hallmark of this contamination: already-treated units assigned as controls show lower prices relative to not-yet-treated treated units, generating spurious negative pre-trends.

### 5. Controls asymmetry
- TWFE uses 9 time-varying controls; CS-DID uses none (cs_controls=[]).
- This is Pattern 30 territory: controls in TWFE but not CS. The controls absorb the pre-trend partially, inflating the apparent post-period effect.
- The Gardner/BJS estimate (which uses the same control-imputation structure) shows much larger post-period effects (+0.023 at t=0, growing to +0.084 at t=12) than either TWFE or CS-NYT.

### 6. Rating justification
The TWFE estimate is numerically reproducible, but the event study reveals severe pre-trend violations (all 11 pre-periods significant). The pre-trend pattern is monotone and fully consistent with contaminated comparisons in an all-eventually-treated design. This means the parallel trends assumption is not satisfied for the TWFE estimand, and the positive post-period TWFE coefficient may reflect pre-existing convergence rather than a causal drug price reduction.

**Verdict: WARN** (pre-trend failure; not FAIL because the estimate is numerically reproduced and the direction of effect is plausible under a correct estimator; the concern is the identification assumption, not the implementation).
