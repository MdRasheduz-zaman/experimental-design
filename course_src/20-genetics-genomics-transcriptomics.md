# Chapter 20 — Genetics, Genomics and Transcriptomics

> **Part IV — Field Playbooks**
> [← Chapter 19](19-breeding-and-field-trials.md) · [Table of Contents](../README.md) · [Next: Chapter 21 — Proteomics, Metabolomics and Multi-Omics →](21-proteomics-metabolomics-multiomics.md)

---

<details>
<summary>🧬 <b>Biology primer</b> — sequencing terms (expand if new)</summary>

- **Library:** DNA/cDNA fragments prepared for sequencing from one sample.
- **Depth:** number of reads per sample (e.g. 20 million).
- **Multiplexing:** pooling barcoded libraries so many samples share a sequencing run.
- **Pseudobulk:** summing single-cell counts per donor (and cell type) to get one profile per biological unit.
- **Input/control library (ChIP-seq):** chromatin not enriched by the antibody, used as background.

</details>

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Summarize the design logic of QTL mapping, GWAS and functional genomics assays.
2. Decide between **more biological replicates** and **more sequencing depth** for RNA-seq.
3. Lay out libraries and runs so that batches never align with conditions.
4. Design single-cell studies around **donors**, with multiplexing and pseudobulk analysis.
5. Specify the controls and replication required for ChIP-seq and similar assays.

**Dominant question types:** comparative (Q2), descriptive (Q1), associational (Q4), screening (Q7).

---

## 🎯 The Big Picture

High-throughput sequencing changes the scale, not the principles. Three features reshape
design: **thousands of features per sample** (multiplicity sets the threshold), **many
processing steps** (each a potential batch), and **high per-sample cost** (constant
pressure to cut replicates). The principles of Part II still decide whether an omics
experiment can answer its question.

---

## 🧠 Core Intuition — the genomics playbook

### 1. Genetics

- **QTL mapping** in experimental crosses: cross type, population size, marker density and
  phenotyping replication set power and resolution [@lander1989; @mackay2009].
- **GWAS** (Chapter 11): large samples, 5 × 10⁻⁸ threshold, stratification control,
  replication cohorts, ancestral diversity [@visscher2017; @price2006; @peterson2019].
- **Clinical variant interpretation** combines structured evidence rather than single
  tests [@richards2015].

### 2. Depth and coverage depend on the question

Variant calling, assembly, peak calling and expression counting have different depth
needs [@sims2014]. For chromatin profiling, ENCODE guidelines require biological replicates,
matched input/control libraries and depth thresholds depending on whether marks are
punctate or broad [@landt2012]. Methylation studies need methods that handle general
designs with replicates [@park2016].

### 3. RNA-seq: replicates beat depth

Deeper sequencing reduces *sampling* noise, but **biological variability is not removed by
depth** [@hansen2011]. Once a gene has a moderate number of reads, extra depth adds little,
whereas extra replicates keep helping [@liu2014]. With 48 replicates per condition in yeast,
at least six biological replicates were needed for robust detection of differential
expression, and twelve to find most changes [@schurch2016; @conesa2016]. Plan with power
tools that use realistic dispersions [@hart2013; @ching2014]. Count models with shared
dispersion estimation accommodate blocking terms [@love2014; @robinson2010; @ritchie2015; @auer2010].

```mermaid
%% alt: Sequencing depth and biological replication answer different limits: depth decides which transcripts are detected at all, while the number of independent samples decides whether a difference between groups can be distinguished from biological variation
flowchart TB
  D["More reads per sample"]:::ctl --> D1["Better detection of low-expressed transcripts,<br/>isoforms and allele-specific signal"]:::note
  D --> D2["Beyond a point, gene-level differential expression<br/>gains almost nothing"]:::bad
  R["More biological replicates"]:::trt --> R1["Better estimate of biological variation<br/>→ the comparison between groups"]:::ok
  R --> R2["This is what power for differential expression depends on"]:::ok
  D2 ~~~ R1
  N["Fixed budget: spend it on samples first,<br/>then on the depth the question needs"]:::ok
```

### 4. Batch layout

Balance conditions across RNA extraction days, library-prep batches and sequencing
runs/lanes (Chapter 5). Correction methods (ComBat, ComBat-seq) need group and batch effects to be
separable; perfect balance helps but is not required in every identifiable design [@johnson2007; @zhang2020; @nygaard2016]. Microarray-era work established both the
efficiency of balanced designs [@kerr2001; @churchill2002] and the reproducibility achievable
with standardization [@maqc2006; @seqc2014].

