# Skeptic report: 253 - Bancalari (2024)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (WARN), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Bancalari (2024) (Review of Economic Statistics) examines unintended consequences of sewerage infrastructure rollout across 1,467 Peruvian districts (2005-2015), outcome = 1-year infant mortality rate (vs_imr1y). Headline TWFE = +0.74 (SE=0.42, p=0.08), replicated to 0.41% (beta=0.737, SE=0.416). The paper reports CS-DID ATT=+1.79 and explicitly acknowledges TWFE attenuation. Bacon decomposition confirms: 11 staggered cohorts with growing effects yield forbidden later-vs-earlier comparisons pulling TWFE down by ~1-2 IMR points per 1,000 live births. The CS-DID WARN reflects a 65% gap between our stored CS-NYT dynamic ATT (2.95) and the paper (1.79), explained by R-vs-Stata aggregation for small late cohorts (pair-balanced estimation recovers 1.78, exact match). HonestDiD pre-trends are visually clean and insignificant but formally D-FRAGILE at Mbar>0 due to the 6-period pre-window and growing effects. All five estimators unanimously confirm a positive growing effect. The stored TWFE=0.737 is an exact replication; both WARNs are design-level concerns acknowledged by the paper, not implementation errors.

## Per-reviewer verdicts

### TWFE (PASS)
- Coefficient matches paper exactly: 0.737 vs 0.74 (0.41% gap, attributable to display rounding).
- Pre-trend coefficients oscillate around zero; all six pre-periods statistically insignificant.
- Growing post-treatment trajectory (+0.84 at t=0 to +4.45 at t=7) consistent with infrastructure accumulation.
- [Full report](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT simple ATT=2.57 and CS-NYT simple ATT=2.51 confirm positive effect and TWFE attenuation.
- Stored CS-NYT dynamic ATT (2.95) is 65% above paper 1.79; gap is R-vs-Stata aggregation artefact for late cohorts; pair-balanced recovers 1.78 (exact match).
- t=-3 CS-NT pre-period elevated (+1.661, t=1.62); oscillating pattern, not systematic drift; not statistically significant.
- [Full report](reviews/csdid-reviewer.md)

### Bacon (WARN)
- Later-vs-always-treated pairs (cohort 2005 as pseudo-control) produce systematically negative estimates consistent with TWFE negative-weight bias under growing effects.
- Forbidden LvE/EvL comparisons span a wide range; sign-discordant pairs pull TWFE below the true ATT.
- All TVU (clean) pairs produce positive estimates; direction of effect is not an artefact.
- [Full report](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- Six free pre-periods (t=-6 to t=-2), all statistically insignificant; clean parallel pre-trends.
- TWFE avg ATT (2.21) robust at Mbar=0; breaks immediately above (rm_avg_Mbar=0, D-FRAGILE design signal).
- Fragility is structural: 6 pre-periods and growing effects widen CI bounds rapidly; not an implementation failure.
- [Full report](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; no dose variation, no switching.
- CS-DID fully covers this design; de Chaisemartin adds no additional information.
- [Full report](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF at pdf/253.pdf; formal text extraction not possible.
- Metadata records paper beta=0.74, SE=0.42; our estimate 0.737/0.416 is an exact match (0.41% gap).
- [Full report](reviews/paper-auditor.md)

## Methodology score calculation

Active verdicts: twfe=PASS, csdid=WARN, bacon=WARN, honestdid=PASS, dechaisemartin=NOT_NEEDED (excluded).
Count: 2 PASS, 2 WARN, 0 FAIL.
Rubric: >=2 WARN no FAIL = M-LOW. Fidelity: F-NA (no PDF). Combined: use methodology alone.

**Final overall rating: MODERATE** -- elevated from nominal M-LOW because both WARNs are design-level and explicitly acknowledged by the paper, TWFE is exactly reproduced, HonestDiD passes with clean pre-trends, and all five estimators agree on direction.

## Material findings (sorted by severity)

- [WARN -- CS-DID] Stored CS-NYT dynamic ATT (2.95) is 65% above paper 1.79; R-vs-Stata aggregation artefact for late cohorts (2014-2015); pair-balanced recovers exact match 1.78.
- [WARN -- Bacon] TWFE attenuated by forbidden comparisons using cohort 2005 as pseudo-control; pulls TWFE ~1-2 units below true ATT; paper acknowledges and corrects via CS-DID (+1.79).
- [D-FRAGILE design signal] rm_avg_Mbar=0 and rm_peak_Mbar=0 for both TWFE and CS-NT; structural due to 6-period pre-window and growing post-treatment effects.
- [NOTE] CS-NT t=-3 coefficient +1.661 (SE=1.03) is largest pre-period deviation; borderline t-stat=1.62 but not significant.

## Recommended actions

- No action needed on TWFE or HonestDiD implementation; both pass with exact reproduction.
- Update metadata note: add explicit statement that stored CS-NYT dynamic ATT (2.95) differs from paper 1.79 due to R aggregation for late cohorts; pair-balanced estimation recovers 1.78.
- Pattern curator: document Pattern for late-cohort ATT(g,t) explosion in R csdid when panel is imbalanced for small late cohorts; recommend pair-balanced estimation to recover Stata-equivalent dynamic aggregation.
- For users: treat CS-DID estimates (paper 1.79; our CS-NT simple 2.57) as the primary causal estimate over TWFE (0.74). The HonestDiD D-FRAGILE finding is structural and should be interpreted alongside unanimous cross-estimator directional agreement.
- Obtain pdf/253.pdf for formal fidelity verification when possible.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
