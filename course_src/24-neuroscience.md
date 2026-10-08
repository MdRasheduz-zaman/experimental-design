# Chapter 24 — Neuroscience

> **Part IV — Field Playbooks**
> [← Chapter 23](23-clinical-and-preclinical.md) · [Table of Contents](../README.md) · [Next: Chapter 25 — Pre-registration and Reporting →](25-preregistration-and-reporting.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Identify the nested structure of neuroscience data (trials, neurons, slices, animals, participants) and design around it.
2. Avoid **circular analysis** by separating selection data from test data.
3. Plan sample sizes for brain–behaviour correlations and explain the **winner's curse**.
4. Describe design efficiency in task fMRI and valid inference thresholds.
5. Design multi-site imaging studies with site as a block.

**Dominant question types:** comparative (Q2), mechanistic (Q3), associational (Q4), predictive (Q5).

---

## 🎯 The Big Picture

Neuroscience has produced some of the clearest diagnoses of design failure. The median
statistical power of neuroscience studies was estimated at about **21%** [@button2013].
Nested data invite pseudoreplication [@lazic2010; @aarts2014]; flexible voxel or neuron
selection invites circularity [@kriegeskorte2009]; brain–behaviour correlations are small
and need very large samples [@marek2022]. Each has a design solution.

---

## 🧠 Core Intuition — the neuroscience playbook

### 1. Nested data

Trials within neurons, neurons within slices, slices within animals; scans within sessions
within participants. The **animal or participant** is usually the unit for group
comparisons. Model the hierarchy or aggregate (Chapter 3) [@aarts2014].

```mermaid
%% alt: Nested levels in a typical neuroscience experiment: groups contain animals, animals contain sessions, sessions contain neurons and neurons contain trials; the level at which the treatment was assigned is the level that counts as n
flowchart TB
  G["Group — the level the treatment was assigned to"]:::ok --> A["Animals (n for a group claim)"]:::trt
  A --> S["Sessions per animal"]:::ctl
  S --> N["Neurons per session"]:::note
  N --> T["Trials per neuron"]:::note
  T -. "thousands of rows in the data file" .-> W["Counting rows as n inflates confidence<br/>— model the levels, or summarize up to the animal"]:::bad
```

### 2. Circular analysis ("double dipping")

Selecting voxels, neurons or time windows because they show an effect, then testing that
effect in the same data, inflates it [@kriegeskorte2009]. **Design fix:** independent
localizer runs, split-half designs, or pre-specified regions of interest.

```mermaid
%% alt: Circular analysis selects a region or neurons using the same data that are then used to test the effect, which inflates the result; independence is restored by selecting on separate data such as a localizer, other trials or an anatomical atlas
flowchart TB
  subgraph BAD["❌ Selection and test share the data"]
    b1["Search the whole dataset<br/>for the strongest effect"]:::bad --> b2["Report that effect<br/>and its p-value"]:::bad
  end
  BAD --> N["The selection already used the noise that makes the effect look large,<br/>so the reported value is biased upward"]:::bad
  subgraph OK["✅ Selection independent of the test"]
    o1["Define the region or units from:<br/>a localizer run · other trials · an anatomical atlas · prior data"]:::ok --> o2["Measure the effect<br/>in the held-out data"]:::ok
  end
  OK --> M["The estimate is unbiased, and the test means what it claims"]:::ok
```

### 3. Interactions

"Effect in condition A but not B" requires an interaction test [@nieuwenhuis2011] (Chapter 7).

### 4. Task fMRI design efficiency

Event timing and order determine how efficiently responses can be estimated. Jittered,
randomized designs can be optimized in advance [@dale1999]. Sample sizes should be planned
with realistic variance components [@desmond2002].

### 5. Inference thresholds

Commonly used parametric cluster-wise inference produced familywise false-positive rates
far above nominal, up to 70% [@eklund2016; @woo2014]. Choose and pre-specify validated
thresholds.

### 6. Brain–behaviour associations need large *n*

Inter-individual brain–behaviour correlations are typically small. Reproducible
brain-wide association studies need **thousands** of participants [@marek2022]. Small
studies produce inflated correlations [@yarkoni2009]. Sample sizes have grown, but often
not enough [@szucs2020; @poldrack2017].

### 7. Multi-site studies

Scanner and site effects are batches: balance groups across sites, include site as a block,
harmonize acquisition, and validate across sites [@hu2023]. Community best practices:
COBIDAS for MRI [@nichols2017], fMRI reporting [@poldrack2008], MEG [@gross2013], and
preclinical rigour [@steward2014].

---

## 👁️ Visual Intuition — avoiding double dipping

```mermaid
%% alt: Using independent data halves to select regions and to test effects
flowchart LR
  D["All data"] --> L["Localizer run/half 1<br/>select ROI or neurons"]
  D --> T["Task run/half 2<br/>test the effect"]
  L -->|"ROI definition only"| T
```

---

## 🔬 Worked Example — sample size and the winner's curse for correlations

**Required *n*.** For 80% power (α = 0.05, two-sided):

| True correlation r | *n* needed |
|---|---|
| 0.3 | 85 |
| 0.1 | 783 |

**What small studies report.** We simulated 20,000 studies of a true r = 0.1:

| *n* per study | Power | Mean r among significant positive results |
|---|---|---|
| 20 | 7% | **0.52** |
| 100 | 17% | **0.25** |
| 800 | 81% | **0.11** |

With *n* = 20, the rare "significant" studies report correlations about **five times** the
true value — the winner's curse (type M error, Chapter 8) [@gelman2014; @yarkoni2009]. A
literature built from such studies will look full of strong, irreproducible effects.
(Code: `scripts/course/worked_examples.R`.)

![Histograms of observed correlations for n = 20, 100 and 800, with significant positive results highlighted](../assets/course/ch24-winners-curse.png)


---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Hundreds of neurons = large *n*."** | Animals are the unit for group claims. |
| **"I selected the ROI from my data, but the test is still valid."** | Validity depends on independence of selection and the tested statistic under the null. An independent ROI/localizer or held-out data is the simplest safeguard [@kriegeskorte2009]. |
| **"r = 0.6 with *n* = 20 is a strong finding."** | It is a noisy estimate, likely inflated. |
| **"Default software thresholds are safe."** | Some common ones were shown to inflate false positives. Pre-specify validated inference. |
| **"Site effects average out."** | Only if groups are balanced across sites. |

---

## 🧪 Spot the Flaw

> "We recorded 412 neurons from 3 control and 3 knockout mice. Neurons responding to the
> stimulus (selected by a *t*-test on responses) were analysed further; knockout responsive
> neurons had 40% larger responses (*p* < 0.0001, *n* = 412)."

<details>
<summary>▶ Diagnosis</summary>

- **Pseudoreplication:** 3 vs 3 mice; neurons are sub-units.
- **Circularity:** neurons selected for responding, then their response size compared —
  selection inflates response estimates, possibly differently by genotype.
- **Fix:** more mice; selection on independent trials (e.g. odd trials select, even trials
  measure); mixed model with mouse as random effect; report per-mouse values.
</details>

---

## 🔎 The Reviewer's Perspective

- **"What is *n* for each claim — animals, participants, neurons?"**
- **"Were selection and testing done on independent data?"**
- **"Was the inference threshold validated and pre-specified?"**
- **"For correlations: is *n* adequate for plausible effect sizes?"**
- **"Were sites/scanners balanced and modelled?"**

---

## 🛠️ Design Challenges

Three neuroscience designs: a multi-site imaging trial, a cellular-imaging study and a task
fMRI experiment. For each, identify the nesting (sites, animals, neurons, trials) and any
risk of double dipping — then open the model answer and its diagram.

### Challenge 1 · Human neuroimaging · ⭐⭐ — training and hippocampal volume

You want to test whether a training programme changes hippocampal volume in older adults,
using MRI at two sites.

<details>
<summary>▶ A model design</summary>

- **RCT:** participants randomized to training or active control, **stratified by site**
  (site as block); allocation concealed; MRI analysts blinded.
- **Measurement:** same scanner protocol at both sites; phantom/traveling-subject scans to
  quantify site differences; automated segmentation with QC by blinded raters.
- **Design:** pre/post scans; primary outcome = change in volume; analysis
  `change ~ site + baseline + group`.
- **Sample size:** from a smallest meaningful change and realistic test–retest variability;
  inflate for dropout.
- **Pre-registration** of the ROI (hippocampus), pipeline and analysis.

```mermaid
%% alt: Two-site imaging trial: at each site participants are randomized to training or active control with concealed allocation; harmonized scanner protocols and travelling-subject scans quantify site differences; blinded segmentation of pre and post scans gives the change in hippocampal volume analysed with site and baseline as covariates
flowchart TB
  subgraph S["Randomization stratified by site (site = block)"]
    subgraph Sr[" "]
      direction TB
      a["Site A<br/>training · active control"]:::trt
      b["Site B<br/>training · active control"]:::ctl
    end
  end
  style Sr fill:none,stroke:none
  H["Harmonized protocol + travelling-subject<br/>/ phantom scans"]:::note --> S
  S --> P["Pre and post MRI → automated segmentation<br/>QC by blinded raters"]:::note
  P --> A["change ~ site + baseline + group<br/>(pre-registered ROI and pipeline)"]:::ok
```
</details>

### Challenge 2 · Systems neuroscience · ⭐⭐⭐ — "stimulus-responsive" neurons

Using two-photon calcium imaging, you record ~200 neurons per mouse in visual cortex of
6 knockout and 6 wild-type mice, presenting a stimulus on 40 trials. The draft analysis:
(1) select neurons that respond significantly to the stimulus; (2) compare the response
amplitude of **those** neurons between genotypes, treating each neuron as a data point.

<details>
<summary>▶ A model design</summary>

- **Two problems.** (1) **Double dipping:** neurons selected *because* they responded strongly
  on these trials will, on the same trials, show inflated responses (regression to the mean),
  and the inflation can differ between genotypes if their noise levels differ. (2)
  **Pseudoreplication:** neurons are nested in mice; genotype is assigned to mice, so *n* = 6
  vs 6.
- **Fix selection:** split trials — select responsive neurons on **odd trials**, measure
  amplitude on **even trials** (or use an independent localizer stimulus/session).
  Pre-specify the selection criterion.
- **Fix the unit:** summarize per mouse (or use a mixed model with mouse as random effect);
  report the number of neurons per mouse and the fraction responsive per mouse.
- **Blind** the analysis to genotype; image both genotypes interleaved across days.

```mermaid
%% alt: Independent selection and testing: trials are split into odd and even halves; responsive neurons are selected using odd trials only and their amplitudes are measured on even trials; neuron values are summarized per mouse so that the genotype comparison uses six versus six mice; selecting and testing on the same trials is marked as double dipping
flowchart TB
  X["❌ Select and measure on the same 40 trials<br/>→ inflated amplitudes; neurons as n"]:::bad
  X ~~~ T
  T["40 trials per mouse"]:::note --> O["Odd trials (20):<br/>select responsive neurons"]:::ctl
  T --> E["Even trials (20):<br/>measure amplitude"]:::trt
  O -- "selected neurons" --> E
  E --> M["Summarize per mouse<br/>(or mixed model, mouse random)"]:::note
  M --> G["Genotype comparison: n = 6 vs 6 mice<br/>analysis blind to genotype"]:::ok
```
</details>

### Challenge 3 · Cognitive neuroscience · ⭐⭐ — a task fMRI design

You will compare brain responses to **faces**, **houses** and **scrambled images** (3
conditions) in 24 participants, each doing 3 runs of about 6 minutes. You want to estimate
the response to each condition and the contrast faces − houses. Design the task.

<details>
<summary>▶ A model design</summary>

- **Event-related design** with **jittered** inter-stimulus intervals (e.g. 2–6 s): jitter
  lets the overlapping haemodynamic responses be separated, improving design efficiency
  (Chapter 24).
- **Trial order:** pseudo-randomized so that each condition follows every other condition
  about equally often (first-order counterbalancing), with a different order in each run.
- **Run order across participants:** counterbalance which sequence comes first (e.g. a Latin
  square of the 3 run orders over participants), so fatigue and learning are not confounded
  with any one sequence.
- **Check efficiency** of candidate sequences by simulation before scanning; include an
  attention task (e.g. press for a repeated image) to keep participants alert, identical for
  all conditions.
- **Analysis:** first level per run, then per participant; group level with participant as
  the unit; pre-specify the ROI (e.g. fusiform face area from an **independent** localizer run).

```mermaid
%% alt: Task fMRI design: each of three runs is a jittered event-related sequence of faces, houses and scrambled images with counterbalanced transitions; the order of the three runs follows a Latin square across participants; an independent localizer run defines the region of interest used to test the faces minus houses contrast
flowchart TB
  subgraph RUN["One run (excerpt): jittered events, counterbalanced transitions"]
    subgraph Rr[" "]
      direction TB
      e1["Face<br/>gap 2 s"]:::trt
      e2["House<br/>gap 5 s"]:::ctl
      e3["Scrambled<br/>gap 3 s"]:::pos
      e4["House<br/>gap 6 s"]:::ctl
      e5["Face<br/>…"]:::trt
    end
  end
  style Rr fill:none,stroke:none
  RUN --> LS["Run orders 1-2-3/2-3-1/3-1-2<br/>Latin square across 24 participants"]:::note
  LS --> LOC["Independent localizer run → ROI"]:::note
  LOC --> A["Faces − houses in ROI<br/>participant = unit at group level"]:::ok
```
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** What is circular analysis?

**⭐ Q2.** Why did cluster-wise inference attract criticism?

**⭐⭐ Q3.** Approximately how many participants are needed to detect r = 0.3 with 80%
power? And r = 0.1?

**⭐⭐ Q4.** Explain the winner's curse using the simulation table.

**⭐⭐⭐ Q5.** Redesign the "412 neurons" study (Spot the Flaw) for a confirmatory claim.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Using the same data to select and test."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"It gave too many false positives."* — **✔ 9/10.** Specifically,
some parametric implementations produced familywise error rates far above the nominal 5%
[@eklund2016].

> **Q3 — Sample answer:** *"85 and 783."* — **✔ 10/10.**

> **Q4 — Sample answer:** *"Small studies only become significant when they overestimate."* —
**✔ 10/10.** With n = 20 the significant ones average r ≈ 0.52 for a true 0.1.

> **Q5 — Sample answer:** *"More mice and a mixed model."* — **◑ 7/10.** Add: power
calculation at the **mouse** level; pre-specified neuron-inclusion criteria applied on
independent trials; blinded recording/analysis; both sexes; report per-mouse summaries.

**Rubric:** neuroscience answers need the unit, independence of selection and test, and
realistic effect sizes.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Nesting** | Animals/participants are the unit for group claims. |
| **Circularity** | Select on independent data. |
| **fMRI design** | Optimize event timing; pre-specify validated thresholds. |
| **Correlations** | Small effects need hundreds to thousands; small studies inflate. |
| **Sites** | Balance and model scanners/sites. |

**Traps to remember:** neurons as *n* · double dipping · r from n = 20 · unvalidated
thresholds · unbalanced sites.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Unit per claim (animal, participant) | |
| Independent selection/test data | |
| Pre-specified ROI, threshold and pipeline | |
| *n* justified for plausible effect sizes | |
| Site/scanner balance and harmonization | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 32 — Pseudoreplication](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/32-pseudoreplication.md) · [Ch. 26 — Multiple Testing](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/26-multiple-testing.md) · [Ch. 9 — Errors and Power](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/09-errors-and-power.md)

<!-- REFS -->

---

[← Chapter 23](23-clinical-and-preclinical.md) · [Table of Contents](../README.md) · [Next: Chapter 25 — Pre-registration and Reporting →](25-preregistration-and-reporting.md)
