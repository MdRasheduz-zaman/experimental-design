# Chapter 18 — Biotechnology, Bioprocess and Pharmacy

> **Part IV — Field Playbooks**
> [← Chapter 17](17-microbiology-microbiome.md) · [Table of Contents](../README.md) · [Next: Chapter 19 — Plant and Animal Breeding, Field Trials →](19-breeding-and-field-trials.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Apply sequential DoE to bioprocess and formulation development, including blocking by raw-material lot or reactor.
2. Explain **Quality by Design (QbD)** and the idea of a design space.
3. Recognize mixture designs and when they are needed.
4. Plan concentration–response, crossover and drug–drug-interaction studies in pharmacology.
5. Describe design–build–test–learn (DBTL) cycles as sequential experimental design.

**Dominant question types:** optimization (Q6), screening (Q7), comparative (Q2), predictive (Q5).

---

## 🎯 The Big Picture

Biotechnology and pharmacy are where biology meets manufacturing. The questions are
often *"which settings give the best, most robust product?"* — optimization — and the
answers must hold up at scale and under regulatory scrutiny. Statistical DoE (Chapter 13)
is therefore not optional here but embedded in regulatory practice [@yu2014; @politis2017].

---

## 🧠 Core Intuition — the biotech & pharmacy playbook

### 1. Bioprocess development with DoE

- **Screen** many medium components or process parameters with Plackett–Burman or
  fractional factorials [@plackett1946]; **optimize** the important few with response
  surfaces [@boxwilson1951]; **confirm** with replicated runs. This beats OFAT for media
  and process optimization [@weusterbotz2000; @mandenius2008; @kumar2014; @keskin2016].
- **Blocks:** raw-material lot, inoculum batch, bioreactor, day. **Randomize run order**
  against drift.
- **Multiple responses** (titre, quality attributes, cost): desirability functions
  [@candioti2014].
- **Scale:** small-scale models must be qualified against large-scale runs before their
  optima are trusted.

```mermaid
%% alt: Bioprocess development moves from a small scale-down model used for designed experiments, through confirmation at bench scale, to pilot and manufacturing scale, with scale-dependent parameters re-checked at each step
flowchart TB
  A["Scale-down model<br/><i>microplates/mini-bioreactors — many parallel runs</i>"]:::ctl
  A --> B["Designed experiments<br/><i>screen factors → response surface → optimum</i>"]:::trt
  B --> C["Confirm at bench scale<br/><i>replicated runs at the predicted setting</i>"]:::trt
  C --> D["Pilot scale"]:::pos
  D --> E["Manufacturing scale"]:::ok
  C -. "mixing, oxygen transfer and shear do not scale with volume —<br/>re-check the scale-dependent parameters at each step" .-> D
```

### 2. Quality by Design (QbD)

Critical quality attributes (CQAs) of the product are linked, through designed
experiments, to critical material attributes and process parameters. The resulting
**design space** is the region of settings within which quality is assured
[@yu2014; @politis2017; @weissman2015].

```mermaid
%% alt: Quality by Design workflow from target product profile to design space and verification
flowchart LR
  T["Target product profile"] --> Q["Critical quality attributes"]
  Q --> R["Risk assessment: which inputs matter?"]
  R --> D["DoE: link inputs to CQAs"]
  D --> S["Design space + control strategy"]
  S --> V["Continual verification"]
```

```mermaid
%% alt: The Quality by Design sequence: define the target product profile, identify critical quality attributes, link them to material attributes and process parameters by experiment, establish a design space and then a control strategy
flowchart TB
  A["1 · Target product profile<br/><i>what the product must do for the patient</i>"]:::ok
  A --> B["2 · Critical quality attributes<br/><i>measurable properties that matter: purity, size, potency</i>"]:::ctl
  B --> C["3 · Which inputs drive them?<br/><i>material attributes + process parameters</i>"]:::trt
  C --> D["4 · Experiments (DoE)<br/><i>screen → response surface → confirm</i>"]:::trt
  D --> E["5 · Design space<br/><i>the region where quality is met</i>"]:::pos
  E --> F["6 · Control strategy<br/><i>limits, monitoring, what to do on drift</i>"]:::ok
```

### 3. Formulation: mixture designs

When components must sum to 100% (excipients in a tablet, lipids in a nanoparticle), the
factors are not independent. **Mixture designs** (simplex lattice, simplex centroid,
constrained mixtures) are needed [@singh2005].

### 4. Strain, enzyme and metabolic engineering

- **DBTL cycles** are sequential experimental design: each round's results train a model
  that proposes the next designs (ML-guided directed evolution) [@yang2019].
- **Isotope-labelling experiments**: tracer choice and sampling times determine which
  fluxes are identifiable. Optimize the design before the experiment [@noh2006].
- **Biocatalysis reporting** guidelines define what must be recorded [@gardossi2010].

### 5. Experimental pharmacology

Guidance from the *British Journal of Pharmacology* requires randomization, blinding,
pre-specified group sizes, and **at least five independent experimental units per group**
for statistical analysis. It cautions against normalizations that remove control-group
variance [@curtis2018; @curtis2022]. This is a journal-specific threshold, not a
power justification: five units can still be inadequate for your target effect.

- **Concentration–response:** span the full curve (log spacing), vehicle and time-matched
  controls, enough points to estimate potency and efficacy.
- **Clinical pharmacology:** **crossover** designs for bioequivalence and drug–drug
  interaction studies, with washout periods [@huang2007; @senn2004].
- **PBPK models** used for regulatory decisions need explicit qualification and reporting
  [@shebley2018].

---

## 👁️ Visual Intuition — a 2×2 crossover

```
                Period 1        washout        Period 2
Sequence AB:    Test (A)          ───          Reference (B)
Sequence BA:    Reference (B)     ───          Test (A)
Each subject is randomized to a sequence → each serves as own control;
period and sequence effects are estimable.
```

---

## 🔬 Worked Example — a bioequivalence crossover

A generic tablet (test, T) is compared with the reference product (R) in 24 healthy
volunteers, randomized to sequence TR or RT, with a washout of more than five elimination
half-lives.

1. **Outcome:** AUC and C_max on the log scale (pharmacokinetic parameters are roughly
   log-normal).
2. **Model:** `log(AUC) ~ sequence + period + formulation + (1 | subject)`.
3. **Result (illustrative):** geometric mean ratio T/R = 0.95, **90% CI 0.88 to 1.03**.
4. **Decision rule** (standard regulatory criterion): bioequivalent if the 90% CI of the
   ratio lies within **0.80–1.25**. Here it does.
5. **Design features doing the work:** within-subject comparison (removes the large
   between-person variability), randomized sequence (balances period effects), washout
   (prevents carry-over), and a pre-specified equivalence margin.

Note the logic: this is an **equivalence** question, so the design is powered to show the
difference is *small*, not to show it is non-zero.

![Confidence intervals of four products against the 0.80 to 1.25 equivalence band](../assets/course/ch18-bioequivalence.png)


---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"We optimized at bench scale, so we're done."** | Optima can shift with scale; verify in a qualified scale-down model and at scale. |
| **"Mixture components can be varied independently."** | Not when they sum to a fixed total. |
| **"Normalize each experiment to its control = 100%."** | This removes control variance and can distort tests; analyse raw or log data with experiment as a block [@curtis2018]. |
| **"Non-significant difference = equivalent."** | Equivalence needs a pre-specified margin and a CI inside it. |
| **"Run order doesn't matter in bioreactors."** | Drift in probes, media lots and inocula makes order a confounder. |

---

## 🧪 Spot the Flaw

> "Antibody titre was optimized in shake flasks. Runs 1–8 used medium lot A (low glucose
> conditions) and runs 9–16 used lot B (high glucose conditions). High glucose increased
> titre by 30%."

