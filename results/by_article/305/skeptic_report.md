# Skeptic report: 305 — Brodeur, Yousaf (2020)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

**Methodology score:** M-LOW (4 WARNs, 0 FAILs among applicable methodology reviewers)
**Fidelity score:** F-NA (no PDF; fidelity axis not evaluated)
**Design credibility:** D-FRAGILE

---

## Executive summary

Brodeur & Yousaf (2020) use a staggered DiD design to estimate the effect of mass shootings on local employment (ln_emp_pop) across 173 treated US counties from 2000-2013. The paper's headline TWFE result is -2.658 (Table 2, Col 1), but this is obtained without division×year fixed effects and exhibits severe pre-trends (t-5 coefficient >1.5). The methodologically preferred specification with division×year FEs (Col 3, beta=-1.348) is what our implementation uses, and it is confirmed by Sun-Abraham (-1.421 at t=5 cumulative), Gardner (-1.848 at t=5), CS-NT (-1.276 simple), and CS-NYT (-1.257 simple). The point estimates are consistent and directionally robust: mass shootings reduce local employment by approximately 1.3-1.8 log points. However, four reviewers issued WARN verdicts: (1) large pre-period coefficients at t-5 and t-6 under both TWFE (with div×year FEs) and CS-DID specifications; (2) the aroundms filter creates structural panel imbalance that contaminates Bacon comparisons; (3) HonestDiD sensitivity shows the average and peak effects are robust only at M=0 and break quickly with even small assumed violations; (4) the CS-DID sample requires dropping 46 treated counties to achieve balance, a 27% reduction. Users should treat the stored estimate of -1.348 as directionally credible but fragile to modest violations of parallel trends, and should not use the Col 1 estimate (-2.658) for inference.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Our implementation uses Col 3 spec (beta=-1.348, div×year FEs), not Col 1 (beta=-2.658 in metadata's original_result). The two differ by 1.31 log points.
- TWFE event study: t-6 = +1.27 (SE=0.666), t-5 = +0.52 — moderate pre-trend elevation even with div×year FEs absorbed.
- SA and Gardner estimators confirm the negative post-period ramp-up, but t-6 elevation persists across all methods.
- [Full report: `reviews/twfe-reviewer.md`]

### CS-DID (WARN)
- CS-NT simple = -1.276 and CS-NYT simple = -1.257 are consistent with TWFE Col 3 — directionally robust.
- CS-DID pre-trends are larger than TWFE: t-6=+2.63 (SE=0.730), t-5=+1.70 (SE=0.653) — statistically significant pre-trends that exceed the post-period treatment effect at several horizons.
- CS-DID required dropping 46 treated counties (27%) to achieve a balanced panel, reducing generalisability.
- [Full report: `reviews/csdid-reviewer.md`]

### Bacon (WARN)
- 14 staggered cohorts (2000-2013) create substantial treated-vs-treated (TVT) comparison weight.
- Growing post-period treatment effects (ramp-up: -0.12 at t=0 to -1.79 at t=5) imply heterogeneous treatment effects that make TVT comparisons prone to negative Bacon weights.
- The aroundms filter asymmetry (treated: 8-16 years, never-treated: 24 years) contaminates the 2x2 DiD structure.
- [Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (WARN)
- TWFE: avg target is fragile (CI = [-1.247, +0.046] at M=0); peak target is robust at M=0 but breaks at M=0.25.
- CS-NT: avg (-1.607, -0.170) and peak (-2.231, -0.121) robust at M=0; first-post includes zero at M=0.
- Critical: the observed t-5 (0.52/1.70 TWFE/CS-NT) and t-6 (1.27/2.63) pre-trends imply realistic M>>1, at which point all targets in both estimators include zero.
- [Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing-binary-staggered design; CS-DID covers the relevant diagnostic space.
- [Full report: `reviews/dechaisemartin-reviewer.md`]

---

## Material findings (sorted by severity)

**WARN — Severity 1 (Design): Large pre-period trends under CS-DID**
Counties hit by mass shootings were experiencing employment growth (+1.7 to +2.6 log points) relative to never-treated counties 5-6 years before their shooting. This is larger than the post-period effect, raising serious questions about the parallel trends assumption. The div×year FEs in TWFE absorb part of this, but CS-DID (which cannot include the same FE structure) does not absorb it.

**WARN — Severity 2 (Design): HonestDiD robustness is M=0 only**
All HonestDiD results (except CS-NT avg and peak at M=0) are not robust to pre-trend violations. The observed pre-period coefficients imply M>>1 as the realistic benchmark, which would encompass zero for all estimates.

**WARN — Severity 3 (Implementation): aroundms structural panel imbalance**
The aroundms filter keeps ±6 years for treated but all 24 years for never-treated. This asymmetric window affects Bacon weights, TWFE identifying variation, and required the CS-DID sample to be constructed differently from the TWFE sample.

**WARN — Severity 4 (Implementation): CS-DID sample excludes 46 treated counties**
27% of treated counties had to be dropped from the CS-DID analysis to achieve balance. The 127-county CS-DID sample may not be representative of the 173-county TWFE sample.

---

## Recommended actions

1. **For the repo-custodian:** Investigate whether the `aroundms` filter can be symmetrised — e.g., restrict never-treated to the same window length (±6 years around each treated county's year) to eliminate the structural imbalance. This may substantially change TWFE estimates.

2. **For the repo-custodian:** Update `original_result.beta_twfe` in metadata from -2.658 (Col 1, no div×year FEs) to -1.348 (Col 3, div×year FEs) to reflect the spec actually implemented, OR add a second key `beta_twfe_col1: -2.658` for reference. As-is, the metadata's original_result does not match the stored result.

3. **For the repo-custodian:** Verify whether the 46 treated counties dropped from CS-DID (those without full 24-year balanced panels) are systematically different from the 127 retained. If so, note this as a generalisability limitation.

4. **For the pattern-curator:** Consider adding a pattern for "asymmetric event-window sample filter creates structural panel imbalance (treated window shorter than never-treated window), requiring CS-DID to use alternative balanced sample" — this is a design pattern distinct from the standard unbalanced-panel problem.

5. **For the user:** The directional conclusion (mass shootings reduce local employment by ~1.3-1.8 log points over 5 years) appears robust across all modern estimators. However, given the large pre-trends at t-5 and t-6, caution is warranted. We recommend interpreting the TWFE Col 3 estimate (-1.348) as an upper-bound on credibility; the null cannot be excluded under realistic pre-trend violation assumptions.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
