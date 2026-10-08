# Chapter 25 — Pre-registration, Analysis Plans and Reporting Guidelines

> **Part V — From Plan to Paper**
> [← Chapter 24](24-neuroscience.md) · [Table of Contents](../README.md) · [Next: Chapter 26 — Capstone: The Design Clinic →](26-capstone-design-clinic.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Explain how undisclosed analytic flexibility inflates false positives.
2. Write a minimal **pre-registration** or **statistical analysis plan** (SAP).
3. Distinguish confirmatory from exploratory analyses — and report both honestly.
4. Choose the right **reporting guideline** for a study and use it as a design checklist.
5. Report estimates with uncertainty rather than significance alone.

---

## 🎯 The Big Picture

A design is not finished until the **analysis** is fixed. Every dataset allows many
defensible analyses: which outcome, which covariates, which exclusions, which transformation,
when to stop collecting. If these choices are made *after* seeing the data, almost any result
can be made significant ([Simmons et al., 2011](https://doi.org/10.1177/0956797611417632)). Before trial registration became routine, primary
outcomes in published trials frequently differed from those in the protocols ([Chan et al., 2004](https://doi.org/10.1001/jama.291.20.2457)).

Pre-specification closes this gap. It does not forbid exploration; it makes the
**difference between confirmation and exploration visible** ([Nosek et al., 2018](https://doi.org/10.1073/pnas.1708274114); [Munafò et al., 2017](https://doi.org/10.1038/s41562-016-0021)).

---

## 🧠 Core Intuition

### The garden of forking paths

![Garden of forking paths: several defensible analyses with different p-values](figures/diagrams/25-preregistration-and-reporting-bdf25218da.png)

Each path is defensible. Choosing the path *because* it gives *p* < 0.05 turns a 5% error
rate into something much larger.

![Chance of at least one significant result rising with the number of analyses tried](../assets/course/ch25-forking-paths.png)


### Tools for pre-specification

| Tool | Where | What it fixes |
|---|---|---|
| **Trial registration** | clinical trials (required) | primary outcome, design |
| **Protocol (SPIRIT)** | trials | full methods ([Chan et al., 2013](https://doi.org/10.1136/bmj.e7586)) |
| **Statistical analysis plan** | trials and large studies | models, covariates, missing data, multiplicity ([Gamble et al., 2017](https://doi.org/10.1001/jama.2017.18556)) |
| **Pre-registration** | any study (e.g. OSF, AsPredicted) | hypotheses, design, analysis |
| **Registered report** | journals | peer review *before* data collection; acceptance in principle |

### Confirmatory versus exploratory

Both are valuable. Problems arise only when exploratory results are **presented as**
confirmatory ("HARKing" — hypothesizing after the results are known). Label them clearly
and test exploratory findings in new data.

![The same analysis can be confirmatory or exploratory depending on when it was specified: a pre-registered primary outcome and model give an interpretable p-value, while analyses chosen after seeing the data are exploratory and need replication](figures/diagrams/25-preregistration-and-reporting-aabda550fd.png)

### Estimation over dichotomies

Report effect sizes with confidence intervals; treat *p*-values as continuous evidence and
avoid "significant/non-significant" as the conclusion ([Wasserstein & Lazar, 2016](https://doi.org/10.1080/00031305.2016.1154108); [Halsey et al., 2015](https://doi.org/10.1038/nmeth.3288); [Cumming et al., 2007](https://doi.org/10.1083/jcb.200611141)).
Absence of evidence is not evidence of absence ([Altman & Bland, 1995](https://doi.org/10.1136/bmj.311.7003.485)).

### Reporting guidelines are design checklists

Each item in ARRIVE, CONSORT, STROBE, MIQE, STORMS or TRIPOD+AI corresponds to a design
decision. Read the relevant one **before** the experiment — see
[Appendix C](A3-reporting-guidelines.md).

---

![Reporting guidelines matched to study types: CONSORT for randomized trials, STROBE for observational studies, ARRIVE for animal research, PRISMA for systematic reviews, MIQE for qPCR and STORMS for microbiome studies; reading them at the design stage prevents gaps](figures/diagrams/25-preregistration-and-reporting-db7b8edca9.png)

## 👁️ Visual Intuition — a minimal pre-registration

| Section | One or two sentences |
|---|---|
| Question & hypothesis | |
| Question type (Q1–Q8) | |
| Design (units, groups, blocks, randomization, blinding) | |
| Primary outcome (exact measure, time point) | |
| Sample size and justification | |
| Exclusion rules | |
| Analysis model (formula), multiplicity handling | |
| Secondary/exploratory analyses (labelled) | |

---

## 🔬 Worked Example — pre-registering the diet study from Chapter 8

| Section | Entry |
|---|---|
| **Hypothesis** | A high-fibre diet reduces liver fat in C57BL/6 mice fed a Western diet. |
| **Type** | Q2 comparative. |
| **Design** | Cage-fed diets: cage is the assignment unit, 2 same-sex littermates per cage. Each litter/sex block supplies cages for both diets; randomize cages within blocks. Diet bags coded; MRI analyst blinded. Report mice, cages and litters separately. |
| **Primary outcome** | Liver fat fraction (%) by MRI at week 12. |
| **Sample size** | Illustrative assumptions: Δ = 3 points, SD = 4, ICC = 0.05, 2 mice/cage, α = 0.05, power 80%. Independent size 29/arm × DE 1.05 → 16 analyzable cages/arm. For 10% whole-cage loss, allocate ceiling(16/0.90) = 18 cages/arm (36 mice). Verify with the planned blocked analysis and plausible ICCs before collection. |
| **Missing outcomes and welfare** | Humane endpoints follow the approved animal protocol; record removals and reasons by arm. Outcomes unavailable at week 12 are missing, not silently discarded. State the missing-data assumptions and sensitivity analyses; assess whether treatment-related removals change the target question. |
| **Analysis** | For this layout: `fat ~ diet + sex + factor(litter) + (1 \| cage)` with globally unique cage IDs; report diet contrast and 95% CI using a small-sample method. Inspect cage means as a sensitivity analysis. State missing-data handling before unblinding. |
| **Exploratory** | Diet × sex interaction; liver transcriptomics (labelled exploratory). |

The crucial step is to record **how diet is delivered**. Splitting littermates between
diets does not make mice independent when each diet is shared by a cage. If mice were
individually fed without interference, an individual-level blocked calculation could
apply. The numbers above illustrate allocation and attrition rounding, not validated power
for every blocked mixed model. Replace the assumed ICC/SD with justified values and
save the simulation or calculation before finalizing the protocol.

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Pre-registration stops me from exploring."** | It labels exploration; it doesn't forbid it. |
| **"I can't pre-register basic research."** | A one-page plan of hypothesis, outcome, *n* and analysis is possible for most confirmatory experiments. |
| **"Deviations ruin a pre-registration."** | Report them transparently with reasons; that is still far better than undisclosed flexibility. |
| **"Reporting guidelines are for the end."** | They are most useful at the start. |
| **"*p* = 0.06 means no effect."** | Report the estimate and CI. |

---

## 🧪 Spot the Flaw

> "We measured 12 behavioural outcomes. Anxiety in the elevated plus maze differed
> significantly (*p* = 0.02), confirming our hypothesis that the knockout increases anxiety.
> Two outlier mice were excluded because their values were implausible."

<details>
<summary>▶ Diagnosis</summary>

- **12 outcomes, 1 significant:** about what chance alone would produce at α = 0.05 (12 ×
  0.05 = 0.6 expected false positives). No primary outcome specified.
- **"Confirming our hypothesis"** — likely hypothesized after the result (HARKing).
- **Post hoc exclusion** of outliers, not by a pre-specified rule.
- **Fix:** pre-register a primary outcome and exclusion rules; correct for multiplicity or
  treat secondary outcomes as exploratory; report all 12 outcomes.
</details>

---

## 🔎 The Reviewer's Perspective

- **"Was there a registration or pre-specified plan, and do the paper and the plan match?"**
- **"Are exploratory analyses labelled as such?"**
- **"Are all outcomes reported?"**
- **"Is the relevant reporting guideline followed?"**

---

## 🛠️ Design Challenges

Three pre-specification problems: your own plan, a plan full of forking paths, and a
replication. For each, decide what must be fixed **before** the data exist — then open the
model answer and its diagram.

### Challenge 1 · Your project · ⭐ — a one-page pre-registration

Write a minimal pre-registration (the table above) for your own Design Card project.

<details>
<summary>▶ What a good one looks like</summary>

It fits on one page; another researcher could run the analysis from it without asking
you anything; the primary outcome is a single, precisely defined measure; the sample size
has all four ingredients (Chapter 8); exclusions are rules, not judgements; and the
analysis formula includes the blocks and the unit structure of the design.

![From Design Card to pre-registration: the question, unit, allocation, primary outcome, sample size, exclusion rules and analysis formula are written down and time-stamped before data collection; afterwards, confirmatory results follow the plan and anything else is labelled exploratory](figures/diagrams/25-preregistration-and-reporting-d25d562a2d.png)
</details>

### Challenge 2 · Behavioural neuroscience · ⭐⭐ — pruning the forking paths

A lab plans to test whether a probiotic reduces anxiety-like behaviour in mice. Their
draft: "We will record time in open arms, open-arm entries, total distance, time in centre
(open field), latency to feed and marble burying, and remove outliers as appropriate. We will
use a *t*-test or a Mann–Whitney test depending on the data, and may adjust for body weight."
List the forking paths and write the pre-specified version.

<details>
<summary>▶ A model answer</summary>

- **Forking paths:** 6 outcomes × outlier rules × test choice × with/without covariate —
  dozens of possible analyses, and any one "significant" result could be reported
  (Chapter 25).
- **Pre-specified version:**
  - **One primary outcome:** % time in open arms of the elevated plus maze (or a
    pre-defined composite of all tests, with its formula written down).
  - **Secondary outcomes** listed, with a multiplicity correction (e.g. Holm), and reported
    whatever their results.
  - **Exclusions as rules:** e.g. mouse falls off the maze, tracking fails for > 10% of the
    session — decided blind to group; no "outliers as appropriate".
  - **One analysis:** `open_time ~ cage_block + sex + group` as a linear model (or a mixed
    model with cage), with body weight **either** always or never included — decided now.
  - **Effect size with 95% CI** as the main result, not only a *p*-value.

![Garden of forking paths: six outcomes, flexible outlier removal, a choice between two tests and an optional covariate multiply into dozens of analyses; the pre-registered plan prunes them to one primary outcome, rule-based exclusions decided blind, one fixed model and labelled secondary outcomes with multiplicity correction](figures/diagrams/25-preregistration-and-reporting-aaa8dc9a6b.png)
</details>

### Challenge 3 · Replication · ⭐⭐⭐ — a registered report

A published study (*n* = 15 per group) reported a large effect, *d* = 0.8, of a training
intervention on a memory score. You want to replicate it as a **registered report**. How
large should the replication be, and how does the registered-report process protect it?

<details>
<summary>▶ A model answer</summary>

- **Do not power for d = 0.8.** Small published studies that cleared *p* < 0.05 tend to
  overestimate effects (the winner's curse, Chapter 24). Power for a smaller, still relevant
  effect, e.g. **half the original, d = 0.4**: `power.t.test(delta = 0.4, sd = 1, power = 0.9)`
  gives **≈ 133 per group**. Powering for d = 0.8 would give only ≈ 34 per group — likely to
  miss a real but smaller effect.
- **Registered report, Stage 1:** introduction, methods, sample size, analysis plan and
  criteria for interpreting the result are peer-reviewed **before data collection**; if
  accepted ("in-principle acceptance"), the journal commits to publish regardless of the
  outcome.
- **Stage 2:** data are collected and analysed as planned; deviations are reported; extra
  analyses are labelled exploratory.
- **Interpretation planned in advance:** e.g. an equivalence test to decide whether the
  effect is smaller than the smallest effect of interest, so a null result is informative.

![Registered report workflow: the replication is sized for half the original effect, giving about 133 per group; the Stage 1 protocol is peer reviewed before data collection and receives in-principle acceptance; data are then collected and analysed as planned and the Stage 2 paper is published whatever the result](figures/diagrams/25-preregistration-and-reporting-53ccf00a26.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** What is HARKing?

**⭐ Q2.** What is the difference between a pre-registration and a registered report?

**⭐⭐ Q3.** Why does undisclosed flexibility inflate false positives even when each choice is
reasonable?

**⭐⭐ Q4.** Which reporting guideline applies to (a) a mouse study, (b) a cohort study,
(c) a diagnostic test study, (d) an ML prediction model?

**⭐⭐⭐ Q5.** Your pre-registered primary analysis gives *p* = 0.09, but an exploratory
covariate adjustment gives *p* = 0.01. How do you report it?

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Hypothesizing after results are known."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"Registered reports are reviewed before data collection."* —
**✔ 10/10.** And journals commit to publish regardless of results if the protocol is
followed.

> **Q3 — Sample answer:** *"Because you get many chances."* — **✔ 9/10.** Each path is a
separate test; picking the best of several tests inflates the overall error rate.

> **Q4 — Sample answer:** *"ARRIVE, STROBE, STARD, TRIPOD+AI."* — **✔ 10/10.**

> **Q5 — Sample answer:** *"Report the adjusted one because it's better."* — **✘ 2/10.**
Report the **pre-registered primary result** as primary (estimate, CI, *p* = 0.09), and the
adjusted analysis as exploratory/sensitivity, explaining why it was run. Readers can then
weigh both.

**Rubric:** full credit requires transparency about what was planned versus what was
not.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Forking paths** | Post hoc choices inflate false positives. |
| **Pre-specification** | Registration, protocol, SAP, pre-registration, registered reports. |
| **Exploration** | Valuable when labelled; test it in new data. |
| **Estimation** | Effects with CIs, not significance stars. |
| **Guidelines** | Use them as design checklists. |

**Traps to remember:** HARKing · outcome switching · post hoc exclusions · *p* = 0.06 as
"no effect".

### 📇 Design Card — final rows

| Field | Your answer |
|---|---|
| Primary outcome (exact) | |
| Analysis formula | |
| Exclusion rules | |
| Registration venue and reporting guideline | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 8 — Hypothesis Testing](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/08-hypothesis-testing.md) · [Ch. 38 — Failure Modes](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/38-failure-modes.md)
- Meta-science: ([Ioannidis, 2005](https://doi.org/10.1371/journal.pmed.0020124); [Open Science Collaboration, 2015](https://doi.org/10.1126/science.aac4716))

## 📚 References cited in this chapter

- Altman DG, Bland JM (1995). Statistics notes: Absence of evidence is not evidence of absence. *BMJ* 311:485. [doi:10.1136/bmj.311.7003.485](https://doi.org/10.1136/bmj.311.7003.485)
- Chan AW, Hróbjartsson A, Haahr MT, Gøtzsche PC, Altman DG (2004). Empirical Evidence for Selective Reporting of Outcomes in Randomized Trials. *JAMA* 291:2457. [doi:10.1001/jama.291.20.2457](https://doi.org/10.1001/jama.291.20.2457)
- Chan AW, Tetzlaff JM, Gotzsche PC, Altman DG, Mann H, Berlin JA, et al. (2013). SPIRIT 2013 explanation and elaboration: guidance for protocols of clinical trials. *BMJ* 346:e7586-e7586. [doi:10.1136/bmj.e7586](https://doi.org/10.1136/bmj.e7586)
- Cumming G, Fidler F, Vaux DL (2007). Error bars in experimental biology. *The Journal of Cell Biology* 177:7-11. [doi:10.1083/jcb.200611141](https://doi.org/10.1083/jcb.200611141)
- Gamble C, Krishan A, Stocken D, Lewis S, Juszczak E, Doré C, et al. (2017). Guidelines for the Content of Statistical Analysis Plans in Clinical Trials. *JAMA* 318:2337. [doi:10.1001/jama.2017.18556](https://doi.org/10.1001/jama.2017.18556)
- Halsey LG, Curran-Everett D, Vowler SL, Drummond GB (2015). The fickle P value generates irreproducible results. *Nature Methods* 12:179-185. [doi:10.1038/nmeth.3288](https://doi.org/10.1038/nmeth.3288)
- Ioannidis JPA (2005). Why Most Published Research Findings Are False. *PLoS Medicine* 2:e124. [doi:10.1371/journal.pmed.0020124](https://doi.org/10.1371/journal.pmed.0020124)
- Munafò MR, Nosek BA, Bishop DVM, Button KS, Chambers CD, Percie du Sert N, et al. (2017). A manifesto for reproducible science. *Nature Human Behaviour* 1:0021. [doi:10.1038/s41562-016-0021](https://doi.org/10.1038/s41562-016-0021)
- Nosek BA, Ebersole CR, DeHaven AC, Mellor DT (2018). The preregistration revolution. *Proceedings of the National Academy of Sciences* 115:2600-2606. [doi:10.1073/pnas.1708274114](https://doi.org/10.1073/pnas.1708274114)
- Open Science Collaboration (2015). Estimating the reproducibility of psychological science. *Science* 349:aac4716. [doi:10.1126/science.aac4716](https://doi.org/10.1126/science.aac4716)
- Simmons JP, Nelson LD, Simonsohn U (2011). False-Positive Psychology. *Psychological Science* 22:1359-1366. [doi:10.1177/0956797611417632](https://doi.org/10.1177/0956797611417632)
- Wasserstein RL, Lazar NA (2016). The ASA Statement on p -Values: Context, Process, and Purpose. *The American Statistician* 70:129-133. [doi:10.1080/00031305.2016.1154108](https://doi.org/10.1080/00031305.2016.1154108)


---

[← Chapter 24](24-neuroscience.md) · [Table of Contents](../README.md) · [Next: Chapter 26 — Capstone: The Design Clinic →](26-capstone-design-clinic.md)
