# Paper fidelity audit: 395 — Malkova (2018)

**Verdict:** NOT_APPLICABLE (paper does not report a standalone static TWFE estimate)
**Date:** 2026-04-19

## Selected specification

Metadata notes: "Static TWFE ATT=1.09 is reliable (identified from timing variation)."
SKILL_profiler protocol applied: searched all tables (2–6) and figures in the 13-page main text
plus the replication do-file (`alltables.do`). No candidate table with a single post-treatment
coefficient was found.

Selected specification: NOT APPLICABLE — see below.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (any table) | not reported | not reported | — | — | — |
| Our stored results.csv | 1.0908 | 0.4086 | — | Birthplace_code | — |
| Relative Δ | n/a | n/a | | | |

## Notes

- Malkova (2018) uses year-by-year interaction dummies throughout:
  - Table 2 (short-run, annual data): coefficients for `pre_treat`, `post1_treat` (1981),
    `post2_treat` (1982), `post3_treat` (1983–1986) — no single static `treat_post`.
  - Table 3: same structure, parity-specific GFR.
  - Table 4: age-at-birth and interval outcomes, similarly interacted.
  - Table 5 (long-run): grouped event-study dummies (1–3, 4–6, 7–10 years post).
  - Table 6: adult outcomes; dummies for birth years 1981 and 1982 only.
- The replication do-file (`alltables.do`) confirms: no regression uses a single collapsed
  `treat_post` variable. The variable `treat_post` used in our pipeline (`df$treat_post <-
  as.integer(df$Year >= df$gvar_CS)`) is a construction specific to our template, not the
  paper's specification.
- The metadata `original_result.beta_twfe = 1.091` / `se_twfe = 0.409` represents our
  pipeline's output from that constructed indicator — it has no direct counterpart in any
  published table in the paper.
- The paper's headline short-run result (Table 2 Col 2) is: `post1_treat` (1981) = 2.354***
  [0.634]; `post2_treat` (1982) = 6.192*** [1.031]. The headline long-run result (Table 5
  Col 1) groups 1–3 years post = 9.063*** [1.497], 4–6 years = 10.71*** [2.277],
  7–10 years = 10.84*** [3.463]. None of these is a single ATT.
- The PDF available is the 13-page published article only; the online appendix (referenced as
  available at http://www.mitpress journals.org/doi/suppl/10.1162/rest_a_00713) is not
  included in the local PDF. However, the replication do-file covers all tables and confirms
  no static DiD table exists in the appendix either.

## Verdict rationale

The paper exclusively reports year-interacted or grouped-year event-study coefficients; it
never collapses the post-treatment period into a single binary indicator. Our stored
`beta_twfe = 1.091` is a pipeline artifact from the template's `treat_post` construction
that has no counterpart in any published table — therefore no fidelity comparison is possible.
