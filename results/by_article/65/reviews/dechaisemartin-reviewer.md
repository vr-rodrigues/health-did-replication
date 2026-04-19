# de Chaisemartin Reviewer Report: Article 65
# Akosa Antwi, Moriya & Simon (2013) — ACA Dependent-Coverage Mandate

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

---

## Applicability check

The de Chaisemartin & D'Haultfoeuille (2020) reviewer is designed for:
- Non-absorbing treatment (units can switch in and out of treatment)
- Continuous treatment or heterogeneous dose at adoption
- Cases where treatment variance across cohorts is structurally complex

### Assessment for Article 65:
- **Treatment structure**: Binary absorbing treatment. Once an individual is age 19–25 after October 2010, they are treated. The treatment indicator `elig_oct10 = after_oct10 * fedelig` is fixed at the individual level for the duration of eligibility.
- **Treatment timing**: Single timing ("unica") — all treated units become treated at the same calendar moment (month 34 = October 2010).
- **Dose heterogeneity**: None. The treatment is binary and uniform — all age-eligible young adults receive the same federal mandate (access to dependent coverage up to age 26).
- **Non-absorbing concern**: Not applicable. Age-eligibility is time-varying (individuals age out of 19–25), but the TWFE treatment variable `elig_oct10` captures post-Oct-2010 status for those in the eligible age range — there is no re-entry or switching concern within the study window.

### de Chaisemartin relevance:
The Chaisemartin-D'Haultfoeuille (2020) critique targets TWFE estimators that weight ATTs by treatment variance across units and periods, which can yield negative weights when treatment switches or is heterogeneous. In a single-timing binary absorbing design, TWFE is clean — it directly estimates the ATT for the treated cohort vs the never-treated group. No negative weighting pathology applies.

**Conclusion**: de Chaisemartin analysis is NOT_NEEDED for this design.

---

## Summary

Standard absorbing binary single-timing design. The de Chaisemartin (2020) negative-weighting concern does not apply. No action required.

**Verdict: NOT_NEEDED**
