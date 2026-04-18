# Skeptic report: 233 — Kresch (2020)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (SKIPPED — single-cohort), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT — cached 2026-04-18)

## Executive summary

Kresch (2020) estimates the effect of Brazil's 2005 Water and Sanitation Law on municipal investment, finding a headline TWFE effect of BRL 2,868 thousand (SE 1,254) in a balanced panel of 1,346 municipalities over 2001–2012. Our replication reproduces this estimate to within 0.01%. The CS-DID estimate is BRL 3,329 (SE 1,200) after resolving the Kresch-class clustering bug (Pattern 49/50: unit-level bootstrap rather than asymmetric company-level clusters). The stored CS-DID value of 3,329.351 is correct. The primary concern flagged by both the TWFE and HonestDiD reviewers is a consistent positive pre-trend pattern in the event study (pre-period coefficients of 400–715 BRL), suggesting treated municipalities (Local scope) were already on a rising investment trajectory before 2006. HonestDiD analysis shows the first post-period effect is fragile to trend violations at Mbar≈0.4–0.5, while the medium-run peak effect holds through Mbar≈0.6. The stored result (TWFE=2,868, CS-NT=3,329) likely captures a real post-reform investment increase, but the parallel trends assumption is under meaningful pressure. Interpret the headline result with caution — the effect is directionally credible but the magnitude estimate could partially reflect a pre-existing differential growth path.

## Per-reviewer verdicts

### TWFE (WARN)
- Specification is correctly implemented: unit + year FEs, 14 controls including baseinvestTT interaction, company-level clustering with 149 clusters. Matches paper to 0.01%.
- Pre-period event study shows consistently positive coefficients (387–715 BRL, t=-5 to t=-2) that grow toward treatment, suggesting a pre-existing upward trend in Local vs Regional municipalities before the 2006 reform.
- Single-cohort design: no negative-weighting concern from staggered adoption; TWFE = ATT under parallel trends. Concern is the validity of parallel trends, not the estimator's internal logic.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- Kresch-class bug (Pattern 49) resolved: unit-level bootstrap (cs_cluster=code) replaces asymmetric company-level clustering; stored ATT rises from old 367 to correct 3,329.
- 16% divergence from TWFE fully explained by CS-DID using no controls vs TWFE's 14-control specification — a deliberate, documented difference.
- Single cohort means CS-NYT=NA (correct: no not-yet-treated units exist).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)
- Not applicable: treatment_timing = "single". Bacon decomposition is mechanically degenerate for a single-cohort design (no cross-cohort variance to decompose).

### HonestDiD (WARN)
- 4 pre-periods available (t=-5 through t=-2); consistently positive pattern in both TWFE and CS-NT pre-period estimates.
- First post-period effect fragile: Mbar breakeven ≈ 0.40–0.48 (for CS-NT and TWFE respectively).
- Peak effect (t=1, BRL ~2,840) more robust: holds through Mbar≈0.62 for CS-NT.
- TWFE average post-period fragile at Mbar=0.25 — the average is pulled down by noisy later periods.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary single-cohort design. DH estimator adds nothing beyond CS-DID for this design. NOT_NEEDED verdict is correct and expected.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (EXACT — cached)
- β reproduced to 0.01% (2,868.317 vs paper's 2,868). SE diverges 4.9% (Stata/R clustering convention difference, within tolerance). Full report: [`paper_audit.md`](paper_audit.md)

## Material findings (sorted by severity)

**WARN — Pre-trend pattern (TWFE and HonestDiD reviewers)**
Both the TWFE event study and HonestDiD analysis reveal that Local municipalities had consistently higher and growing investment levels relative to Regional municipalities before the 2006 law (pre-period estimates 400–715 BRL, t=-5 through t=-2). This threatens the parallel trends assumption. The HonestDiD breakeven Mbar of 0.4–0.5 for the first post-period is below the conventional acceptability threshold of 1.0.

**WARN — Short-run effect fragility (HonestDiD reviewer)**
The first post-period (t=0) effect is sign-fragile at Mbar=0.5 for both estimators. The average post-period TWFE effect loses sign robustness at Mbar=0.25. Only the peak (t=1) and longer-run effects (t=5, t=6) are robust through Mbar≈0.6.

## Recommended actions

- Repo-custodian: no metadata changes needed — Pattern 49/50 invariant is already in place; stored CS-DID value (3,329.351) is correct.
- User (methodological judgement): The pre-trend concern should be noted explicitly when reporting 233 results. The paper's own robustness section may address this — check whether Kresch (2020) reports a pre-trend test (F-test of joint pre-period equality to zero) and whether it passes.
- User (methodological judgement): Consider whether the `baseinvestTT` control (base investment × time trend) sufficiently absorbs the pre-existing differential growth — if Local municipalities had structurally different investment trajectories, this control may partially but not fully address it.
- Pattern-curator: No new patterns needed; Pattern 49/50 already documents the Kresch-class bug.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`paper_audit.md`](paper_audit.md)
