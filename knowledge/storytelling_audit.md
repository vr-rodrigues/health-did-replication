# Storytelling Audit of the Dissertation — Consolidated Plan

*Prepared from the `storyteller` agent rubric, calibrated against two exemplar DiD papers:*
- **MSSU23**: Ma, Sant'Anna, Sasaki & Ura (2023), *Doubly Robust Estimators with Weak Overlap*.
- **OS25**: Ortiz-Villavicencio & Sant'Anna (2025), *Better Understanding Triple Differences Estimators*.

*This document consolidates the rule-by-rule audit of every chapter of the dissertation, at the same level of detail for each. No `.tex` file has been modified yet. This is the single reference for the chapter-by-chapter revisions that follow.*

*User decisions already incorporated:*
- *Reject the "Spec A / Spec B / Spec C" labels from §4 cross-cutting recommendations; use the existing text labels (matched, unconditional, legacy) or whatever prose description fits each context.*
- *Adopt Option B for Chapter 2 (§3.3): compress the psychology-reproducibility paragraph and move faster to Baker/Chiu/Brodeur.*

---

## 0. Executive summary

The dissertation is clean, technical, and evenly paced. Its econometrics and its reanalysis protocol are defensible and documented. What it does not yet do is carry a reader from "why should I care" through "what did you find that surprised you" to "what should I do differently on Monday".

The text currently reads like a **methods report**. In MSSU23 and OS25, the same authors whose methods this dissertation applies write in a register that is closer to a **prosecuting argument**: stakes first, conventional wisdom put on the table and rejected, surprising findings previewed before the math, figures that carry the punchline in their own caption, each section ending on a natural next question, and a conclusion that opens a door rather than closing one.

**Overall score across the document:**

| Unit | Score | Key weakness |
|---|---|---|
| Abstract | MIXED (3 PASS, 2 PARTIAL, 2 MISS, 4 N/A) | Opens with notation; artifacts absent; no scope sentence |
| Chapter 1 | MIXED-STRONG (4 PASS, 4 PARTIAL, 2 MISS, 1 N/A) | Opens with notation; scope missing; artifacts under-promoted |
| Chapter 2 | MIXED-STRONG (4 PASS, 5 PARTIAL, 0 MISS, 2 N/A) | §2.1 subsections lack R4 confrontation except §2.1.4; §2.2 is paratactic |
| Chapter 3 | MIXED (3 PASS, 2 PARTIAL, 4 MISS, 2 N/A) | Identification/meta-statistic section commented out; no named assumptions; no R1 |
| Chapter 4 | MIXED (3 PASS, 6 PARTIAL, 2 MISS) | No chapter overture; 8/10 Lessons open with finding not confrontation; no inter-Lesson transitions; no honesty section |
| Chapter 5 | MIXED-STRONG (3 PASS, 3 PARTIAL, 0 MISS, 5 N/A) | Opens procedurally; estimator-side limits absent; horizon listed not framed |

**Document-wide score: MIXED**. Wave 1 (§6 below) takes the document to STRONG across the board in 7-9 hours of writing.

---

## 1. Top three priority edits

The three edits that most improve the reader's experience for the smallest amount of work.

### Priority 1 — Give Chapter 1 a stakes-first opening (R1)

- **Location**: `overleaf/Chapters/Chapter1.tex`, sentence 1.
- **Current (first 15 words)**: *"Two-way fixed-effects (TWFE) has been the default estimator for difference-in-differences (DiD) in applied economics…"*
- **Problem**: Opens with notation and a method name. MSSU23 opens with *policy decision-making across four fields*; OS25 opens with a live *methodological revolution*. Neither starts with a method.
- **Suggested direction**: Open with the health-economics stake (welfare and cost-effectiveness calculations depend on the *magnitude* of the DiD estimate, not just its sign). Then sentence 2 notes the live methodological debate. Only then introduce TWFE.
- **Exemplar**: MSSU23 §1 sentence 1 and OS25 §1 sentence 1.

### Priority 2 — Add a "challenge conventional wisdom" move to every Lesson opening in Chapter 4 (R4)

- **Location**: Top of Chapter 4 (chapter overture, currently absent), and opening sentence of every Lesson.
- **Current (Lesson 1 first 15 words)**: *"Replacing TWFE with modern DiD estimators usually preserves the direction of published findings…"*
- **Problem**: This is a finding, not a confrontation. The reader is told something but not shown a belief being rejected. Out of 10 Lessons, only L7 and L10 open with R4 moves.
- **Suggested direction**: Every Lesson opens with *"common belief is X — we show Y"*. Lesson 1: *"The common reading is that sign preservation saves the TWFE result; we show that belief is incomplete, because in 39.6% of cases the magnitude shifts enough to change the policy decision."*
- **Exemplar**: Chapter 4 Lesson 7 already does this correctly (*"Switching from TWFE to a heterogeneity-robust estimator can improve the mapping… It does not, by itself, make the identifying counterfactual more credible."*) — use as internal model.

### Priority 3 — Make figure captions do narrative work (R6)

- **Location**: All event-study and scatter-plot figures in Chapter 4, starting with Figure 4.1 (aggregate scatter) and the Maclean & Pabilonia (2025) decomposition.
- **Current (Maclean figure caption first 15 words)**: *"Panel~(a) reports the Goodman-Bacon decomposition of the state×year pseudo-panel TWFE…"*
- **Problem**: Describes *what is plotted* but not *what the reader should conclude*.
- **Suggested direction**: Rewrite each caption in two moves — (i) a one-sentence conclusion, (ii) the technical notes. The reader who sees only the figure must leave with the conclusion.
- **Exemplar**: OS25 Figure 1 (densities) and Figure 2 (4-panel density comparison).

---

## 2. Structural proposal — from 10 Lessons to 6 + honesty

Chapter 4 architecture currently treats ten Lessons as a list. The proposal is to transform them into **one argument chained along the applied workflow: pre-registration → estimation → interpretation → implementation → honesty**. Several merges are natural because multiple Lessons cover the same design margin.

| New Lesson | Consolidates | Case study |
|---|---|---|
| **L1. Directionally stable, quantitatively fragile** | current L1 | aggregate diagnostic |
| **L2. In staggered designs, aggregation structure and control-group choice do the heavy lifting** | current **L2 + L8** | Maclean & Pabilonia (2025) |
| **L3. Covariates change the identifying comparison** | current **L3 + L4 as subsection** (geographic is a special covariate) | Hoynes et al. (2015) + graduated sensitivity |
| **L4. Dynamic margins: binning, long-tail contamination, persistence** | current **L5 + L6** | Lawler & Yewell (2023) |
| **L5. Robustness to heterogeneity does not imply credibility** | current L7 | HonestDiD, PT violations |
| **L6. Implementation is part of the estimand** | current **L9 + L10** | Li (2025), software + CS-DID aggregation |
| **L7. When modern estimators do not help** *(new — honesty section)* | — | Pattern 42 DR collapse, Kresch sample mismatch, wider-CI cases |
| **Toward an applied guide** | final section (preserved) | checklist + decision tree |

**Rationale**:
1. Ten Lessons saturate the reader; six plus a honesty section give the reader one claim per chapter-long scroll.
2. The merges respect the criterion *one Lesson, one design margin*.
3. L7 (new) addresses the single largest R8 gap — today the body rarely acknowledges where modern estimators *lose*, the move MSSU23 §5 (DGP3) uses to earn credibility.
4. Ordering follows the workflow the applied researcher actually executes.

**What is preserved**: all currently-existing prose, tables, figures, and boxes (checklist + decision tree) remain. Content migrates to new Lesson headings rather than being deleted.

---

## 3. Chapter-by-chapter plan

Each chapter is audited with the same structure: rule-by-rule verdict → specific problems (with quoted 15-word excerpts) → what to preserve → detailed interventions (direction + exemplar) → structural options considered → order of execution.

---

### 3.1. Abstract (`overleaf/main_dry_en.tex`, lines 206-240)

#### 3.1.1. Rule-by-rule verdict

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes-first | **MISS** | Opens *"Two-way fixed-effects (TWFE) difference-in-differences (DiD) has been the default estimator…"* — same structural problem as Ch 1 |
| R2 Preview-before-math | **PARTIAL** | 46/7 preservation rate is front-loaded; 39.6% shift is there; but the surprise (negative weights are second-order) is absent |
| R3 Named assumptions | **N/A** | abstract register |
| R4 Challenge conventional wisdom | **MISS** | No "X is commonly believed but we show Y" move |
| R5 Natural-question transitions | **N/A** | single-paragraph register |
| R6 Figure captions | **N/A** | no figures |
| R7 Calibrated claims | **PASS** | "53 papers", "46 cases", "reverses in 7", "39.6%", "24.5%" — exemplary |
| R8 Epistemic honesty | **PASS** | "follows each paper's own preferred specification and replaces only the estimator, so any divergence is attributable to methodology" is a clean honesty move |
| R9 Explicit scope | **PARTIAL** | "53 published health-economics papers" is implicit scope; no explicit "what this is not" |
| R10 Artifact | **MISS** | The checklist and decision tree — the dissertation's durable deliverables — are not mentioned. "A template for future methodological audits" (P3) is vague. |
| R11 Forward-looking | **N/A** | abstract register |

**Score**: 3 PASS / 2 PARTIAL / 2 MISS / 4 N/A.

#### 3.1.2. Specific problems

