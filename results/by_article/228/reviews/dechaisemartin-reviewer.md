# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

---

## Applicability Check

The de Chaisemartin reviewer is applicable iff treatment is non-absorbing OR continuous OR has heterogeneous dose at adoption.

### Treatment structure assessment

From metadata:
- `treatment_twfe: "treatment"` — binary 0/1 indicator
- `gvar_cs: "treat_cohort"` — first adoption year, staggered 2008-2016
- Treatment is **absorbing**: once a city adopts a Low Emission Zone (LEZ), it remains treated in all subsequent years. LEZs are permanent policy interventions; no reversal or dosage variation is documented in the data or paper.
- Treatment is **binary**: station is either inside/near a treated LEZ municipality or not.

### DCDH specific concerns

1. **Non-absorbing treatment?** NO. LEZs are permanent once enacted. No deactivation of LEZs is documented for German cities in the 2008-2016 period.

2. **Continuous treatment / dosage?** NO. Treatment is binary (treated municipality vs. not). There is no variable LEZ stringency or coverage fraction in the data.

3. **Heterogeneous dose at adoption?** NO variation in dose is captured in the data structure. All treated stations in a municipality share the same binary treatment status.

4. **Late reversal concern?** The sample ends in 2018, and LEZ adoption runs through 2016. No reversal episodes are noted.

### Conclusion

This is a standard staggered absorbing binary treatment design — the canonical case where de Chaisemartin estimators add no additional information beyond what CS-DiD and Bacon already provide. The DCDH estimator (`did_multiplegt` or `did_multiplegt_dyn`) would produce results equivalent to CS-DiD under these design conditions.

**NOT_NEEDED** — Standard absorbing binary staggered design; no non-absorbing, continuous, or dosage variation that would necessitate DCDH.

---

## Summary

No action required. CS-DiD (Callaway-Sant'Anna) is the appropriate estimator for this design and is already implemented. The de Chaisemartin & D'Haultfoeuille estimator is not needed here.
