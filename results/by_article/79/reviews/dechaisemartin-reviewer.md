# de Chaisemartin Reviewer Report — Article 79 (Carpenter & Lawler 2019)

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

---

## Applicability check

The de Chaisemartin & D'Haultfoeuille (DH) estimator is designed for:
1. Non-absorbing treatment (treatment can switch on and off)
2. Continuous/dose treatment with heterogeneous dose at adoption
3. Designs where treatment can reverse

**Article 79 treatment structure:**
- `treatment_twfe`: `TDcont_mandate` — a continuous mandate intensity measure
- Treatment timing: staggered (states adopt Tdap mandates at different years)
- The mandate intensity can vary over time within a state (continuous dose)

**Verdict assessment:**

The treatment is continuous with staggered adoption. This technically satisfies condition (2) — continuous treatment. However:

1. The paper's research design uses the continuous `TDcont_mandate` as an intensity-weighted treatment, which is their primary TWFE specification. This is intentional design, not a misclassification.

2. Callaway & Sant'Anna (CS-DID) is already run and provides the primary robustness check for staggered adoption heterogeneity.

3. de Chaisemartin's `did_multiplegt` is most valuable when treatment is non-absorbing (switchers-on and switchers-off) or when cohort heterogeneity is the primary concern. For continuous dose-response, it offers limited additional insight beyond what CS-NYT already provides here.

4. The continuous nature of the mandate variable is not a sign of non-absorbing binary treatment — it is a measured intensity of a policy that states adopt and rarely revoke in this data period (2008–2014 NIS-Teen survey).

5. The metadata notes do not indicate reversal of treatment or switchers-off, and the Bacon decomposition (which was run even though RCS flags it as inapplicable) confirms all between-group comparisons yield positive estimates — consistent with a monotone absorbing design.

**Conclusion:** Standard absorbing staggered design with a continuous intensity variable. The continuous variable is an original design choice, not a sign of non-absorbing or reversible treatment. The CS-NYT estimator already handles cohort-level ATT heterogeneity. DH adds no material additional information for this specific design.

---

**Verdict: NOT_NEEDED**