1. **Opens with notation**. First 15 words: *"Two-way fixed-effects (TWFE) difference-in-differences (DiD) has been the default estimator in applied…"*. A reader who does not already care about TWFE has no reason to continue past word 10.
2. **Cataloged estimator list**. P1 ends with *"Callaway--Sant'Anna (CS-DID), Sun--Abraham (SA), Borusyak--Jaravel--Spiess (BJS), Goodman-Bacon's decomposition, and the Rambachan--Roth (HonestDiD) sensitivity framework"*. This is a list of acknowledgments, not a sentence that carries an argument.
3. **Surprise buried in P2**. The *"Bacon decompositions show that treated-versus-treated comparisons account for a substantial share…"* sentence is the door to the key surprise (negative weights are not the central margin) but the surprise itself is never stated.
4. **Boilerplate contribution paragraph**. P3 *"The contribution is threefold"* is a dissertation-template sentence, not a claim-carrying one. *"Third, the package itself provides a template for future methodological audits of applied literatures"* is too vague — no reader can cite "a template".
5. **No checklist / decision tree**. Box 4.1 and Box 4.2 — the dissertation's two citable deliverables — are invisible in the abstract.

#### 3.1.3. What to preserve

- Sentence *"follows each paper's own preferred specification and replaces only the estimator, so any divergence is attributable to methodology rather than to redesign"* (P2 opening) — exemplary honesty; keep.
- The quantitative string *"sign of the effect is preserved in 46 cases and reverses in 7 (86.8% preservation rate)"* — exemplary R7; keep.
- *"Sixteen articles lose conventional statistical significance"* + *"magnitude of the point estimate moves by more than 50% in 39.6% of designs (24.5% move by more than 100%)"* — keep.
- *"Bacon decompositions show that treated-versus-treated comparisons account for a substantial share of the identifying variation in staggered TWFE specifications"* — the mechanism statement; keep.
- *"HonestDiD sensitivity exercises further show that robustness to parallel-trends violations is limited under both TWFE and CS-DID"* — keep.
- *"reproducible metadata-driven pipeline that re-estimates each paper from its original replication package under a standardized protocol with a fixed random seed"* — P3 sentence 1; keep.

#### 3.1.4. Interventions

**Intervention 1 — Rewrite the opening into a stakes-first sentence** (R1 MISS → PASS)

- Direction: first sentence names the health-policy stake. Welfare and cost-effectiveness calculations depend on the *magnitude* of the DiD estimate; the sign is not the whole quantity of interest. Only then does the abstract note that the default estimator in this literature has been put under methodological scrutiny.
- Exemplar: MSSU23 abstract sentence 1 (*"In this paper, we derive a new class of doubly robust estimators…"* — not ideal as opener in their case, but the intent is the same: lead with what the reader gains, not with notation. A better exemplar is OS25 abstract sentence 1: *"Triple Differences (DDD) designs are widely used in empirical work to relax parallel trends assumptions…"* — leads with what DDD *does for the reader*).

**Intervention 2 — Add the central surprise as an explicit sentence** (R4 MISS → PASS; R2 PARTIAL → PASS)

- Direction: one sentence after the magnitude-shift numbers that states the surprise plainly: *"Against the dominant reading of the modern DiD critique as primarily a negative-weights problem, this sample shows those weights are empirically second-order; the larger sources of divergence are control-group choice, covariate handling, endpoint binning, and software defaults."*
- Exemplar: OS25 abstract, sentences 3-4: *"This paper highlights that common DDD implementations — such as taking the difference between two DiDs or applying three-way fixed effects regressions — are generally invalid when identification requires conditioning on covariates. In staggered adoption settings, the common DiD practice of pooling all not-yet-treated units as a comparison group can introduce additional bias…"*. That is two surprises stated in two sentences, before any technical content.

**Intervention 3 — Promote the two artefacts by name** (R10 MISS → PASS)

- Direction: replace *"the package itself provides a template for future methodological audits"* with a concrete sentence naming the two Boxes: *"We distill these patterns into two practical artefacts — a fifteen-item pre-submission checklist and a design-triage decision tree — both available in the replication package."*
- Exemplar: OS25 abstract last sentence: *"A companion R package is available."* One sentence, three words, visible.

**Intervention 4 — Add one explicit scope line** (R9 PARTIAL → PASS)

- Direction: one sentence (or half-sentence) at the end naming the sample scope: *"The exercise is restricted to binary absorbing-treatment DiD in health economics; extensions to continuous and non-absorbing designs are left to future work."*
- Exemplar: OS25 abstract last line on package + future work register.

**Intervention 5 — Replace the estimator catalog with a claim-carrying sentence** (R7 holds; structure)

- Direction: the current P1 ending lists five estimator families. Rewrite as a single sentence that says *what* this ensemble achieves: *"We compare TWFE against a standardized ensemble of modern heterogeneity-robust estimators (CS-DID, Sun-Abraham, Gardner/did2s, Borusyak-Jaravel-Spiess) and design diagnostics (Goodman-Bacon, HonestDiD), applied uniformly across the 53 papers."* Same information, one sentence, forward motion.
- Exemplar: OS25 abstract, *"We develop regression adjustment, inverse probability weighting, and doubly robust estimators that remain valid under covariate-adjusted DDD parallel trends."* — an ensemble stated as one claim, not a list.

#### 3.1.5. Target structure (7 sentences, ≈200 words)

1. Health-policy stake.
2. Live methodological debate.
3. The exercise (53 papers, standardized ensemble, uniform protocol).
4. Directional result (46/7).
5. Magnitude results (16 lose significance, 39.6%/24.5%).
6. **The surprise** (negative weights are second-order).
7. Artefacts (checklist + decision tree) + one-line scope.

#### 3.1.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Rewrite sentence 1 (stakes) | 15 min | R1 MISS → PASS |
| 2 | Add surprise sentence (negative weights second-order) | 15 min | R4 MISS → PASS; R2 PARTIAL → PASS |
| 3 | Replace cataloged estimator list with one claim-carrying sentence | 15 min | structural |
| 4 | Add artefact sentence (Box 4.1 + Box 4.2) | 10 min | R10 MISS → PASS |
| 5 | Add one-line scope statement | 5 min | R9 PARTIAL → PASS |

**Total**: ~1 hour. **Result**: 6 PASS / 1 PARTIAL / 0 MISS / 4 N/A. Abstract moves from MIXED to **STRONG**.

---

### 3.2. Chapter 1 — Introduction (`overleaf/Chapters/Chapter1.tex`)

#### 3.2.1. Rule-by-rule verdict

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes-first | **MISS** | Opens *"Two-way fixed-effects (TWFE) has been the default estimator for difference-in-differences (DiD) in applied economics for decades"* — notation + method, no stake |
| R2 Preview | **PASS** | "Three findings organize the answer" is followed by the three findings, stated before any technical content |
| R3 Named assumptions | **N/A** | introduction register |
| R4 Challenge conventional wisdom | **PARTIAL** | The three findings (P4-P6) are confrontational in substance but soft in register; *"empirically second-order"* is the move but it is not framed as rejecting a belief |
| R5 Natural-question transitions | **PASS (internal)** | *"That pattern shifts the next question"* (P3) is exactly the right move |
| R6 Figure captions | **N/A** | no figures |
| R7 Calibrated claims | **PASS** | 46/7, 39.6%, 24.5% all present; 53 articles stated; comparative claims vs Baker/Chiu/Brodeur |
| R8 Epistemic honesty | **PARTIAL** | The limits of the sample are deferred to Ch 5; Ch 1 does not state "what we do not do" |
| R9 Explicit scope | **MISS** | No "this paper does not X, does not Y, does not Z" paragraph |
| R10 Artifact | **PARTIAL** | The checklist appears once in P6 (*"a short pre-submission checklist for applied researchers"*) but is not named by Box number and is not a headline deliverable |
| R11 Forward-looking | **N/A** | introduction register |

**Score**: 4 PASS / 4 PARTIAL / 2 MISS / 3 N/A.

#### 3.2.2. Specific problems

1. **Opens with method**. *"Two-way fixed-effects (TWFE) has been the default estimator for difference-in-differences (DiD) in applied economics for decades"* — a textbook sentence. No stake, no debate, no urgency.
2. **The positioning paragraph is on page 1 but reads late**. P7 (*"Compared with prior exercises in finance and accounting…"*) is the strongest paragraph in the chapter — it names Baker, Chiu, Brodeur and states *"this paper goes deeper rather than wider"*. It arrives after the reader has already absorbed the findings; moving it earlier, or echoing its core claim in P2, would compound the argument.
3. **Three findings are soft**. The prose in P4 *"First, the negative-weights critique that has attracted much of the methodological attention is empirically second-order in this sample"* states the surprise but without naming the belief it rejects. Compare to the candidate register: *"The modern DiD critique is widely read as a critique of negative weights. In this sample, that reading is misplaced."* The second is the OS25 register.
4. **Net health benefit is buried in Ch 4 footnote**. The footnote *"the net health benefit is \(\text{NHB}(\lambda)=\Delta E-\Delta C/\lambda\)…"* in Chapter 4 is the sharpest expression of *why magnitude matters for policy* in the whole dissertation. It belongs in Chapter 1, not in Chapter 4 footnote.
5. **Roadmap paragraph (P8) is mechanical**. Current *"The remainder of the paper proceeds as follows. Chapter 2 reviews… Chapter 3 describes…"* is standard but inert. It could be compressed and made to serve scope + artefact announcement at once.
6. **Scope absent**. The sample is restricted to health economics, binary absorbing treatments, studies with usable replication packages; Ch 1 does not say so. Ch 5 does; the reader learns in the wrong place.

