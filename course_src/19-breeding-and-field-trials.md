# Chapter 19 — Plant and Animal Breeding, Field Trials

> **Part IV — Field Playbooks**
> [← Chapter 18](18-biotech-bioprocess-pharmacy.md) · [Table of Contents](../README.md) · [Next: Chapter 20 — Genetics, Genomics and Transcriptomics →](20-genetics-genomics-transcriptomics.md)

---

<details>
<summary>🧬 <b>Biology primer</b> — breeding terms (expand if new)</summary>

- **Entry/line/genotype:** a variety or breeding line being tested.
- **Check:** an established variety included for comparison and to measure field variation.
- **Environment:** a location × year (× management) combination.
- **G × E:** genotype-by-environment interaction — lines rank differently in different environments.
- **BLUP:** best linear unbiased prediction of genetic values from a mixed model.
- **Genomic selection:** predicting breeding values from genome-wide markers.

</details>

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Choose among RCBD, incomplete-block (α-lattice), row–column, augmented and p-rep designs for a field trial.
2. Explain why **blocking plus spatial analysis** is essential in heterogeneous fields.
3. Design multi-environment trials around G × E.
4. Design the **training population** and validation scheme for genomic selection.
5. Recognize the pen/herd as the experimental unit in livestock trials.

**Dominant question types:** screening (Q7), predictive (Q5), comparative (Q2).

---

## 🎯 The Big Picture

Randomization, replication and blocking were invented for agricultural field trials, and
breeding still faces them in their hardest form: hundreds or thousands of genotypes, too
little seed to replicate early generations, fields with fertility and moisture gradients,
and conclusions that must hold in environments that have not happened yet.

---

## 🧠 Core Intuition — the breeding playbook

### 1. Field designs by number of entries and seed

| Situation | Design |
|---|---|
| Few entries (≤ ~15), plenty of seed | randomized complete block (RCBD) |
| Many entries, plenty of seed | incomplete blocks: lattice, **α-designs** [@piepho2006]; row–column designs |
| Many entries, seed for one plot each | **augmented design** (replicated checks in every block) |
| Many entries, seed for ~1.2 plots each | **partially replicated (p-rep)** designs with spatial analysis [@cullis2006] |

```mermaid
%% alt: Choosing a field design by how many entries there are and how much seed is available: complete blocks for few entries, incomplete block or alpha designs when a block cannot hold every entry, augmented designs when most entries cannot be replicated, and partially replicated designs as the middle ground
flowchart TB
  S{"Can a block hold<br/>every entry?"} -- "yes (few entries)" --> R["Randomized complete blocks<br/><i>every block holds every entry</i>"]:::ctl
  S -- "no (many entries)" --> T{"Enough seed to<br/>replicate every entry?"}
  T -- "yes" --> A["Resolvable incomplete blocks<br/><i>α-design, lattice; add row–column if two gradients</i>"]:::trt
  T -- "partly" --> P["Partially replicated (p-rep)<br/><i>a fraction of entries replicated</i>"]:::pos
  T -- "no, one plot per entry" --> G["Augmented design<br/><i>replicated checks estimate block effects</i>"]:::ok
  R & A & P & G --> SP["In every case: record row and column,<br/>and consider a spatial model of the residuals"]:::note
```

### 2. Spatial analysis

Blocks capture large-scale gradients. Smooth trends and local patchiness remain. Modelling
correlation between neighbouring plots (e.g. separable autoregressive structures) removes
much of this variation [@gilmour1997]. Design and spatial analysis work together: record
row and column for every plot.

```mermaid
%% alt: Field variation has three layers: a smooth trend across the field, patchy local variation between neighbouring plots, and independent plot error; blocking captures large-scale differences while a spatial model captures what remains
flowchart TB
  F["Variation seen between plots"]:::note
  F --> A["Smooth large-scale trend<br/><i>slope, drainage, old field boundary</i>"]:::ctl
  F --> B["Local patchiness<br/><i>neighbouring plots resemble each other</i>"]:::trt
  F --> C["Plot-to-plot error<br/><i>independent noise</i>"]:::note
  A --> D["Blocks handle much of this — if block shape follows the gradient"]:::ok
  B --> E["A spatial model of the residuals handles what blocks miss<br/><i>row/column effects, correlated errors</i>"]:::ok
  C --> G["What remains is the error used for comparisons"]:::note
```

### 3. Environments are the replicates that matter

Because of **G × E**, the environment (location × year) is the unit for generalization.
For a recommendation across a region, more environments usually beat more replicates
within one site.

