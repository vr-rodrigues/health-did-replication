# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is designed to handle:
1. Non-absorbing (switching-on and switching-off) treatments
2. Continuous treatments
3. Designs with heterogeneous treatment doses at adoption

### Assessment for article 97

**Treatment type:** Binary absorbing. Municipalities either receive the water disinfection reform in 1991 or never receive it. Once treated, they remain treated. No treatment reversal is documented in the metadata or original paper.

**Treatment intensity:** Uniform binary (treated/not-treated). No continuous dose or heterogeneous intensity at adoption.

**Staggered variation:** Treatment timing is single (all treated units adopt in 1991). There is no cross-cohort contamination issue of the type did_multiplegt addresses.

**Dual-cohort structure:** The treated2 variable creates two "cohorts" — treated2=1 (never-treated) and treated2=2 (treated in 1991). This is a within-municipality repeated-cross-section design with two observation slots per municipality, not a multi-wave treatment-reversal or dose-heterogeneity scenario.

### Conclusion

None of the conditions triggering the de Chaisemartin estimator are present:
- Treatment is absorbing (not non-absorbing)
- Treatment is binary uniform (not continuous or dose-heterogeneous)
- Treatment timing is single (not staggered with heterogeneous doses)

**NOT_NEEDED** — the standard absorbing-binary-single-cohort design does not require the de Chaisemartin corrective. The TWFE and CS-NT estimators are the appropriate tools and are already computed.