#### 3.2.3. What to preserve

- Full paragraph 7 (positioning vs Baker/Chiu/Brodeur). The line *"this paper goes deeper rather than wider"* is a positioning sentence that OS25 would be proud of; keep verbatim.
- The three quantified findings (46/7, 39.6%, 24.5%) — keep the numerics.
- Paragraph 5 (second-finding: heterogeneity-robust ≠ PT-robust) is already in the correct register; keep.
- The three reasons health is a useful setting (*"DiD is a workhorse design", "policy stakes are often explicit", "health economics has developed its own applied guidance"*) — these are the dissertation's justification for field choice; preserve the substance (may be compressed).
- The \(\text{NHB}(\lambda)\) footnote — promote upward but do not rewrite.

#### 3.2.4. Interventions — target structure of 6 paragraphs

**P1. Stakes-first opening** (R1 MISS → PASS)

- Direction: first sentence states the health-economics stake using the net-benefit framing now buried in Ch 4. Second sentence: the magnitude of the DiD estimate enters that calculus directly, so sign preservation is insufficient. Third sentence: the methodological literature of the last five years has revisited the estimator that most of this evidence base rests on.
- Exemplar: OS25 §1 sentence 1 — debate framing.

**P2. Active debate + applied question** (R4 + R5)

- Direction: name the *"methodological revolution"* with Goodman-Bacon (2021), Roth-Sant'Anna-Bilinski-Poe (2023), Baker-Callaway-Cunningham-Goodman-Bacon-Sant'Anna (2025). State the applied question in plain English: *"when we replace TWFE with modern estimators in published studies, how often do the conclusions change, and along what margin?"*
- This paragraph stays close to the current P1 substance but reorders to place the debate before TWFE rather than after.

**P3. The exercise** (R2 preview)

- Direction: 53 studies, health-economics, standardized modern-estimator protocol, fixed seed, AI-assisted pipeline. Keep to 3-4 sentences; detail belongs in Ch 3.

**P4. Three findings in confrontational format** (R4 PARTIAL → PASS; R2 PARTIAL → PASS)

- Rewrite each finding as *"common reading is X — we show Y"*:
  - *"The modern DiD critique is commonly read as a critique of negative weights. In this sample that reading is misplaced: negative weights appear but are rarely dominant. The divergence between TWFE and modern estimators is driven by control-group choice, covariate handling, dynamic aggregation, endpoint binning, and software defaults."*
  - *"A second common reading is that adopting a heterogeneity-robust estimator closes the identification question. It does not. Robustness to heterogeneous treatment effects and credibility of parallel trends are different questions; the literature often conflates them."*
  - *"A third common expectation is that correcting these problems requires methodological expertise. We propose two practical deliverables — a fifteen-item pre-submission checklist (Box 4.1) and a design-triage decision tree (Box 4.2) — that translate the reanalysis into a workflow any applied researcher can execute before submission."*
- Exemplar: OS25 §1 — three surprising findings stated before the formal framework.

**P5. Positioning** (R7 preserved)

- Preserve current P7 almost verbatim. Optionally move the *"goes deeper rather than wider"* line higher in the paragraph so it is the first thing the reader encounters.

**P6. Scope + artefacts + compressed roadmap** (R9 MISS → PASS; R10 PARTIAL → PASS)

- Direction: one sentence of explicit scope (*"This paper does not re-collect data, re-identify the ATT from first principles, cover continuous or multi-valued treatments, or claim a census of the DiD literature; it re-estimates a defined sample under a common protocol"*). Two-sentence roadmap pointing to Ch 3 (protocol), Ch 4 (lessons + artefacts), Appendix B (per-article cards).
- Artefacts naming: *"Box 4.1 (checklist) and Box 4.2 (decision tree) are the paper's practical output; they are anchored to the empirical patterns documented in Chapter 4."*
- Exemplar: OS25 §1 *"Organization of the paper: The rest of the paper is organized as follows…"* with explicit deliverables named.

#### 3.2.5. Structural options considered

- **Option: open with a specific surprising case (Maclean 2025)**. Rejected. Chapter 1 is not a case-study chapter; opening with one paper lowers the register. The Maclean case carries Ch 4 Lesson 2.
- **Option: include the \(\text{NHB}(\lambda)\) formula in the body of P1**. Rejected. Formula belongs in a footnote. The *concept* (net-benefit framework, threshold-dependent decisions) belongs in the body.

#### 3.2.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Rewrite P1 with stakes-first opening + \(\text{NHB}\) reference | 45 min | R1 MISS → PASS |
| 2 | Rewrite P4 as three confrontational findings | 45 min | R4 PARTIAL → PASS |
| 3 | Promote P7 (positioning) or echo its thesis earlier | 15 min | compounds R7 |
| 4 | Add scope paragraph (P6 first half) | 20 min | R9 MISS → PASS |
| 5 | Promote Box 4.1 + Box 4.2 by name in P6 | 10 min | R10 PARTIAL → PASS |
| 6 | Compress roadmap into 2 sentences in P6 | 15 min | economy |

**Total**: ~2.5 hours. **Result**: 8 PASS / 0 PARTIAL / 0 MISS / 3 N/A. Chapter 1 moves from MIXED-STRONG to **STRONG**.

---

### 3.3. Chapter 2 — Related Literature (`overleaf/Chapters/Chapter2.tex`)

*This chapter was re-audited in detail after the user asked for a personalized plan. The chapter is substantially stronger than initial impression.*

#### 3.3.1. Rule-by-rule verdict

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes | **PARTIAL** | Opens *"Recent work on DiD has changed how applied researchers should interpret TWFE estimates"* — live debate, but generic; could open any DiD review |
| R2 Preview | **PARTIAL** | §2.1.4 previews the reanalysis finding; §2.1.1, §2.1.2, §2.1.3 do not |
| R3 Named assumptions | **PASS** | Correct register for a lit review |
| R4 Challenge conventional wisdom | **PARTIAL** | §2.1.4 does this well; §2.1.1, §2.1.2, §2.1.3 and §2.2 do not |
| R5 Natural-question transitions | **PARTIAL** | §2.1.1→§2.1.2 works by accident; other subsection transitions are absent |
| R6 Figure captions | **N/A** | no figures |
| R7 Calibrated claims | **PASS** | *"Chiu et al. reanalyze 49 studies in APSR/AJPS/JoP"* — exemplary |
| R8 Epistemic honesty | **PASS** | NT vs NYT trade-off stated cleanly in §2.1.2 |
| R9 Scope statement | **PASS** | §2.2.1 "The gap this paper fills" is textbook-correct |
| R10 Artifact | **N/A** | not the natural place |
| R11 Forward-looking | **PARTIAL** | Closes on a pointer to Ch 4, not on an horizon |

**Score**: 4 PASS / 5 PARTIAL / 0 MISS / 2 N/A.

**Narrative verdict**: the chapter reads like a map drawn from above rather than a walk through the terrain. Each subsection is correct in isolation, but the architecture between them is paratactic (side-by-side) instead of constructive (each supporting the next).

#### 3.3.2. Four specific problems

1. **The opening is diagnostic, not tensional**. *"Recent work on DiD has changed how applied researchers should interpret TWFE estimates"* could open any recent DiD review; it does not carry the field-specific tension that motivates the dissertation.
2. **§2.1.1, §2.1.2, §2.1.3 lack the R4 move**. §2.1.4 (Covariates) opens by placing a common applied practice on the table and confronting it — the model this subsection should replicate across the other three.
3. **§2.2 is a catalog, not a ladder**. The paragraphs on Baker, Chiu, and Brodeur are written in parallel. But they have argumentative relationships that disappear: Baker establishes that *estimator-swap is a valid unit of analysis*; Chiu pivots the focus from *heterogeneity* to *identification*; Brodeur distinguishes *reproducibility* from *robustness*.
4. **Transitions §2.1.2→§2.1.3 and §2.1.3→§2.1.4 are absent**. §2.1.4→§2.2 is the most violent jump.

#### 3.3.3. What to preserve intact

- **§2.1.4 (Covariates as part of the design)** — strongest subsection; opens with R4 confrontation and closes with a preview of the Ch 4 finding. Use as model for the other three §2.1 subsections.
- **§2.2.1 (The gap this paper fills)** — explicit gap statement, three reasons health is the right field, positioning sentence *"trades breadth across fields for depth across design margins within one field"* is exactly the rhetorical move OS25 uses.
- **Trade-off NT vs NYT in §2.1.2** — exemplary R8.
- **Equations 2.1, 2.2, and the \(ATT(g,t)\) definition** — compact and correct.
- **Three reasons health is a useful setting** — preserve verbatim.

#### 3.3.4. Six interventions

**Intervention 1 — Reopen the chapter with field-specific tension** (R1 PARTIAL → PASS)

- First paragraph of ~80 words, three moves:
  - Sentence 1: health economics is the most DiD-intensive applied subfield (`\parencite{goldsmith2024tracking}`).
  - Sentence 2: finance has already been reanalyzed (Baker 2022), political science too (Chiu 2025), cross-field too (Brodeur 2026); health has not, at scale.
  - Sentence 3: this chapter assembles the methodological tools and the reanalysis literature needed to ask the same question in health, with emphasis on the design margins that Chapter 4 documents.
- Exemplar: OS25 §1 opening (*"methodological revolution"*).

