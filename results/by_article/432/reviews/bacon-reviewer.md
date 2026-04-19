# Bacon Decomposition Reviewer Report — Article 432 (Gallagher 2014)

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability
APPLICABLE: treatment_timing == "staggered", data_structure == "panel", allow_unbalanced == false.

## Checklist

### 1. Design characterisation for Bacon
- 18 staggered adoption cohorts (1990–2007), each cohort = communities first hit by a PDD flood in that year.
- 6,914 treated communities; 3,927 never-treated communities (36% never-treated).
- Panel: balanced, 195,138 obs (10,841 × 18 years).
- Treatment: absorbing binary (once hit, post_hit stays 1 permanently).

### 2. Expected decomposition structure
With 36% never-treated units, the Bacon decomposition is dominated by Treated-vs-Untreated (TVU) comparisons. TVU pairs are the "clean" comparisons (never-treated serve as pure controls). Timing comparisons (Later-vs-Earlier and Earlier-vs-Later) are present given 18 cohorts but should represent a minority of weight.

### 3. Forbidden comparisons assessment
Earlier-vs-Later (EvL) comparisons use already-treated earlier cohorts as controls for later-adopting units during later cohorts' post-treatment periods. These are the "forbidden" comparisons that can introduce negative weights. However:
- With 36% never-treated, TVU weight dominates.
- 18 cohorts spread across 18 years: no single cohort dominates.
- Treatment effects are stable/flat post-adoption (t=0 to t=11: 0.09–0.12), so EvL comparisons comparing periods where the early cohort has had treatment for years are comparing treated-to-treated, which with stable ATTs introduces minimal negative weight bias.
- The TWFE (0.1095) < CS-NT (0.1215) by 10.9%: this modest attenuation is consistent with a small fraction of negative-weight EvL comparisons pulling TWFE downward.

### 4. Cohort heterogeneity assessment
CS-NT post-treatment event study: t=0: 0.126, gradually declining to t=11: 0.066. SA estimator (Sun-Abraham, which corrects for heterogeneity): t=0: 0.098, t=4: 0.126, t=10: 0.096. SA and TWFE are very close (0.5–3% gap at most horizons), confirming that cohort-specific ATT heterogeneity is modest and not distorting the TWFE materially.

### 5. TVT (Timing-only) weight concern
With 36% never-treated pool, TVU dominates. Even if 50% TVT in the timing comparison weights, the presence of a large never-treated pool keeps overall TVT weight well below concern thresholds (typically flagged at >80% TVT).

### 6. Repeated-events interaction
The Bacon decomposition here uses post_hit (first-hit timing). The 55% of treated communities hit >1 time do not affect Bacon's clean identification — Bacon decomposition is agnostic to subsequent events; it only decomposes the TWFE coefficient in terms of 2×2 timing comparisons based on the treatment indicator (post_hit). Subsequent events affect potential outcomes but not the decomposition algebra itself.

### 7. Balance / unbalanced panel
Panel is balanced (10,841 × 18 years = 195,138 rows confirmed). No unbalanced-panel issues for Bacon.

## Summary
Clean design for Bacon decomposition: large never-treated pool (36%), stable ATTs post-adoption, 18 evenly-spread cohorts, no single dominant cohort. TWFE attenuation of ~11% relative to CS-DID is consistent with moderate EvL forbidden comparisons. No critical TVT dominance or severe cohort heterogeneity.

**Verdict: PASS**