<details>
<summary>▶ Diagnosis</summary>

The glucose factor is **confounded with medium lot**, and probably with run time. The 30%
could be a lot effect. **Fix:** treat lot as a **block** that contains both glucose levels
(or all factorial runs), randomize run order within each block, and include replicated
centre points in each block.
</details>

---

## 🔎 The Reviewer's Perspective

- **"Which DoE was used, with what blocks and run order?"**
- **"Were the optimum and the design space confirmed?"**
- **"Is *n* the number of independent experiments (≥ 5 for BJP), and were data normalized
  appropriately?"**
- **"For equivalence: was the margin pre-specified and the CI reported?"**

---

## 🛠️ Design Challenges

Three development problems from biotechnology and pharmaceutics: a formulation, a
stability programme and a bioprocess. For each, identify the factors, their type
(mixture, process, time) and the decision the data must support — then open the model
answer and its diagram.

### Challenge 1 · Nanomedicine · ⭐⭐⭐ — a lipid nanoparticle

You develop a lipid nanoparticle for mRNA delivery with four lipid components (molar
fractions summing to 1) and one process parameter (mixing flow rate). Responses:
encapsulation efficiency, particle size, and transfection in cells. Outline the design.

<details>
<summary>▶ A model design</summary>

- **Mixture part:** a constrained mixture design over the four lipids, within feasible
  ranges for each (e.g. an extreme-vertices or D-optimal mixture design).