```mermaid
%% alt: A variety tested at several locations and years: replicates within one trial improve the estimate at that site, while locations and years are what let a recommendation generalize, because genotype by environment interaction means rankings change between environments
flowchart TB
  subgraph ONE["One trial, many plots"]
    subgraph Or[" "]
      direction TB
      o1["rep 1"]:::ctl
      o2["rep 2"]:::ctl
      o3["rep 3"]:::ctl
    end
  end
  style Or fill:none,stroke:none
  ONE --> N1["More plots → a better estimate <b>for this site and season</b>"]:::note
  subgraph MANY["Several locations × years"]
    subgraph Mr[" "]
      direction TB
      m1["site A · yr 1"]:::trt
      m2["site B · yr 1"]:::trt
      m3["site C · yr 2"]:::trt
      m4["site D · yr 2"]:::trt
    end
  end
  style Mr fill:none,stroke:none
  MANY --> N2["Environments are the units for a recommendation:<br/>G × E means rankings can change between them"]:::ok
```

### 4. Mixed models and BLUP

Genetic values are estimated with mixed models (BLUP) [@henderson1975], which combine the
design (blocks, rows, columns), relationships between lines and environments.

### 5. Genomic selection: a predictive (Q5) design problem

Genomic selection [@meuwissen2001] is now routine in dairy cattle [@hayes2009] and many crops
[@crossa2017]. Accuracy depends on the **training population**: its size, phenotyping
quality, and **relatedness to the selection candidates**. Validation must mimic use —
predicting new families or new environments — or it will overestimate accuracy
[@daetwyler2013; @runcie2019].

### 6. Mapping populations are designed experiments

Nested association mapping [@yu2008] and MAGIC populations [@cavanagh2008] are built to
balance allelic diversity, recombination and power. Genotyping platform and marker QC are
design decisions [@pavan2020]. High-throughput phenotyping must itself be validated
[@araus2014].

### 7. Livestock

Animals in a pen or herd share feed, water and pathogens, so the **pen or herd** is often
the experimental unit. Livestock trials are reported with REFLECT [@sargeant2010].

---

## 👁️ Visual Intuition — an augmented design block

```
Block 7 (field row 7, columns 1–24)
| L161 | C2 | L162 | L163 | C4 | L164 | ... | C1 | L178 | C3 | L179 | L180 |
  L = new line (1 plot each, randomized)   C1–C4 = checks (in every block, randomized)
Check plots estimate block effects and error; new lines are adjusted using them.
```

---

## 🔬 Worked Example — what blocking buys in a field with a gradient

Simulation: **10 genotypes × 4 blocks** along a strong fertility gradient (block effects
−3, −1, +1, +3), genotype effects with SD 1, plot error SD 1. The same data analysed two
ways:

| Analysis | Residual mean square | *p* for genotype |
|---|---|---|
| Ignoring blocks (`y ~ genotype`) | 7.63 | 0.98 |
| With blocks (`y ~ block + genotype`) | 0.86 | 0.035 |

The gradient inflated the error **about ninefold** when ignored, hiding real genotype
differences. Blocking removed it — but only because the **design** put every genotype in
every block, so block and genotype effects were separable. (Code:
`scripts/course/worked_examples.R`.)

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Big blocks are fine."** | Large blocks are heterogeneous. With many entries, use incomplete blocks and spatial models. |
| **"Unreplicated lines can't be analysed."** | Augmented and p-rep designs, plus spatial models, make it possible. |
| **"One great site is enough."** | G × E means rankings can change; test in multiple environments. |
| **"Random cross-validation shows genomic prediction accuracy."** | Not if relatives sit in both sets and the use case is new families. |
| **"Each animal is a replicate."** | Not when treatments are applied per pen. |

---

## 🧪 Spot the Flaw

> "Twenty wheat varieties were planted in a single replicate, sorted alphabetically from
> west to east across one field. The top five yielding varieties are recommended for the
> region."

<details>
<summary>▶ Diagnosis</summary>

**No replication** (no error estimate), **no randomization** (alphabetical order aligns
varieties with an east–west gradient), **no blocking**, **one environment** (G × E
ignored). The ranking may reflect position in the field. **Fix:** an RCBD or α-design with
≥ 2–3 replicates per site, randomized positions, checks, row/column recorded for spatial
analysis, and several locations and years.
</details>

---

## 🔎 The Reviewer's Perspective

- **"What design, how many replicates, and how many environments?"**
- **"Were row/column positions recorded and spatial variation modelled?"**
- **"Are checks included, and how often?"**
- **"For genomic prediction: does validation mimic the intended use?"**
- **"For livestock: what is the unit — animal, pen or herd?"**

---

## 🛠️ Design Challenges

Three designs from breeding and animal science: a multi-location variety trial, a
livestock feeding trial and an on-farm trial with farmers. For each, decide what the
block is and what the replicates that matter are — then open the model answer and its
diagram. (For many more, see the [field-trials sub-course](../subcourses/field-trials/README.md).)

