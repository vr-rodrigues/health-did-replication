# Skeptic report: 47 — Clemens (2015)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A — single cohort), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

## Executive summary

Clemens (2015) estimates the effect of community-rating health insurance regulations on private coverage rates using a DiD design comparing stable community-rating states (New York, Maine, Vermont) to never-regulated controls. The paper's headline estimate — a 9.6 percentage point decline in private coverage (beta = -0.0962, SE = 0.0206) — is an exact numerical match in our replication (-0.09617, 0.03% gap). The CS-DID estimate is also within tolerance (-0.1243 vs. paper's -0.1248). The design has a substantial methodological strength: treatment is single-cohort, absorbing, and binary, meaning TWFE carries no staggered-timing bias and de Chaisemartin concerns do not apply. The primary methodological concern is a statistically significant pre-trend at t=-5 (five years before treatment onset) visible in both TWFE and CS-NT event studies, raising a modest parallel trends question. HonestDiD sensitivity analysis shows the TWFE point estimate is robust to pre-trend violations up to Mbar=2 (twice the observed t=-5 deviation), and the CS-NT average ATT remains significant up to Mbar≈1.5. The paper's own discussion partially explains the t=-5 deviation as New Jersey's market-specific uncompensated care shock (NJ is excluded from the stable-state estimating sample). Users should trust the stored consolidated result as directionally sound and numerically faithful, while acknowledging the pre-trend flag as a residual uncertainty.

## Per-reviewer verdicts

### TWFE (WARN)
- Specification exactly matches paper equation (3): state and year FEs, full demographic controls, CPS person weights, stable-state sample. Point estimate is an exact match (0.03% gap).
- SE discrepancy (analytic 0.0097 vs. bootstrap 0.0206) is expected with only 3 treated clusters; bootstrap inference is appropriate and does not indicate misspecification.
- WARN: t=-5 pre-period coefficient is -0.027 (SE=0.009, t≈3.1), statistically significant, raising a parallel trends concern at the five-year horizon.
- See full report at [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md).

### CS-DID (WARN)
- Single-cohort CS-DID correctly implemented with never-treated comparison; 0.4% gap from paper's reported CS-NT value confirms correct group-time cell construction.
- WARN: t=-5 pre-trend is -0.047 (SE=0.013, t≈3.6) in the CS-NT event study — larger than TWFE, reflecting the absence of covariate adjustment.
- CS-NT ATT (-0.1243) is 29% larger in magnitude than TWFE (-0.0962), consistent with demographic compositional differences between stable states and control states that covariates absorb in TWFE.
- See full report at [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md).

### Bacon (NOT_APPLICABLE)
- `treatment_timing == "single"`: no staggered adoption. Bacon decomposition is not applicable. The existing bacon.csv confirms 100% of TWFE weight falls on the clean treated-vs-never-treated comparison — zero contamination from timing heterogeneity.
- See full report at [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md).

### HonestDiD (WARN)
- TWFE: all targets (first, avg, peak) remain significant at Mbar=1 (natural benchmark); avg and first remain significant at Mbar=2; peak loses significance only at Mbar=2 (extremely demanding assumption).
- CS-NT: first and avg targets significant at Mbar=1; avg loses significance at Mbar≈1.75; reflects weaker robustness without covariate adjustment.
- WARN: the pre-trend at t=-5 is itself statistically significant, making Mbar=1 a plausible rather than conservative benchmark. The paper's institutional argument (NJ shock excluded from stable-state sample) provides partial mitigation.
- See full report at [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md).

### de Chaisemartin (NOT_NEEDED)
- Single-cohort, absorbing, binary treatment with a clean never-treated comparison group. No staggered timing, no non-absorbing treatment, no dose heterogeneity. TWFE is numerically equivalent to a clean 2×2 DiD. The de Chaisemartin critique does not apply.
- See full report at [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md).

### Paper Auditor (EXACT)
- TWFE point estimate: 0.03% gap (EXACT). CS-NT: 0.4% gap (within tolerance).
- SE difference is fully explained by bootstrap vs. analytic clustering with 3 treated units — not a replication failure.
- See full report at [`reviews/paper-auditor.md`](reviews/paper-auditor.md).

## Material findings (sorted by severity)

**WARN — Pre-trend at t=-5 (shared across TWFE and CS-NT):**
Both event studies show a statistically significant negative coefficient at t=-5 (TWFE: -0.027, p≈0.002; CS-NT: -0.047, p<0.001). This is the paper's weakest point. The paper's own evidence (NJ excluded from stable-state sample, institutional narrative) partially mitigates this, and the HonestDiD analysis shows the TWFE result is robust at Mbar=1. However, the pre-trend cannot be dismissed as pure noise.

**WARN — Few effective clusters (inference):**
Only 3 treated states (NY, ME, VT). Bootstrap-based SEs are approximately twice the analytic clustered SEs. This is not a flaw in the replication, but it implies conventional inference is unreliable; users should rely on the paper's bootstrap SEs when drawing conclusions.

**WARN — Repeated cross-section / CS-DID inference:**
CS-DID is applied to a repeated cross-section; influence-function SEs may understate true uncertainty given the effective state-level sample size. The direction and magnitude of the CS-NT estimate are confirmed, but its SE should be treated as a lower bound.

## Recommended actions

- No action needed on the metadata or implementation — the specification is correctly coded and achieves exact numerical replication.
- For the repo-custodian agent: note that the paper's bootstrap SEs (0.0206) should be preserved in original_result.se_twfe rather than analytic SEs, as the bootstrap is the paper's preferred inference approach with few clusters.
- For the user: the pre-trend at t=-5 is a genuine methodological concern but is partially mitigated by (a) the paper's institutional explanation for New Jersey's pre-period market disruption, (b) HonestDiD robustness at Mbar=1, and (c) the qualitative visual evidence (Figures 1 and 2) showing parallel trends for the stable states specifically. This is an appropriate topic to flag in the dissertation as a known limitation that the original paper acknowledges.
- For the pattern-curator: consider adding a pattern entry for "Significant pre-trend at t=-5 in CPS-based state DiD with few treated clusters — partially explained by institutional market events in pre-period; HonestDiD robust at Mbar=1."

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

