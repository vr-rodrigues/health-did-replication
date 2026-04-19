# de Chaisemartin-d'Haultfoeuille Reviewer Report — Article 419

**Verdict:** NOT_NEEDED

**Article:** Kahn, Li, Zhao (2015) — "Water Pollution Progress at Borders"
**Date:** 2026-04-18

---

## Assessment

### Design characteristics

- Treatment: `bypost06 = boundary * post06` — binary indicator, absorbing (stations designated as boundary or not by geographic criterion; cannot switch back)
- Timing: Single cohort (all boundary stations adopt in 2006; no staggered adoption)
- Dose: Binary only — no continuous dose variation, no heterogeneous dosage at adoption
- Non-absorbing? No — treatment is permanent (geographic designation)

### Applicability determination

The de Chaisemartin-d'Haultfoeuille `did_multiplegt` estimator is designed for settings with:
1. Non-absorbing (switching) treatments
2. Continuous treatment intensities
3. Heterogeneous dose at adoption in staggered designs

None of these conditions apply to article 419:
- Treatment is binary and absorbing (boundary vs interior stations)
- Single adoption cohort — no staggered timing concerns
- No continuous dose dimension

With a single clean adoption cohort of never-treated comparators, the TWFE estimand is a single 2×2 DiD ATT with no contamination from heterogeneous timing. The de Chaisemartin-d'Haultfoeuille critique of TWFE (which concerns negative weighting from treatment effect heterogeneity across cohort-time cells) does not materially apply.

### Conclusion

**NOT_NEEDED** — the design does not trigger any of the conditions for which `did_multiplegt` provides diagnostic value beyond what TWFE and CS-DID already capture.

Full report: `reviews/dechaisemartin-reviewer.md`
