# Skeptic report: 395 — Malkova (2018)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (PASS), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Malkova (2018) estimates the effect of Soviet maternity benefit expansions on the general fertility rate (GFR) using a staggered DiD across 82 Russian oblasts: 32 adopted the reform in 1981 (early cohort) and 50 in 1982 (late cohort). The paper reports a TWFE static ATT of 1.091 GFR units (SE = 0.409), which our implementation reproduces exactly (0.02% difference). Three reviewers flag WARN — all tracing to a single structural feature of the design: this is an all-eventually-treated dataset with no never-treated units, and all units are treated by 1982. This means TWFE event-study dummies are mechanically contaminated post-1982 (year FEs absorb treatment effects, inflating the pre-period dummies: e=-6=+8.7, e=-5=+6.5, ..., e=-2=+1.7), the Bacon decomposition produces a forbidden Later-vs-Earlier comparison that attenuates TWFE to 1.09 relative to the CS-NYT estimate of 1.97, and HonestDiD on the contaminated TWFE event study is D-FRAGILE. Critically, the Gardner (2SLS/BJS) pre-trends are flat (-0.20 to +0.10 GFR), CS-NYT pre-trends are clean (max 0.54 GFR), and HonestDiD on the CS-NYT estimate is D-MODERATE (robust to Mbar=1.0). The direction of the effect is positive across all estimators and the modern robust estimate (CS-NYT = 1.97, Gardner = 2.09) is approximately 80% larger than the TWFE headline. Users should trust the direction of the stored result but note that 1.091 is a downward-biased TWFE estimate; the modern preferred estimate is approximately 2.0 GFR units.

## Per-reviewer verdicts

### TWFE (WARN)
- Static ATT of 1.091 reproduces paper exactly (0.02% difference). Implementation is correct.
- TWFE event-study pre-trends show monotonically increasing pattern (e=-6: +8.68 → e=-2: +1.67) that is an artifact of the all-eventually-treated design: no clean post-period controls cause year FEs to be contaminated, inflating pre-period dummies.
- Gardner 2SLS pre-trends for same periods are flat (<0.20 GFR), confirming no genuine parallel trends violation.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NYT ATT = 1.968 (SE = 0.526), 80% above TWFE (1.091). CS-NT not run (no never-treated units — correct).
- Gap fully explained by Bacon decomposition: TWFE is attenuated by the Later-vs-Earlier forbidden comparison (weight=45.5%, estimate=-0.062).
- CS-NYT pre-trends are flat (max |0.54| GFR); Gardner confirms at e=0: 2.09 GFR.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (PASS)
- 100% timing comparisons (no never-treated weight). Two comparison pairs: EvL (+1.702, weight=0.545) and LvE (-0.062, weight=0.455).
- LvE forbidden comparison (1981-treated used as control for 1982-treated) explains TWFE attenuation.
- No extreme cohort heterogeneity; 2-cohort design is structurally simple.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE HonestDiD: D-FRAGILE (rm_Mbar=0; CI at Mbar=0 = [-1.38, +1.99] includes zero) — but this reflects the contaminated TWFE event study, not a genuine pre-trend failure.
- CS-NYT HonestDiD: D-MODERATE (CI at Mbar=0 = [+1.21, +3.01]; sign maintained to Mbar=1.0; sign loss at Mbar=1.25).
- Gardner pre-trends confirm clean design; CS-NYT HonestDiD is the valid diagnostic.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; no non-absorbing, continuous, or dose features.
- CS-NYT and Gardner adequately cover heterogeneity-robust estimation.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Material findings (sorted by severity)

- **[WARN — TWFE event study artifact]** TWFE event-study pre-trend dummies are contaminated by the all-eventually-treated design. After 1982 all units are treated; year FEs absorb post-treatment variation and push pre-period dummies to +1.7 through +8.7. Researchers relying only on the TWFE event study would incorrectly infer parallel trends failure. Gardner and CS-NYT pre-trends are clean and should be used for pre-trend diagnostics.
- **[WARN — TWFE downward bias]** The stored TWFE ATT (1.091) is attenuated ~45% relative to the modern robust estimate (CS-NYT = 1.97, Gardner = 2.09). The attenuation is driven by the Bacon LvE forbidden comparison (weight=45.5%), which uses already-treated 1981 units as controls for 1982 units. This is a known consequence of all-eventually-treated staggered designs with TWFE.
- **[WARN — HonestDiD TWFE fragility]** TWFE HonestDiD includes zero at Mbar=0 (D-FRAGILE). However, this is an artifact of the contaminated TWFE pre-trend estimates, not a genuine sensitivity failure. CS-NYT HonestDiD is D-MODERATE (robust to Mbar=1.0) and is the correct diagnostic.

## Rating computation

| Reviewer | Verdict |
|---|---|
| twfe-reviewer | WARN |
| csdid-reviewer | WARN |
| bacon-reviewer | PASS |
| honestdid-reviewer | WARN |
| dechaisemartin-reviewer | NOT_NEEDED (excluded) |

Active verdicts: 1 PASS, 3 WARN, 0 FAIL.
Methodology score: ≥ 2 WARN, no FAIL → **M-LOW**.
Fidelity score: paper-auditor = NOT_APPLICABLE → **F-NA**.
Combined: M-LOW × F-NA → methodology alone → **LOW**.

Note: All three WARNs share a common structural origin (all-eventually-treated design). The direction of the effect is unambiguous across all estimators, and the CS-NYT estimate (1.97) is the preferred modern estimate. The LOW rating reflects the mechanical rubric count; the underlying causal story is cleaner than LOW typically implies.

## Recommended actions

- **For the repo-custodian agent:** Update the analysis notes to flag that the preferred modern ATT for this paper is CS-NYT = 1.97 (not TWFE = 1.09), and that the TWFE ATT is attenuated by ~45% due to the Bacon LvE forbidden comparison (all-eventually-treated design).
- **For the pattern-curator:** Consider adding a pattern documenting the "all-eventually-treated TWFE event-study contamination" artifact: when all units treat by the end of the panel, TWFE year FEs absorb post-treatment variation and pre-period event-study dummies explode monotonically — this is NOT a parallel trends violation and should not trigger a pre-trend FAIL. Analogous to Pattern 36 (SA inverted signs in all-eventually-treated) but for event-study diagnostics.
- **For the user:** The paper's headline TWFE estimate (1.09 GFR) is a valid causal estimate but understates the ATT by ~45% due to the forbidden Bacon comparison. The modern best estimate is ~1.97-2.09 GFR (CS-NYT and Gardner). The positive effect of Soviet maternity benefits on fertility is robust: all estimators agree on direction, CS-NYT pre-trends are clean, and HonestDiD is D-MODERATE (Mbar=1.0). The LOW rating is a mechanical rubric artifact driven by 3 structurally linked WARNs from the all-eventually-treated design, not 3 independent methodological failures.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