**Intervention 2 — Replicate §2.1.4's architecture in §2.1.1, §2.1.2, §2.1.3** (R4 PARTIAL → PASS)

Every subsection opens with *"In applied work, researchers often do X. The recent literature shows X is inadequate/incomplete because Y."* and closes with a preview of the Ch 4 finding.

- **§2.1.1 (Weighting)** — open by placing on the table the applied reading of TWFE in staggered as *"average of cohort effects"*; confront with Goodman-Bacon's decomposition showing it is built from *earlier-vs-later-treated* comparisons. Close with preview: *"In our 53-paper sample, negative weights appear but rarely dominate — the mean negative-weight share in staggered papers is 6.4%. What generates TWFE-vs-modern divergence is comparison structure, not the sign of the weights."*
- **§2.1.2 (Modern estimators)** — open by placing on the table the reading that *"adopting a heterogeneity-robust estimator solves the problem"*; confront with the fact that these estimators relocate the problem to choices that become explicit: control group, aggregation scheme, reference period.
- **§2.1.3 (Parallel trends)** — open with the applied practice of *"run pre-trend tests; if you fail to reject, declare PT valid; proceed"*; confront with Roth (2022) on low power and pre-test bias, then Rambachan-Roth (2023) on the replacement of binary logic with sensitivity analysis. Close with preview: *"Chapter 4 Lesson 5 shows that in 16 of 53 papers the HonestDiD M̄ is smaller than the largest pre-trend coefficient already observed."*
- **§2.1.4 (Covariates)** — leave intact. Adjust only the closing sentence to prepare §2.2.

**Intervention 3 — Turn §2.2 into an argumentative ladder** (structural)

Rewrite the three paragraphs (Baker / Chiu / Brodeur) as three rungs:

- **Baker**: keep the current content; add *"Baker establishes the validity of the exercise; what it does not answer is whether the patterns found in finance transfer to a field with different design features — still staggered, but shorter windows, heavier covariates, and more explicit policy diagnostics."*
- **Chiu**: open with *"Chiu et al. (2025) advance in the same direction in political science and pivot the focus: in many cases the sharper problem is not heterogeneity but identification."* Close: *"That reorientation — from robustness-to-heterogeneity to PT-credibility — is also a central finding of this paper, but in a different field and with an explicit ranking of design margins."*
- **Brodeur**: open with *"Brodeur et al. (2026) introduce a conceptual distinction that will be useful here: computational reproducibility is not the same as robustness."* Close: *"Our exercise is one of robustness under re-estimation, not of reproducibility."*

After the three laddered paragraphs, §2.2.1 (the gap) lands as natural resolution.

**Intervention 4 — Four explicit transition sentences between §2.1.X subsections** (R5 PARTIAL → PASS)

- End of **§2.1.1 → §2.1.2**: *"If the comparison structure of TWFE is opaque, the natural next question is whether estimators exist that make that structure explicit."*
- End of **§2.1.2 → §2.1.3**: *"With the estimand declared at the (g,t) level, the identification burden returns to parallel trends — now in a form that can be tested and, as we show, falsified."*
- End of **§2.1.3 → §2.1.4**: *"Heterogeneity and parallel trends are dimensions of the estimand; covariates alter the estimand itself."*
- End of **§2.1.4 → §2.2**: *"The four methodological margins define the state of the literature. The empirical question is which of them actually move results in applied work."*

**Intervention 5 — Adopt Option B: marginalize the psychology-reproducibility opening of §2.2** (user-approved)

- Compress the first two paragraphs of §2.2 — the one on Open Science Collaboration (2015) and Camerer et al. (2018) plus the Vivalt (2020) specification-robustness tradition — into a **single paragraph of 4-5 sentences** that mentions the reproducibility lineage for context and moves on to Baker/Chiu/Brodeur.
- Rationale: the current opening makes a lateral move (psychology → economics) before saying the actionable thing.
- **What is lost**: no citations; they remain, compressed.
- **What is gained**: §2.2 reaches Baker/Chiu/Brodeur + gap faster.

**Intervention 6 — Add a horizon-opening sentence at the very end of Chapter 2** (R11 PARTIAL → PASS)

- Current last sentence: *"Chapter~\ref{Chapter4} organizes the results around those margins."*
- Suggested direction: keep the pointer and add one sentence that frames the reanalysis enterprise as a method — e.g., *"The exercise this paper performs in health economics can, in principle, be repeated in any applied subfield where DiD is the workhorse design; Chapter 5 returns to that question."*

#### 3.3.5. Structural options considered and rejected

- **Option A**: reorganize §2.1 by the design margins of Ch 4 rather than by econometric categories. **Not adopted**. Worth revisiting only if Ch 4 is consolidated to 6 Lessons.
- **Option C**: move §2.2.1 (the gap) to the start of the chapter. **Not adopted**. Would subvert the lit-review convention. Intervention 1 captures ~80% of the benefit without this cost.

#### 3.3.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Rewrite first paragraph (health-specific tension) | 30 min | R1 PARTIAL → PASS |
| 2 | Add 4 transition sentences between §2.1.X subsections | 30 min | R5 PARTIAL → PASS |
| 3 | Add R4 confrontational openings to §2.1.1, §2.1.2, §2.1.3 | 60 min | R4 PARTIAL → PASS |
| 4 | Add preview-of-finding sentences to §2.1.1 and §2.1.3 | 20 min | R2 PARTIAL → PASS |
| 5 | Rewrite Baker/Chiu/Brodeur as ladder | 45 min | Structure of §2.2 |
| 6 | Compress psychology paragraphs (Option B) | 20 min | §2.2 economy of attention |
| 7 | Add one horizon sentence at chapter end | 10 min | R11 PARTIAL → PASS |

**Total**: ~3.5 hours. **Result**: 8 PASS / 1 PARTIAL / 0 MISS (excluding R6/R10 N/A). Chapter 2 moves from MIXED to **STRONG**.

---

### 3.4. Chapter 3 — Empirical Design (`overleaf/Chapters/Chapter3.tex`)

#### 3.4.1. Rule-by-rule verdict

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes | **MISS** | Opens *"The reanalysis draws on health-economics articles published between 2000 and 2025…"* — pure procedural |
| R2 Preview | **PARTIAL** | The AI-pipeline calibration is described but its success criterion (match the manual benchmark) is buried inline |
| R3 Named assumptions | **MISS** | The commented-out §3.2 *would* have named two assumptions (representativeness, estimator recovery). Currently compiled chapter has none. |
| R4 Challenge conventional wisdom | **MISS** | No confrontational move |
| R5 Natural-question transitions | **PARTIAL** | §3.3 → §3.4 has a transition (*"requires a separate protocol, described next"*). §3.1 → §3.3 does not. |
| R6 Figure captions | **PARTIAL** | Figure 3.1 caption *"Calibration and expansion workflow for AI-assisted reanalysis"* is descriptive; does not carry a conclusion |
| R7 Calibrated claims | **PASS** | 8,171 → 1,884 → 431 → 53 pipeline is exemplary; 10 calibration + 43 new |
| R8 Epistemic honesty | **PASS** | *"We do not audit the authors' code line by line"* and fallback-when-covariates-can't-match admissions are honest |
| R9 Explicit scope | **MISS** | The scope/identification section is commented out in the source (lines 38-89). The compiled chapter has no explicit scope statement. |
| R10 Artifact | **N/A** | not the natural chapter |
| R11 Forward-looking | **N/A** | methods chapter register |

**Score**: 3 PASS / 2 PARTIAL / 4 MISS / 2 N/A. **Lowest-scoring chapter of the dissertation**.

#### 3.4.2. Specific problems

1. **Opens procedurally**. *"The reanalysis draws on health-economics articles published between 2000 and 2025 in 17 general-interest and field journals"* — correct but inert. A reader with no prior investment in the project has no reason to continue.
2. **The identification section is commented out** (lines 38-89). The source contains a well-written section on the meta-statistic's representativeness assumption, monotone-selection bounds in the Manski sense, and a selection-bounds table (2.5%-99.8% Manski range, tightening to ≤88.7% under Manski-Pepper). This section is currently hidden behind `\begin{comment}...\end{comment}`. The compiled chapter consequently has no identification discussion, no named assumptions, no scope paragraph, and no Manski bounds.
3. **The two implicit assumptions of the meta-statistic are un-named**. (i) The 53-paper sample is informative about the Step-2 candidate pool along the design margins that drive TWFE-vs-modern divergence. (ii) The AI-assisted protocol recovers the modern estimator the original authors would have selected. Neither is given a memorable name.
4. **§3.1 → §3.3 transition is missing**. §3.1 ends on Table 3.2 (sample detailed); §3.3 (Estimators and coverage) opens on *"We re-estimate each article's main specification with different econometric tools"* — no bridge.
5. **Figure 3.1 caption does not carry conclusion**. Current caption: *"Calibration and expansion workflow for AI-assisted reanalysis"*. The figure is one of the dissertation's most original contributions — the manual-then-automated-with-audit architecture — and the caption does not say so.
6. **"Xu-Yang 2026" and "Korinek 2023" are cited but under-exploited**. The chapter situates its AI-pipeline in the emerging genAI-for-economics literature but does not claim that situating as a contribution. The audit agents, reviewer agents, and skeptic orchestration are not advertised.

#### 3.4.3. What to preserve

