# Bacon Decomposition Reviewer Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check

Bacon decomposition requires:
- `treatment_timing == "staggered"` — FAILED (this paper has `treatment_timing == "single"`)
- `data_structure == "panel"` — FAILED (this paper has `data_structure == "repeated_cross_section"`)
- `allow_unbalanced == false` or pre-balanceable — FAILED (`allow_unbalanced == true`)

All three conditions fail. Bacon decomposition is not applicable to a single-cohort repeated cross-section design. The TWFE estimate in this paper has no "staggered-vs-clean" or "earlier-vs-later-treated" variance decomposition — all treated units adopt in 1991.

The metadata confirms `run_bacon = false`, consistent with this determination.

**NOT_APPLICABLE — no further analysis.**
