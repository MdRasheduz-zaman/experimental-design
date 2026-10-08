# Chapter 22 — Bioinformatics, Computational Biology and Data Science

> **Part IV — Field Playbooks**
> [← Chapter 21](21-proteomics-metabolomics-multiomics.md) · [Table of Contents](../README.md) · [Next: Chapter 23 — Clinical and Preclinical Research →](23-clinical-and-preclinical.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Treat computational studies — benchmarks, simulations, analyses of public data — as **designed experiments**.
2. Plan a neutral benchmark from purpose to metrics.
3. Build reproducibility into a computational project from day one.
4. Recognize leakage, confounding and selection problems in data-science projects on biological and health data.
5. Know when an online/digital experiment (A/B test) is the right design.

**Dominant question types:** measurement (Q8), predictive (Q5), associational (Q4).

---

## 🎯 The Big Picture

"The data already exist, so design doesn't apply" is the most common misconception in
computational biology. Design shows up in three forms:

1. **Computational experiments** — benchmarks and simulation studies (Chapter 15).
2. **Data splits** for predictive modelling (Chapter 12).
3. **Analyses of observational data** standing in for experiments (Chapter 11).

And one new form: **the analysis pipeline itself**, whose many tunable choices can be
exploited, deliberately or not, unless they are fixed and recorded.

---

## 🧠 Core Intuition — the computational playbook

### 1. Benchmarks are experiments

| Experimental concept | Benchmark equivalent |
|---|---|
| treatments | methods (and their parameter settings) |
| units | datasets |
| outcome | performance metrics |
| ground truth | simulations, spike-ins, mixtures, reference samples |
| bias control | neutrality, pre-specified protocol, fair tuning |
| replication | many datasets spanning realistic conditions |

([Weber et al., 2019](https://doi.org/10.1186/s13059-019-1738-8); [Mangul et al., 2019](https://doi.org/10.1038/s41467-019-09406-4); [Boulesteix et al., 2013](https://doi.org/10.1371/journal.pone.0061562)). Community resources with truth sets exist for
variant calling ([Krusche et al., 2019](https://doi.org/10.1038/s41587-019-0054-x)), metagenomic classification ([Ye et al., 2019](https://doi.org/10.1016/j.cell.2019.07.010)) and single-cell
integration ([Luecken et al., 2022](https://doi.org/10.1038/s41592-021-01336-8); [Tran et al., 2020](https://doi.org/10.1186/s13059-019-1850-9)).

![A benchmark seen as an experiment: methods are the treatments, datasets are the experimental units, the data-generating mechanisms and tuning budget are the design, and the performance metric is the outcome measured](figures/diagrams/22-computational-and-data-science-2dc4e7291b.png)

### 2. Simulation studies: ADEMP

Aims, Data-generating mechanisms, Estimands, Methods, Performance measures — specified in
advance, with the number of repetitions chosen from the acceptable Monte-Carlo error
([Morris et al., 2019](https://doi.org/10.1002/sim.8086)).

### 3. Reproducibility is a design requirement

- Version control; recorded software environments (containers/conda); workflow managers.
- A clear project structure separating raw data, code, results and documents ([Noble, 2009](https://doi.org/10.1371/journal.pcbi.1000424)).
- Random seeds recorded; parameters in config files, not hard-coded.
- FAIR data deposition ([Wilkinson et al., 2016](https://doi.org/10.1038/sdata.2016.18)); ten simple rules for reproducible research
  ([Sandve et al., 2013](https://doi.org/10.1371/journal.pcbi.1003285)); community software infrastructures such as Bioconductor ([Huber et al., 2015](https://doi.org/10.1038/nmeth.3252)).
- Avoid silent data corruption. Spreadsheet software converted gene symbols (e.g. *SEPT2*,
  *MARCH1*) to dates in roughly one-fifth of papers with supplementary gene lists that were
  examined ([Ziemann et al., 2016](https://doi.org/10.1186/s13059-016-1044-7)).

![A reproducible computational project separates raw data, code, environment and outputs, with every result traceable to a script and a version, so that rerunning the pipeline regenerates the figures and tables](figures/diagrams/22-computational-and-data-science-159f3c2c22.png)

### 4. Data science on biological and health data

- **Leakage** (Chapter 12) ([Kapoor & Narayanan, 2023](https://doi.org/10.1016/j.patter.2023.100804); [Whalen et al., 2022](https://doi.org/10.1038/s41576-021-00434-9)).
- **Confounding by acquisition:** site, scanner, batch or date correlated with the label;
  harmonization helps only when the design allows it ([Hu et al., 2023](https://doi.org/10.1016/j.neuroimage.2023.120125)).
- **Selection:** who is in an EHR dataset or biobank is not random. Define the target
  population (Chapter 9).
- **Reporting standards:** DOME ([Walsh et al., 2021](https://doi.org/10.1038/s41592-021-01205-4)), ML reproducibility tiers ([Heil et al., 2021](https://doi.org/10.1038/s41592-021-01256-7)), TRIPOD+AI
  ([Collins et al., 2024](https://doi.org/10.1136/bmj-2023-078378)). Reproducibility of health ML is still limited ([Beam et al., 2020](https://doi.org/10.1001/jama.2019.20866); [McDermott et al., 2021](https://doi.org/10.1126/scitranslmed.abb1655)).

![Health-record data were generated by care, not by a study: who is tested, when, and what is recorded all depend on clinical decisions, so missingness carries information and apparent associations can reflect the care process](figures/diagrams/22-computational-and-data-science-6e108e8f21.png)

### 5. When you can intervene: online controlled experiments

Digital health apps, reminder systems and decision-support tools can be evaluated by
**A/B tests**: randomize users (or clinics) to versions, pre-specify metrics, check that the
sample-ratio matches the design, and avoid "peeking" at results repeatedly ([Kohavi et al., 2020](https://doi.org/10.1017/9781108653985)).
All of Part II applies.

---

## 👁️ Visual Intuition — a reproducible project skeleton

```
project/
├── data/raw/          ← read-only, never edited
├── data/processed/    ← produced by code only
├── code/              ← scripts / workflow (Snakemake, Nextflow, targets)
├── config/            ← parameters, seeds, sample sheets
├── results/           ← figures, tables (regenerable)
├── env/               ← environment.yml / Dockerfile
└── README.md          ← how to rerun everything
```

---

## 🔬 Worked Example — designing a neutral benchmark

**Question (Q8):** which differential-abundance method controls false discoveries best in
microbiome data?

1. **Purpose and scope:** methods for 16S count tables, two-group comparisons. State the
   conclusions you want to be able to draw.
2. **Methods:** all widely used methods meeting predefined criteria, run with the authors'
   recommended settings (or equal tuning effort for all).
3. **Datasets:**
   - **Null datasets:** real data assigned to two fake groups at the independent-unit level,
     preserving any blocks/clusters → a randomization null benchmark. Splitting
     correlated samples as if independent would build an invalid null into the benchmark.
   - **Spiked datasets:** known taxa artificially altered by known amounts → sensitivity.
   - **Simulations** from more than one simulator, to avoid favouring one model.
   - Several sequencing depths and sample sizes.
4. **Metrics:** false-discovery proportion, sensitivity, calibration of *p*-values, runtime.
5. **Replication:** many datasets × many random splits; report variability, not just means.
6. **Neutrality and transparency:** protocol written before running; code, containers and
   results public.

This mirrors the guidance in ([Weber et al., 2019](https://doi.org/10.1186/s13059-019-1738-8)) and the simulation framework in ([Morris et al., 2019](https://doi.org/10.1002/sim.8086)).

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Computational work doesn't need a protocol."** | Pipelines have dozens of choices. Pre-specify them or report all of them. |
| **"My simulator shows my method works."** | Simulations encode assumptions; use several and real data with truth. |
| **"Re-running gives the same results."** | Not without fixed versions, environments and seeds. |
| **"Public data are unbiased."** | They carry the design flaws of the original studies (batches, selection). |
| **"A/B tests are only for tech companies."** | Any digital intervention in health or education can be randomized. |

---

## 🧪 Spot the Flaw

> "We downloaded 12 public RNA-seq datasets of disease X vs controls, merged them, removed
> batch effects with ComBat, and trained a classifier with 10-fold cross-validation
> (AUC 0.95)."

<details>
<summary>▶ Diagnosis</summary>

- In many public datasets, **disease status is confounded with study** (some studies
  contain mostly cases). ComBat with unbalanced study × group removes biology or leaves batch
  ([Nygaard et al., 2016](https://doi.org/10.1093/biostatistics/kxv027)).
- Random 10-fold CV mixes samples from the same study in training and test sets → the
  model can learn study signatures (leakage via batch).
- **Fix:** leave-one-study-out validation; check group balance per study; correct batches
  only within the training folds; report per-study performance.
</details>

---

## 🔎 The Reviewer's Perspective

- **"Is the code, environment and data available to rerun everything?"**
- **"For benchmarks: neutral? many datasets? fair tuning? ground truth?"**
- **"For ML: split at the right unit? external validation? confounders in acquisition?"**
- **"Were analysis choices pre-specified or reported exhaustively?"**

---

## 🛠️ Design Challenges

Three computational designs: a causal analysis of health records, a methods benchmark and
a machine-learning split. Computational studies are experiments too — for each, state
what is compared, on what, and what would make the comparison unfair. Then open the model
answer and its diagram.

### Challenge 1 · Health data science · ⭐⭐⭐ — early physiotherapy in the ICU

You will use 10 years of hospital EHR data to ask whether early physiotherapy shortens ICU
stay. Outline the design.

<details>
<summary>▶ A model design</summary>

- **Question type:** causal from observational data (Q4) → **target-trial emulation**
  ([Hernán & Robins, 2016](https://doi.org/10.1093/aje/kwv254)).
- **Protocol:** eligibility (adult ICU admissions meeting criteria), strategies (start
  physiotherapy within 48 h vs later/never), time zero (ICU admission + eligibility),
  outcome (ICU length of stay, competing risk of death), follow-up, causal contrast.
- **Confounders** (DAG): severity scores, diagnosis, age, sedation, ventilation, staffing
  period.
- **Bias checks:** negative-control outcomes; sensitivity analyses for unmeasured
  confounding.
- **Reproducibility:** versioned extraction queries, code and environment; pre-registered
  analysis plan.

![Target-trial emulation: first write the protocol of the trial you would like to run — eligibility, strategies, time zero, outcome and follow-up — then emulate each element in the health-record data, align eligibility, assignment and time zero to avoid immortal-time bias, adjust for DAG confounders and run bias checks](figures/diagrams/22-computational-and-data-science-f636b9bef0.png)
</details>

### Challenge 2 · Bioinformatics · ⭐⭐ — which differential-abundance method?

Your group wants to recommend a method for differential abundance analysis of microbiome
data. Six published methods are candidates, one of which your group developed. Design a
neutral benchmark.

<details>
<summary>▶ A model design</summary>

- **ADEMP** (Chapter 15) for the simulation part: **Aims** (false-positive control and power
  under compositionality); **Data-generating mechanisms** (several, including ones that do
  *not* match any method's assumptions — e.g. resampling real datasets and spiking in known
  effects); **Estimands** (which taxa truly differ); **Methods** (all six, at defaults *and*
  with equal tuning effort); **Performance measures** (false discovery rate, sensitivity,
  type I error under the null), with Monte-Carlo uncertainty.
- **Real data too:** several public datasets with **no true differences** (e.g. random
  splits of one group) to check false positives, and datasets with known positives.
- **Neutrality:** pre-register the design; give the same tuning budget to every method;
  ideally include the other methods' authors or report your own method's conflict of interest
  explicitly.
- **Report** everything: code, versions, seeds, all results (not only the favourable settings).

![Neutral benchmark of six differential-abundance methods: simulated data designed with the ADEMP framework, real datasets with no true differences and with known positives, equal tuning effort, pre-registration and full code release lead to a recommendation that states where each method works](figures/diagrams/22-computational-and-data-science-721397b96a.png)
</details>

### Challenge 3 · Machine learning for proteins · ⭐⭐ — homology leakage

You will train a deep-learning model that predicts enzyme function from protein sequence.
You have 200,000 annotated sequences. A random 80/10/10 split gives 95% accuracy on the test
set. The model will be used on **newly sequenced organisms**, whose proteins are often only
distantly related to anything in the training data.

<details>
<summary>▶ A model design</summary>

- **The leak:** proteins in the test set have close homologues (near-identical sequences)
  in the training set, so the model can succeed by **recognizing relatives**, not by learning
  function. This is the protein version of related lines or repeated patients (Chapter 12).
- **Split by sequence clusters:** cluster all sequences at a low identity threshold (e.g.
  30% identity, using a tool such as MMseqs2 or CD-HIT) and assign **whole clusters** to
  train, validation or test.
- **Report accuracy as a function of similarity** to the nearest training sequence — users
  need to know how fast performance drops for distant proteins.
- **Baseline:** compare with a simple nearest-homologue (BLAST-like) annotation; a deep model
  that does not beat it on distant proteins adds little.
- **Optional external test:** proteins from a newly sequenced clade added to the databases
  after the training data were frozen.

![Leakage-free split for protein function prediction: sequences are clustered at 30 percent identity and whole clusters are assigned to training, validation or test sets; accuracy is reported by similarity to the nearest training sequence and compared with a nearest-homologue baseline; a random split is marked as leaky](figures/diagrams/22-computational-and-data-science-03cabba5f0.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** Map treatments, units and outcomes onto a benchmark.

**⭐ Q2.** What does ADEMP stand for?

**⭐⭐ Q3.** Why are "null datasets" made by randomly splitting real data useful in
benchmarks?

**⭐⭐ Q4.** Name four elements of a reproducible computational project.

**⭐⭐⭐ Q5.** A model trained on public data from 12 studies performs well in random CV but
poorly on a new hospital's data. Give a design diagnosis and a better validation scheme.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Treatments = methods, units = datasets, outcomes = metrics."* —
**✔ 10/10.**

> **Q2 — Sample answer:** *"Aims, Data, Estimands, Methods, Performance."* — **✔ 10/10.**

> **Q3 — Sample answer:** *"Because we know there is no true difference, so every
discovery is false."* — **✔ 10/10.** And the data keep real-world structure that
simulations may miss.

> **Q4 — Sample answer:** *"Git, conda, seeds, README."* — **✔ 9/10.** Add a workflow
manager and read-only raw data.

> **Q5 — Sample answer:** *"Overfitting."* — **◑ 4/10.** More specific: random CV mixed
samples from the same studies (and their batch signatures) across folds, so it measured
within-study performance. **Leave-one-study-out** (or train on some studies, test on
others) estimates performance on new sites.

**Rubric:** computational answers need the computational *unit* (dataset, study, site) and
the *truth* against which performance is judged.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Benchmarks** | Experiments with methods as treatments and datasets as units. |
| **Simulations** | ADEMP; several simulators; real truth sets too. |
| **Reproducibility** | Versions, environments, seeds, workflows, FAIR data. |
| **Data science** | Leakage, acquisition confounding and selection are design issues. |
| **A/B tests** | When you can randomize digital interventions, do. |

**Traps to remember:** own-simulator benchmarks · Excel gene names · random CV across
studies · unrecorded seeds.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Protocol/analysis plan written before running | |
| Ground truth and datasets (benchmarks) | |
| Split strategy at the right unit (ML) | |
| Environment, versions, seeds recorded | |
| Code and data release plan | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 23 — Data Leakage](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/23-data-leakage.md) · [Ch. 40 — Thinking Like an AI Evaluator](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/40-ai-evaluator.md)
- More: ([Kass et al., 2016](https://doi.org/10.1371/journal.pcbi.1004961); [Chicco, 2017](https://doi.org/10.1186/s13040-017-0155-3); [Luo et al., 2016](https://doi.org/10.2196/jmir.5870))

## 📚 References cited in this chapter

- Beam AL, Manrai AK, Ghassemi M (2020). Challenges to the Reproducibility of Machine Learning Models in Health Care. *JAMA* 323:305. [doi:10.1001/jama.2019.20866](https://doi.org/10.1001/jama.2019.20866)
- Boulesteix AL, Lauer S, Eugster MJA (2013). A Plea for Neutral Comparison Studies in Computational Sciences. *PLoS ONE* 8:e61562. [doi:10.1371/journal.pone.0061562](https://doi.org/10.1371/journal.pone.0061562)
- Chicco D (2017). Ten quick tips for machine learning in computational biology. *BioData Mining* 10:35. [doi:10.1186/s13040-017-0155-3](https://doi.org/10.1186/s13040-017-0155-3)
- Collins GS, Moons KGM, Dhiman P, Riley RD, Beam AL, Van Calster B, et al. (2024). TRIPOD+AI statement: updated guidance for reporting clinical prediction models that use regression or machine learning methods. *BMJ* 385:e078378. [doi:10.1136/bmj-2023-078378](https://doi.org/10.1136/bmj-2023-078378)
- Heil BJ, Hoffman MM, Markowetz F, Lee SI, Greene CS, Hicks SC (2021). Reproducibility standards for machine learning in the life sciences. *Nature Methods* 18:1132-1135. [doi:10.1038/s41592-021-01256-7](https://doi.org/10.1038/s41592-021-01256-7)
- Hernán MA, Robins JM (2016). Using Big Data to Emulate a Target Trial When a Randomized Trial Is Not Available: Table 1.. *American Journal of Epidemiology* 183:758-764. [doi:10.1093/aje/kwv254](https://doi.org/10.1093/aje/kwv254)
- Hu F, Chen AA, Horng H, Bashyam V, Davatzikos C, Alexander-Bloch A, et al. (2023). Image harmonization: A review of statistical and deep learning methods for removing batch effects and evaluation metrics for effective harmonization. *NeuroImage* 274:120125. [doi:10.1016/j.neuroimage.2023.120125](https://doi.org/10.1016/j.neuroimage.2023.120125)
- Huber W, Carey VJ, Gentleman R, Anders S, Carlson M, Carvalho BS, et al. (2015). Orchestrating high-throughput genomic analysis with Bioconductor. *Nature Methods* 12:115-121. [doi:10.1038/nmeth.3252](https://doi.org/10.1038/nmeth.3252)
- Kapoor S, Narayanan A (2023). Leakage and the reproducibility crisis in machine-learning-based science. *Patterns* 4:100804. [doi:10.1016/j.patter.2023.100804](https://doi.org/10.1016/j.patter.2023.100804)
- Kass RE, Caffo BS, Davidian M, Meng XL, Yu B, Reid N (2016). Ten Simple Rules for Effective Statistical Practice. *PLOS Computational Biology* 12:e1004961. [doi:10.1371/journal.pcbi.1004961](https://doi.org/10.1371/journal.pcbi.1004961)
- Kohavi R, Tang D, Xu Y (2020). Trustworthy Online Controlled Experiments. *Cambridge University Press*. [doi:10.1017/9781108653985](https://doi.org/10.1017/9781108653985)
- Krusche P, Trigg L, Boutros PC, Mason CE, De La Vega FM, Moore BL, et al. (2019). Best practices for benchmarking germline small-variant calls in human genomes. *Nature Biotechnology* 37:555-560. [doi:10.1038/s41587-019-0054-x](https://doi.org/10.1038/s41587-019-0054-x)
- Luecken MD, Büttner M, Chaichoompu K, Danese A, Interlandi M, Mueller MF, et al. (2022). Benchmarking atlas-level data integration in single-cell genomics. *Nature Methods* 19:41-50. [doi:10.1038/s41592-021-01336-8](https://doi.org/10.1038/s41592-021-01336-8)
- Luo W, Phung D, Tran T, Gupta S, Rana S, Karmakar C, et al. (2016). Guidelines for Developing and Reporting Machine Learning Predictive Models in Biomedical Research: A Multidisciplinary View. *Journal of Medical Internet Research* 18:e323. [doi:10.2196/jmir.5870](https://doi.org/10.2196/jmir.5870)
- Mangul S, Martin LS, Hill BL, Lam AKM, Distler MG, Zelikovsky A, et al. (2019). Systematic benchmarking of omics computational tools. *Nature Communications* 10:1393. [doi:10.1038/s41467-019-09406-4](https://doi.org/10.1038/s41467-019-09406-4)
- McDermott MBA, Wang S, Marinsek N, Ranganath R, Foschini L, Ghassemi M (2021). Reproducibility in machine learning for health research: Still a ways to go. *Science Translational Medicine* 13:eabb1655. [doi:10.1126/scitranslmed.abb1655](https://doi.org/10.1126/scitranslmed.abb1655)
- Morris TP, White IR, Crowther MJ (2019). Using simulation studies to evaluate statistical methods. *Statistics in Medicine* 38:2074-2102. [doi:10.1002/sim.8086](https://doi.org/10.1002/sim.8086)
- Noble WS (2009). A Quick Guide to Organizing Computational Biology Projects. *PLoS Computational Biology* 5:e1000424. [doi:10.1371/journal.pcbi.1000424](https://doi.org/10.1371/journal.pcbi.1000424)
- Nygaard V, Rødland EA, Hovig E (2016). Methods that remove batch effects while retaining group differences may lead to exaggerated confidence in downstream analyses. *Biostatistics* 17:29-39. [doi:10.1093/biostatistics/kxv027](https://doi.org/10.1093/biostatistics/kxv027)
- Sandve GK, Nekrutenko A, Taylor J, Hovig E (2013). Ten Simple Rules for Reproducible Computational Research. *PLoS Computational Biology* 9:e1003285. [doi:10.1371/journal.pcbi.1003285](https://doi.org/10.1371/journal.pcbi.1003285)
- Tran HTN, Ang KS, Chevrier M, Zhang X, Lee NYS, Goh M, et al. (2020). A benchmark of batch-effect correction methods for single-cell RNA sequencing data. *Genome Biology* 21:12. [doi:10.1186/s13059-019-1850-9](https://doi.org/10.1186/s13059-019-1850-9)
- Walsh I, Fishman D, Garcia-Gasulla D, Titma T, Pollastri G, Capriotti E, et al. (2021). DOME: recommendations for supervised machine learning validation in biology. *Nature Methods* 18:1122-1127. [doi:10.1038/s41592-021-01205-4](https://doi.org/10.1038/s41592-021-01205-4)
- Weber LM, Saelens W, Cannoodt R, Soneson C, Hapfelmeier A, Gardner PP, et al. (2019). Essential guidelines for computational method benchmarking. *Genome Biology* 20:125. [doi:10.1186/s13059-019-1738-8](https://doi.org/10.1186/s13059-019-1738-8)
- Whalen S, Schreiber J, Noble WS, Pollard KS (2022). Navigating the pitfalls of applying machine learning in genomics. *Nature Reviews Genetics* 23:169-181. [doi:10.1038/s41576-021-00434-9](https://doi.org/10.1038/s41576-021-00434-9)
- Wilkinson MD, Dumontier M, Aalbersberg IJ, Appleton G, Axton M, Baak A, et al. (2016). The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data* 3:160018. [doi:10.1038/sdata.2016.18](https://doi.org/10.1038/sdata.2016.18)
- Ye SH, Siddle KJ, Park DJ, Sabeti PC (2019). Benchmarking Metagenomics Tools for Taxonomic Classification. *Cell* 178:779-794. [doi:10.1016/j.cell.2019.07.010](https://doi.org/10.1016/j.cell.2019.07.010)
- Ziemann M, Eren Y, El-Osta A (2016). Gene name errors are widespread in the scientific literature. *Genome Biology* 17:177. [doi:10.1186/s13059-016-1044-7](https://doi.org/10.1186/s13059-016-1044-7)


---

[← Chapter 21](21-proteomics-metabolomics-multiomics.md) · [Table of Contents](../README.md) · [Next: Chapter 23 — Clinical and Preclinical Research →](23-clinical-and-preclinical.md)