- **Table 3.1 (sample pipeline)** — exemplary R7; preserve verbatim.
- **Selection hierarchy paragraph** (*"We first prioritize specifications the authors describe as main, preferred, or baseline… If a tie remains, we apply three tie-breakers in sequence"*) — documented decision protocol; keep.
- ***"We do not audit the authors' code line by line"*** — exemplary honesty; keep.
- **Figure 3.1 diagram** — the tikz workflow is clear; only the caption and position need work.
- **Footnote listing implementation problems** (*"Stata date encodings, missing standard errors in plotting routines, silent dropping of event-time horizons, singular matrices in small-cohort CS-DID estimation, and differences in event-study aggregation across software"*) — gold for credibility; promote upward or keep.
- **Calibration-on-10 + expansion-to-43 architecture** — the methodological backbone; keep.
- **The commented-out §3.2 and selection-bounds table** — do not discard. See Intervention 2 below.

#### 3.4.4. Interventions

**Intervention 1 — Rewrite §3.1 opening with a stakes + preview move** (R1 MISS → PASS)

- Direction: first paragraph sets up the triple constraint the protocol must resolve: *"53 heterogeneous replication packages, one common estimator menu, one comparable sample-of-estimates. No existing pipeline executes all three at once. This chapter describes how we did it."* This frames the methods chapter as solving a real problem, not just describing a procedure.
- Exemplar: MSSU23 §4 opening (*"This section presents a more detailed analysis of our DR estimator for the average treatment effect on the treated (ATT) in DiD setups with potentially weak covariate overlap. Our emphasis on DiD setups is motivated by their widespread empirical usage"*) — states the problem the section is solving before describing the solution.

**Intervention 2 — Restore the identification/scope section** (R3 + R9 MISS → PASS)

This is the single largest intervention in Ch 3. The commented-out §3.2 is too long for the compiled text (it takes 50+ lines with a Manski-bounds table), but its content is exactly what R3 and R9 need.

- Direction: revive §3.2 but compress to a page. Keep the named assumption structure:
  - **Assumption 1 (Sample Representativeness)**: the 53-paper sample is informative about the larger Step-2 candidate pool along the design margins that drive TWFE-vs-modern divergence. State formally + one-paragraph interpretation + state that Table `selection_balance` partially tests this.
  - **Assumption 2 (Estimator Recovery)**: the AI-assisted protocol recovers the modern estimator the original authors would have selected. State formally + one-paragraph interpretation + state that the ten calibration articles validate *execution fidelity*, not *counterfactual estimator choice*.
- Drop or compress the Manski-bounds table. Keep the bound `π ≤ 88.7%` (Manski-Pepper monotone selection) as one sentence in the body. The table can move to Appendix D.
- Exemplar: OS25 §2.2 — Assumptions SO, NA, DDD-CPT are stated formally, then each gets a paragraph of plain-English unpacking.

**Intervention 3 — Name the two meta-statistic assumptions prominently** (R3 MISS → PASS)

- Use the names "Sample Representativeness" and "Estimator Recovery" repeatedly across the dissertation. They become searchable; the reader can return to them by name.

**Intervention 4 — Add §3.1 → §3.3 transition** (R5 PARTIAL → PASS)

- End of §3.1 currently: *"Appendix~\ref{AppendixB} lists the reanalyzed studies."*
- Proposed addition: *"Sample defined, the next question is what we re-estimate on it and which estimators are comparable across designs. §3.3 specifies the estimator menu and reports coverage."*

**Intervention 5 — Promote the AI-pipeline as an infrastructural contribution** (R4 + artifact dimension)

- §3.4 currently reads as documentation. Rewrite the opening to frame it as a *claim*: *"Reanalyzing 53 articles under a common protocol is not a trivial engineering problem. The standard approach — re-estimating each paper by hand — does not scale and does not produce comparable outputs. We solve this with a manual-calibrate-then-automated-expand architecture with continuous audit. The architecture itself is a contribution of this dissertation."*
- Exemplar: OS25 §7 conclusion line on the R package as a durable artefact.

**Intervention 6 — Rewrite Figure 3.1 caption** (R6 PARTIAL → PASS)

- Current caption: *"Calibration and expansion workflow for AI-assisted reanalysis"*.
- Suggested direction: *"The pipeline calibrates on 10 hand-coded articles, then runs on 43 new articles under the same fixed estimation template. Mismatches between manual and automated outputs feed back into protocol revisions; matches release articles into the audited corpus."* Then the technical notes.

**Intervention 7 — Advertise the audit/agents infrastructure** (structural)

- Direction: add a short paragraph (3-4 sentences) noting that the audit layer (24 checks, per-article reviewer agents, skeptic orchestration) is what makes the 53-paper exercise trustworthy. This is the component most differentiated from prior reanalysis literature and is currently under-announced.
- Where: either near end of §3.4, or as a closing paragraph of Ch 3.

#### 3.4.5. Structural options considered

- **Option: merge §3.3 and §3.4** (estimators + protocol). Rejected. The two are logically sequential: estimator menu is *what* we compute; protocol is *how* we compute it. Merging muddles that.
- **Option: drop the Xu-Yang and Korinek citations**. Rejected. They position the AI pipeline in an intellectual lineage that makes the infrastructural contribution legible.
- **Option: move selection-bounds table to appendix**. **Accepted** as part of Intervention 2. Body carries the one-sentence Manski-Pepper bound; appendix carries the table.

#### 3.4.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Rewrite §3.1 opening (stakes) | 30 min | R1 MISS → PASS |
| 2 | Restore + compress identification section (named assumptions) | 90 min | R3 + R9 MISS → PASS |
| 3 | Name the two assumptions consistently across the chapter | 20 min | R3 completion |
| 4 | Add §3.1 → §3.3 transition | 10 min | R5 PARTIAL → PASS |
| 5 | Rewrite §3.4 opening as architectural claim | 30 min | R4 MISS → PASS |
| 6 | Rewrite Figure 3.1 caption | 15 min | R6 PARTIAL → PASS |
| 7 | Add audit/agents paragraph | 30 min | infrastructural promotion |

**Total**: ~4 hours. **Result**: 8 PASS / 1 PARTIAL / 0 MISS (excluding R10/R11 N/A). Chapter 3 moves from MIXED to **STRONG**. Of all six chapters, this is the one where the audit identifies the largest structural gap (the commented-out identification section) — fixing it alone closes two MISS verdicts.

---

### 3.5. Chapter 4 — Lessons (`overleaf/Chapters/Chapter4.tex`)

*The chapter that carries the dissertation's empirical content. Largest audit, largest intervention, largest potential payoff.*

#### 3.5.1. Rule-by-rule verdict (chapter-level)

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes (chapter-level) | **MISS** | Chapter opens directly into Lesson 1; no overture |
| R2 Preview | **PARTIAL** | L1 previews aggregate; individual Lessons open with finding but not with surprise |
| R3 Named assumptions | **N/A** | empirical register |
| R4 Challenge conventional wisdom | **PARTIAL** | L7 and L10 open with R4; L1, L3, L4, L5, L6, L8, L9 do not |
| R5 Natural-question transitions | **MISS** | Lessons are juxtaposed; most end at their own finding without handing a baton |
| R6 Figure captions | **PARTIAL** | Most describe plot; L5 panel caption (*"The panels report…"*) is especially weak |
| R7 Calibrated claims | **PASS** | Numbers are everywhere; 34% TWFE weight in Maclean, 16/21 articles move >20% in progbin, etc. |
| R8 Epistemic honesty | **PARTIAL** | Chapter shows where modern estimators *win*; rarely where they *lose* |
| R9 Explicit scope | **PARTIAL** | Each Lesson has a "the implication is narrow" moment; no chapter-level scope |
| R10 Artifact | **PASS** | Box 4.1 checklist + Box 4.2 decision tree are prominently featured |
| R11 Forward-looking | **PARTIAL** | Applied guide opens doors; chapter does not close on horizon |

**Score**: 3 PASS / 6 PARTIAL / 2 MISS / 1 N/A.

#### 3.5.2. Lesson-by-Lesson problem diagnosis

| Lesson | Opening register | Transition into next | R6 caption |
|---|---|---|---|
| **L1** (directional stability) | Finding, not confrontation: *"Replacing TWFE with modern DiD estimators usually preserves the direction…"* | Does not hand baton to L2 | Figures 4.1 and 4.2 captions technical |
| **L2** (staggered) | Finding: *"The sharpest disagreements between TWFE and modern DiD estimators arise in staggered-adoption designs"* | Does not hand baton to L3 | Maclean caption descriptive |
| **L3** (covariates) | Finding: *"A meaningful part of the TWFE–CS-DID gap in this sample runs through covariate handling"* | Does not hand baton to L4 | Hoynes figure caption descriptive |
| **L4** (geographic) | Finding: *"Geographic conditioning opens a distinct margin of sensitivity…"* | Does not hand baton to L5 | Graduated-sensitivity caption partially conclusive (*"FAILURE"* label) |
| **L5** (dynamics) | Finding: *"Dynamic reanalysis often leaves the short-run direction of the result intact…"* | Does not hand baton to L6 | 6-case panel caption weak (*"The panels report…"*) |
| **L6** (binning) | Stronger opening with contamination framing | Does not hand baton to L7 | Lawler-Yewell caption partially informative |
| **L7** (PT sensitivity) | **R4 PASS**: *"Switching from TWFE to a heterogeneity-robust estimator can improve the mapping… It does not, by itself, make the identifying counterfactual more credible"* | Does not hand baton to L8 | No figures (table-only Lesson) |
| **L8** (control choice) | Finding: *"In staggered-adoption designs, the control group is not a secondary implementation choice"* | Does not hand baton to L9 | NT/NYT caption partially informative |
| **L9** (aggregation) | Finding: *"In CS-DID, the comparison with TWFE depends not only on the underlying ATT(g,t) structure…"* | Does not hand baton to L10 | No figures (table-only) |
| **L10** (software) | **R4 PASS**: *"Software choices can matter even when the estimator does not change"* | Does not hand baton to applied guide | Li (2025) caption partially informative |