```mermaid
%% alt: Sequencing work happens in stages — collection, extraction, library preparation, pooling and flow cell or lane — and each stage is a batch that should contain all groups rather than one group at a time
flowchart TB
  A["Collection/harvest<br/><i>day, operator, time of day</i>"]:::note --> B["RNA extraction<br/><i>kit lot, batch</i>"]:::note
  B --> C["Library preparation<br/><i>day, kit lot, index set</i>"]:::note
  C --> D["Pooling + flow cell/lane"]:::note
  D --> E["Sequencing run"]:::note
  A & B & C & D & E -. "each is a batch" .-> R["Rule: every batch at every stage holds all groups,<br/>in randomized positions; record the batch of each sample"]:::ok
  R --> M["Then the model can include batch — if groups are confounded with it, it cannot"]:::bad
```

### 5. Single-cell and spatial

- **Donors are the unit.** Tests treating cells as replicates produce floods of false
  positives; **pseudobulk** or mixed models restore error control [@squair2021; @zimmerman2021].
- **Multiplex** samples from different conditions into the same capture (genetic or
  hashtag demultiplexing) so batch and condition are separable [@tung2017; @barangale2018].
- Integration methods are benchmarked [@luecken2022; @tran2020; @haghverdi2018] but cannot
  fix confounding. Best-practice workflows: [@luecken2019; @heumos2023].
- Protocol choice affects sensitivity [@svensson2017].
- **Spatial transcriptomics** adds sections and regions as further nesting levels
  [@moses2022].

### 6. Time-courses

Sampling density, synchronization and replication at each time point are design choices
[@barjoseph2012].

---

## 👁️ Visual Intuition

![Replicates versus depth](../assets/fig_simulations.png)

*Panel b: power to detect a 1.5-fold change for a gene with biological dispersion 0.1.
Going from a mean of 100 to 1,000 reads changes power very little at any replicate
number; going from 2 to 12 replicates raises power from about 25% to over 85%.*

---

## 🔬 Worked Example — spend the budget on replicates or depth?

Using the simulation behind panel b (negative-binomial counts, dispersion 0.1, true
1.5-fold change, α = 0.05; code: `scripts/05_figures.R`):

| Design per group | Mean reads for the gene | Power |
|---|---|---|
| 3 replicates, deep | 1,000 | 0.34 |
| 3 replicates, moderate | 100 | 0.34 |
| 6 replicates, moderate | 100 | 0.57 |
| 12 replicates, moderate | 100 | 0.85 |
| 12 replicates, shallow | 10 | 0.65 |

- **3 deep samples** (3,000 reads per group for this gene) have *lower* power than
  **12 moderate samples** (1,200 reads per group).
- Very shallow sequencing does hurt (mean 10), so depth must be *adequate*, not maximal.
- **Lesson:** after adequate depth, put money into biological replicates — library prep is
  usually cheaper than an underpowered study. Multiplex more samples per run at lower
  depth.

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Deeper sequencing = more power."** | Only up to adequate depth. Replicates dominate. |
| **"Thousands of cells = large *n*."** | Donors are the unit. |
| **"Batch correction will fix it."** | Only if group and batch can be separated; a balanced layout is preferable. |
| **"Two replicates per condition are standard."** | They are common, and badly underpowered for modest fold changes. |
| **"A GWAS hit identifies the causal gene."** | It identifies an associated region. |

---

## 🧪 Spot the Flaw

> "We performed scRNA-seq on PBMCs from 2 patients and 2 healthy donors (one 10x lane
> per donor, processed on four different days). Differential expression in monocytes
> (Wilcoxon test on 8,000 cells) found 1,450 significant genes."

<details>
<summary>▶ Diagnosis</summary>

- **n = 2 vs 2 donors**; cells are pseudoreplicates → the 1,450 genes are mostly
  donor-level noise treated as signal [@squair2021].
- **Donor = lane = day**: donor and processing effects cannot be separated.
  With one donor per batch and two batches per condition, this is not the same as
  all cases sharing one batch and all controls another; both designs still benefit
  from multiplexing and more donors.
- **Fix:** more donors (e.g. 6+ per group), multiplex donors from both groups in each lane
  with genetic demultiplexing, pseudobulk per donor × cell type, and a model including
  batch.
</details>

---

## 🔎 The Reviewer's Perspective

- **"How many biological replicates per condition, and how was that justified?"**
- **"Group × batch table for extraction, library prep and sequencing?"**
- **"For single-cell: donors per group, multiplexing, pseudobulk or mixed model?"**
- **"Controls and replicate concordance for ChIP-seq/ATAC-seq?"**

---

## 🛠️ Design Challenges

Three genomics designs: a bulk RNA-seq budget, a multiplexed single-cell study and an
evolution experiment read out by sequencing. For each, decide how many **independent
units** you need before deciding how deeply to sequence them — then open the model answer
and its diagram.

### Challenge 1 · Transcriptomics · ⭐⭐ — replicates or depth?

