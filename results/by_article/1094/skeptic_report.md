# Skeptic report: 1094 - Fisman and Wang (2017)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (N/A - no PDF)

## Executive summary

Fisman and Wang (2017) study the effect of China NSNP death-ceiling law on the probability that provincial death tolls exceed the assigned quota (exceedquota, binary LPM), using a staggered DiD design across 19 adopting provinces (2005-2012) with 245 province-by-industry panel units. The paper headline Table 2 Col 1 result is TWFE = -0.051 (SE 0.040), statistically insignificant. Our replication yields -0.047 (SE 0.041), a 7.8% gap attributable to a software-level merge difference (1 obs). The null finding is robust: CS-NT ATT = -0.029 (SE 0.035), also insignificant; HonestDiD CIs include zero at all Mbar values for both estimators. The LOW rating reflects two concurrent WARN verdicts: (1) ~38% magnitude divergence between TWFE and CS-NT ATT suggesting heterogeneity bias in TWFE, and (2) a mild CS-NT pre-trend concern at t=-3 (-0.103, SE=0.069). Neither concern reverses the qualitative conclusion, but both indicate TWFE is not a well-defined causal parameter for this staggered design. The preferred CS-NT ATT of -0.029 is the more credible causal estimate.

## Per-reviewer verdicts

### TWFE (WARN)

- TWFE coefficient (-0.047) within 8% of paper value (-0.051); 1-observation N gap is a Stata/R merge artifact.
- Post-period TWFE coefficients noisy and sign-inconsistent (positive at t=1, t=2; negative at t=0, t=3, t=4).
- Seven adoption cohorts (2006-2012) create heterogeneity-weighting contamination; Bacon 2x2 estimates range -0.309 to +0.113.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- CS-NT correctly specified: gvar_CS=effective_year+1, 16 never-treated control provinces, province-level clustering.
- CS-NT ATT (-0.029) is ~38% smaller in absolute value than TWFE (-0.047); both insignificant; null conclusion preserved.
- Pre-period t=-3 under CS-NT: -0.103 (SE=0.069), approaches 1.5 SEs, nearly as large as post-period ATT; SA corroborates.

Full report: reviews/csdid-reviewer.md

### Bacon (N/A)

- Skipped: allow_unbalanced=true; Bacon decomposition requires balanced panel for valid weight decomposition.
- Bacon output (bacon.csv) used qualitatively by other reviewers; formal weight interpretation unreliable.

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- At Mbar=0: TWFE CI=[-0.157,+0.046], CS-NT CI=[-0.169,+0.019]; both include zero, confirming the null.
- Paper itself reports a non-significant finding; HonestDiD confirms rather than contradicts. No significant claim undermined.
- Pre-trend quality adequate under TWFE; CS-NT t=-3 within bounds for credible sensitivity analysis.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design (no reversals, no dose heterogeneity); DID_M adds nothing beyond CS-NT.
- Bacon shows dominant Treated-vs-Untreated weight (~71%); cohort heterogeneity already captured by CS-NT.

Full report: reviews/dechaisemartin-reviewer.md

### Paper-Auditor (N/A)

- Not applicable: no PDF at pdf/1094.pdf. Fidelity axis not evaluable.
- Metadata notes: Paper=-0.051 (SE 0.040, N=1755); ours=-0.047 (SE 0.041, N=1756). Gap is software artifact.

## Material findings (sorted by severity)

- WARN (twfe-reviewer): Staggered TWFE heterogeneity bias. 7 cohorts, unbalanced panel prevents formal Bacon; post-period TWFE coefficients sign-inconsistent.
- WARN (csdid-reviewer): CS-NT/TWFE magnitude divergence. CS-NT ATT (-0.029) ~38% smaller than TWFE (-0.047) in absolute value; 1.8pp vs 4.7pp on binary LPM.
- WARN (csdid-reviewer): CS-NT pre-trend at t=-3. Coef=-0.103 (SE=0.069), approaching 1.5 SEs, nearly as large as post-period ATT.

## Recommended actions

- No reversal of qualitative conclusion required. Null finding is robust across TWFE, CS-NT, and HonestDiD.
- For repo-custodian: Flag preferred causal estimate as CS-NT ATT (-0.029, SE=0.035) rather than TWFE (-0.047); update consolidated_result if CS-NT is to be the headline estimate.
- For pattern-curator: Candidate new pattern - erratic post-period dynamics and mild pre-trend concerns with small staggered panels (N<250 units, 7 cohorts).
- For user (methodological judgement): If a balanced sub-panel can be constructed (industries with continuous coverage), re-run Bacon to formally quantify later-vs-earlier-treated contamination share.

## Rating computation

Active methodology verdicts: twfe=WARN, csdid=WARN, honestdid=PASS (bacon=N/A excluded, dechaisemartin=NOT_NEEDED excluded).
Count: 2 WARN, 1 PASS, 0 FAIL. Methodology score: M-LOW (2+ WARN, no FAIL).
Fidelity score: F-NA (no PDF available). Combined M-LOW x F-NA: use methodology alone. Final rating: LOW.

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