**Summary**: 8 of 10 Lessons open with finding not confrontation; 10 of 10 lack inter-Lesson transitions; 8 of 10 figure captions are descriptive rather than conclusive.

#### 3.5.3. What to preserve

**All prose, all tables, all figures, all boxes**. Consolidation is structural (re-heading), not deletion. Specifically:

- Every case-study paragraph (Maclean, Hoynes, Lawler & Yewell, Dranove, Carpenter, Sarmiento, Li) — these are the dissertation's empirical backbone.
- All tables (4.1 aggregate concordance, 4.2 timing heterogeneity, 4.3 Bacon summary, 4.4 progbin, 4.5 HonestDiD, 4.6 aggte comparison, covariate coverage) — content preserved; only position changes if Lessons are consolidated.
- All figures (aggregate scatter, Bacon+dCdH Maclean, density_covariates, csdid_controls_133, graduated_sensitivity, six-case event study, panel_binning_76, NT/NYT, Li sensitivity).
- **L7 opening sentence**: *"Switching from TWFE to a heterogeneity-robust estimator can improve the mapping between the estimate and the causal parameter. It does not, by itself, make the identifying counterfactual more credible."* — exemplary R4; use as internal model for other Lessons.
- **L10 opening sentence**: *"Software choices can matter even when the estimator does not change."* — exemplary R4; keep.
- **Box 4.1 (checklist)** and **Box 4.2 (decision tree)** — preserve verbatim; structure and content both correct.
- **The "Taken together" / "The implication is practical" summary paragraphs at Lesson ends** — all correctly calibrated; preserve.

#### 3.5.4. Interventions

**Intervention 1 — Add a chapter overture** (R1 chapter-level MISS → PASS)

- New paragraph of ~180 words before L1 that does the work §3 of OS25 does:
  - Frame the chapter as argument, not list.
  - Announce each Lesson as a *design margin*.
  - Announce the order (aggregate → staggered → covariates → dynamics → PT credibility → implementation → honesty → guide).
  - Announce the checklist and decision tree as the destination.
- Exemplar: OS25 §3 opens *"Before presenting our formal results, we challenge some standard empirical practices and highlight important practical takeaways from our paper."* — explicit argumentative framing.

**Intervention 2 — Rewrite the opening sentence of every Lesson in R4 register** (R4 PARTIAL → PASS)

Each Lesson opens with *"common reading/practice/belief is X — we show Y"*. Specific directions:

- **L1 opening**: *"The common reading is that sign preservation saves the TWFE result. We show that reading is incomplete: 39.6% of cases shift magnitude enough to change the cost-effectiveness recommendation for the median paper."*
- **L2 opening**: *"The modern critique of TWFE is often read as a critique about negative weights. In this sample it is not: negative weights appear in 21 of 27 staggered articles but their mean share is 6.4%. What produces disagreement is aggregation structure and control-group choice."*
- **L3 opening**: *"A common practice is to add covariates to a TWFE regression and interpret the coefficient as 'conditional on observables'. In the CS-DID protocol that step does not only change precision — it changes the identifying comparison."*
- **L4 opening** (if retained as standalone — otherwise folded into L3): *"A common refinement is to condition on region or state to strengthen design credibility. We show that finer geographic conditioning can trade identification for support, not strengthen one without costing the other."*
- **L5 opening**: *"A common practice is to collapse the event study into a single post-treatment dummy. We show that aggregation hides three distinct empirical patterns: stability in some cases, control-group sensitivity in others, and persistence reversals in a third group."*
- **L6 opening** (preserve current opening; already half-confrontational): *"Long-horizon coefficients are often the least credible part of a dynamic DiD design."* Extend with preview: *"In 16 of 21 papers, the far-post coefficient moves by more than 20% under progressive-binning exercises."*
- **L7 (current)**: preserve.
- **L8 opening**: *"A common practice is to run CS-DID under one control-group choice — usually never-treated — and treat the other as a robustness check. In staggered designs that ordering is backward: the control group belongs to identification, not to robustness."*
- **L9 opening**: *"A common reading is that the choice between group, simple, and dynamic aggregation is a display convention. We show it is part of the estimand: the choice can move the TWFE-vs-CS-DID classification of the same article."*
- **L10 (current)**: preserve.

**Intervention 3 — Add natural-question transitions between Lessons** (R5 MISS → PASS)

One closing sentence per Lesson that hands the baton. Examples:
- End of L1: *"Where does this magnitude instability concentrate? Lesson 2 shows it clusters in staggered designs."*
- End of L2: *"If staggered designs are the source of the disagreement, the next question is whether the covariate margin compounds or dampens it. Lesson 3 examines that question."*
- End of L3: *"Among covariate choices, geographic conditioning has a distinct profile that deserves separate treatment. Lesson 4 documents it."* *(Only if L4 remains standalone.)*
- End of L4/L5: *"With static margins clarified, the dynamic profile raises its own questions. Lesson 5 addresses them."*
- End of L5: *"Dynamic profiles diverge most visibly at long horizons. Lesson 6 examines why."*
- End of L6: *"Sharper estimands clarify aggregation; they do not by themselves clarify parallel trends. Lesson 7 separates the two."*
- End of L7: *"Even once the estimator and the identifying assumption are defended, the choice of control group remains. Lesson 8 treats it as part of identification."*
- End of L8: *"Inside the modern estimator, the aggregation rule is the next implementation choice. Lesson 9 documents it."*
- End of L9: *"Beyond aggregation, software defaults can change the sample itself. Lesson 10 documents one such case."*
- End of L10: *"The ten margins above do not cover every case. Lesson 7 [the new honesty Lesson] discusses when even modern estimators leave the applied researcher worse off."*

If Lessons are consolidated to 6 (see §2), the transitions reduce to six.

**Intervention 4 — Consolidate 10 Lessons into 6 + new L7 honesty** (structural, per §2)

- Merge current L2 + L8 into new L2 (aggregation + control choice in staggered).
- Merge current L3 + L4 into new L3 (covariates, with geographic as §X.Y subsection).
- Merge current L5 + L6 into new L4 (dynamic margins, combined).
- Merge current L9 + L10 into new L6 (implementation).
- Keep current L7 as new L5.
- Keep current L1 as new L1.
- **Add new L7: "When modern estimators do not help"** (see Intervention 5).

**Intervention 5 — Write new L7 "When modern estimators do not help"** (R8 PARTIAL → PASS at chapter level)

- Content candidates:
  - **Pattern 42** (DR propensity collapse to zero under weak overlap). Cite one paper from the sample where this happens.
  - **Kresch-style sample mismatch** between TWFE and CS-DID branches. Cite the specific paper where Pattern 50 was discovered.
  - **CI widening**: count how many papers have CS-DID SE > 1.5 × TWFE SE; provide the median widening factor.
  - **Sign ambiguity under CS-DID**: papers where TWFE had statistical significance but CS-DID loses precision without changing sign — cost of interpretability is lost power.
- Length: 2-3 pages. Central case: one paper where TWFE had significance but CS-DID loses it without sign reversal.
- Closing direction: *"Modern estimators are not a free correction. In designs with weak overlap, small samples, or high-dimensional covariates, the price of clarifying the estimand can be a substantial loss of precision. The gain in interpretability is real, but it is honest to price the trade-off."*
- Exemplar: MSSU23 §5 DGP3 — the proposed method loses in bias but gains in SD/RMSE; the authors declare the loss in one sentence.

**Intervention 6 — Rewrite five priority figure captions** (R6 PARTIAL → PASS)

Each caption becomes two parts: (i) one-sentence conclusion; (ii) technical notes.

1. **Figure 4.1 (aggregate variation)** — direction: *"The proportional change (\(\hat\beta_{CS}-\hat\beta_{TWFE})/|\hat\beta_{TWFE}|\) centers on zero, but the tails are long: 21 articles move by more than 50% in magnitude, enough to change the cost-effectiveness recommendation for the median paper."*
2. **Figure 4.2 (aggregate scatter)** — direction: *"Most estimates cluster near the 45-degree line, but the cloud is not tight. A sizeable share moves enough to change statistical precision or materially alter the implied effect size, even when the sign is preserved."*
3. **Bacon + dCdH Maclean** — direction: *"A single cohort whose treatment activates in 2020 absorbs 34% of the TWFE weight and produces a positive 2×2 ATT (+10.1); CS-DID distributes weight more evenly and recovers the negative pattern of the remaining cohorts. The sign reversal does not come from negative weights — zero negative cells in 484 — it comes from the aggregation rule interacting with the COVID-19 shock."*
4. **Six-case event-study panel** — direction: *"The six panels show that dynamic reanalysis can leave the headline sign unchanged and still alter persistence, control-group sensitivity, and the reading of pre-treatment dynamics. The panels report Dranove (stable), Carpenter (control-group sensitive), Lawler & Yewell (persistence weakens), Bosch (long-run diverges), Cao (long-run intensifies), and Brodeur (shared credibility concern)."*
5. **Lawler & Yewell binning panel** — direction: *"The far-post coefficient rises from +0.032 (unbinned) to +0.047 when the endpoint bin absorbs horizons 4 through 16, demonstrating that 45% of the apparent persistence comes from the binning rule itself rather than from horizon-specific evidence."*

