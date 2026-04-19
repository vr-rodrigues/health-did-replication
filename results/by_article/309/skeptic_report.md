# Skeptic report: 309 -- Johnson, Schwab and Koval (2024)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation)*
**Design credibility:** MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; updated 2026-04-19), bacon (impl=NOT_APPLICABLE; allow_unbalanced=true gate, TvT share=27.1% from prior balanced-panel run), honestdid (impl=PASS, M_avg=0.25/0.25 TWFE/CS-NT; M_first=0.25/0.0; M_peak=0.25/0.0), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF; metadata TWFE match EXACT at 0.24%)

---

## Executive summary

Johnson, Schwab and Koval (2024) estimate the effect of whistle-blower protection (public policy exception to at-will employment) on workplace safety (log accident rate) using staggered DiD across 21 adoption cohorts (1970-1993) and 50 US states. The headline TWFE estimate is -0.137 (SE 0.046, marginally significant); our replication reproduces it to within 0.24%. The stored CS-DID estimate was updated on 2026-04-19 following an infrastructure fix (allow_unbalanced toggled false->true): CS-NT = -0.033 (SE 0.074), CS-NYT = -0.034 (SE 0.075), both directionally consistent with TWFE but 4x smaller in magnitude and individually insignificant. All estimators agree on sign (negative). The Bacon decomposition -- run under the prior balanced-panel configuration -- identified a cohort-1989 sign reversal (TvU = +0.316) as the leading candidate explanation for the TWFE/CS-DID magnitude gap. The user should treat the stored TWFE (-0.137) as the reproducible paper number and the CS-DID estimates (-0.033 to -0.054) as the modern heterogeneity-robust estimates -- the policy direction survives but CS-DID magnitude is not individually significant.

Rating computation: Fidelity = F-NA (no PDF; 0.24% metadata match strongly suggestive of EXACT but formally unverifiable). Implementation = I-HIGH (twfe PASS, csdid PASS after allow_unbalanced fix, bacon NOT_APPLICABLE, honestdid PASS on implementation -- HonestDiD WARNs are design findings not implementation faults; dechaisemartin NOT_NEEDED). F-NA x I-HIGH -> use implementation alone -> MODERATE.

---

## Per-reviewer verdicts

### TWFE (PASS)

- Stored TWFE = -0.13667 reproduces paper Table 2 Col 1 (-0.137) within 0.24% -- essentially exact.
- Pre-trends across 5 pre-periods are small and insignificant (all |t| < 1.5); parallel trends supported by both TWFE and SA event studies.
- SA peak (-0.275 at t=4) attenuated vs TWFE peak (-0.323); Gardner/BJS peak (-0.202) further attenuated -- consistent with staggered-timing contamination in TWFE post-period profiles.

Full report: reviews/twfe-reviewer.md

### CS-DID (PASS -- updated 2026-04-19)

- Infrastructure fix (allow_unbalanced=true) resolved the 2026-04-18 segfault; full-panel att_gt() now executes cleanly covering all 21 cohorts and 7 never-treated states.
- CS-NT simple = -0.033 (SE 0.074); CS-NYT simple = -0.034 (SE 0.075). Both negative, directionally consistent with TWFE, but 4x smaller in magnitude and not individually significant.
- Prior fix-script values (CS-NT=-0.201, CS-NYT=-0.202) are superseded; they reflected a restricted 13-cohort balanced-panel run under an old configuration.
- NT vs NYT nearly identical (-0.033 vs -0.034), confirming not-yet-treated states form a valid comparison group.

Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)

- Applicability gate: allow_unbalanced=true in current metadata; Bacon reviewer requires allow_unbalanced=false for a valid balanced-panel decomposition.
- Contextual design evidence from the prior 2026-04-18 balanced-panel run: TvT share = 27.1% (below 30% D-ROBUST threshold); cohort 1989 has sign-reversed TvU estimate (+0.316) opposite to all 9 other cohorts -- retained as Axis-3 design evidence only.
- The 1989 cohort anomaly is the leading explanation for the TWFE (-0.137) vs CS-DID (-0.033) magnitude gap under the full-panel specification.

Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN -- design finding only)

- Average ATT robust to Mbar=0.25 under both TWFE (CI [-0.367, -0.037]) and CS-NT (CI [-0.379, -0.026]); breaks at Mbar=0.5. rm_avg_Mbar = 0.25 for both estimators.
- First post-period and peak: TWFE robust to Mbar=0.25; CS-NT first-post and peak lose significance at Mbar=0.25 (rm_first = rm_peak = 0 for CS-NT).
- Classification: D-MODERATE (average ATT survives; CS-NT more fragile on tail targets).
- This is a design finding about the paper; it does not count against the implementation score.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Treatment is absorbing binary after full adoption; fractional adoption-year handled correctly by first_year_full_wdlapY gvar. DCDH adds no information.