- **Process part:** flow rate at 2–3 levels crossed with the mixture design
  (a mixture–process design), or fixed after a preliminary screen.
- **Replication:** centre-blend replicates for pure error; batches prepared on different
  days as blocks; randomized preparation order.
- **Responses:** fit models for each, then combine them with desirability. Confirm the
  optimum with replicated batches, and transfection in independent cell experiments.

```mermaid
%% alt: Mixture-process design for a lipid nanoparticle: a constrained mixture design over four lipid fractions is crossed with two or three flow-rate levels, run in randomized order over several days with replicate centre blends; three responses are modelled and combined by desirability, then the optimum is confirmed with replicate batches
flowchart TB
  M["Mixture factors: 4 lipid fractions (sum = 1)<br/>constrained/D-optimal mixture design"]:::trt --> X
  P["Process factor: flow rate<br/>2–3 levels"]:::ctl --> X
  X["Mixture × process runs<br/>+ replicate centre blends · days as blocks · random order"]:::note
  X --> R["Responses: encapsulation · size · transfection<br/>one model each → combined desirability"]:::note
  R --> C["Confirm optimum: replicate batches<br/>+ independent cell experiments"]:::ok
```
</details>

### Challenge 2 · Pharmaceutics · ⭐⭐ — how long will the tablets keep?

A new tablet formulation needs a shelf-life claim for a climate with moderate temperature
and humidity. Following the ICH Q1A(R2) stability guideline, plan the formal stability study:
batches, storage conditions, time points and analysis.

<details>
<summary>▶ A model design</summary>

- **Batches:** at least **3 primary batches** (pilot or production scale, made by the final
  process and packaged in the final container) — batches are the replicates for the shelf
  life, because batch-to-batch variation is what patients will meet.
- **Conditions:** **long-term 25 °C/60% RH**, tested at **0, 3, 6, 9, 12, 18 and 24 months**
  (then annually); **accelerated 40 °C/75% RH** at **0, 3 and 6 months**; an intermediate
  condition (30 °C/65% RH) if the accelerated data show significant change.
- **Attributes:** assay (content), degradation products, dissolution, appearance and
  water content — with validated, stability-indicating methods.
- **Analysis:** regression of each attribute on time **per batch**; test whether batches can be
  pooled (similar slopes and intercepts); the shelf life is where the **95% confidence bound**
  of the mean crosses the specification limit — not where the mean line crosses it.

```mermaid
%% alt: Stability programme: three primary batches are stored at long-term conditions of 25 degrees and 60 percent humidity, tested from 0 to 24 months, and at accelerated conditions of 40 degrees and 75 percent humidity, tested at 0, 3 and 6 months; regression per batch with a test for pooling gives the shelf life where the 95 percent confidence bound meets the specification
flowchart TB
  subgraph BAT["3 primary batches · final process · final packaging"]
    subgraph Br[" "]
      direction TB
      b1["Batch 1"]:::note
      b2["Batch 2"]:::note
      b3["Batch 3"]:::note
    end
  end
  style Br fill:none,stroke:none
  BAT --> LT["Long-term 25 °C/60% RH<br/>0 · 3 · 6 · 9 · 12 · 18 · 24 months"]:::ctl
  BAT --> AC["Accelerated 40 °C/75% RH<br/>0 · 3 · 6 months"]:::trt
  LT & AC --> AN["Regression per batch → pool if slopes agree<br/>shelf life where the 95% bound meets the specification"]:::ok
```
</details>

### Challenge 3 · Bioprocess development · ⭐⭐ — 24 mini-bioreactors

You must improve the titre of an antibody-producing CHO cell fed-batch process. Four
factors are candidates: temperature shift (yes/no), feed rate, dissolved oxygen setpoint and
pH setpoint. You have one run of a **24-vessel** automated mini-bioreactor system. The
current process should also be included.

<details>
<summary>▶ A model design</summary>

