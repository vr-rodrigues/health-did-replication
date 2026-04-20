# Paper Auditor Report: Article 9 — Dranove et al. (2021)

**Verdict:** WITHIN_TOLERANCE
**Date:** 2026-04-19

---

## Applicability check
- `pdf/9.pdf` exists: YES — found at `Replication Package/pdf/9.pdf`.
- `beta_twfe` in results.csv is numeric: YES (-0.17631).
- **APPLICABLE.**

---

## Fidelity assessment

### TWFE static estimate
| Metric | Paper (original_result) | Our computation | Absolute diff | % diff | Verdict |
|--------|------------------------|-----------------|---------------|--------|---------|
| beta_twfe | -0.1763 | -0.17631 | 0.00001 | 0.003% | **EXACT** |
| se_twfe | 0.0484 | 0.04839 | 0.00001 | 0.02% | **EXACT** |

The TWFE estimate matches to within floating-point precision. The specification (`reghdfe lnpriceperpresc Post_avg exp [aw=wgt], absorb(state_r yq) cluster(state_r)`) is faithfully reproduced.

### CS-DID estimates
| Metric | Paper (original_result) | Our computation | % diff | Notes |
|--------|------------------------|-----------------|--------|-------|
| att_csdid_nt | -0.2019 | -0.2084 | 3.2% | Package version difference; our spec methodologically cleaner |
| att_csdid_nyt | -0.2084 | -0.2133 | 2.4% | Same explanation |

The CS-DID gaps (3.2%, 2.4%) are within tolerance and are fully explained by the documented did v2.3.0 package version difference: the paper's version passed `xformla=~exp`, which in our package version drops early cohorts (205–216); our cs_controls=[] specification preserves all 10 cohorts and is methodologically superior. This is a known and documented pattern (metadata notes).

### PDF page audit
The paper (Dranove, Ody & Starc 2021, AEJ: Economic Policy) reports the main TWFE result in Table 2. The stored beta_twfe=-0.1763 corresponds to the "Log Drug Price" column, main specification row. SE=0.0484 matches column (1). The match is exact.

---

## Summary
TWFE estimate matches the paper's Table 2 exactly (0.003%). CS-DID gaps are within tolerance and are explained by package-version-documented cohort-dropping behavior. Fidelity axis: **WITHIN_TOLERANCE** (upgrading to EXACT for the TWFE component; CS-DID tolerance gap does not demote overall because it is a documented and superior specification choice).

**Verdict: WITHIN_TOLERANCE**
(TWFE component: EXACT; CS-DID component: within 3.2%, explained and documented)
