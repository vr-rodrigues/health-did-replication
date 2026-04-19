# TWFE Reviewer Report — Article 263

**Article:** Axbard, Deng (2024) — "Informed Enforcement: Lessons from Pollution Monitoring in China"
**Reviewer:** twfe-reviewer
**Date:** 2026-04-18

**Verdict:** WARN

---

## Checklist

### 1. Treatment variable construction
- Treatment is constructed as `Post_avg = as.integer(min_dist_10 == 1 & post1 == 1)`.
- This is an interaction of a binary geographic indicator (within 10 km of air monitor) and a post-2015 dummy.
- Single treatment date: Q1 2015 (time = 21). All treated firms adopt simultaneously — no staggered rollout.
- **Status: PASS** — construction is faithful to the paper's Stata specification (`c.min_dist_10#c.post1`).

### 2. Fixed effects specification
- FEs: firm (`id`) + time + `industry^time` + `prov_id^time`.
- The additional FEs (`industry^time`, `prov_id^time`) are correctly specified in metadata.
- This matches the paper's `reghdfe` absorb specification.
- **Status: PASS** — FE structure is correctly replicated.

### 3. Clustering
- Clustered by `city_id` (171 cities).
- Matches paper's cluster specification.
- Note: The paper also reports Conley spatial HAC SEs as a robustness check; our implementation uses only cluster-robust SEs, which is acceptable for the main specification.
- **Status: PASS**

### 4. Sample filter
- Filter: `min_dist < 50 & starty <= 2010 & !is.na(revenue) & !is.na(key)`
- This restricts to firms within 50 km (bandwidth), founded by 2010, with non-missing revenue and key identifier.
- N ≈ 36,103 firms × 32 quarters = ~1.15M observations.
- **Status: PASS** — matches paper's sample construction.

### 5. TWFE estimate
- `beta_twfe = 0.00333` (SE = 0.000556)
- t-statistic ≈ 5.99 — highly statistically significant.
- The effect magnitude (0.33 pp increase in probability of any air enforcement) is small in absolute terms but economically meaningful given the baseline.
- **Status: PASS**

### 6. Controls
- No baseline controls (`twfe_controls = []`). This matches the paper's baseline specification.
- `beta_twfe_no_ctrls` equals `beta_twfe` (0.00333) confirming no controls were added.
- **Status: PASS**

### 7. WARN flag: High-dimensional FEs and collinearity risk
- The specification includes `industry^time` (531 industry-quarter dummies) and `prov_id^time` (21 province-quarter dummies), in addition to firm and time FEs.
- This is a very demanding specification (~550+ interacted FEs). The notes document that adding these as CS controls causes overfitting (ATT=0), confirming the FE structure is near-collinear with the variation used by CS-DID.
- TWFE can absorb these mechanically via within-transformation; semiparametric estimators cannot. This is a genuine methodological tension documented as Pattern 50 in the knowledge base.
- The TWFE β is valid under the assumption that industry-time and province-time shocks are correctly absorbed, but the estimator conflates the treatment effect with any residual variation after removing these shocks.
- **Status: WARN** — High-dimensional interacted FEs create near-identification concerns for alternative estimators. TWFE itself is internally consistent but the parallel trends assumption conditional on these FEs is untestable at this granularity.

### 8. Event study pre-trends (TWFE)
- Pre-period coefficients (t=-5 to t=-2, relative to t=-1 reference):
  - t=-5: 0.000085 (SE=0.000847) — insignificant
  - t=-4: 0.000202 (SE=0.000920) — insignificant
  - t=-3: 0.001306 (SE=0.001214) — insignificant (p≈0.28)
  - t=-2: 0.000710 (SE=0.000995) — insignificant
- All pre-period estimates are small relative to the post-period ATT (~0.0033) and statistically insignificant.
- **Status: PASS** — parallel trends hold in pre-period under TWFE.

---

## Summary

The TWFE implementation faithfully replicates the paper's baseline specification. The estimate (β=0.00333, SE=0.000556) is credible, pre-trends are clean, and the sample/FE/cluster choices match the paper. The sole concern is the very high-dimensional interacted FE structure (industry×time, province×time), which passes within TWFE but cannot be accommodated by semiparametric estimators — this is a structural limitation documented as Pattern 50 and generates the 7x SE widening in CS-DID. This does not invalidate the TWFE estimate per se, but raises the question of whether the identifying variation after conditioning on 550+ FEs is narrow enough to threaten external validity.

**Verdict: WARN** (one methodological concern: high-dimensional FE structure creates untestable parallel-trends assumptions and precludes equivalent CS-DID conditioning)
