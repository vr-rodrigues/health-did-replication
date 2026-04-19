# TWFE Reviewer Report — Article 47 (Clemens 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification alignment
- Treatment variable: `Post_avg` = `communityratingstate2 × post1`, correctly identifies community-rating states post-1993.
- Unit FE: `state_fips`. Time FE: `t` (actyear recoded to 1–8, dropping 1993–1995). Both included.
- Controls: full set of demographic interactions as specified (kid indicators, superregion × femhead/black/poverty, educ_category, workersB, ownershp, householdocc1990). Matches paper equation (3) exactly.
- Sample filter: small-firm workers (parentsmallfirm==1), excludes states MA (25), NJ (34), KY (21), NH (33) — correctly restricts to "stable" community-rating states (NY, ME, VT) plus controls.
- Weights: CPS person weights (`perwt`). Consistent with paper notes.

### 2. Numerical fidelity
- Paper (Table 5, Panel A, col 1): beta = -0.0962, SE = 0.0206, N = 127,554.
- Our estimate: beta = -0.09617, SE = 0.00974, N confirmed via replication notes as 127,554.
- Point estimate gap: 0.03% — EXACT MATCH.
- SE discrepancy: paper SE = 0.0206 vs our SE = 0.00974. The paper uses a block bootstrap with clusters at the state level; our SE is from analytic clustering. This is a known mechanical difference — the bootstrap SE is approximately 2× larger, consistent with few treated clusters (3 treated states: NY, ME, VT). This is NOT a sign of misspecification; it reflects the small-cluster bootstrap penalty.

### 3. Design concerns

**WARN flag — pre-trend at t = -5:**
The event study (event_study_data.csv) shows:
- TWFE t=-5: coef = -0.027, SE = 0.0086 (t ≈ 3.1, p ≈ 0.002)
- TWFE t=-4: coef = -0.003, SE = 0.0089 (insignificant)
- TWFE t=-3: coef = +0.013, SE = 0.0107 (insignificant)
- TWFE t=-2: coef = -0.001, SE = 0.0108 (insignificant)

The t=-5 coefficient (year 1987 relative to treatment in 1993) is statistically significant and negative. This could indicate a pre-trend or could reflect New Jersey's uncompensated care spiral (explicitly discussed by Clemens at pp. 123–124) affecting the pre-period. The paper itself acknowledges this instability; its preferred specification uses only the stable states (NY, ME, VT) for the main estimates, but the event study still flags a divergence at the earliest pre-period. This raises modest concern about parallel trends.

**Single cohort — no staggered heterogeneity:**
Treatment_timing is "single" (all stable states adopt community rating simultaneously in 1993). There is no differential timing across treated units, so TWFE is not contaminated by heterogeneous treatment timing bias. This is a significant methodological strength.

**Repeated cross-section — no unit-level panel:**
The underlying data are repeated cross-sections (CPS individuals). TWFE is applied at the state×year level, which is appropriate. No compositional bias concern beyond what is controlled by covariates.

**Few treated clusters:**
Only 3 treated states (NY, ME, VT). This is the fundamental inference challenge Clemens addresses via bootstrap. Conventional clustered SEs understate uncertainty; bootstrap-based SEs (as reported) are more appropriate. Our analytic SE therefore should not be compared directly to the paper's SE.

### 4. Summary
The TWFE specification is correctly implemented and achieves an exact point-estimate match. The primary concern is the statistically significant pre-trend at t=-5, which the paper's own event study reveals, suggesting possible pre-existing differential trends that may partially violate the parallel trends assumption. The single-cohort design avoids staggered-timing bias.

## References
- event_study_data.csv: TWFE pre-period coefficients
- metadata.json: specification details
- Clemens (2015) pp. 119–120: equation (3), bootstrap clustering