Budget: €12,000 for bulk RNA-seq of liver from mice on two diets × two sexes. Library prep
costs €100 per sample. Sequencing costs €300 per 100 million reads, in multiples of 100 M.
Design the study.

<details>
<summary>▶ A model design</summary>

- **Allocation:** prioritize replicates: e.g. 10 mice per diet × sex = 40 samples → €4,000
  library prep.
- **Depth:** €8,000 buys 2.6 billion reads → about 65 M reads per sample. That is more than
  needed for standard gene-level differential expression. Consider 48 samples (12 per group
  → €4,800 prep) at ~25–30 M reads each (12 × 100 M = 1.2 B for €3,600), leaving a reserve.
- **Batches:** each extraction/library batch contains all four diet × sex groups;
  all libraries multiplexed across all lanes.
- **Analysis:** `~ batch + sex * diet`, with the interaction if sex-specific effects are of
  interest (and power for it checked by simulation).

```mermaid
%% alt: Two ways to spend 12,000 euros: 40 mice at about 65 million reads each uses the budget on depth, while 48 mice at about 25 million reads each buys more independent replicates and leaves a reserve of 3,600 euros; every library batch contains all four diet by sex groups
flowchart TB
  B["Budget €12,000 · prep €100/sample · €300 per 100 M reads"]:::note
  B --> A["Option A · 40 mice (10 per group)<br/>prep €4,000 + 2.6 B reads €7,800<br/>≈ 65 M reads each — more depth than needed"]:::bad
  B --> C["Option B · 48 mice (12 per group)<br/>prep €4,800 + 1.2 B reads €3,600<br/>≈ 25 M reads each · €3,600 reserve"]:::ok
  C --> BT["Every library batch holds all 4 diet × sex groups<br/>analysis: ~ batch + sex * diet"]:::ok
```
</details>

### Challenge 2 · Single-cell genomics · ⭐⭐⭐ — patients and controls on four lanes

You will compare blood immune cells of 8 patients and 8 healthy donors by single-cell
RNA-seq. Each microfluidic lane (one "run" of the instrument) can take cells from 4 people
at once, and you can afford 4 lanes. Design the layout and the analysis.

<details>
<summary>▶ A model design</summary>

- **Pool donors per lane:** **2 patients + 2 healthy donors in every lane**, assigned at
  random; cells are later assigned to their donor by **genetic demultiplexing** (natural
  SNP differences between people) [@tung2017]. Lane (a batch) is then balanced across groups
  instead of confounded with them, and doublets between people can be detected.
- **Same day, same protocol** for sample thawing and processing where possible; if samples
  are processed on 2 days, each day also gets both groups.
- **The donor is the unit:** thousands of cells per donor are sub-units (Chapter 3). Compare
  groups with **pseudobulk** (sum counts per donor and cell type) and a model
  `~ lane + group`, or a mixed model with donor as random effect — **not** a test treating
  cells as replicates.
- **Cell-type proportions** are compared per donor too (16 values, not thousands of cells).

```mermaid
%% alt: Four single-cell lanes, each pooling cells from two patients in orange and two healthy donors in blue, assigned at random; genetic demultiplexing assigns cells to donors, and donors are analysed by pseudobulk with lane as a block
flowchart TB
  subgraph LANES["4 lanes = batches · 2 patients (P) + 2 healthy (H) per lane, drawn at random"]
    subgraph L1["Lane 1"]
      direction TB
      a1["P2"]:::trt
      a2["P5"]:::trt
      a3["H3"]:::ctl
      a4["H2"]:::ctl
    end
    subgraph L2["Lane 2"]
      direction TB
      b1["P7"]:::trt
      b2["H6"]:::ctl
      b3["P4"]:::trt
      b4["H5"]:::ctl
    end
    subgraph L3["Lane 3"]
      direction TB
      c1["P1"]:::trt
      c2["P6"]:::trt
      c3["H7"]:::ctl
      c4["H8"]:::ctl
    end
    subgraph L4["Lane 4"]
      direction TB
      d1["H1"]:::ctl
      d2["P8"]:::trt
      d3["P3"]:::trt
      d4["H4"]:::ctl
    end
  end
  LANES --> DM["Genetic demultiplexing → cells assigned to donors<br/>(+ doublet detection)"]:::note
  DM --> PB["Pseudobulk per donor × cell type<br/>n = 8 vs 8 donors · ~ lane + group"]:::ok
```
</details>

### Challenge 3 · Experimental evolution · ⭐⭐ — how do bacteria adapt to an antibiotic?

You will evolve *E. coli* under a sub-lethal antibiotic concentration for 500 generations
and identify the mutations responsible for adaptation by whole-genome sequencing. You can
maintain 24 populations in a 96-well plate with daily transfers.