### Challenge 1 · Plant breeding · ⭐⭐ — 150 maize hybrids at 4 locations

You must evaluate 150 advanced maize hybrids at 4 locations, with seed for 2 replicates
per location. Fields are 10 rows × 30 columns of plots per location.

<details>
<summary>▶ A model design</summary>

- **Per location:** a resolvable **α-design** with 2 replicates of 150 plots; each
  replicate split into 15 incomplete blocks of 10 plots; 300 plots fit the 10 × 30 grid.
  Better still, a **row–column** α-design so both directions are blocked.
- **Checks:** include 2–3 commercial hybrids as entries (they are part of the 150, or add
  them).
- **Randomize** independently at each location.
- **Record** row and column; analyse with a mixed model including replicate, incomplete
  block, spatial residual structure, and genotype; combine locations in a
  multi-environment model with G × E.

```mermaid
%% alt: Resolvable alpha design at one location: the 10 by 30 field holds two replicates of 10 by 15 plots; each replicate contains all 150 hybrids in 15 incomplete blocks of 10; the design is randomized independently at each of four locations and analysed with a multi-environment mixed model
flowchart TB
  subgraph LOC["One location · 10 rows × 30 columns = 300 plots"]
    subgraph Rr[" "]
      direction TB
      R1["Replicate 1 · 10 × 15 plots<br/>all 150 hybrids<br/>15 incomplete blocks of 10"]:::ctl
      R2["Replicate 2 · 10 × 15 plots<br/>all 150 hybrids<br/>15 new incomplete blocks of 10"]:::trt
    end
  end
  style Rr fill:none,stroke:none
  LOC --> X["× 4 locations, randomized independently"]:::note
  X --> M["Mixed model: rep + block + spatial + genotype<br/>then multi-environment model with G × E"]:::ok
```
</details>

### Challenge 2 · Animal nutrition · ⭐⭐ — four diets for dairy cows

You want to compare 4 diets for milk yield. Cows differ enormously in yield, and you have
12 cows in mid-lactation. Each diet needs 2 weeks of adaptation before 1 week of
measurement. Design the trial.

<details>
<summary>▶ A model design</summary>

- **Within-cow comparison:** each cow receives all 4 diets in 4 periods — a **crossover**
  (Chapter 7) that removes the large between-cow variation.
- **Latin squares:** 3 squares of 4 cows × 4 periods; within a square each diet appears once
  per cow and once per period, so cow and period are both blocked.
- **Carry-over:** use a **Williams square**, in which each diet follows every other diet
  exactly once, so first-order carry-over effects are balanced and can be estimated; the
  2-week adaptation acts as a washout, and only week 3 of each period is analysed.
- **Lactation stage changes yield over time** — the period effect in the model absorbs it.
- **Analysis:** `yield ~ square + cow(square) + period(square) + diet` (± carry-over term);
  **cow-period** is the unit for diet comparisons.

```mermaid
%% alt: One four by four Williams square: four cows in rows and four periods in columns; the diet sequences are A B D C, B C A D, C D B A and D A C B, so every diet appears once per cow and once per period and each diet follows every other diet exactly once; the trial uses three such squares with twelve cows
flowchart TB
  subgraph SQ["One Williams square (× 3 squares = 12 cows) · columns = periods 1–4"]
    subgraph c1["Cow 1"]
      direction TB
      c1a["A"]:::trt
      c1b["B"]:::ctl
      c1c["D"]:::ok
      c1d["C"]:::pos
    end
    subgraph c2["Cow 2"]
      direction TB
      c2a["B"]:::ctl
      c2b["C"]:::pos
      c2c["A"]:::trt
      c2d["D"]:::ok
    end
    subgraph c3["Cow 3"]
      direction TB
      c3a["C"]:::pos
      c3b["D"]:::ok
      c3c["B"]:::ctl
      c3d["A"]:::trt
    end
    subgraph c4["Cow 4"]
      direction TB
      c4a["D"]:::ok
      c4b["A"]:::trt
      c4c["C"]:::pos
      c4d["B"]:::ctl
    end
  end
  SQ --> N["Each period: 2 weeks adaptation + 1 week measured<br/>diet compared within cows and within periods"]:::note
```
</details>

### Challenge 3 · Participatory breeding · ⭐⭐ — 10 varieties, 30 farmers

A programme wants farmers' own evaluation of 10 bean varieties under real farm conditions.
Each of 30 farmers can grow only **3 small plots**. Farmers' fields, soils and management
differ a lot. Design the trial.

<details>
<summary>▶ A model design</summary>

