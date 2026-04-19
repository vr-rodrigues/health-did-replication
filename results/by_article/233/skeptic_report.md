# Skeptic report: 233 — Kresch (2020)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Rubric version:** 3-axis (Fidelity × Implementation; Design credibility reported separately)
**Reviewers run:** twfe (IMPL-PASS), csdid (IMPL-PASS), bacon (SKIPPED — single-cohort), honestdid (IMPL-PASS; design signal recorded), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT — cached 2026-04-18)

---

## Axis summary

| Axis | Score | Basis |
|---|---|---|
| **Fidelity** | F-HIGH | paper-auditor: EXACT (0.01% diff on β, 4.9% on SE — within tolerance) |
| **Implementation** | I-HIGH | All applicable methodology reviewers PASS under new rubric |
| **Design credibility** | D-FRAGILE | Pre-trend 400–715 BRL pre-reform; HonestDiD M-bar(first) ≈ 0.40–0.48 |

**Final rating: HIGH** (F-HIGH × I-HIGH). Design credibility finding is D-FRAGILE and is reported below as a standalone finding about the paper's identifying assumption — it does not affect the rating, which reflects our reanalysis quality.

---

## Executive summary

Kresch (2020) estimates the effect of Brazil's 2005 Water and Sanitation Law on municipal investment, finding a headline TWFE effect of BRL 2,868 thousand (SE 1,254) in a balanced panel of 1,346 municipalities over 2001–2012. Our replication reproduces this estimate to within 0.01% (F-HIGH). The CS-DID implementation is correct after resolving the Kresch-class asymmetric-clustering bug (Pattern 49/50): unit-level bootstrap yields ATT = 3,329.351 (SE 1,199.78), up from the erroneous 367.503 stored in prior runs. All five methodology reviewers return PASS or NOT_NEEDED/SKIPPED under the new rubric — the pre-trend pattern and HonestDiD M-bar findings are correctly classified as design-credibility signals about the paper's assumptions, not defects in our reanalysis. The stored results are correctly computed and faithfully reproduce the paper; the caution for the user is about the paper's parallel trends assumption, not about our numbers.

---

## Per-reviewer verdicts

### TWFE (IMPL-PASS)

- Specification correct: unit + year FEs, 14 controls including baseinvestTT interaction, company-level clustering (149 clusters). Reproduces paper to 0.01%.
- Single-cohort design: no negative-weighting from staggered adoption; TWFE = ATT under parallel trends.
- Pre-period coefficients (387–715 BRL, t=-5 to t=-2) are a **design-credibility signal** — our implementation correctly reveals this pattern; it is a finding about the paper, not an error in our code.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (IMPL-PASS)

- Pattern 49/50 bug resolved: cs_cluster=code (unit-level) replaces asymmetric company-level bootstrap; stored ATT = 3,329.351 is correct.
- 16% divergence from TWFE fully explained by CS-DID using no controls vs TWFE's 14-control specification — deliberate and documented.
- CS-NYT = NA (correct: no not-yet-treated units in a single-cohort design).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)

- Not applicable: treatment_timing = "single". Bacon decomposition is mechanically degenerate for a single-cohort design.

### HonestDiD (IMPL-PASS; design signal recorded)

- Tool ran correctly on 4 valid pre-periods. Sensitivity bounds are correctly computed.
- M-bar breakeven findings are **design-credibility signals** about the paper's parallel trends assumption:
  - First post-period: M-bar ≈ 0.40–0.48 (fragile at modest trend violations)
  - Peak effect (t=1): M-bar ≈ 0.62 (more robust)
- Our implementation of HonestDiD is correct; the fragility is the paper's.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Absorbing binary single-cohort design. DH estimator adds nothing beyond CS-DID here.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (EXACT — cached 2026-04-18)

- β reproduced to 0.01% (2,868.317 vs paper's 2,868). SE diverges 4.9% (Stata/R clustering convention, within the 30% tolerance band).
- Full report: [`paper_audit.md`](paper_audit.md)

---

## Design credibility finding: D-FRAGILE

This section reports what our correct reanalysis reveals about the paper's identifying assumption. It does not affect the HIGH rating.

**Pre-trend pattern.** Both TWFE and CS-NT event studies show consistently positive and growing pre-period coefficients (TWFE: 388, 455, 715, 599 BRL at t=-5 through t=-2; CS-NT: 138, 398, 709, 689 BRL). Local municipalities appear to have been on a higher investment trajectory before 2006 relative to Regional municipalities. The baseinvestTT control (base investment × time trend) partially addresses this but may not fully absorb differential growth paths.

**HonestDiD sensitivity.** Under the relative-magnitudes (RM) sensitivity class:
- First post-period (t=0) effect loses sign robustness at M-bar ≈ 0.40 (CS-NT) to 0.48 (TWFE) — below the conventional threshold of 1.0.
- Peak effect (t=1, ~BRL 2,840 thousand) holds through M-bar ≈ 0.62.
- TWFE average post-period effect fragile at M-bar = 0.25.

**Interpretation.** The paper's medium-to-long-run investment effect is directionally credible and survives moderate trend violations. The short-run first-period estimate is fragile. The aggregate ATT (TWFE = 2,868, CS-NT = 3,329) likely captures a real post-reform investment increase, but the magnitude could partially reflect a pre-existing differential growth path. Readers should weight the peak and longer-run event study coefficients more than the aggregate ATT when assessing the reform's impact.

---

## Recommended actions

- No action on stored results: TWFE = 2,868.317 and CS-NT = 3,329.351 are correct; no metadata changes needed.
- User (methodological judgement): Note the D-FRAGILE design finding explicitly when reporting article 233. Check whether Kresch (2020) reports a pre-trend F-test and whether it passes; if so, cite it as the paper's own robustness evidence.
- User (methodological judgement): The baseinvestTT control is a reasonable attempt to absorb differential trends; assess whether the paper discusses this choice and whether additional controls or a different comparison group would strengthen identification.
- Pattern-curator: No new patterns needed. Pattern 49/50 already documents the Kresch-class clustering bug and its resolution.

---

## Rating change log

| Date | Rubric | Rating | Basis |
|---|---|---|---|
| 2026-04-18 (prior run) | 2-axis (conflated) | LOW | TWFE WARN + HonestDiD WARN counted as implementation failures |
| 2026-04-18 (this run) | 3-axis (separated) | HIGH | Pre-trend/HonestDiD findings reclassified as Design signals; Implementation = PASS; Fidelity = EXACT |

The rating change from LOW to HIGH reflects a rubric correction, not new empirical findings. The underlying data and estimates are unchanged. The design-credibility concern (D-FRAGILE) is preserved and explicitly reported.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`paper_audit.md`](paper_audit.md)
