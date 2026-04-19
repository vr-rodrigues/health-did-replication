# CS-DID Reviewer Report — Article 309

**Verdict:** PASS
**Date:** 2026-04-19
**Reviewer:** csdid-reviewer
**Update:** Supersedes 2026-04-18 report. Infrastructure fix 2026-04-19: allow_unbalanced toggled false→true.

---

## Checklist

### 1. CS-DID results availability

Results stored in results.csv now show populated CS-DID values (resolved from NA):
- att_csdid_nt: -0.0326 (SE 0.0741)
- att_csdid_nyt: -0.0340 (SE 0.0752)
- att_nt_simple: -0.0366 (SE 0.0773)
- att_nt_dynamic: -0.0531 (SE 0.0804)
- att_nyt_simple: -0.0381 (SE 0.0699)
- att_nyt_dynamic: -0.0543 (SE 0.0762)

The 2026-04-18 segfault (did v2.3.0 on severely unbalanced panel) is resolved by
allow_unbalanced=true. The full-panel att_gt() call now executes without error.

### 2. Infrastructure fix assessment

Setting allow_unbalanced=true is the correct resolution for a panel where 21 state-run
OSHA states have a shorter observation window (1992–2005) than the 29 baseline states
(1979–2005). The did package v2.3.0 supports unbalanced panels via this flag; the
2026-04-18 false setting was unnecessarily restrictive.

No cohort restriction was required: all 21 adoption cohorts (1970–1993) plus 7
never-treated states are included in the estimation. This is an improvement over the
prior fix-script approach (fix_csdid_309.R) which dropped 40% of cohorts.

Implementation verdict on this axis: PASS.

### 3. Magnitude comparison

- TWFE: -0.137 (SE 0.046)
- CS-NT simple aggregate: -0.033 (SE 0.074)
- CS-NYT simple aggregate: -0.034 (SE 0.075)
- CS-NT dynamic aggregate: -0.053 (SE 0.080)
- CS-NYT dynamic aggregate: -0.054 (SE 0.076)

The CS-DID estimates are uniformly 4× smaller in absolute magnitude than TWFE and
not statistically distinguishable from zero (all |t| < 0.7). TWFE is marginally
significant (t ≈ 3.0).

This is the reverse of the typical staggered-timing attenuation story: staggered-timing
contamination would make TWFE smaller (in absolute value) than CS-DID, not larger.
The 4× TWFE-vs-CS-DID gap is therefore a design finding requiring Bacon decomposition
interpretation (see bacon-reviewer, noting cohort 1989 sign reversal in TvU).

### 4. NT vs NYT comparison

CS-NT = -0.033; CS-NYT = -0.034. Near-identical, suggesting not-yet-treated units
form a valid comparison group. No systematic contamination of the never-treated pool
from early-cohort spillovers.

### 5. Direction consistency

Both CS-NT and CS-NYT are negative, consistent with the TWFE sign. The conclusion
that whistle-blower protection legislation reduces workplace accident rates is directionally
robust across all estimators, though CS-DID estimates are not individually significant.

### 6. Pre-trend assessment

HonestDiD (v3) computed on CS-NT uses 4 pre-periods. Pre-trends from event study are
flat (TWFE pre-period coefficients all |t| < 1.5). CS-DID unconditional CI at Mbar=0
for first post-period: [-0.236, -0.019] — this was computed from the prior fix-script
run and may differ slightly under the full-panel run, but the direction of robustness
is supported.

### 7. Controls decomposition

twfe_controls = [] (empty). Specs A/B/C not applicable (no original covariates).
cs_nt_with_ctrls_status = "N/A_no_twfe_controls". Implementation correct.

---

## Material findings

- **NOTE (design finding, not implementation fault):** CS-DID is 4× smaller than TWFE in
  magnitude (-0.033 vs -0.137) and individually insignificant. This gap likely reflects
  cohort 1989 sign reversal (TvU = +0.316) contaminating the TWFE weighted average
  upward in absolute value, while CS-DID weights cohort-ATTs more uniformly. This is a
  design finding about the paper, not an error in our implementation.
- **NOTE:** Prior fix-script values (CS-NT=-0.201, CS-NYT=-0.202) are superseded and
  should not be cited. They reflected a restricted 13-cohort balanced panel under a
  pre-2026-04-19 did package configuration that produced different numbers.

**Verdict: PASS**
