# Skeptic report: 437 -- Hausman (2014)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF)

## Executive summary

Hausman (2014) studies nuclear plant divestiture effects on radiation exposure (personrem) using staggered DiD with 30 divested and 33 never-divested facilities (63 total), annual panel 1974-2008. TWFE = -42.245 person-rem (SE 66.098, t = -0.64) reproduced exactly from Table 6 Col 1. CS-DID collapses this to -1.9 (CS-NT) and -3.7 (CS-NYT) -- a 20x magnitude shrinkage. All four applicable methodology reviewers return WARN (M-LOW). Fidelity axis is F-NA (no PDF). Final rating: LOW by methodology alone. The stored TWFE value reproduces the paper exactly but is not a reliable causal estimate: the 20x TWFE-vs-CS gap is explained by secular trend contamination (personrem fell 10x over 34 years), approximately 50% forbidden Bacon TVT weight, singleton cohort leverage (3/9 cohorts have 1 facility each), and unbalanced panel composition effects. All estimates across all estimators are statistically insignificant. The paper main causal findings (Tables 3-5) use Poisson/NB regressions on count outcomes; the OLS radiation result (Table 6) is supplementary.

## Per-reviewer verdicts

### TWFE (WARN)
- TWFE = -42.245 reproduced exactly (0.00% deviation). Fidelity is perfect.
- WARN: Fractional treatment in divestiture year (monthly binary collapsed to annual mean; 18 obs with 0 < divested < 1) creates structural asymmetry vs CS-DID estimators.
- WARN: 34-year secular decline (personrem ~1200 to ~135) combined with 25-year pre-treatment window creates severe composition risk for parallel trends.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)
- 20x magnitude collapse: TWFE = -42.245 vs CS-NT = -1.943, CS-NYT = -3.724 (all non-significant, SEs ~20-22 person-rem).
- WARN: 3/9 treatment cohorts are singletons (cohorts 2003, 2004, 2006 have 1 facility each), creating extreme leverage in the pooled ATT.
- WARN: Unbalanced panel with universal base period mixes high-personrem 1970s-80s with low-personrem 1990s-2000s, generating composition effects in group-time ATTs.
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN)
- TVT (forbidden) pairs account for approximately 49.5% of TWFE weight.
- WARN: EvL forbidden pairs show -352 to -682 person-rem (secular trend contamination making early-treated units spuriously negative as controls for late-treated).
- WARN: TVU cohort estimates span -372 to +301 person-rem; the two largest-weight cohorts (2001 at 24.8%, 2000 at 13.4%) are both strongly negative.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN)
- All rm_Mbar = 0 for TWFE and CS-NT (D-FRAGILE); Mbar=0 CIs include zero for all three targets (first, avg, peak).
- WARN: TWFE post-period event study oscillates between positive (t=1: +40.6) and negative (t=5: -95.7 person-rem) with no coherent effect trajectory.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing-binary-staggered design. No treatment reversal.
- Fractional transition-year divested is a measurement artefact of the monthly-to-annual collapse, not a genuine non-absorbing treatment.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper-auditor (NOT_APPLICABLE)
- No PDF at pdf/437.pdf. Fidelity axis F-NA.
- TWFE matches paper exactly (-42.245) per metadata original_result field cross-referenced with Stata do-file specification.

## Material findings (sorted by severity)

WARN -- 20x magnitude shrinkage (TWFE vs CS-DID): TWFE = -42.245 vs CS-NT = -1.943, CS-NYT = -3.724. TWFE is contaminated by secular trend and forbidden Bacon pairs; CS estimates are unreliable due to singleton cohorts and composition effects. Neither provides a credible causal estimate.

WARN -- Bacon TVT approximately 50% weight: Half of TWFE weight comes from forbidden treated-vs-treated pairs showing -350 to -682 person-rem driven by secular decline making early-treated units low-personrem controls for late-treated.

WARN -- D-FRAGILE HonestDiD (all targets, both estimators): All rm_Mbar = 0 for TWFE and CS-NT. Effect not bounded away from zero even at Mbar=0 (no pre-trend violations permitted). CIs at Mbar=0 span approximately -90 to +67 (TWFE first) and -40 to +37 (TWFE avg).

WARN -- 3 singleton cohorts: Cohorts 2003, 2004, and 2006 each have 1 facility, creating extreme leverage in the CS-DID pooled ATT without meaningful uncertainty quantification.

WARN -- Secular trend and unbalanced panel: personrem declines approximately 10x over 1974-2008. Only 14/63 facilities span the full panel. Universal base period creates composition effects in CS-DID group-time ATTs.

WARN -- Fractional treatment in divestiture year: 18 facility-year observations with 0 < divested < 1 from monthly-to-annual collapse. TWFE uses fractional value (matching Stata exactly); CS-DID uses binary gvar_CS (first year >= year_divest).

## Recommended actions

- Repo-custodian agent: Flag metadata for article 437 that CS-DID estimates should be excluded from aggregate DiD robustness analysis. Root cause is structural unreliability (singleton cohorts, unbalanced panel composition effects) rather than an implementation error. TWFE coefficient is retained for fidelity records only.

- Pattern-curator: Add a pattern for secular-trend contamination in long-panel TWFE. When an outcome has a strong monotonic secular trend over 30-plus years and treatment cohorts cluster in a narrow window decades after panel start (here: 1999-2007 cohorts, panel starts 1974), Bacon TVT pairs are structurally contaminated by the secular trend even after year FEs. The early-treated units have already absorbed trend decline during their post period when they serve as comparison for late-treated units.

- User (methodological judgement): The paper main causal claims (Tables 3-5, Poisson/NB regressions on nuclear event counts, fires, and escalated enforcement actions) are not replicated in this audit. The OLS radiation result (Table 6) is a supplementary outcome. The 20x magnitude shrinkage documented here does not directly undermine the paper primary findings, which are on a different outcome with a different estimator.

- User: The OLD-to-NEW consolidated comparison 20x magnitude shrinkage is fully explained by two concurrent structural problems: TWFE overstating magnitude due to secular trend contamination and approximately 50% forbidden Bacon pairs, and CS-DID being unreliable for different structural reasons (singleton cohorts, composition effects). This is not a replication failure -- it is the audit correctly diagnosing why both estimators are problematic in this specific design.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
