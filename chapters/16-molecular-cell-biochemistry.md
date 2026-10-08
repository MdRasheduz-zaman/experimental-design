# Chapter 16 — Molecular and Cell Biology, Biochemistry

> **Part IV — Field Playbooks**
> [← Chapter 15](15-measurement-and-benchmarking.md) · [Table of Contents](../README.md) · [Next: Chapter 17 — Microbiology and the Microbiome →](17-microbiology-microbiome.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Define independent replication for cell-culture experiments and present it with SuperPlots.
2. Design qPCR, western blot, imaging and viability experiments around their measurement properties.
3. Plan enzyme-kinetics and binding experiments by choosing informative concentrations.
4. Include material-quality checks (cell line authentication, mycoplasma, antibody validation) in the design.

**Dominant question types:** comparative (Q2), mechanistic (Q3), measurement (Q8).

---

## 🎯 The Big Picture

Bench experiments are small, fast and endlessly repeatable, which makes them seem
design-free. In fact, the most common bench errors are design errors: wells counted as
replicates, one reagent used as proof, a single time point, a housekeeping gene that is
not stable, an over-exposed blot. A few habits fix most of them.

---

## 🧠 Core Intuition — the bench playbook

### 1. Replication = independent experiments

Separately randomized and treated wells can be **assignment units** within a run.
Wells from one flask do not replicate culture histories, days or donors (Chapter 3).
Repeat the full comparison with independently prepared cultures across runs ([Vaux et al., 2012](https://doi.org/10.1038/embor.2012.36)).
For run-level reproducibility, analyse paired run-level contrasts or model wells nested
within runs; plot the hierarchy with a **SuperPlot** ([Lord et al., 2020](https://doi.org/10.1083/jcb.202001064)). Make sure error bars state what they show (SD, SEM, CI) and
what *n* counts ([Cumming et al., 2007](https://doi.org/10.1083/jcb.200611141)).

![SuperPlot with cells as small dots and three experiment means as large circles](../assets/course/ch03-superplot.png)


### 2. Assay-specific design

| Assay | Design essentials |
|---|---|
| **RT-qPCR** | RNA quality checks; primer efficiency from a standard curve; **several validated reference genes**, geometrically averaged ([Vandesompele et al., 2002](https://doi.org/10.1186/gb-2002-3-7-research0034)); no-RT and no-template controls; MIQE reporting ([Bustin et al., 2009](https://doi.org/10.1373/clinchem.2008.112797)). ΔΔCt assumes ~100% efficiency ([Livak & Schmittgen, 2001](https://doi.org/10.1006/meth.2001.1262)). |
| **Digital PCR** | dMIQE checklist ([Huggett et al., 2013](https://doi.org/10.1373/clinchem.2013.206375)) |
| **Western blot** | load within the **linear range**; total-protein normalization is generally preferable to a single loading-control protein; validated antibodies ([Pillai-Kastoori et al., 2020](https://doi.org/10.1016/j.ab.2020.113608)) |
| **Imaging** | acquisition settings fixed in advance; **blinded** field selection and analysis; controls for bleed-through/autofluorescence ([Lee & Kitaoka, 2018](https://doi.org/10.1091/mbc.e17-05-0276)) |
| **Viability (MTT etc.)** | measures metabolic activity, not cell number; treatments altering metabolism confound it ([Ghasemi et al., 2021](https://doi.org/10.3390/ijms222312827)) |

![Each assay brings its own design requirements: qPCR needs efficiency and reference genes, western blots need a linear range and a loading control, imaging needs fixed acquisition settings and blinded scoring, and flow cytometry needs compensation and gating defined in advance](figures/diagrams/16-molecular-cell-biochemistry-1938422f87.png)

### 3. Materials are part of the design

Tens of thousands of papers have used misidentified or cross-contaminated cell lines
([Horbach & Halffman, 2017](https://doi.org/10.1371/journal.pone.0186281)). Build **STR authentication** and **mycoplasma testing** into the schedule,
record passage numbers, and validate antibodies in your system.

![Materials that silently become part of the design: cell line identity and passage number, reagent and antibody lots, serum batch, mycoplasma status and the specific knockdown reagent; each can differ between groups if not controlled](figures/diagrams/16-molecular-cell-biochemistry-7b23ba9ae7.png)

### 4. Biochemistry: choose the concentrations

Kinetic parameters are estimable only from informative design points. For
Michaelis–Menten kinetics, substrate concentrations should span well below to well above
$K_m$ (e.g. ~0.2–5 × the expected $K_m$, log-spaced), with initial rates measured in the
linear phase and fitted by **nonlinear regression** rather than linearized plots
([Johnson & Goody, 2011](https://doi.org/10.1021/bi201284u)). Optimal-design theory formalizes the choice ([Smucker et al., 2018](https://doi.org/10.1038/s41592-018-0083-2)). Report
with **STRENDA** ([Tipton et al., 2014](https://doi.org/10.1016/j.pisc.2014.02.012)). Binding assays need ligand concentrations spanning the
$K_d$ and attention to ligand depletion. Drug combinations need **dose matrices** to
separate synergy from additivity.

### 5. Mechanism needs orthogonal evidence

Two independent siRNAs/guides + rescue; genetic + pharmacological perturbation;
dose–response and time-course (Chapter 10).

---

## 👁️ Visual Intuition — what is *n* in a cell experiment?

![Three independent experiments, each with three wells and five fields per well](figures/diagrams/16-molecular-cell-biochemistry-95262da716.png)

There are 3 independent experimental runs. Fields → wells → a mean **per condition
per run** are averaged (or modelled) in that order. Compare conditions within runs;
do not average different conditions into a single run mean.

---

## 🔬 Worked Example — why primer efficiency matters

Define ΔCt = Ct(target) − Ct(reference), and ΔΔCt = ΔCt(treated) − ΔCt(control).
Relative expression is **2^(−ΔΔCt)** ([Livak & Schmittgen, 2001](https://doi.org/10.1006/meth.2001.1262)): a negative ΔΔCt means induction.
You measure **ΔΔCt = −3** and report **2³ = 8-fold** induction. But the
standard curve shows that target and reference amplify at **90%** efficiency
(amplification factor 1.9 per cycle, not 2).

- True fold change = 1.9³ ≈ **6.9** → you overestimated by about **17%**.
- For ΔΔCt = −6: reported 2⁶ = 64, true 1.9⁶ ≈ **47** → overestimated by **36%**.

The error grows with the size of the change. **Design response:** run a standard curve
for every primer pair (≥ 5 dilutions, in triplicate), use efficiency-corrected
quantification when efficiencies differ from 100% or from each other, and validate
reference-gene stability in *your* conditions. (Code: `scripts/course/worked_examples.R`.)

![Overestimate of induction rising with minus Delta-Delta-Ct for 90 and 95 percent efficiency](../assets/course/ch16-qpcr-efficiency.png)


---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"Technical triplicate = *n* = 3."** | It is *n* = 1 measured three times. |
| **"GAPDH/actin is always stable."** | Housekeeping genes can change with treatment; validate several references. |
| **"A representative blot."** | Show all replicates and quantify within the linear range. |
| **"Kinetics from three substrate concentrations."** | Too few to estimate *K_m* and *V_max* reliably. Use ≥ 6–8 well-spaced concentrations. |
| **"Cell line identity is the supplier's problem."** | Authentication is your design responsibility. |

---

## 🧪 Spot the Flaw

> "Gene X knockdown reduced migration (wound-healing assay, *n* = 9 wells, *p* < 0.001).
> Images were analysed by the first author. Knockdown was confirmed by qPCR normalized
> to GAPDH."

<details>
<summary>▶ Diagnosis</summary>

- **n = 9 wells**: from how many independent experiments? Likely pseudoreplication.
- **Unblinded image analysis** of a subjective endpoint (wound edges).
- **Single reference gene**, not validated under knockdown conditions.
- **One knockdown reagent?** No second siRNA or rescue.
- **Proliferation confound:** reduced closure may reflect reduced proliferation rather
  than migration. Use a proliferation inhibitor (e.g. mitomycin C) or measure
  proliferation in parallel.
</details>

---

## 🔎 The Reviewer's Perspective

- **"How many independent experiments, and what are the error bars?"**
- **"MIQE items: efficiency, reference-gene validation, controls?"**
- **"Is quantification within the linear range, with all blots shown?"**
- **"Were cell lines authenticated and mycoplasma-tested?"**
- **"Are kinetic and binding experiments designed around *K_m*/*K_d*?"**

---

## 🛠️ Design Challenges

Three bench experiments: a mechanistic qPCR study, an enzyme-kinetics study and a
quantitative western blot. For each, decide what an **independent experiment** is before
anything else — then open the model answer and its diagram.

### Challenge 1 · Molecular biology · ⭐⭐ — hypoxia, HIF1A and VEGFA

Design an experiment to test whether hypoxia induces gene *VEGFA* via the transcription
factor HIF1A in a human cell line, using qPCR as the main readout.

<details>
<summary>▶ A model design</summary>

- **Structure:** 2 × 2 factorial: (control siRNA, HIF1A siRNA) × (normoxia, hypoxia),
  plus a second, independent HIF1A siRNA; time-course of 0, 4, 8, 24 h hypoxia in one
  arm to choose the main time point.
- **Replication:** 4 independent experiments (separate thaws/days) as blocks; 3 wells
  per condition per experiment averaged.
- **qPCR:** efficiency from standard curves; 2–3 reference genes validated as stable
  under hypoxia; no-RT and no-template controls; MIQE.
- **Confirm knockdown** at protein level (western within the linear range).
- **Analysis:** `log expression ~ experiment + siRNA * oxygen`. The key test is the
  interaction (hypoxic induction reduced by HIF1A knockdown).

![Four independent experiments act as blocks; each contains all six conditions — control siRNA, HIF1A siRNA 1 and HIF1A siRNA 2, each under normoxia and hypoxia; the key test is whether the hypoxic induction of VEGFA is smaller with HIF1A siRNA](figures/diagrams/16-molecular-cell-biochemistry-39d29ae517.png)
</details>

### Challenge 2 · Biochemistry · ⭐⭐ — how does the inhibitor work?

You want to determine *K*ₘ and *V*ₘₐₓ of an enzyme and whether a new inhibitor is
competitive, non-competitive or mixed. A pilot suggests *K*ₘ ≈ 50 µM and an inhibitor
*K*ᵢ somewhere around 1 µM. You have 3 independent enzyme preparations and a plate reader
that measures initial rates.

<details>
<summary>▶ A model design</summary>

- **Substrate range:** about 0.2 × *K*ₘ to 5 × *K*ₘ — e.g. **10, 20, 40, 80, 160 and
  250 µM** — so the curve's rising part *and* its approach to saturation are both sampled
  (Chapter 16: choose the concentrations).
- **Inhibitor:** **0, 0.5, 1, 2 and 4 µM** (around the expected *K*ᵢ) — each crossed with every
  substrate concentration: a 6 × 5 grid.
- **Initial rates:** check linearity over time for the highest and lowest rates; use only the
  linear part; include no-enzyme blanks.
- **Replication:** the grid is run with each of the **3 enzyme preparations** (blocks);
  duplicate wells within a run are averaged; positions randomized on the plate.
- **Analysis:** fit the competitive, non-competitive and mixed models **globally** to all
  data by nonlinear regression and compare them (e.g. by AIC or an *F*-test) — not by
  eyeballing Lineweaver–Burk lines.

![Enzyme inhibition design: six substrate concentrations from 10 to 250 micromolar crossed with five inhibitor concentrations from 0 to 4 micromolar, repeated with three independent enzyme preparations, analysed by global nonlinear fitting of competitive, non-competitive and mixed models](figures/diagrams/16-molecular-cell-biochemistry-d38e2c12fe.png)
</details>

### Challenge 3 · Cell signalling · ⭐⭐ — a quantitative western blot

You want to show that a growth factor increases phosphorylation of a kinase (p-KIN relative
to total KIN) after 15 min, and that an inhibitor blocks it. Conditions: unstimulated,
stimulated, stimulated + inhibitor. Your blot has 10 lanes. Plan the experiment so the
bands can be **compared quantitatively**.

<details>
<summary>▶ A model design</summary>

- **Linear range first:** run a 2-fold dilution series of one lysate to find the loading
  range where band intensity is proportional to the amount loaded — for both antibodies.
- **Independent experiments:** 3 separate stimulations on different days (the unit); each
  gel carries **all three conditions** of one experiment, never one condition per gel.
- **Bridge sample:** the same pooled lysate in one lane of every gel, so signals can be
  compared across gels.
- **Normalization:** p-KIN to total KIN on the same membrane (strip/reprobe or two-colour
  detection), and total protein staining as a loading control rather than a single
  "housekeeping" protein that may change.
- **Lane order:** randomize or alternate positions between gels (transfer can be uneven
  across a gel); quantify blind to lane identity.

![Western blot plan: each of three independent experiments is run on its own gel containing unstimulated, stimulated and stimulated-plus-inhibitor samples plus a shared bridge lysate and a dilution series confirming the linear range; lane order differs between gels](figures/diagrams/16-molecular-cell-biochemistry-9ec74387ed.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** What makes two cell-culture experiments "independent"?

**⭐ Q2.** Name three MIQE essentials.

**⭐⭐ Q3.** With equal target/reference efficiencies of 95% and ΔΔCt = −4, what is the
efficiency-corrected fold change, compared with the 2^(−ΔΔCt) estimate?

**⭐⭐ Q4.** Why should substrate concentrations in a kinetics experiment span values
above and below *K_m*?

**⭐⭐⭐ Q5.** A reviewer asks for "biological replicates" of your western blot result.
You have three blots, run the same day from one lysate. What do you do?

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Different days."* — **◑ 6/10.** Different day helps, but
repeat the full treatment comparison in independently prepared cultures. Record shared
stock, passage and reagent lots; model shared run effects. A different day or thaw alone
does not replicate donors or cell lines.

> **Q2 — Sample answer:** *"Efficiency, reference gene validation, no-template control."* —
**✔ 10/10.**

> **Q3 — Sample answer:** *"1.95⁴ ≈ 14.5 vs 16."* — **✔ 10/10.** (1.95⁴ = 14.46.)

> **Q4 — Sample answer:** *"To see the curve flatten."* — **✔ 8/10.** More fully: points
below *K_m* determine the initial slope (*V_max/K_m*), points well above determine
*V_max*. Both are needed to estimate both parameters.

> **Q5 — Sample answer:** *"Say it's three replicates."* — **✘ 1/10.** They are technical
replicates of one lysate. Repeat the experiment from independent cultures (new treatment,
new lysate) across runs, justify the number for the target effect or precision, quantify each
within the linear range, and present all blots. Three runs is not a universal adequacy threshold.

**Rubric:** bench answers earn full credit when they name what varies between replicates.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **Replication** | Independent experiments; SuperPlots to show them. |
| **qPCR** | Efficiency, validated reference genes, controls, MIQE. |
| **Blots & imaging** | Linear range, total-protein normalization, blinding. |
| **Kinetics** | Concentrations around *K_m*; nonlinear fits; STRENDA. |
| **Materials** | Authenticate, test for mycoplasma, validate antibodies. |

**Traps to remember:** wells as *n* · GAPDH by default · representative blots ·
three-point kinetics · unauthenticated lines.

### 📇 Design Card — field checklist

| Item | Done? |
|---|---|
| Independent experiments defined | |
| Assay-specific controls (MIQE/STRENDA) | |
| Blinding of quantification | |
| Orthogonal perturbations/rescue | |
| Cell line authentication & mycoplasma | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 31 — Replicates](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/31-replicates.md) · [Ch. 4 — Data Visualization](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/04-data-visualization.md)
- More: ([Bustin & Nolan, 2017](https://doi.org/10.1111/eci.12801); [Blainey et al., 2014](https://doi.org/10.1038/nmeth.3091))

## 📚 References cited in this chapter

- Blainey P, Krzywinski M, Altman N (2014). Replication. *Nature Methods* 11:879-880. [doi:10.1038/nmeth.3091](https://doi.org/10.1038/nmeth.3091)
- Bustin S, Nolan T (2017). Talking the talk, but not walking the walk: RT-qPCR as a paradigm for the lack of reproducibility in molecular research. *European Journal of Clinical Investigation* 47:756-774. [doi:10.1111/eci.12801](https://doi.org/10.1111/eci.12801)
- Bustin SA, Benes V, Garson JA, Hellemans J, Huggett J, Kubista M, et al. (2009). The MIQE Guidelines: Minimum Information for Publication of Quantitative Real-Time PCR Experiments. *Clinical Chemistry* 55:611-622. [doi:10.1373/clinchem.2008.112797](https://doi.org/10.1373/clinchem.2008.112797)
- Cumming G, Fidler F, Vaux DL (2007). Error bars in experimental biology. *The Journal of Cell Biology* 177:7-11. [doi:10.1083/jcb.200611141](https://doi.org/10.1083/jcb.200611141)
- Ghasemi M, Turnbull T, Sebastian S, Kempson I (2021). The MTT Assay: Utility, Limitations, Pitfalls, and Interpretation in Bulk and Single-Cell Analysis. *International Journal of Molecular Sciences* 22:12827. [doi:10.3390/ijms222312827](https://doi.org/10.3390/ijms222312827)
- Horbach SPJM, Halffman W (2017). The ghosts of HeLa: How cell line misidentification contaminates the scientific literature. *PLOS ONE* 12:e0186281. [doi:10.1371/journal.pone.0186281](https://doi.org/10.1371/journal.pone.0186281)
- Huggett JF, Foy CA, Benes V, Emslie K, Garson JA, Haynes R, et al. (2013). The Digital MIQE Guidelines: Minimum Information for Publication of Quantitative Digital PCR Experiments. *Clinical Chemistry* 59:892-902. [doi:10.1373/clinchem.2013.206375](https://doi.org/10.1373/clinchem.2013.206375)
- Johnson KA, Goody RS (2011). The Original Michaelis Constant: Translation of the 1913 Michaelis–Menten Paper. *Biochemistry* 50:8264-8269. [doi:10.1021/bi201284u](https://doi.org/10.1021/bi201284u)
- Lee JY, Kitaoka M (2018). A beginner’s guide to rigor and reproducibility in fluorescence imaging experiments. *Molecular Biology of the Cell* 29:1519-1525. [doi:10.1091/mbc.e17-05-0276](https://doi.org/10.1091/mbc.e17-05-0276)
- Livak KJ, Schmittgen TD (2001). Analysis of Relative Gene Expression Data Using Real-Time Quantitative PCR and the 2−ΔΔCT Method. *Methods* 25:402-408. [doi:10.1006/meth.2001.1262](https://doi.org/10.1006/meth.2001.1262)
- Lord SJ, Velle KB, Mullins RD, Fritz-Laylin LK (2020). SuperPlots: Communicating reproducibility and variability in cell biology. *Journal of Cell Biology* 219:e202001064. [doi:10.1083/jcb.202001064](https://doi.org/10.1083/jcb.202001064)
- Pillai-Kastoori L, Schutz-Geschwender AR, Harford JA (2020). A systematic approach to quantitative Western blot analysis. *Analytical Biochemistry* 593:113608. [doi:10.1016/j.ab.2020.113608](https://doi.org/10.1016/j.ab.2020.113608)
- Smucker B, Krzywinski M, Altman N (2018). Optimal experimental design. *Nature Methods* 15:559-560. [doi:10.1038/s41592-018-0083-2](https://doi.org/10.1038/s41592-018-0083-2)
- Tipton KF, Armstrong RN, Bakker BM, Bairoch A, Cornish-Bowden A, Halling PJ, et al. (2014). Standards for Reporting Enzyme Data: The STRENDA Consortium: What it aims to do and why it should be helpful. *Perspectives in Science* 1:131-137. [doi:10.1016/j.pisc.2014.02.012](https://doi.org/10.1016/j.pisc.2014.02.012)
- Vandesompele J, De Preter K, Pattyn F, Poppe B, Van Roy N, De Paepe A, et al. (2002). Accurate normalization of real-time quantitative RT-PCR data by geometric averaging of multiple internal control genes. *Genome Biology* 3:research0034.1. [doi:10.1186/gb-2002-3-7-research0034](https://doi.org/10.1186/gb-2002-3-7-research0034)
- Vaux DL, Fidler F, Cumming G (2012). Replicates and repeats—what is the difference and is it significant?. *The EMBO Reports* 13:291-296. [doi:10.1038/embor.2012.36](https://doi.org/10.1038/embor.2012.36)


---

[← Chapter 15](15-measurement-and-benchmarking.md) · [Table of Contents](../README.md) · [Next: Chapter 17 — Microbiology and the Microbiome →](17-microbiology-microbiome.md)
