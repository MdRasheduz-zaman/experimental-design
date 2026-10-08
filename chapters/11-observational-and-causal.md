# Chapter 11 — Observational and Causal Designs (Q4)

> **Part III — Designs by Question Type**
> [← Chapter 10](10-comparative-and-mechanistic.md) · [Table of Contents](../README.md) · [Next: Chapter 12 — Predictive Studies →](12-predictive-studies.md)

---

<details>
<summary>🧬 <b>Biology primer</b> — GWAS and Mendelian randomization in one minute</summary>

- **GWAS (genome-wide association study):** test hundreds of thousands to millions of genetic variants (SNPs) for association with a trait across many individuals.
- **Population stratification:** groups with different ancestry differ in allele frequencies *and* (for non-genetic reasons) in trait values, creating false associations.
- **Mendelian randomization (MR):** uses genetic variants that influence an exposure (e.g. LDL cholesterol) as natural "instruments" to estimate the exposure's causal effect on an outcome (e.g. heart disease), because alleles are allocated at conception.

</details>

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Choose among cross-sectional, cohort and case–control designs, and state each one's main bias.
2. Draw a simple causal diagram (DAG) and decide what to adjust for — and what not to.
3. Explain the design logic of GWAS: sample size, thresholds, stratification control and replication.
4. State the three core assumptions of Mendelian randomization and compute a Wald ratio.
5. Describe **target-trial emulation** as a design for causal questions in observational data.

---

## 🎯 The Big Picture

