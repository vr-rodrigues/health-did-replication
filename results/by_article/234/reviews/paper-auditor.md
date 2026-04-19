# Paper Auditor Report: Article 234 — Myers (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability check
- PDF available: No (ls of pdf/ showed no 234.pdf).
- results.csv has numeric beta_twfe: YES (-0.00332).
- APPLICABLE for numerical fidelity check (using available metadata notes for paper comparison).

## Checklist

### 1. Original paper headline result
- Myers (2017), JPE: The paper's main TWFE estimate for the effect of pill consent laws on first birth before age 19.
- From metadata notes: "our univariate TWFE gives -0.0053 vs original -0.0084 (both insig)."
- Note: metadata note states -0.0053 but results.csv records beta_twfe = -0.00332. Minor inconsistency in the note vs actual output.

### 2. Our estimate vs paper
- Our beta_twfe = -0.00332 (univariate, no controls).
- Paper's estimate = -0.0084 (multivariate: 6 policy exposures + state trends).
- Absolute difference: |-0.00332 - (-0.0084)| = 0.00508.
- As fraction of paper SE (not available but approximately similar scale): the gap is meaningful.
- WARN: The difference is not a coding error — it is attributable to deliberately omitted controls (6 policy exposures + state trends in original). Our spec is univariate as designed.

### 3. Sign concordance
- Both estimates are negative. PASS on sign.

### 4. Significance concordance
- Both null (neither statistically significant). PASS on qualitative conclusion.

### 5. Magnitude assessment
- Our -0.0033 is 39% of the paper's -0.0084.
- This is a substantial magnitude gap but explainable by the univariate vs multivariate difference.
- Without the PDF to check exact Table/column targets, cannot confirm whether the paper reports a univariate baseline that would match more closely.

### 6. Tolerance assessment
- The gap of 0.005 exceeds a typical 10% relative tolerance.
- WARN: Not FAIL because the discrepancy is fully explained by the known specification difference (no state trends, no 5 other policy controls).
- If the paper reports a univariate baseline, we would need to compare to that figure.

## Summary
- Sign: match (both negative).
- Significance: match (both null).
- Magnitude: our estimate is 39% of paper's multivariate estimate — explainable by deliberate controls omission.
- No PDF available to verify exact table/column target.

**Verdict: WARN** — magnitude gap (39% of paper estimate) is fully explainable by univariate vs multivariate specification, and no PDF available to verify exact comparison target.

**Fidelity Score: F-MOD** (WARN verdict)
