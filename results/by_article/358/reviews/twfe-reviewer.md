# TWFE Reviewer Report — Article 358
## Bargain, Boutin, Champeaux (2019)

**Verdict:** PASS

**Date:** 2026-04-18

---

## Checklist

### 1. Design validity

- **Two time periods only (2008 and 2014).** The treatment event is the 2011 Egyptian Arab Spring, a single shock. With exactly two periods and a single treatment event, TWFE is equivalent to a clean 2x2 DiD. No staggered adoption problem arises.
- Treatment variable `post_group` is a pre-computed dummy equal to 1 for post-period (year=2014) observations in treated municipalities (above-median protest intensity governorates). This correctly encodes a DiD interaction.
- Data structure is repeated cross-section, which is appropriate for `areg` with municipality FE in the original paper and for `feols` in the replication.

### 2. Fixed effects structure

- Municipality FE (`ID_2`) plus time variation absorbed by the `post` control variable. With only 2 years, this is equivalent to a two-way FE specification.
- Cluster-robust SEs at municipality level (`cluster(ID_2)`) — 272 municipalities, well above the 42-cluster rule-of-thumb.
- Additional FEs: none declared. Consistent with original `areg` spec.

### 3. Controls

- 30 control variables including socioeconomic characteristics and post × covariate interactions. This is a rich control set consistent with the paper's Table 1 Model 4 (baseline with full interactions).
- Including post × covariate interactions in TWFE with only 2 periods is methodologically sound — it allows treatment effect heterogeneity to be absorbed rather than biasing the TWFE coefficient.

### 4. Coefficient replication

- Replication: beta = 4.181, SE = 1.053
- Paper: beta = 4.181, SE = 1.058
- Coefficient: exact match to 3 decimal places.
- SE: trivial difference (0.5%) attributable to small-sample degrees-of-freedom correction in feols vs. Stata areg. Not a concern.

### 5. Negative weights / heterogeneous treatment effect bias

- **Not applicable.** With two time periods and a single treatment cohort, TWFE = 2x2 DiD. No negative-weighting pathology from staggered adoption is possible.
- The Bacon decomposition is meaningless here (and was correctly skipped).

### 6. Pre-trends

- No pre-period data available (only 2008 and 2014). Pre-trend testing is structurally impossible. This is a limitation of the data, not of the replication specification.
- The parallel trends assumption is untestable — standard disclaimer applies.

### 7. Sample

- N = 27,782 observations, consistent with the paper's declared sample.

---

## Summary

The TWFE specification is correctly implemented. The 2x2 DiD structure with a single treatment event means the classic modern DiD critiques (negative weights, heterogeneous timing) are structurally irrelevant. The coefficient replicates exactly. The only methodological caveat — inability to test pre-trends — is inherent to the two-period data structure, not a flaw in the analysis.

**Verdict: PASS**
