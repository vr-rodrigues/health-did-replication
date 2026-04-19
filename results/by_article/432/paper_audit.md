# Paper fidelity audit: 432 — Gallagher (2014)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19

## Selected specification

From metadata notes and SKILL_profiler protocol: Equation (1) is explicitly labeled "the main estimating equation" (p. 214). The headline result is **Figure 2** — the event-study plot of β_τ coefficients from equation (1) on the 1990–2007 community panel (N=10,841 communities). The paper reports **no static post-treatment ATT** anywhere in the main text or in the single main-text table (Table 1).

Table 1 (p. 226) reports two event-study point estimates at τ=0 only:
- Flooded community, year of flood: β = 0.079 (SE = 0.012) ***
- Media neighbor, year of flood: β = 0.031 (SE = 0.006) ***

These are single-year event-time coefficients, not aggregate post-treatment ATTs.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Figure 2 / Table 1 Col 1, τ=0 only) | 0.079 | (0.012) | 10,841 communities | state | *** |
| Our stored results.csv (static post_hit) | 0.1095 | (0.0163) | 195,138 obs | state | *** |
| Relative Δ (vs τ=0) | +38.6% | +35.8% | | | |

**Note:** The relative Δ is shown for reference only. The comparison is structurally invalid — see rationale below.

## Notes

- The paper's main estimating equation is an event study (equation 1). All empirical results are presented as event-time coefficient plots (Figures 2–9). No summary static ATT is reported in the paper.
- Table 1 (the only table in the main text) reports τ=0 year-of-flood coefficients from a specific specification that adds media-neighbor indicators (equation 2, 1980–2007 panel) — not equation (1) on the 1990–2007 panel.
- Our stored `beta_twfe` = 0.1095 is constructed from a synthetic `post_hit` indicator (1{year2 >= hit1year}) to produce a static summary for the pipeline. This number does not appear in the paper.
- The τ=0 coefficient from Figure 2 (equation 1, 1990–2007 panel) is approximately 0.078–0.090 per the paper's text ("8 percent increase"). The Table 1 Col 1 τ=0 value is 0.079. Our static beta (0.1095) is higher because it averages across all post-treatment years including the spike years (τ=+1 peak ≈ 0.09) and later years when take-up declines but remains positive.
- Metadata documents this explicitly: "Collapse = 1: paper reports ONLY event study coefficients (no static ATT), so we construct post_hit = 1{year2 >= hit1year} for static TWFE."
- The prior paper-auditor.md in reviews/ was written without PDF access and noted NOT_APPLICABLE on those grounds. This audit confirms NOT_APPLICABLE on substantive grounds: no comparable published number exists.
- The paper uses repeated-event hityear_* variables for the event study (not first-hit only), which is documented in metadata as an idiosyncrasy. Our stored TWFE uses first-hit post_hit — a further structural divergence from any published Figure 2 coefficient.

## Verdict rationale

The paper reports exclusively event-study coefficients in figures; no static post-treatment ATT appears in any published table or figure. Our stored `beta_twfe` (0.1095) is a pipeline artifact from a synthetic `post_hit` indicator that has no direct counterpart in the paper's published results. A numerical comparison would be structurally meaningless.
