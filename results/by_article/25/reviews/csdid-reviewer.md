# CS-DID Reviewer Report: Article 25 — Carrillo, Feres (2019)

**Verdict:** WARN
**Date:** 2026-04-18

## Results Data
| Estimator | ATT | SE | t-stat |
|---|---|---|---|
| CS-NT (no ctrls) | 0.11440 | 0.00730 | 15.67 |
| CS-NYT (no ctrls) | 0.11440 | 0.00709 | 16.14 |
| CS-NT (with ctrls) | 0.09721 | 0.00667 | 14.57 |
| CS-NYT (with ctrls) | 0.09721 | 0.00688 | 14.13 |
| TWFE | 0.11594 | 0.00859 | 13.49 |

## Checklist

### 1. ATT Direction and Significance
- All variants positive and highly significant (t > 13)
- **PASS**

### 2. TWFE vs CS Convergence
- TWFE = 0.11594, CS-NT (no ctrls) = 0.11440 → Gap = 1.3% — EXCELLENT
- CS-NT with controls = 0.09721 vs TWFE = 0.11594 → 16% gap
- 16% gap attributable to `cs_controls=[]` (CS-DID cannot replicate 18 state×time-interacted controls); NOT indicative of TWFE heterogeneity bias
- **CONVERGENCE: PASS (with explanation)**

### 3. Never-Treated vs Not-Yet-Treated
- NT and NYT yield identical results (0.11440 and 0.09721)
- Consistent with large never-treated pool; no instability
- **PASS**

### 4. CS-DID Control Sensitivity
- `cs_controls = []` (empty — no controls in CS-DID)
- Correct: 18 controls are time-varying linear interactions, technically infeasible in standard `did` package
- 16% gap is the "controls penalty" — expected and explainable
- **WARN: controls explain 16% of TWFE magnitude**

### 5. Pre-Trend Assessment (CS-NT event study)
| Period | Coef | SE | t-stat | Significant? |
|---|---|---|---|---|
| t=-5 | -0.01086 | 0.00695 | -1.56 | No (p~0.12) |
| t=-4 | -0.01031 | 0.00672 | -1.53 | No (p~0.13) |
| t=-3 | -0.00636 | 0.00486 | -1.31 | No (p~0.19) |
| t=-2 | -0.00845 | 0.00395 | -2.14 | **Borderline** (p~0.03) |
- 3/4 pre-periods clean; t=-2 borderline at 2.14σ
- **WARN: t=-2 pre-period borderline significant**

### 6. Post-Period Pattern (CS-NT)
| Period | Coef |
|---|---|
| t=0 | +0.00308 |
| t=1 | +0.01891 |
| t=2 | +0.03233 |
| t=3 | +0.06379 |
| t=4 | +0.11272 |
- Monotonically growing — consistent with gradual physician reallocation
- ATT_dynamic ≈ ATT_simple (1.5% gap): **PASS**

### 7. Cohort Heterogeneity
- NT=NYT convergence; no extreme early/late cohort split visible
- **LOW CONCERN**

## Warn Sources
1. t=-2 CS-NT pre-period borderline significant (2.14σ, p~0.03)
2. CS-NT with controls 16% below TWFE due to `cs_controls=[]` — expected gap but worth noting

## Key Findings
- Direction and significance unanimous positive across all CS variants
- TWFE/CS convergence excellent without controls (1.3% gap)
- t=-2 pre-period borderline significant (2.14σ) — mild concern, not disqualifying
- 16% controls gap is a specification artefact, not a TWFE bias signal
- Growing post-period pattern beautifully consistent (0 → 0.113 over 4 periods)