**Intervention 7 — Promote the applied-guide section** (structural)

- Rename *"Toward an applied guide to DiD"* → *"A pre-submission checklist and a design-triage decision tree"* (concrete > abstract).
- Open the section with: *"From the six empirical margins documented above, we distill two practical artefacts..."*
- Close the chapter pointing back to the checklist: *"Each checklist item is traceable to one of the six Lessons; the italicised cross-references in Box 4.1 indicate which."*

**Intervention 8 — Add a horizon-opening closing sentence to Chapter 4** (R11 PARTIAL → PASS)

- Current chapter ends with Box 4.2 content (*"the primary result should come from the modern specification that best aligns the causal target, the identifying comparison, and the available support"*).
- Add one sentence after Box 4.2 that points forward: *"The next chapter places these lessons in their sample and disciplinary context and identifies the extensions where the same protocol should be applied."*

#### 3.5.5. Structural options considered

- **Option: keep 10 Lessons but add the R4 openings without merging**. Possible. Trades a cleaner argument arc for preservation of the existing numbering. **Recommendation: merge (as per §2)**, because inter-Lesson transitions become forced when two Lessons cover the same margin.
- **Option: L7 honesty as a Chapter 5 subsection instead of a Lesson**. Rejected. Ch 4's arc is stronger if honesty is inside the argument, not a defensive footnote.
- **Option: split L2 further into "aggregation" and "cohort weighting" sub-Lessons**. Rejected. Would undo the consolidation.
- **Option: move the checklist + decision tree into Chapter 5**. Rejected. They are the chapter's deliverable and belong where the empirical patterns supporting them are fresh in the reader's memory.

#### 3.5.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Add chapter overture (before L1) | 45 min | R1 MISS → PASS (chapter-level) |
| 2 | Rewrite opening sentence of each Lesson (10 or 6) | 60-90 min | R4 PARTIAL → PASS |
| 3 | Add natural-question transitions between Lessons | 45 min | R5 MISS → PASS |
| 4 | Consolidate 10 → 6 Lessons (Wave 2 structural) | 1 day | §2 structural proposal |
| 5 | Write new L7 "When modern estimators do not help" | 1 day | R8 PARTIAL → PASS (chapter-level) |
| 6 | Rewrite 5 priority figure captions | 45 min | R6 PARTIAL → PASS |
| 7 | Rename + reopen applied-guide section | 20 min | R10 polishing |
| 8 | Add chapter-ending horizon sentence | 10 min | R11 PARTIAL → PASS |

**Total Wave 1 only (items 1, 2, 3, 6, 7, 8)**: ~4 hours. Wave 1 alone moves chapter to 7 PASS / 3 PARTIAL / 0 MISS.

**Total Wave 1 + Wave 2 (items 4 and 5 added)**: ~6 hours Wave 1 + 2 days Wave 2 = 2.5 days. Result: 9 PASS / 1 PARTIAL / 0 MISS — **STRONG**.

---

### 3.6. Chapter 5 — Conclusion (`overleaf/Chapters/Chapter5.tex`)

#### 3.6.1. Rule-by-rule verdict

| Rule | Verdict | Note |
|---|---|---|
| R1 Stakes | **PARTIAL** | Opens *"This paper reassessed 53 health-economics studies under a common replication and re-estimation protocol"* — procedural; could reopen with stakes |
| R2 Preview | **N/A** | conclusion register |
| R3 Named assumptions | **N/A** | conclusion register |
| R4 Challenge conventional wisdom | **PARTIAL** | *"disagreement is not driven mainly by negative weights"* is the move; present but soft |
| R5 Natural-question transitions | **N/A** | single chapter |
| R6 Figure captions | **N/A** | no figures |
| R7 Calibrated claims | **PASS** | (where used) |
| R8 Epistemic honesty | **PASS** | Paragraph 4 (*"The exercise has clear limits"*) is exemplary |
| R9 Explicit scope | **PASS** | Paragraph 4 is also a scope statement |
| R10 Artifact | **PASS** | Paragraph 3 explicitly names Box 4.1 and Box 4.2 |
| R11 Forward-looking | **PARTIAL** | Paragraph 5 names extensions but in a single sentence; does not frame them as an agenda the reader can pursue |

**Score**: 3 PASS / 3 PARTIAL / 0 MISS / 5 N/A.

**Narrative verdict**: the chapter is **stronger than initially feared**. R8, R9, R10 are all PASS — a rare combination. What holds it back is the procedural opening and a closing that lists extensions rather than framing an agenda.

#### 3.6.2. Specific problems

1. **Opens procedurally**. *"This paper reassessed 53 health-economics studies under a common replication and re-estimation protocol to examine how conclusions change when TWFE is replaced by modern DiD estimators."* — correct description, zero narrative pull. A conclusion should reopen the stake, not describe the procedure.
2. **Estimator-side limits are absent**. Paragraph 4 (limits) covers sample limits, replication-package limits, field concentration, R-implementation adaptations. It does not cover the limits of modern estimators themselves — DR collapse, wider CIs, loss of power in thin-overlap designs. The chapter preaches modern estimators but does not acknowledge their costs.
3. **Forward paragraph lists instead of framing**. Paragraph 5: *"continuous- or multi-valued-treatment designs, triple-difference designs, and non-absorbing treatments"* — three extensions in one sentence, no elaboration, no framing as a research agenda. Compare to OS25 §7 which names five extensions and gives each a sentence.
4. **Final sentence is a restatement, not a horizon**. *"Extending the protocol to those designs would show which conclusions remain stable once those margins are made explicit and which weaken under a more transparent mapping between design and estimand."* — restates the dissertation's thesis in extension-form. Does not open a door the reader can walk through.

#### 3.6.3. What to preserve

- **Paragraph 1, second half** (*"In this sample, instability appears less often as sign reversal and more often as changes in magnitude, weaker dynamic profiles, loss of precision, and greater sensitivity to design choices than the original articles suggested"*) — gold. Keep verbatim.
- **Paragraph 2 in entirety** — the comparative-and-empirical framing (*"The main contribution is empirical and comparative. By re-estimating a defined applied literature under a common protocol…"*) is one of the strongest paragraphs in the dissertation.
- **Paragraph 3 in entirety** — the promotion of Box 4.1 and Box 4.2 with explicit numbers; the sentence *"Their purpose is not to replace design reasoning. Their purpose is to help researchers state the estimand clearly…"* is correctly calibrated.
- **Paragraph 4 in entirety** — the limits paragraph is correct register, correct placement.
- **Paragraph 5 substance**: the identification of continuous/multi-valued, triple-difference, non-absorbing as the three natural extensions is right; the problem is format, not content.

#### 3.6.4. Interventions

**Intervention 1 — Rewrite opening with stakes** (R1 PARTIAL → PASS)

- Direction: first sentence reopens the stake. *"Health-policy decisions in the United States rest on DiD estimates whose magnitude — not only whose sign — enters welfare calculations. This paper asked how stable those magnitudes are under modern DiD estimators."*
- Exemplar: MSSU23 §6 opening — reopens with the high-level framing before summarizing the specific contribution.

**Intervention 2 — Add one sentence on estimator-side limits to paragraph 4** (R8 supplement)

- Direction: after the current sample-scope limits, add *"Beyond sample scope, modern estimators have their own limits. In designs with weak overlap, small samples, or high-dimensional covariates, they clarify the estimand but may reduce precision — a trade-off quantified in Lesson 7 and discussed in Appendix C."*
- This supports the Wave 2 L7 "When modern estimators do not help" section; even without L7, the sentence alone strengthens R8.

**Intervention 3 — Expand paragraph 5 into three concrete avenues** (R11 PARTIAL → PASS)

- Direction: replace the one-sentence list with three paragraphs (or one paragraph with three sub-moves), each naming an extension and why:
  - *"A natural next step is triple-difference (DDD) designs. \textcite{ortiz2025triple} provide a forward-engineered toolkit for DDD estimation; applying it to health settings with eligibility or geographic partitions (tuition aid, Medicaid expansions interacted with income bands) would allow the same decomposition-by-design-margin exercise in a richer identifying structure."*
  - *"A second extension is non-absorbing treatments. \textcite{dechaisemartin2020twfe,dechaisemartin2024difference} handle policy on/off dynamics that the current sample excludes by construction; they are the natural instrument for revisiting health-policy studies where the treatment is reversible (e.g., temporary Medicaid expansions, short-duration mandates)."*
  - *"A third extension is designs with compositional change. \textcite{sant2026difference} handle the case where the composition of treated units shifts over time; this applies to many health-policy studies where eligibility rules evolve during the study window."*
- Exemplar: OS25 §7 — five avenues, each one sentence.

**Intervention 4 — Rewrite final sentence as a horizon** (R11 completion)

- Direction: replace the current extension-restatement with a sentence that frames the reanalysis enterprise as a reusable method. Candidate direction: *"The reanalysis of a literature is a pointed intervention; what this exercise hopes to leave behind is a more demanding discipline of design justification — auditable, comparable, and applicable to any DiD literature prepared to reexecute the question."*
- Exemplar: OS25 §7 final sentence.

#### 3.6.5. Structural options considered