- **Full factorial 2⁴ = 16 runs** fits: all main effects and all two-factor interactions are
  estimable without aliasing.
- **+ 4 centre points** for the three numeric factors (one set at each level of the
  temperature-shift factor, or all with the current choice) — curvature check and pure error.
- **+ 4 replicate vessels of the current process** — the reference you must beat, and an
  estimate of vessel-to-vessel variation.
- **= 24 vessels.** Randomize the vessel positions (the system's stations can differ) and
  use one inoculum train for all vessels.
- **Responses:** titre, viable cell density, product quality attributes (e.g. glycosylation)
  — a higher titre with worse quality is not an improvement.
- **Next:** confirm the best condition at bench scale (larger bioreactors) before scale-up.

```mermaid
%% alt: Allocation of 24 mini-bioreactor vessels: 16 for a full two-to-the-four factorial, 4 centre points and 4 replicates of the current process, positions randomized, all from one inoculum train; responses include titre, cell density and quality attributes
flowchart TB
  I["One inoculum train for all vessels"]:::note --> V
  subgraph V["24 vessels · positions randomized"]
    subgraph Vr[" "]
      direction TB
      F["16 · full factorial 2⁴<br/>main effects + all 2-factor interactions"]:::trt
      C["4 · centre points<br/>curvature + pure error"]:::note
      R["4 · current process<br/>the reference to beat"]:::ctl
    end
  end
  style Vr fill:none,stroke:none
  V --> O["Titre · viable cell density · quality attributes<br/>→ confirm the best condition at bench scale"]:::ok
```
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** What is a design space in QbD?

**⭐ Q2.** Why do formulations sometimes need mixture designs?

**⭐⭐ Q3.** Explain why crossover designs are efficient for bioequivalence studies.

**⭐⭐ Q4.** What is wrong with normalizing every experiment's treated values to its own
control set at 100% and then running a *t*-test against 100?

**⭐⭐⭐ Q5.** Design the first two DBTL rounds for improving an enzyme's thermostability
using an ML model, including controls and replication.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"The range of settings where quality is guaranteed."* —
**✔ 9/10.** Add that it is established *experimentally* (DoE) and linked to CQAs.

> **Q2 — Sample answer:** *"Because the components add up to 100%."* — **✔ 10/10.**

> **Q3 — Sample answer:** *"Each subject gets both products, so between-subject
variability is removed."* — **✔ 10/10.**

> **Q4 — Sample answer:** *"The control has no variance."* — **✔ 9/10.** Right: the control
group's variability is hidden (every control = 100%), so the test ignores a real source
of variation and overstates precision. Analyse raw (often log) values with experiment as
a block.

> **Q5 — Sample answer:** *"Round 1: random mutants; train model; round 2: model
picks."* — **◑ 6/10.** Add: round 1 should be a *diverse, designed* library (e.g. site
saturation at chosen positions or a space-filling sample); measure wild-type and a
known stabilized variant on **every plate** as controls; replicate measurements of
selected variants; keep a held-out set to check the model's predictions; round 2 balances
exploitation (top predictions) and exploration (uncertain regions).

**Rubric:** full credit needs blocks/controls and the sequential logic.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Bioprocess DoE** | Screen → optimize → confirm; block by lot/reactor; randomize order. |
| **QbD** | Link inputs to CQAs experimentally; define a design space. |
| **Mixtures** | Components summing to 100% need mixture designs. |
| **Pharmacology** | ≥ 5 independent units, full concentration–response, no variance-removing normalization. |
| **Crossover** | Within-subject comparisons for bioequivalence and DDI. |
| **DBTL** | Sequential, model-guided design with controls every round. |

**Traps to remember:** lot = factor · normalized-to-100% tests · equivalence by
non-significance · unverified scale-up.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Factors, ranges and DoE type per stage | |
| Blocks (lot, reactor, day) and randomized run order | |
| Responses and desirability weights | |
| Confirmation/scale-up verification | |
| Regulatory or reporting standard identified | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 16 — Linear Regression](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/16-linear-regression.md) · [Ch. 33 — Mixed Models](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/33-hierarchical-mixed-models.md)
- Chapter 13 of this course (optimization designs).

<!-- REFS -->

---

[← Chapter 17](17-microbiology-microbiome.md) · [Table of Contents](../README.md) · [Next: Chapter 19 — Plant and Animal Breeding, Field Trials →](19-breeding-and-field-trials.md)
