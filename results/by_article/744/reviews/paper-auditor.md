# Paper Auditor Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** paper-auditor
**Date:** 2026-04-18
**Verdict:** NOT_APPLICABLE

---

## Applicability check

- `pdf/744.pdf`: FILE NOT FOUND — no PDF available for direct comparison
- `original_result` in metadata: empty `{}` — no reference estimate provided in metadata

Both conditions for paper-auditor applicability fail:
1. No PDF present to extract the paper's reported coefficient
2. No `original_result.beta` field populated in metadata.json

**Notes from metadata:** The notes field identifies the target as "Table 4 Panel B Column 1 (MMR vs TB)" and states the original Stata specification as `areg lnm_rate treatedXpost37 treatedXyear_c treated year_c, absorb(statepost) cluster(diseaseyear)`. Our stored `beta_twfe = -0.281` with `se_twfe = 0.108`. Without the PDF we cannot verify whether this matches the paper's reported -0.281 (if the paper reports a similar value).

**Verdict: NOT_APPLICABLE** — Fidelity axis cannot be evaluated. Rating will be determined by methodology axis alone.