Full report: reviews/dechaisemartin-reviewer.md

### Paper-Auditor (NOT_APPLICABLE)

- No PDF at pdf/309.pdf; formal fidelity verification not possible (F-NA).
- TWFE-reviewer independently confirms EXACT (0.24%) match from metadata. User confirms paper-auditor EXACT. Formal axis = F-NA; circumstantial evidence is EXACT.

Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates; unconditional comparison only.

twfe_controls = []; cs_controls = []. All three specs (A/B/C) collapse to the same specification; cs_nt_with_ctrls_status = N/A_no_twfe_controls. The TWFE/CS-DID gap is entirely attributable to estimator choice (staggered-timing weighting and comparison group construction), not covariate handling.

---

## Design credibility (Axis 3)

**Design credibility: MODERATE**

| Criterion | Value | Classification |
|---|---|---|
| HonestDiD M_avg TWFE | 0.25 | D-MODERATE |
| HonestDiD M_avg CS-NT | 0.25 | D-MODERATE |
| HonestDiD M_first CS-NT | 0.0 | D-FRAGILE on this target |
| HonestDiD M_peak CS-NT | 0.0 | D-FRAGILE on this target |
| Bacon TvT share | 27.1% (prior balanced run) | D-ROBUST (< 30%) |
| Pre-trends (TWFE) | All t-stats < 1.5 across 5 pre-periods | D-ROBUST |
| Pre-trends (SA) | All pre-period estimates small, insignificant | D-ROBUST |
| Cohort 1989 sign reversal | TvU = +0.316 vs all others negative | Design heterogeneity |
| TWFE vs CS-DID gap | 4x magnitude divergence; CS-DID individually insignificant | Design finding |

The primary inferential target (average ATT, negative sign) is supported under Mbar=0.25 for both estimators. Pre-trends and TvT share support the parallel-trends assumption. The design is D-MODERATE: robust on pre-trends and TvT share, fragile on CS-NT first-post and peak at Mbar=0.25, and complicated by cohort-1989 heterogeneity.

---

## Material findings (sorted by severity)

1. TWFE/CS-DID 4x magnitude gap (design finding): CS-NT = -0.033 (t approx 0.44) vs TWFE = -0.137 (t approx 3.0). Under the full unbalanced panel, CS-DID does not find a statistically significant effect. The gap is not explained by standard staggered-timing attenuation (which would make CS-DID larger in absolute value) but by cohort 1989 positive TvU estimate (+0.316) being weighted differently across estimators -- TWFE amplifies its contribution via variance-weighted averaging while CS-DID weights it uniformly alongside the other 20 cohort-ATTs.

2. HonestDiD CS-NT fragility on first-post and peak (design finding): M_bar = 0 at both targets -- CS-NT first-post and peak already include zero at Mbar=0.25. Average ATT remains robust to Mbar=0.25.

3. Cohort 1989 sign reversal (design finding): TvU Bacon estimate = +0.316, the only positive cohort-ATT among 10 TvU pairs. Drives multiple anomalous forbidden-comparison EvL values (e.g., 1989 vs 1980 = +0.811). No economic explanation available from metadata.

4. Always-treated 1979 cohort as LvA reference (contextual note): Pre-treatment contamination risk in Bacon LvA comparisons; cohort 1979 was treated at panel start. Low-weight concern given TvT share < 30%.

---

## Recommended actions

1. User (judgement): Report both TWFE (-0.137) and CS-NT (-0.033) with standard errors in the dissertation. The CS-DID estimate is directionally consistent but individually insignificant -- an important nuance for the policy conclusion under modern estimators.

2. User (judgement): Run a robustness check excluding cohort 1989 from both TWFE and CS-DID to quantify how much of the magnitude gap is driven by the 1989 sign-reversal anomaly vs structural staggered-timing weighting differences.

3. Repo-custodian: Verify that results.csv att_csdid_nt = -0.0326 and att_csdid_nyt = -0.0340 are the post-fix canonical values. Remove any references to the superseded fix-script values (CS-NT=-0.201) from downstream aggregation tables and consolidated_results.csv.

4. Repo-custodian: Update metadata notes field to clearly flag that prior fix-script values CS-NT=-0.201 are superseded by the allow_unbalanced=true fix (2026-04-19). Canonical values: CS-NT=-0.033, CS-NYT=-0.034.

5. Pattern-curator: Document as Pattern: CS-DID segfault on unbalanced staggered panels resolved by allow_unbalanced=true in did v2.3.0+; affects papers 290 and 309 (2026-04-19 batch fix). Same class as the paper-290 infrastructure fix applied on the same date.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
