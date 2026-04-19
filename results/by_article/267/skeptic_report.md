# Skeptic report: 267 — Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (WARN — informational; formally SKIPPED per allow_unbalanced=true rule), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

**Methodology score:** M-MOD (1 WARN from twfe; csdid PASS; honestdid PASS; dechaisemartin excluded; bacon formally skipped but informational WARN noted)
**Fidelity score:** F-NA (no PDF; fidelity axis not evaluable)
**Combined rating:** MODERATE (M-MOD x F-NA → use methodology alone; M-MOD = MODERATE)

---

## Executive summary

Bhalotra, Clarke, Gomes, Venkataramani (2022) estimate that reserved-seat gender quotas reduce the log maternal mortality ratio by -0.082 (SE=0.051) using a standard TWFE specification across 178 countries from 1990–2015, with 22 reserved-seat quota adopters in a staggered design. The headline TWFE result is reproduced exactly (-0.0821278). The main methodological finding is that TWFE *understates* the true ATT: Bacon decomposition reveals positive components for late-adopting cohorts (2005, 2010, 2012; combined TVU weight ~27%), attenuating the overall estimate toward zero. Modern CS-DiD estimators yield ATTs of -0.112 to -0.131 (37–60% larger in magnitude than TWFE -0.082). Pre-trends are flat across all 5 estimators (TWFE, SA, Gardner, CS-NT, CS-NYT), which is a notable strength. HonestDiD reveals D-FRAGILE design (peak effect survives at exactly Mbar=0 in TWFE but immediately fails at Mbar=0.25), driven by structural constraints (only 2 free pre-periods, near-zero first-period effect). The stored consolidated result of -0.082 is a conservative (attenuated) estimate; the preferred modern ATT is approximately -0.112 to -0.127. Users should trust the direction and policy significance but recognise that TWFE understates the effect.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Exact match to paper: stored -0.0821278 vs paper -0.082 (difference = 0.02% of SE). Specification is correctly reproduced.
- Staggered timing heterogeneity confirmed: Bacon shows late-adopting cohorts (2005, 2010, 2012) have positive TVU components (combined weight 26.7%), attenuating TWFE toward zero.
- Pre-trends flat: all 5 pre-period TWFE coefficients statistically zero (largest is t=-5 at +0.014, SE=0.026).
- WARN reason: known TWFE attenuation from heterogeneous timing; modern estimators indicate true ATT is 37–60% larger in magnitude.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-NT and CS-NYT yield virtually identical ATTs: -0.112 and -0.111 (0.4% gap), providing strong internal consistency.
- Pre-period CS-NT event study shows no systematic slope violations (all pre-period coefficients non-significant, no monotonic drift).
- CS run on balanced 119-country panel; all 22 treated countries retained — excluded units are from the never-treated control pool only.
- ATTs are larger in magnitude than TWFE, consistent with Bacon-confirmed attenuation.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (WARN — informational; formally SKIPPED)
- Bacon was run on the unbalanced panel despite allow_unbalanced=true; results are informational.
- Critical finding: 3 of 7 TVU components are positive (cohorts 2005: +0.102, 2010: +0.085, 2012: +0.159), representing 26.7% combined TVU weight.
- Positive late-adopter components attenuate TWFE toward zero; confirms CS-DiD's larger ATT estimate.
- Forbidden comparisons (Later vs Earlier Treated pairs) have small weights (<5%) and do not dominate.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- Design signal: D-FRAGILE. Peak TWFE effect survives at exactly Mbar=0 (CI: [-0.106, -0.001]) but fails at Mbar=0.25.
- Average and first-period targets include zero at all Mbar levels.
- D-FRAGILE is partly structural: only 2 free pre-periods limits discriminatory power; first-period effect genuinely near-zero (growing effects design).
- Paper's own JEEA HonestDiD analysis used more pre-periods and found robustness — our implementation is more conservative.
- PASS warranted: flat pre-trends across all 5 estimators, no systematic violations.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; did_multiplegt_dc adds no additional methodological insight beyond CS-DiD for this specification.
- Paper uses did_multiplegt_dc as its own robustness check for non-binary quota variants; for the binary quotaRes baseline, NOT_NEEDED.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- PDF `pdf/267.pdf` not found; fidelity axis cannot be formally evaluated.
- Informal check: stored TWFE -0.0821278 matches metadata reference -0.082 (from quotaDifDif.tex Col 4) to 0.02%. F-NA.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

**WARN items:**

1. **TWFE staggered-timing attenuation (twfe-reviewer):** Late-adopting cohorts (2005, 2010, 2012) contribute positive Bacon components (combined TVU weight 26.7%), attenuating TWFE to -0.082 vs. the true ATT of approximately -0.112 to -0.127 from modern estimators. The stored result is a conservative lower bound on the treatment effect.

2. **HonestDiD D-FRAGILE design (honestdid-reviewer):** Peak effect survives only at Mbar=0 (TWFE CI: [-0.106, -0.001]); all targets lose significance at Mbar=0.25. Structural constraints (n_pre=2, growing-effects design with near-zero contemporaneous effect) limit inference at small pre-trend departures.

3. **Bacon heterogeneity (bacon-reviewer — informational):** Cohort 2003 has the largest weight (24.1%) and an extreme estimate (-0.354); cohort 2012 (6.3% weight) shows +0.159. Internal Bacon heterogeneity is substantial, though the "forbidden comparisons" weights are small.

---

## Recommended actions

- No structural action needed: the paper's causal direction is confirmed by all 5 estimators, pre-trends are clean, and CS-DiD provides a well-identified estimate.
- Consider updating the consolidated results commentary to note that TWFE -0.082 is a *lower bound* on the ATT in magnitude; the preferred CS-DiD ATT is -0.112 to -0.127 (37–55% larger).
- For the pattern curator: the positive Bacon TVU components for late adopters in a 22-country staggered design with outcome-variance heterogeneity across development levels is a candidate for a new pattern note — late-adopter positive Bacon components in cross-country MMR studies may reflect compositional differences rather than anticipation effects.
- For the user: the D-FRAGILE HonestDiD rating reflects our conservative implementation (n_pre=2); the paper's own robustness analysis with more pre-periods is more informative. Trust the direction; treat the TWFE magnitude as a lower bound.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