<details>
<summary>▶ A model design</summary>

- **One ancestor:** start all populations from a single sequenced clone, so every mutation
  found later arose during the experiment.
- **Replicate populations are the units:** **12 with antibiotic, 12 without** (controls
  adapting to the medium and the lab). Adaptation specific to the antibiotic shows up as
  genes mutated repeatedly in the antibiotic populations but not in the controls
  (**parallel evolution** is the evidence).
- **Plate layout:** alternate or randomize treatment positions; leave empty wells between
  populations to detect cross-contamination; use a genetic marker (e.g. two neutral marker
  variants in alternating populations) to catch contamination.
- **Frozen record:** freeze every population regularly (e.g. every 50 generations) so
  mutations can be dated and fitness measured later against the ancestor.
- **Sequencing:** whole-population sequencing at ≥ 100× depth finds mutations at ≥ ~10%
  frequency; sequence the ancestor too; follow up with clones and reconstruct key mutations
  in the ancestor to test their effect (Q3).

```mermaid
%% alt: Evolution experiment: a single sequenced ancestor founds 12 populations with antibiotic and 12 controls without, kept in alternating plate positions with empty wells and neutral markers; populations are frozen regularly, sequenced at 100-fold depth, and genes mutated repeatedly only in antibiotic populations are tested by reconstruction in the ancestor
flowchart TB
  A["One sequenced ancestor clone"]:::note --> P
  subgraph P["24 populations · alternating positions · empty wells · neutral markers"]
    subgraph Pr[" "]
      direction TB
      T["12 × antibiotic"]:::trt
      C["12 × no antibiotic<br/>(lab adaptation control)"]:::ctl
    end
  end
  style Pr fill:none,stroke:none
  P --> F["Freeze every ~50 generations (fossil record)"]:::note
  F --> S["Population sequencing ≥ 100× at the end"]:::note
  S --> PAR["Genes mutated in parallel only with antibiotic"]:::ok
  PAR --> REC["Reconstruct mutations in the ancestor → test effect"]:::ok
```
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** Why doesn't deeper sequencing remove biological variability?

**⭐ Q2.** What is pseudobulk, and why is it used?

**⭐⭐ Q3.** Using the table above, which design would you choose for a 1.5-fold change: 6
replicates at mean 100 reads, or 3 replicates at mean 1,000? Why?

**⭐⭐ Q4.** List the controls and replication ENCODE requires for ChIP-seq.

**⭐⭐⭐ Q5.** Design a single-cell study comparing tumour-infiltrating T cells between
responders and non-responders to immunotherapy.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Because the variability is between animals, not between
reads."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"Adding up cells per donor so the donor is the unit."* —
**✔ 10/10.** It turns a pseudoreplicated cell-level test into a properly replicated
donor-level test.

> **Q3 — Sample answer:** *"6 at 100 — power 0.57 vs 0.34, and fewer total reads."* —
**✔ 10/10.**

> **Q4 — Sample answer:** *"Input control and two replicates."* — **✔ 8/10.** Plus depth
thresholds by mark type and replicate-concordance metrics [@landt2012].

> **Q5 — Sample answer:** *"Sequence T cells from responders and non-responders."* —
**◑ 4/10.** Needs: patients as units (enough per group, justified by simulation);
standardized biopsy timing and handling; multiplexing samples across responder status in
each capture; hashtags/genotypes to demultiplex; pseudobulk by patient × cell state;
adjustment for tumour type and prior treatment; a validation cohort.

**Rubric:** omics answers need units, batch layout, and depth *only as much as needed*.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Genetics** | Crosses and GWAS are designed by size, structure and replication. |
| **Depth** | Adequate for the assay; beyond that, replicates win. |
| **Batches** | Balance groups across every processing step. |
| **Single-cell** | Donors are the unit; multiplex; pseudobulk. |
| **Controls** | Inputs, replicates and concordance for chromatin assays. |

**Traps to remember:** 2 vs 2 · cells as *n* · lane = condition · depth over replicates.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Biological replicates per group (justified) | |
| Depth matched to assay | |
| Group × batch table for every processing step | |
| Single-cell: donors, multiplexing, pseudobulk plan | |
| Assay controls (input, spike-ins) | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 20 — Count Data Models](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/20-count-data.md) · [Ch. 28 — FDR](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/28-fdr.md) · [Ch. 29 — Batch Effects](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/29-batch-effects.md) · [Ch. 36 — Population Structure](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/36-causal-tools.md)

<!-- REFS -->

---

[← Chapter 19](19-breeding-and-field-trials.md) · [Table of Contents](../README.md) · [Next: Chapter 21 — Proteomics, Metabolomics and Multi-Omics →](21-proteomics-metabolomics-multiomics.md)