Many important questions cannot be answered by randomization: you cannot assign people
to smoke, assign genotypes, or assign twenty years of diet. Observational data can still
support causal conclusions — but only when the **design** substitutes for randomization
with explicit assumptions, including some that cannot be verified from the observed data ([Hernán & Robins, 2016](https://doi.org/10.1093/aje/kwv254); [Pearl, 2009](https://doi.org/10.1214/09-ss057)).

> **The central threat:** *confounding* — a third factor causes both the exposure and the
> outcome. Others: selection bias (who ends up in the data), reverse causation, and
> measurement error.

See [📘 Biostat Ch. 35](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/35-dags-simpsons.md)
and [📘 Ch. 36](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/36-causal-tools.md)
for the statistical tools; here we focus on design choices.

---

## 🧠 Core Intuition

### Three classic observational designs

| Design | How it works | Strength | Main weakness |
|---|---|---|---|
| **Cross-sectional** | measure exposure and outcome at one time | fast, cheap | cannot order cause and effect |
| **Cohort** | follow exposed and unexposed forward in time | temporal order; several outcomes | slow, costly; loss to follow-up |
| **Case–control** | sample people with and without the outcome, look back at exposure | efficient for rare outcomes | recall bias; choosing comparable controls |

Report them with STROBE ([von Elm et al., 2007](https://doi.org/10.1016/s0140-6736%2807%2961602-x)).

![Three observational designs on a time line: a cohort starts from exposure and follows people forward to outcomes, a case-control starts from the outcome and looks back at exposure, and a cross-sectional study measures both at one moment](figures/diagrams/11-observational-and-causal-c13e0a7fc9.png)

### Draw the DAG before collecting data

A **directed acyclic graph** lists your assumptions about what causes what. It tells you:

- which **confounders** to measure and adjust for (common causes);
- for a **total effect**, avoid adjusting for **mediators** (on the causal path),
  because that blocks part of the effect; estimating a direct effect needs a different
  target and extra assumptions;
- avoid conditioning on **colliders** (common effects), which can open a spurious path.

![Causal diagram: age and smoking confound coffee intake and Parkinson's disease](figures/diagrams/11-observational-and-causal-95e7e0231a.png)

Age and smoking are confounders to measure. If you only collect data *after*
deciding, you may lack the variables you need.

### GWAS: design is mostly about size and structure

- Effects of common variants are small, and the genome-wide threshold is
  **5 × 10⁻⁸**, so well-powered studies of complex traits typically need tens to hundreds
  of thousands of people ([Visscher et al., 2017](https://doi.org/10.1016/j.ajhg.2017.06.005); [Sham & Purcell, 2014](https://doi.org/10.1038/nrg3706); [Spencer et al., 2009](https://doi.org/10.1371/journal.pgen.1000477)).
- **Population stratification** is controlled by design (matched ancestry) and by
  analysis (principal components, mixed models) ([Price et al., 2006](https://doi.org/10.1038/ng1847); [Yang et al., 2014](https://doi.org/10.1038/ng.2876)).
- Strict genotype and sample **QC** is part of the design ([Marees et al., 2018](https://doi.org/10.1002/mpr.1608)).
- **Independent replication** cohorts are the primary safeguard.
- Ancestral **diversity** affects discovery and how well results transfer ([Peterson et al., 2019](https://doi.org/10.1016/j.cell.2019.08.051)).

### Mendelian randomization: a natural experiment

MR uses a genetic variant *G* as an instrument for exposure *X* ([Davey Smith & Ebrahim, 2003](https://doi.org/10.1093/ije/dyg070); [Sanderson et al., 2022](https://doi.org/10.1038/s43586-021-00092-5)):

![Mendelian randomization: genetic variant, exposure, outcome and confounders with the three assumptions](figures/diagrams/11-observational-and-causal-894d539219.png)

1. **Relevance:** *G* is robustly associated with *X* (weak instruments bias the
   estimate; a common rule is F > 10) ([Burgess & Thompson, 2011](https://doi.org/10.1093/ije/dyr036)).
2. **Independence:** *G* is not associated with confounders.
3. **Exclusion restriction:** *G* affects *Y* only through *X* (no horizontal pleiotropy).

Assumptions 2 and 3 cannot be fully tested, so MR studies use several instruments and
sensitivity analyses ([Burgess et al., 2023](https://doi.org/10.12688/wellcomeopenres.15555.3)) and report with STROBE-MR ([Skrivankova et al., 2021](https://doi.org/10.1001/jama.2021.18236)).

### Target-trial emulation

To answer "does starting drug A versus drug B reduce mortality?" with health records:
write the **protocol of the trial you would run** (eligibility, treatment strategies,
assignment, *time zero*, follow-up, outcome, analysis), then emulate each element with
the data ([Hernán & Robins, 2016](https://doi.org/10.1093/aje/kwv254)). Aligning time zero for both groups prevents **immortal-time
bias**, a common, design-induced error.

---

![Target-trial emulation writes the protocol of the randomized trial that would answer the question, then maps each element onto the observational data, aligning eligibility, treatment assignment and the start of follow-up at the same moment](figures/diagrams/11-observational-and-causal-6587254030.png)

## 👁️ Visual Intuition — choosing a design

![Decision tree for choosing case-control, cohort or cross-sectional designs, and Mendelian randomization](figures/diagrams/11-observational-and-causal-0b3de24725.png)

---

## 🔬 Worked Example — a Mendelian randomization (Wald) ratio

A variant raises LDL cholesterol by **0.10 mmol/L per allele** (SE 0.005) and raises the
log-odds of coronary heart disease by **0.05 per allele** (SE 0.012), in separate GWAS.

1. **Instrument strength:** F ≈ (0.10/0.005)² = **400** — a strong instrument.
2. **Wald ratio:** causal effect = 0.05/0.10 = **0.5 log-odds per 1 mmol/L LDL**.
3. **Odds ratio:** e^0.5 ≈ **1.65** per 1 mmol/L higher LDL.
4. **Uncertainty (first-order):** SE ≈ 0.012/0.10 = 0.12 → 95% CI for the OR ≈
   **1.30 to 2.09**.
5. **Design caveats:** valid only if the variant affects heart disease *only through*
   LDL. With many variants, use pleiotropy-robust methods and check consistency.

(Code: `scripts/course/worked_examples.R`. Numbers are illustrative.)

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Adjust for everything available."** | For a total effect, adjusting for mediators removes part of the effect; conditioning on colliders can create bias. Choose adjustments for the estimand with a DAG. |
| **"A huge biobank removes bias."** | Size reduces random error, not confounding or selection. |
| **"GWAS hits are causal genes."** | They are associated loci. The causal variant and gene need fine-mapping and functional work (Q3). |
| **"MR is as good as an RCT."** | Only if its assumptions hold, and pleiotropy is common. |
| **"Correlation in observational data is useless."** | It can generate and, with good design, test causal hypotheses. |

---

## 🧪 Spot the Flaw

> "Using hospital records, we compared patients who received statins during their
> hospital stay with those who did not. Statin users had 40% lower 1-year mortality.
> Exposure was defined as any statin prescription during follow-up."

<details>
<summary>▶ Diagnosis</summary>

**Immortal-time bias:** to be classified as a "statin user" a patient had to survive
long enough to receive a prescription. Early deaths fall automatically into the
non-user group. Also likely **confounding by indication and frailty** (very sick
patients are less likely to be started on preventive drugs). **Fix:** target-trial
emulation with a common time zero (e.g. admission), a defined grace period, and
adjustment for baseline confounders measured before time zero ([Hernán & Robins, 2016](https://doi.org/10.1093/aje/kwv254)).

![Timelines of six patients: prescribed patients survive the orange pre-prescription period; early deaths are all non-users](../assets/course/ch11-immortal-time.png)

</details>

---

## 🔎 The Reviewer's Perspective

- **"What is the causal question, and what trial would answer it?"**
- **"Is there a DAG, and do the adjustments follow from it?"**
- **"How were participants selected, and could selection depend on exposure and outcome?"**
- **"Is time zero aligned?"**
- **"For GWAS/MR: stratification control, instrument strength, pleiotropy analyses, replication?"**

---

## 🛠️ Design Challenges

Three causal questions that must be answered from observational data. For each, **draw
the DAG first** — then choose the design, the adjustment set and a bias check. The model
answers show the DAG.

### Challenge 1 · Environmental epidemiology · ⭐⭐ — pollution and birth weight

Question: does air pollution exposure during pregnancy reduce birth weight? Design an
observational study.

<details>
<summary>▶ A model design</summary>

- **Design:** prospective birth cohort (or registry-based cohort) with exposure
  estimated by residential address and pollution models per trimester.
- **DAG-based confounders:** socioeconomic status, maternal smoking, maternal age,
  parity, season of conception, urbanicity. Do **not** adjust for gestational age if it
  is a mediator of the effect on birth weight (or analyse it as a separate question).
- **Bias checks:** negative-control exposure (pollution *after* birth should not
  affect birth weight); sibling comparisons to control family-level confounding.
- **Size:** precision-based, enough to estimate a small effect (e.g. a few grams per
  10 µg/m³) with a narrow CI.
- **Report:** STROBE.

![DAG for pollution and birth weight: socioeconomic status, smoking, season and urbanicity affect both exposure and outcome and are adjusted for; gestational age lies on the causal path and is not adjusted for; pollution after birth serves as a negative-control exposure with no arrow to birth weight](figures/diagrams/11-observational-and-causal-097b2f6fbb.png)
</details>

### Challenge 2 · Cancer microbiome · ⭐⭐ — a bacterium and colorectal cancer

A study wants to know whether a gut bacterium contributes to colorectal cancer. The draft
plan: collect stool from patients **after** diagnosis (many already had bowel preparation,
antibiotics or surgery) and from healthy blood donors as controls. Draw the DAG and
redesign.

<details>
<summary>▶ A model design</summary>

- **Reverse causation:** a tumour changes the gut environment (bleeding, mucus, obstruction),
  so the bacterium may be a *consequence* of cancer. Stool after diagnosis cannot tell the
  directions apart.
- **Procedure bias:** bowel preparation, antibiotics and surgery change the microbiome and
  are applied only to cases — sample **before** any procedure.
- **Wrong controls:** blood donors differ from patients in age, health and region.
- **Redesign:** a **case-control study nested in a prospective cohort** with stored stool:
  cases are those who later develop cancer, controls are cohort members matched on age,
  sex and sampling date; stool was collected years **before** diagnosis. Adjust for diet,
  BMI, smoking and medication; check whether the association holds when excluding cases
  diagnosed within 2 years of sampling (to reduce reverse causation).
- **Mechanism (Q3)** would still need experiments (Chapter 10).

![DAG for a gut bacterium and colorectal cancer: diet, age, BMI and medication confound the association; the tumour can itself change the bacterium, which is reverse causation; bowel preparation and antibiotics affect only post-diagnosis samples; sampling stool years before diagnosis in a cohort breaks the reverse path](figures/diagrams/11-observational-and-causal-86d9b0bfda.png)
</details>

### Challenge 3 · Animal health · ⭐⭐ — a feed additive and antibiotic use

Farm records show that pig farms using a commercial feed additive use **less antibiotic**
per pig. The supplier wants to claim that the additive reduces disease. No trial is
possible this year. Design the best observational analysis and say what it can claim.

<details>
<summary>▶ A model design</summary>

- **DAG:** farms that buy the additive may also be better managed (biosecurity, vaccination,
  vet advice, newer buildings) — **confounding by management**. Herd size and production
  type affect both. Prescribing habits of the farm vet affect antibiotic use directly.
- **Design:** cohort of farms with data from **before and after** adoption; compare change in
  antibiotic use in adopting farms with change in similar non-adopting farms (a
  difference-in-differences design), matched or weighted on pre-adoption use, herd size,
  production type, biosecurity score and vet practice.
- **Negative-control outcome:** an outcome the additive cannot plausibly affect (e.g.
  antibiotic use for lameness from injuries). If adopters also "improve" there, residual
  confounding is likely.
- **Claim:** at best "adoption was associated with a reduction of X, robust to measured
  confounding" — a randomized trial (farms or pens randomized, blinded feed) is the
  confirmation.

![DAG for a feed additive and antibiotic use on pig farms: management quality, herd size and production type affect both adoption and antibiotic use; vet prescribing habits affect antibiotic use; a difference-in-differences comparison and a negative-control outcome address confounding](figures/diagrams/11-observational-and-causal-0723c069e3.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** Name the three classic observational designs and one weakness of each.

**⭐ Q2.** What are the three core assumptions of Mendelian randomization?

**⭐⭐ Q3.** Why shouldn't you adjust for a collider? Give a biological example.

**⭐⭐ Q4.** A SNP raises BMI by 0.2 units per allele and raises the log-odds of type 2
diabetes by 0.06 per allele. Compute the Wald ratio and the OR per BMI unit.

**⭐⭐⭐ Q5.** Explain immortal-time bias and how target-trial emulation prevents it.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Cross-sectional (no time order), cohort (slow), case–control
(recall bias)."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"Relevance, independence, exclusion restriction."* —
**✔ 10/10.** Be ready to explain each in one sentence.

> **Q3 — Sample answer:** *"It creates a fake association."* — **◑ 6/10.** Explain the
mechanism and give an example: among hospitalized patients (hospitalization is caused
by both disease A and disease B), A and B can appear negatively associated even if
they are independent in the population. Conditioning on the common effect opens a
spurious path.

![Scatter plot of two independent diseases with a negative trend among hospitalized patients only](../assets/course/ch11-collider.png)


> **Q4 — Sample answer:** *"0.06/0.2 = 0.3, OR = e^0.3 ≈ 1.35 per BMI unit."* —
**✔ 10/10.** Mention the assumptions under which this is causal.

> **Q5 — Sample answer:** *"Patients must survive until treatment to be called treated.
Emulation fixes time zero."* — **✔ 9/10.** Add: emulation defines eligibility, treatment
assignment and follow-up start at the same moment for all groups, as in a real trial.

**Rubric:** causal-design answers need the *bias mechanism* and the *design* that
removes it.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Designs** | Cross-sectional, cohort, case–control — choose by rarity and need for time order. |
| **DAGs** | Decide adjustments before data collection; avoid mediators and colliders. |
| **GWAS** | Large *n*, strict threshold, stratification control, replication, diversity. |
| **MR** | Natural experiment with three assumptions; use sensitivity analyses. |
| **Target trial** | Specify the trial you'd run; align time zero. |

**Traps to remember:** adjust-for-everything · immortal time · size ≠ unbiasedness ·
GWAS hit ≠ causal gene.

### 📇 Design Card — add these rows (Q4)

| Field | Your answer |
|---|---|
| Causal question and target trial | |
| DAG: confounders to measure/variables not to adjust | |
| Selection and time-zero definition | |
| Replication or negative-control strategy | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 15 — Correlation, Causation, and Confounding](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/15-correlation-causation.md) · [Ch. 35 — Confounding, DAGs & Simpson's Paradox](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/35-dags-simpsons.md) · [Ch. 36 — Causal Inference Tools & Population Structure](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/36-causal-tools.md)
- Further: ([Uffelmann et al., 2021](https://doi.org/10.1038/s43586-021-00056-9); [Brion et al., 2013](https://doi.org/10.1093/ije/dyt179))

## 📚 References cited in this chapter

- Brion MJA, Shakhbazov K, Visscher PM (2013). Calculating statistical power in Mendelian randomization studies. *International Journal of Epidemiology* 42:1497-1501. [doi:10.1093/ije/dyt179](https://doi.org/10.1093/ije/dyt179)
- Burgess S, Thompson SG (2011). Avoiding bias from weak instruments in Mendelian randomization studies. *International Journal of Epidemiology* 40:755-764. [doi:10.1093/ije/dyr036](https://doi.org/10.1093/ije/dyr036)
- Burgess S, Davey Smith G, Davies NM, Dudbridge F, Gill D, Glymour MM, et al. (2023). Guidelines for performing Mendelian randomization investigations: update for summer 2023. *Wellcome Open Research* 4:186. [doi:10.12688/wellcomeopenres.15555.3](https://doi.org/10.12688/wellcomeopenres.15555.3)
- Davey Smith G, Ebrahim S (2003). ‘Mendelian randomization’: can genetic epidemiology contribute to understanding environmental determinants of disease?*. *International Journal of Epidemiology* 32:1-22. [doi:10.1093/ije/dyg070](https://doi.org/10.1093/ije/dyg070)
- Hernán MA, Robins JM (2016). Using Big Data to Emulate a Target Trial When a Randomized Trial Is Not Available: Table 1.. *American Journal of Epidemiology* 183:758-764. [doi:10.1093/aje/kwv254](https://doi.org/10.1093/aje/kwv254)
- Marees AT, de Kluiver H, Stringer S, Vorspan F, Curis E, Marie‐Claire C, et al. (2018). A tutorial on conducting genome‐wide association studies: Quality control and statistical analysis. *International Journal of Methods in Psychiatric Research* 27:e1608. [doi:10.1002/mpr.1608](https://doi.org/10.1002/mpr.1608)
- Pearl J (2009). Causal inference in statistics: An overview. *Statistics Surveys* 3. [doi:10.1214/09-ss057](https://doi.org/10.1214/09-ss057)
- Peterson RE, Kuchenbaecker K, Walters RK, Chen CY, Popejoy AB, Periyasamy S, et al. (2019). Genome-wide Association Studies in Ancestrally Diverse Populations: Opportunities, Methods, Pitfalls, and Recommendations. *Cell* 179:589-603. [doi:10.1016/j.cell.2019.08.051](https://doi.org/10.1016/j.cell.2019.08.051)
- Price AL, Patterson NJ, Plenge RM, Weinblatt ME, Shadick NA, Reich D (2006). Principal components analysis corrects for stratification in genome-wide association studies. *Nature Genetics* 38:904-909. [doi:10.1038/ng1847](https://doi.org/10.1038/ng1847)
- Sanderson E, Glymour MM, Holmes MV, Kang H, Morrison J, Munafò MR, et al. (2022). Mendelian randomization. *Nature Reviews Methods Primers* 2:6. [doi:10.1038/s43586-021-00092-5](https://doi.org/10.1038/s43586-021-00092-5)
- Sham PC, Purcell SM (2014). Statistical power and significance testing in large-scale genetic studies. *Nature Reviews Genetics* 15:335-346. [doi:10.1038/nrg3706](https://doi.org/10.1038/nrg3706)
- Skrivankova VW, Richmond RC, Woolf BAR, Yarmolinsky J, Davies NM, Swanson SA, et al. (2021). Strengthening the Reporting of Observational Studies in Epidemiology Using Mendelian Randomization. *JAMA* 326:1614. [doi:10.1001/jama.2021.18236](https://doi.org/10.1001/jama.2021.18236)
- Spencer CCA, Su Z, Donnelly P, Marchini J (2009). Designing Genome-Wide Association Studies: Sample Size, Power, Imputation, and the Choice of Genotyping Chip. *PLoS Genetics* 5:e1000477. [doi:10.1371/journal.pgen.1000477](https://doi.org/10.1371/journal.pgen.1000477)
- Uffelmann E, Huang QQ, Munung NS, de Vries J, Okada Y, Martin AR, et al. (2021). Genome-wide association studies. *Nature Reviews Methods Primers* 1:59. [doi:10.1038/s43586-021-00056-9](https://doi.org/10.1038/s43586-021-00056-9)
- Visscher PM, Wray NR, Zhang Q, Sklar P, McCarthy MI, Brown MA, et al. (2017). 10 Years of GWAS Discovery: Biology, Function, and Translation. *The American Journal of Human Genetics* 101:5-22. [doi:10.1016/j.ajhg.2017.06.005](https://doi.org/10.1016/j.ajhg.2017.06.005)
- von Elm E, Altman DG, Egger M, Pocock SJ, Gøtzsche PC, Vandenbroucke JP (2007). The Strengthening the Reporting of Observational Studies in Epidemiology (STROBE) statement: guidelines for reporting observational studies. *The Lancet* 370:1453-1457. [doi:10.1016/s0140-6736(07)61602-x](https://doi.org/10.1016/s0140-6736%2807%2961602-x)
- Yang J, Zaitlen NA, Goddard ME, Visscher PM, Price AL (2014). Advantages and pitfalls in the application of mixed-model association methods. *Nature Genetics* 46:100-106. [doi:10.1038/ng.2876](https://doi.org/10.1038/ng.2876)


---

[← Chapter 10](10-comparative-and-mechanistic.md) · [Table of Contents](../README.md) · [Next: Chapter 12 — Predictive Studies →](12-predictive-studies.md)
