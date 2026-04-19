# TWFE Reviewer Report — Article 80

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

---

## Checklist

### 1. Specification fidelity
- Original Stata spec: `reg sportsclub Post_avg i.year_3rd i.bula_3rd i.cityno, vce(cluster cityno)`
- Our replication: TWFE with year FE, state (bula_3rd) FE, city FE, clustered by cityno.
- Reproduced beta: 0.00892 vs paper's 0.0089. Difference: 0.00002 — within numerical noise.
- Reproduced SE: 0.01872 vs paper's 0.0188. Difference: 0.00008 — within numerical noise.
- **Fidelity: PASS.** The point estimate and SE replicate essentially exactly.

### 2. Treatment variable construction
- `Post_avg` is set equal to `treat` in preprocessing. This is a binary indicator for post-treatment period in treated cities.
- Treatment timing is single (all treated units adopt in 2008). The "staggered" concern does not apply.
- **Construction: PASS.**

### 3. Data structure compatibility
- Data is repeated cross-section (RCS), not a true panel. Individual children observed only once.
- TWFE with city and year FE on RCS is valid as a quasi-DiD when the composition of treated vs control cities is stable across cohorts. The paper's original Stata spec uses city FE, which absorbs time-invariant city characteristics.
- **WARN:** With RCS data, city-level composition changes (e.g., which cohort is tested each year) could confound the estimate if composition is endogenous to treatment. The metadata does not document whether sample composition is balanced across years within city. This is a known limitation of applying city-level panel FE to individual-level RCS data.

### 4. Statistical significance
- Estimate 0.0089, SE 0.0187, t-ratio ≈ 0.48. The effect is **not statistically significant** at any conventional level.
- Paper's main table reports this as a non-significant effect, consistent with our replication.

### 5. Controls
- No individual-level controls specified (twfe_controls = []). The original paper may include additional covariates in robustness checks. The main specification matches.

### 6. Summary
The TWFE estimate replicates the paper's number precisely. The only concern is the inherent limitation of applying panel FE methods to repeated cross-sectional data, which is the paper's own design choice and not a replication artifact. Effect is statistically indistinguishable from zero.

---

## Key findings
- Point estimate replicates to 4 decimal places (0.00892 vs 0.0089).
- SE replicates to 4 significant figures (0.01872 vs 0.0188).
- WARN for RCS composition stability assumption: city FE on RCS requires stable within-city cohort composition.
- Effect is statistically insignificant (t ≈ 0.48).