- **Option: move the L7 honesty content from Ch 4 to Ch 5 as a limits subsection**. Rejected. Ch 5 is the chapter for *sample* limits; estimator-side limits earn more weight inside the argument of Ch 4.
- **Option: add a "what the reader should do on Monday" paragraph**. Rejected. That is already done by Paragraph 3 (checklist + decision tree). Adding another is redundant.
- **Option: rename Ch 5 from "Conclusion" to "Closing"**. Cosmetic; rejected.

#### 3.6.6. Order of execution

| # | Intervention | Time | Rules moved |
|---|---|---|---|
| 1 | Rewrite opening with stakes | 20 min | R1 PARTIAL → PASS |
| 2 | Add one sentence on estimator-side limits | 10 min | R8 supplement |
| 3 | Expand paragraph 5 into three concrete avenues | 45 min | R11 PARTIAL → PASS |
| 4 | Rewrite final sentence as a horizon | 15 min | R11 completion |

**Total**: ~1.5 hours. **Result**: 5 PASS / 1 PARTIAL / 0 MISS / 5 N/A. Chapter 5 moves from MIXED-STRONG to **STRONG**.

---

## 4. Cross-cutting recommendations

### 4.1. Adopt a rhetorical frame: *reanalysis as forward-engineering*

Baker et al. (2025) use the phrase *"forward-engineering"* to describe building the estimator from the identification assumptions forward. This dissertation's premise can be stated as: *we ask whether the applied literature has forward-engineered its DiD estimates, and, where it has not, we show what changes*. A one-paragraph adoption in Chapter 1 or 2 gives the dissertation a slogan a reader can cite.

### 4.2. Named comparators

MSSU23 uses *CON* (conventional) vs *NEW* (proposed); OS25 uses *3WFE*, *Mundlak-based 3WFE*, *Difference of two DiDs*, *DR DDD*. The dissertation already uses *CS-NT* and *CS-NYT* in the right register — preserve. For the covariate decomposition, use descriptive labels in main-text prose (*matched*, *unconditional*, *legacy*, or equivalent).

**Do not promote "Spec A / Spec B / Spec C" from the codebase into the main text** (user decision, 2026-04-23). Those codenames stay in `results.csv`, agent outputs, and internal logs; main-text prose uses descriptive labels only.

### 4.3. Use one density-of-shifts figure as a standalone argument

OS25 Figure 1 is a standalone argument. The dissertation has the raw material — the distribution of \((ATT_{\text{modern}} - ATT_{\text{TWFE}})/SE_{\text{TWFE}}\) across the 53 articles, with vertical lines at zero and at the significance-change threshold. Making this *the* headline figure of Chapter 4 — and writing its caption as a conclusion — would give the dissertation a single image a reader remembers.

### 4.4. Add the "when modern estimators do not help" section

Addressed structurally in §2 as **new L7**. Single largest credibility gain available.

### 4.5. Add a "what this paper does not do" paragraph in Chapter 1

Addressed in §3.2 P6.

---

## 5. Appendix touch-ups

- **Appendix A (specification selection)**: add a box *"How the protocol selects the main spec"* with the 5 criteria of `SKILL_profiler.md` promoted to main text.
- **Appendix B (per-article cards)**: add a *"How to read a card"* box at the front — one annotated card with arrows explaining TWFE / CS-NT / CS-NYT / Bacon / HonestDiD / verdict. Cost: one page. Gain: Appendix B moves from archive to pleasant reading.
- **Appendix C (AI-assisted pipeline)**: promote the audit regime (24-check, reviewer agents, `skeptic` orchestration) as an infrastructural contribution. Most original component of the dissertation; currently under-announced. See §3.4 Intervention 7.
- **Appendix D (sample construction log)**: acceptable as is. Candidate for absorbing the Manski-Pepper selection-bounds table relocated from §3.4.
- **Appendix E (notation)**: already pruned; no change.

---

## 6. Order of execution (document-wide)

### Wave 1 — low-hanging edits (target: STRONG without structural change)

Ordered by chapter, not by time, so the user can work through the document linearly.

| Block | Chapter | Interventions | Time |
|---|---|---|---|
| A | Abstract | 5 interventions (§3.1.6) | 1 h |
| B | Chapter 1 | 6 interventions (§3.2.6) | 2.5 h |
| C | Chapter 2 | 7 interventions (§3.3.6) | 3.5 h |
| D | Chapter 3 | 7 interventions (§3.4.6) | 4 h |
| E | Chapter 4 Wave-1 items only | Overture + Lesson openings + transitions + 5 captions + applied-guide rename + horizon close (§3.5.6 items 1, 2, 3, 6, 7, 8) | 4 h |
| F | Chapter 5 | 4 interventions (§3.6.6) | 1.5 h |

**Wave 1 total**: **~16 hours** of writing. **Result expected**: STRONG across all units.

If the user prefers block-concurrent edits (rewrite all chapter openings in one sitting, then all Lesson openings, etc.), the order can be transposed:

| Block | Topic | Chapters affected | Time |
|---|---|---|---|
| α | Stakes rewrites of first sentences | Abstract, Ch 1, Ch 4 overture, Ch 5 | 1 h |
| β | R4 confrontational openings | Abstract surprise + Ch 1 P4 + Ch 2 §2.1.1-3 + Ch 4 Lesson openings | 3 h |
| γ | Natural-question transitions | Ch 2 §2.1 + Ch 3 + Ch 4 inter-Lesson | 2 h |
| δ | R6 caption rewrites | Ch 3 Fig 3.1 + Ch 4 × 5 | 1.5 h |
| ε | Scope + artefact promotions | Abstract + Ch 1 + Ch 3 named assumptions | 3 h |
| ζ | R11 horizon closes | Ch 2 + Ch 4 + Ch 5 | 1.5 h |
| η | Structural — ladder in Ch 2 §2.2, Option B | Ch 2 | 1.5 h |
| θ | Structural — restore Ch 3 identification section | Ch 3 | 1.5 h |

Total: same ~16 hours, different order.

### Wave 2 — structural consolidation (optional, higher ceiling)

| # | Intervention | Time |
|---|---|---|
| A | Consolidate Ch 4 L2+L8, L5+L6, L9+L10 → 6 Lessons | 1 day |
| B | Write new L7 "When modern estimators don't help" | 1 day |
| C | Density-of-shifts headline figure (§4.3) | half-day |
| D | "How to read a card" box in Appendix B | 2-3 h |
| E | Apply Option A to Ch 2 (reorganize §2.1 by design margins) | half-day, conditional on A |

Wave 2 totals ~3-4 days. Result: from *defensible reanalysis* to *definitive reference on where modern DiD helps and where it does not*.

---

## 7. What NOT to change

- **Numerical prose.** R7 is a real strength — keep the register (21 of 53 articles (39.6%), median 17.6% vs 64.7%, TvT share 34.9%, CS-DID at −15.27).
- **§2.1.4 (Covariates)** and **§2.2.1 (The gap)** in Chapter 2 — both are chapter's strongest subsections and serve as models for the others.
- **Per-article cards in Appendix B** — the durable artefact; replicates OS25's empirical-illustrations arc at scale. Only the introduction to the appendix changes (§5 above).
- **Auditability infrastructure** — failure-patterns file, 24-check audit, reviewer agents, skeptic orchestration. No econometrics paper the committee has read has this. Advertise it more; do not change it.
- **Chapter 5 limits paragraph** (*"The exercise has clear limits"*) — correct register, correct placement; only additions, no rewrites.
- **Footnote on net health benefit** (\(\text{NHB}(\lambda)=\Delta E-\Delta C/\lambda\)) — correct; promote upward to Ch 1 but do not rewrite content.
- **Tables 4.1, 4.2, 4.3** — content stays; only position changes if Lessons are consolidated.
- **Equations 2.1, 2.2, and the \(ATT(g,t)\) definition** in Chapter 2 — correct and compact.
- **Trade-off NT vs NYT in §2.1.2** — exemplary R8, preserve.
- **Three reasons health is a useful setting** in §2.2.1 — preserve verbatim.
- **L7 current opening sentence** (*"Switching from TWFE to a heterogeneity-robust estimator can improve the mapping… It does not, by itself, make the identifying counterfactual more credible"*) — exemplary R4; preserve and use as internal model.
- **L10 current opening sentence** (*"Software choices can matter even when the estimator does not change"*) — exemplary R4; preserve.
- **Sample-pipeline table in Ch 3** (Table 3.1, 8171 → 1884 → 431 → 53) — exemplary R7.
- ***"We do not audit the authors' code line by line"*** in Ch 3 — exemplary R8.
- **All `\input{Tables/*.tex}` commands** — tables are auto-generated; they migrate with the prose.

---

## 8. How to use this report

- This report is advisory. None of the proposed edits have been written into the `.tex` files; the prose remains the user's.
- To rerun this audit on a specific file after editing, invoke the `storyteller` agent with the absolute path to that file. The agent will score the eleven rules, propose quote-level edits, and return a rating — it will not rewrite.
- **Chapter-by-chapter implementation** begins from §3 of this report. Each chapter section has its own §X.X.6 order-of-execution table listing every intervention with its time budget and rule-impact.
- The user may choose **linear order** (block A → B → C → D → E → F: each chapter fully revised before moving on) or **concurrent order** (blocks α → β → γ → δ → ε → ζ → η → θ: one rhetorical move at a time across all chapters). Total time is the same (~16 hours Wave 1).
- If at any point the user wants edits applied directly rather than just diagnosed, instruct outside the `storyteller` agent — the agent is strictly read-only by design.

*End of consolidated audit.*