- **Each farm is an incomplete block** of size 3: within-farm comparisons remove the large
  differences between farms.
- **Allocation:** 30 farms × 3 plots = 90 plots → each variety appears **9 times**; assign
  sets of 3 at random under the constraint that every variety appears equally often (and,
  ideally, each pair of varieties meets on a similar number of farms). This is the logic of
  the "tricot" (triadic comparison of technologies) approach.
- **Data:** farmers **rank** the 3 varieties (best/worst) for yield, taste, cooking time etc.,
  plus a simple yield measurement where possible; codes, not variety names, on the seed packs
  (blinding).
- **Analysis:** rank-based models (e.g. Plackett–Luce) that combine incomplete rankings; add
  farm covariates (soil, altitude, rainfall) to study G × E.

```mermaid
%% alt: On-farm trial: thirty farms each grow a random set of three of the ten coded varieties, every variety appearing nine times in total; farmers rank their three plots and the incomplete rankings are combined with a rank-based model
flowchart TB
  subgraph F["30 farms = incomplete blocks of 3 · coded seed packs (first 6 shown)"]
    subgraph Fr[" "]
      direction TB
      f1["Farm 1<br/>E · I · D"]:::note
      f2["Farm 2<br/>A · J · C"]:::note
      f3["Farm 3<br/>D · G · J"]:::note
      f4["Farm 4<br/>H · D · A"]:::note
      f5["Farm 5<br/>C · B · J"]:::note
      f6["Farm 6<br/>F · D · I"]:::note
    end
  end
  style Fr fill:none,stroke:none
  F --> R["Each variety on 9 farms · farmers rank their 3 plots"]:::trt
  R --> M["Rank model (e.g. Plackett–Luce) + farm covariates → G × E"]:::ok
```

The variety sets were drawn at random (seeded) with the constraint that each of the 10
varieties appears exactly 9 times.
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** When would you use an augmented design?

**⭐ Q2.** Why record row and column for every plot?

**⭐⭐ Q3.** In the worked example, why did *p* change from 0.98 to 0.035?

**⭐⭐ Q4.** How should you validate a genomic prediction model meant to select among new
crosses next year?

**⭐⭐⭐ Q5.** A feed additive is tested on 400 pigs housed in 20 pens of 20. Design the
allocation and analysis.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"When there's only seed for one plot per line."* — **✔ 10/10.**
Add: replicated checks in every block provide the error estimate and adjustment.

> **Q2 — Sample answer:** *"For spatial analysis."* — **✔ 9/10.** And to diagnose field
trends after the fact; without coordinates you cannot model them.

> **Q3 — Sample answer:** *"Blocking removed the gradient from the error."* — **✔ 10/10.**

> **Q4 — Sample answer:** *"Cross-validation."* — **◑ 4/10.** Which kind matters: hold out
whole **families/crosses** (and ideally a future year), because random line splits put
relatives in both sets and overstate accuracy [@runcie2019].

> **Q5 — Sample answer:** *"Randomize pens to additive or control, 10 each; analyse pen
means."* — **✔ 9/10.** Improve with blocking: pair pens by barn location or starting
weight and randomize within pairs; record individual weights but analyse with pen as the
unit or random effect; blinded feed codes.

**Rubric:** breeding answers need the unit, the block/spatial structure and the
environments.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Field designs** | RCBD → α/row–column → augmented → p-rep as entries grow and seed shrinks. |
| **Spatial analysis** | Record coordinates; model neighbour correlation. |
| **Environments** | The unit for generalization under G × E. |
| **Genomic selection** | Training-set design and use-matched validation. |
| **Livestock** | Pen/herd as unit; REFLECT. |

**Traps to remember:** alphabetical plots · single site · random-split GS validation ·
animals as *n* in pen trials.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Field design matched to entries and seed | |
| Checks and their frequency | |
| Coordinates recorded; spatial model planned | |
| Environments (locations × years) | |
| Validation mimics intended selection | |

---

## 🔗 Go Deeper

- 🌾 **Hands-on sub-course:** [Field Experiments in Agriculture & Plant Breeding](../subcourses/field-trials/README.md) — real field maps, design generation and mixed-model analysis in R.
- 📘 Biostat course: [Ch. 13 — ANOVA](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/13-anova.md) · [Ch. 33 — Mixed Models](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/33-hierarchical-mixed-models.md) · [Ch. 22 — Cross-Validation](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/22-cross-validation.md)
- Field and breeding design classics: [@mead2012]

<!-- REFS -->

---

[← Chapter 18](18-biotech-bioprocess-pharmacy.md) · [Table of Contents](../README.md) · [Next: Chapter 20 — Genetics, Genomics and Transcriptomics →](20-genetics-genomics-transcriptomics.md)
