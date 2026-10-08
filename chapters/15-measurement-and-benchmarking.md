# Chapter 15 — Measurement, Validation and Benchmarking (Q8)

> **Part III — Designs by Question Type**
> [← Chapter 14](14-screening-designs.md) · [Table of Contents](../README.md) · [Next: Chapter 16 — Molecular and Cell Biology, Biochemistry →](16-molecular-cell-biochemistry.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Distinguish **accuracy, precision, repeatability, reproducibility** and **agreement**.
2. Design a method-comparison study and analyse it with **Bland–Altman** limits of agreement.
3. Plan a multi-laboratory (ring) study.
4. Design a **neutral computational benchmark** and a simulation study (ADEMP).

---

## 🎯 The Big Picture

Every other question type assumes the measurements mean what we think they mean.
Measurement questions — *is this assay, instrument or algorithm valid?* — check that
assumption. They include assay validation, inter-laboratory ring trials,
diagnostic-accuracy studies, and benchmarks of bioinformatics tools.

These studies are experiments in which the "treatments" are **methods** and the "units"
are **samples, laboratories or datasets**. They need ground truth, realistic variety and
replication — and protection against the developer's natural optimism.

---

## 🧠 Core Intuition

### Vocabulary

| Term | Question | Design element |
|---|---|---|
| **Trueness** | Is the average close to the reference value? | reference materials; assess bias |
| **Accuracy** | Are results close to the reference, considering bias and scatter? | assess both trueness and precision |
| **Precision** | How much does it scatter? | replicate measurements |
| **Repeatability** | Same lab, same operator, short time | within-run replicates |
| **Reproducibility** | Different labs, operators, instruments | ring trials |
| **Agreement** | Can method B replace method A? | paired measurements, Bland–Altman |
| **Diagnostic accuracy** | Does the test classify correctly? | sensitivity/specificity vs reference standard (STARD) |

![Four measurement properties distinguished: trueness is closeness of the average to the true value, precision is agreement among repeats, accuracy combines both for a single measurement, and agreement is whether two methods give interchangeable numbers](figures/diagrams/15-measurement-and-benchmarking-eb52c068c7.png)

### Correlation is not agreement

Two methods can correlate almost perfectly while one consistently reads 20% higher.
Correlation measures *association*. Agreement asks whether the *differences* are small
enough to matter. Use **Bland–Altman** analysis: plot differences against means, and
report the **bias** (mean difference) and **95% limits of agreement**
(bias ± 1.96 × SD of differences) ([Martin Bland & Altman, 1986](https://doi.org/10.1016/s0140-6736%2886%2990837-8)).

![Two methods can correlate almost perfectly yet disagree: a constant offset, a proportional difference or increasing scatter all leave the correlation high while the numbers differ](figures/diagrams/15-measurement-and-benchmarking-7fe9412671.png)

### Inter-laboratory studies

Multi-site studies show what reproducibility is achievable under standardized protocols.
Microarray and RNA-seq consortia (MAQC/SEQC) ([Shi et al., 2006](https://doi.org/10.1038/nbt1239); [SEQC/MAQC-III Consortium, 2014](https://doi.org/10.1038/nbt.2957)) and multi-lab
targeted and DIA proteomics studies ([Addona et al., 2009](https://doi.org/10.1038/nbt.1546); [Collins et al., 2017](https://doi.org/10.1038/s41467-017-00249-5)) are examples. Design: the
**same** samples (including reference materials) sent to several labs, each following the
protocol, with replicates within labs, so that within- and between-lab variance can be
separated.

### Benchmarks of computational methods

A benchmark is an experiment ([Weber et al., 2019](https://doi.org/10.1186/s13059-019-1738-8); [Mangul et al., 2019](https://doi.org/10.1038/s41467-019-09406-4)):

- **Purpose and scope** defined in advance.
- **Method selection** that is comprehensive or justified, not just favourable.
- **Datasets** with ground truth — simulations, spike-ins, mixtures, reference samples
  (e.g. Genome in a Bottle for variant calling ([Krusche et al., 2019](https://doi.org/10.1038/s41587-019-0054-x))) — spanning realistic
  conditions.
- **Several metrics** and **many datasets**, not one showcase.
- **Neutrality:** comparisons by people not invested in one method are less biased
  ([Boulesteix et al., 2013](https://doi.org/10.1371/journal.pone.0061562)).

### Simulation studies: ADEMP

Plan **A**ims, **D**ata-generating mechanisms, **E**stimands, **M**ethods and
**P**erformance measures in advance, and choose the number of simulation repetitions
from the Monte-Carlo error you can accept ([Morris et al., 2019](https://doi.org/10.1002/sim.8086)).

---

## 👁️ Visual Intuition — a Bland–Altman plot (sketch)



![Left: scatter of device versus lab with r = 0.993. Right: Bland-Altman plot with bias 0.57 and limits 0.22 to 0.92](../assets/course/ch15-bland-altman.png)

*The worked example's data, plotted. Code: scripts/course/figures.R.*


---

## 🔬 Worked Example — does a point-of-care device agree with the lab?

Ten blood samples measured on the lab analyser (A) and a new device (B), mmol/L:

| A | 5.1 | 6.3 | 7.8 | 4.9 | 9.2 | 6.7 | 8.1 | 5.5 | 7.0 | 6.1 |
|---|---|---|---|---|---|---|---|---|---|---|
| B | 5.6 | 6.9 | 8.1 | 5.6 | 10.0 | 7.1 | 8.9 | 6.0 | 7.4 | 6.8 |

1. **Correlation:** r = **0.993** — tempting to declare "excellent agreement".
2. **Differences B − A:** mean (bias) = **+0.57 mmol/L**; 95% limits of agreement
   **+0.22 to +0.92 mmol/L**.
3. **Interpretation:** the device reads systematically higher, by up to about 0.9 mmol/L.
   Whether that matters depends on pre-specified acceptable differences, not on *r*.
   These limits estimate the spread of individual differences, **not a CI for the
   mean bias**. The bias and limits themselves have uncertainty. Check for differences
   that grow with concentration (consider ratios/log scale) and account for repeated
   measurements from the same participant.
4. **Design lessons:** cover the **whole clinical range**, measure **in random order**
   with both methods on the same sample at the same time, include **replicates** to
   estimate each method's repeatability, and use a sample size large enough to estimate
   the limits of agreement precisely (10 is only for illustration).

(Code: `scripts/course/worked_examples.R`.)

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"High correlation = methods agree."** | Correlation ignores bias and depends on the range of values. |
| **"Validated once, valid forever."** | Reagent lots, instruments and sample types change. Re-verify after changes and run QC samples. |
| **"Our new tool wins the benchmark."** | Developers' benchmarks are optimistic. Look for independent, neutral comparisons on many datasets. |
| **"Simulation proves the method works."** | Only under the simulated data-generating mechanism. Test on real data with known truth too. |
| **"Sensitivity and specificity are fixed properties of a test."** | They depend on the patient spectrum and the reference standard (STARD) ([Bossuyt et al., 2015](https://doi.org/10.1136/bmj.h5527)). |

---

## 🧪 Spot the Flaw

> "We present FastAlign, a new aligner. On a simulated dataset generated with our own
> simulator, FastAlign achieved the highest accuracy among three tools (FastAlign and
> two older versions of popular aligners run with default parameters)."

<details>
<summary>▶ Diagnosis</summary>

Several benchmark biases: data generated by the **authors' own simulator** (may favour
their model assumptions); **one dataset**; **cherry-picked and outdated competitors**
with untuned defaults; no real data with ground truth. **Fix:** several independent
simulators and real reference datasets, current competitor versions with recommended
settings, several metrics, and code and data released for re-analysis ([Weber et al., 2019](https://doi.org/10.1186/s13059-019-1738-8)).
</details>

---

## 🔎 The Reviewer's Perspective

- **"What is the ground truth, and how was it established?"**
- **"Is agreement analysed with differences, not correlation?"**
- **"Do the samples/datasets cover the realistic range of conditions?"**
- **"Who ran the benchmark — and are competitor methods fairly configured?"**

---

## 🛠️ Design Challenges

Three measurement (Q8) problems: validating an assay, testing agreement between two
methods, and testing agreement between people. For each, name the property you are
measuring (accuracy, precision, agreement, reliability) — then open the model answer.

### Challenge 1 · Plant diagnostics · ⭐⭐ — validating a qPCR assay

Your lab developed a qPCR assay to quantify a plant pathogen. Plan its validation before
it is used in field surveys.

<details>
<summary>▶ A model design</summary>

- **Specificity:** test DNA from related non-target species and healthy plants.
- **Standard curve:** 6–7 tenfold dilutions of a quantified standard, in triplicate,
  on ≥ 3 runs → efficiency, linear range, limit of detection/quantification.
- **Repeatability and intermediate precision:** the same samples across days and
  operators.
- **Agreement:** compare with an established method (e.g. culture or a published assay)
  on field samples covering the range; Bland–Altman.
- **Controls every run:** no-template, positive control, extraction blank, inhibition
  control. Report with MIQE ([Bustin et al., 2009](https://doi.org/10.1373/clinchem.2008.112797)).

![Validation plan for a qPCR assay with four components — specificity against non-targets, a standard curve over three runs giving efficiency, range and limits, precision across days and operators, and agreement with an established method on field samples — plus controls in every run](figures/diagrams/15-measurement-and-benchmarking-79aecf459e.png)
</details>

### Challenge 2 · Digital health · ⭐⭐ — a wrist-worn heart-rate monitor

A company claims its wrist-worn device measures heart rate as well as an ECG chest strap.
You will test this in 40 adults. The device will be used during daily life, including
exercise. Design the agreement study.

<details>
<summary>▶ A model design</summary>

- **Reference:** a simultaneous ECG (the accepted reference), time-synchronized with the
  device.
- **Conditions that matter for use:** rest, walking, running, and recovery — wrist devices
  often fail during movement. Each participant goes through all conditions, so each has
  **repeated paired measurements**.
- **Participants:** a spectrum of ages, skin tones (optical sensors can perform differently),
  wrist sizes and fitness — agreement must hold across the people who will use it.
- **Pre-specify** the acceptable limits of agreement (e.g. ±5 beats per minute, chosen
  from clinical or training needs) **before** collecting data.
- **Analysis:** **Bland–Altman** (bias and 95% limits of agreement), using a method that
  accounts for repeated measurements per person; report separately by condition.
  Correlation is *not* agreement (Chapter 15).

![Agreement study: 40 participants chosen across ages, skin tones and fitness each wear the device and an ECG simultaneously through rest, walking, running and recovery; Bland-Altman analysis with repeated measures per condition is compared with limits of agreement fixed in advance](figures/diagrams/15-measurement-and-benchmarking-ecacc26665.png)
</details>

### Challenge 3 · Pathology · ⭐⭐ — do pathologists agree?

A new 4-grade scoring system for liver fibrosis on biopsies will be used in a clinical trial.
Before that, you must show that pathologists apply it consistently. You have 3 pathologists
and an archive of biopsies.

<details>
<summary>▶ A model design</summary>

- **Two properties:** **inter-rater reliability** (do different pathologists agree?) and
  **intra-rater reliability** (does each agree with themselves?).
- **Cases:** about 100 biopsies chosen to cover **all grades** (a spectrum) — reliability
  measured only on easy or only on mild cases is misleading.
- **Procedure:** each pathologist scores all slides **independently**, blinded to clinical
  information and to the others' scores, in a **random order**; then re-scores all slides
  after a washout (e.g. ≥ 4 weeks) in a new random order.
- **Training first:** a short calibration session on separate slides, not on the test set.
- **Analysis:** weighted κ (ordinal grades) for pairs, or an ICC/Krippendorff's α for all
  three; report agreement per grade and where disagreements happen.

![Reliability study: 100 biopsies covering all four grades are scored independently by three blinded pathologists in random order, then rescored after a washout; inter-rater agreement compares pathologists and intra-rater agreement compares each pathologist's two rounds](figures/diagrams/15-measurement-and-benchmarking-25a48e806c.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** Distinguish repeatability from reproducibility.

**⭐ Q2.** Why is correlation inappropriate for assessing agreement?

**⭐⭐ Q3.** Differences between methods have mean −0.3 and SD 0.5. Compute the 95% limits
of agreement.

**⭐⭐ Q4.** List five properties of a good computational benchmark.

**⭐⭐⭐ Q5.** Design a three-lab ring trial for a metabolomics platform. What samples,
replication and analysis would you use?

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Repeatability: same conditions; reproducibility: different
labs/operators."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"Because correlation doesn't detect bias."* — **✔ 9/10.** Also:
correlation increases with the range of values, regardless of how well the methods agree.

> **Q3 — Sample answer:** *"−0.3 ± 1.96 × 0.5 → −1.28 to +0.68."* — **✔ 10/10.**

> **Q4 — Sample answer:** *"Ground truth, many datasets, fair competitor settings,
multiple metrics, neutrality."* — **✔ 10/10.**

> **Q5 — Sample answer:** *"Send the same samples to three labs and compare."* —
**◑ 5/10.** Add design detail: identical aliquots of study-like samples plus reference
materials and a pooled QC; replicate injections within each lab and on several days;
randomized run order; a shared SOP; analysis with a variance-components (mixed) model
separating within-run, between-day and between-lab variance.

**Rubric:** measurement studies need ground truth, replication at each level of
variation, and an analysis that separates those levels.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Vocabulary** | Accuracy, precision, repeatability, reproducibility, agreement. |
| **Agreement** | Bland–Altman bias and limits, not correlation. |
| **Ring trials** | Same samples, many labs, replicates at each level. |
| **Benchmarks** | Ground truth, many datasets, fair competitors, neutrality. |
| **Simulations** | Plan with ADEMP; test on real data too. |

**Traps to remember:** r = 0.99 "agreement" · one showcase dataset · untuned competitors ·
validated-once assays.

### 📇 Design Card — add these rows (Q8)

| Field | Your answer |
|---|---|
| Ground truth/reference standard | |
| Levels of variation to estimate (run, day, operator, lab) | |
| Range of samples or datasets | |
| Metrics and acceptance criteria | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 24 — Evaluating Classifiers](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/24-classifier-evaluation.md) · [Ch. 15 — Correlation, Causation, and Confounding](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/15-correlation-causation.md)
- Reproducible computational work: ([Sandve et al., 2013](https://doi.org/10.1371/journal.pcbi.1003285); [Noble, 2009](https://doi.org/10.1371/journal.pcbi.1000424))

## 📚 References cited in this chapter

- Addona TA, Abbatiello SE, Schilling B, Skates SJ, Mani DR, Bunk DM, et al. (2009). Multi-site assessment of the precision and reproducibility of multiple reaction monitoring–based measurements of proteins in plasma. *Nature Biotechnology* 27:633-641. [doi:10.1038/nbt.1546](https://doi.org/10.1038/nbt.1546)
- Bossuyt PM, Reitsma JB, Bruns DE, Gatsonis CA, Glasziou PP, Irwig L, et al. (2015). STARD 2015: an updated list of essential items for reporting diagnostic accuracy studies. *BMJ*:h5527. [doi:10.1136/bmj.h5527](https://doi.org/10.1136/bmj.h5527)
- Boulesteix AL, Lauer S, Eugster MJA (2013). A Plea for Neutral Comparison Studies in Computational Sciences. *PLoS ONE* 8:e61562. [doi:10.1371/journal.pone.0061562](https://doi.org/10.1371/journal.pone.0061562)
- Bustin SA, Benes V, Garson JA, Hellemans J, Huggett J, Kubista M, et al. (2009). The MIQE Guidelines: Minimum Information for Publication of Quantitative Real-Time PCR Experiments. *Clinical Chemistry* 55:611-622. [doi:10.1373/clinchem.2008.112797](https://doi.org/10.1373/clinchem.2008.112797)
- Collins BC, Hunter CL, Liu Y, Schilling B, Rosenberger G, Bader SL, et al. (2017). Multi-laboratory assessment of reproducibility, qualitative and quantitative performance of SWATH-mass spectrometry. *Nature Communications* 8:291. [doi:10.1038/s41467-017-00249-5](https://doi.org/10.1038/s41467-017-00249-5)
- Krusche P, Trigg L, Boutros PC, Mason CE, De La Vega FM, Moore BL, et al. (2019). Best practices for benchmarking germline small-variant calls in human genomes. *Nature Biotechnology* 37:555-560. [doi:10.1038/s41587-019-0054-x](https://doi.org/10.1038/s41587-019-0054-x)
- Mangul S, Martin LS, Hill BL, Lam AKM, Distler MG, Zelikovsky A, et al. (2019). Systematic benchmarking of omics computational tools. *Nature Communications* 10:1393. [doi:10.1038/s41467-019-09406-4](https://doi.org/10.1038/s41467-019-09406-4)
- Martin Bland J, Altman D (1986). STATISTICAL METHODS FOR ASSESSING AGREEMENT BETWEEN TWO METHODS OF CLINICAL MEASUREMENT. *The Lancet* 327:307-310. [doi:10.1016/s0140-6736(86)90837-8](https://doi.org/10.1016/s0140-6736%2886%2990837-8)
- Morris TP, White IR, Crowther MJ (2019). Using simulation studies to evaluate statistical methods. *Statistics in Medicine* 38:2074-2102. [doi:10.1002/sim.8086](https://doi.org/10.1002/sim.8086)
- Noble WS (2009). A Quick Guide to Organizing Computational Biology Projects. *PLoS Computational Biology* 5:e1000424. [doi:10.1371/journal.pcbi.1000424](https://doi.org/10.1371/journal.pcbi.1000424)
- Sandve GK, Nekrutenko A, Taylor J, Hovig E (2013). Ten Simple Rules for Reproducible Computational Research. *PLoS Computational Biology* 9:e1003285. [doi:10.1371/journal.pcbi.1003285](https://doi.org/10.1371/journal.pcbi.1003285)
- SEQC/MAQC-III Consortium (2014). A comprehensive assessment of RNA-seq accuracy, reproducibility and information content by the Sequencing Quality Control Consortium. *Nature Biotechnology* 32:903-914. [doi:10.1038/nbt.2957](https://doi.org/10.1038/nbt.2957)
- Shi L, Shi L, Reid LH, Jones WD, Shippy R, Warrington JA, et al. (2006). The MicroArray Quality Control (MAQC) project shows inter- and intraplatform reproducibility of gene expression measurements. *Nature Biotechnology* 24:1151-1161. [doi:10.1038/nbt1239](https://doi.org/10.1038/nbt1239)
- Weber LM, Saelens W, Cannoodt R, Soneson C, Hapfelmeier A, Gardner PP, et al. (2019). Essential guidelines for computational method benchmarking. *Genome Biology* 20:125. [doi:10.1186/s13059-019-1738-8](https://doi.org/10.1186/s13059-019-1738-8)


---

[← Chapter 14](14-screening-designs.md) · [Table of Contents](../README.md) · [Next: Chapter 16 — Molecular and Cell Biology, Biochemistry →](16-molecular-cell-biochemistry.md)
