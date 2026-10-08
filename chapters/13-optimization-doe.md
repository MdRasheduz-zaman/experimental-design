# Chapter 13 — Optimization: Design of Experiments and Response Surfaces (Q6)

> **Part III — Designs by Question Type**
> [← Chapter 12](12-predictive-studies.md) · [Table of Contents](../README.md) · [Next: Chapter 14 — Screening Designs →](14-screening-designs.md)

---

## 🧭 Learning Objectives

After this chapter you will be able to:

1. Explain the **sequential DoE strategy**: screen → move → model curvature → confirm.
2. Set up a **2^k factorial** in coded units and compute main effects and interactions.
3. Recognize when to use fractional factorial, Plackett–Burman, central composite and Box–Behnken designs.
4. Use centre points to estimate pure error and detect curvature.
5. Describe how model-guided (Bayesian) optimization extends classical DoE.

---

## 🎯 The Big Picture

Optimization questions — *which settings maximize yield, titre, purity, stability?* —
dominate biotechnology, bioprocess engineering, formulation science and assay
development. The naive approach is **one factor at a time** (OFAT): vary temperature,
fix it at the best value, then vary pH, and so on. OFAT needs many runs, misses
interactions, and can stop far from the true optimum when factors interact.

**Design of experiments (DoE)** varies several factors *together* in a planned pattern,
then fits a model of how the response depends on them ([Box & Wilson, 1951](https://doi.org/10.1111/j.2517-6161.1951.tb00067.x)). It consistently
outperforms OFAT in media and bioprocess optimization ([Weuster-Botz, 2000](https://doi.org/10.1016/s1389-1723%2801%2980027-x); [Mandenius & Brundin, 2008](https://doi.org/10.1002/btpr.67); [Kumar et al., 2014](https://doi.org/10.1002/btpr.1821)).

---

## 🧠 Core Intuition

### Coded units

Each factor gets a low (−1) and high (+1) level, e.g. temperature 30 °C = −1 and
37 °C = +1. Coding puts all factors on the same scale, so effects are directly comparable.

### The sequential strategy

![Sequential design of experiments: screen, move, model curvature, confirm](figures/diagrams/13-optimization-doe-ae84ec5330.png)

![Optimization in three stages: screening many factors with a fractional factorial, refining the few that matter with a response surface design, and confirming the predicted optimum with replicated runs](figures/diagrams/13-optimization-doe-602b545c66.png)

### Which design for which stage?

| Stage | Design | Runs for k factors | Estimates |
|---|---|---|---|
| Screening (many factors) | Plackett–Burman ([PLACKETT & BURMAN, 1946](https://doi.org/10.1093/biomet/33.4.305)); 2^(k−p) fractional factorial | ~k + 1 to 2^(k−p) | main effects (interactions aliased) |
| Effects and interactions | full 2^k factorial | 2^k | all main effects and interactions |
| Curvature/optimum | central composite | factorial/fractional core + 2k axial runs + centre points | quadratic surface |
| Curvature/optimum | Box–Behnken (k ≥ 3) | standard 3-factor design: 12 + centre points; size depends on k | quadratic surface without all-extreme corners |
| Mixtures (components sum to 100%) | simplex/mixture designs | varies | blending effects |

![Matching the design to the stage of optimization: many factors and few runs call for a fractional factorial or Plackett-Burman screen, a full factorial suits a handful of factors, and a central composite or Box-Behnken design fits a curved surface over two or three factors](figures/diagrams/13-optimization-doe-df6186774f.png)

### Centre points

Adding 3–5 runs at the centre (all factors at 0) gives an estimate of **pure error**
(replication) and a test for **curvature**: if the centre mean differs from the average
of the corner runs, a linear model is not enough.

![Design points for two factors: four factorial corners estimate linear effects and the interaction, replicated centre points estimate pure error and reveal curvature, and axial points added later allow a quadratic surface](figures/diagrams/13-optimization-doe-2707f6c9cc.png)

### Several responses

Titre, purity and cost often pull in different directions. **Desirability functions**
convert each response to a 0–1 scale and combine them, so a compromise optimum can be
found ([Vera Candioti et al., 2014](https://doi.org/10.1016/j.talanta.2014.01.034)).

### Beyond classical DoE: model-guided optimization

When experiments are run in batches and the space is large (protein sequences, strain
designs), a model is trained on results so far and proposes the **next batch** — e.g.
Bayesian optimization or machine-learning-guided directed evolution ([Yang et al., 2019](https://doi.org/10.1038/s41592-019-0496-6); [Ryan et al., 2016](https://doi.org/10.1111/insr.12107)).
The design principles still apply: replicate controls in every batch, randomize run
order, and keep a hold-out set to check the model's predictions.

---

## 👁️ Visual Intuition — OFAT can miss the optimum



When factors interact, the ridge of the response surface runs diagonally, and OFAT
walks along the wrong axis.

![Response surface with a diagonal ridge: the OFAT path stops at yield 68 while the true optimum is 75; central composite design points cover the region](../assets/course/ch13-ofat-vs-doe.png)


---

## 🔬 Worked Example — a 2³ factorial for a fermentation

Factors: temperature (T), pH and glucose (G), each at two coded levels. Eight runs in
random order; response = product yield (mg/L).

| Run | T | pH | G | Yield |
|---|---|---|---|---|
| 1 | − | − | − | 52 |
| 2 | + | − | − | 60 |
| 3 | − | + | − | 54 |
| 4 | + | + | − | 70 |
| 5 | − | − | + | 50 |
| 6 | + | − | + | 62 |
| 7 | − | + | + | 56 |
| 8 | + | + | + | 80 |

**Main effect** = mean at + minus mean at −:

- **T:** (60 + 70 + 62 + 80)/4 − (52 + 54 + 50 + 56)/4 = 68 − 53 = **15**
- **pH:** (54 + 70 + 56 + 80)/4 − (52 + 60 + 50 + 62)/4 = 65 − 56 = **9**
- **G:** (50 + 62 + 56 + 80)/4 − (52 + 60 + 54 + 70)/4 = 62 − 59 = **3**

**Interaction T × pH:** the effect of T at high pH minus its effect at low pH, halved:
at pH +: (70 + 80)/2 − (54 + 56)/2 = 20; at pH −: (60 + 62)/2 − (52 + 50)/2 = 10;
interaction = (20 − 10)/2 = **5**. The other interactions are 3 (T×G), 3 (pH×G) and
1 (T×pH×G).

**Interpretation:** temperature dominates, pH matters, and they reinforce each other.
Glucose has little effect in this range. **Next step:** move toward higher T and pH
(steepest ascent), then run a central composite design there to model curvature, with
centre points for pure error. (Check in R: `2 * coef(lm(Yield ~ T * pH * G))` reproduces
these effects; script: `scripts/course/worked_examples.R`.)

*Note:* with one run per corner and no centre points, there is no estimate of pure
error. In practice add centre-point replicates, or treat the three-factor interaction as
error.

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"OFAT is fine if I'm careful."** | Care cannot reveal interactions that OFAT never tests. |
| **"DoE needs too many runs."** | A 2^(7−4) fractional factorial screens 7 factors in 8 runs; OFAT needs more for less information. |
| **"Runs can be done in the standard order."** | Randomize run order to protect against drift in equipment, inoculum or raw materials. Block on raw-material lot if needed. |
| **"The model's optimum is the answer."** | Always **confirm** with new runs at the predicted optimum. |
| **"Fractional designs give everything."** | Main effects are *aliased* with some interactions. Choose the resolution deliberately. |

---

## 🧪 Spot the Flaw

> "We optimized six medium components by varying each one in turn while holding the
> others at their baseline values. The final medium (each component at its individually
> best level) increased titre by 40% over baseline in a single confirmation run."

<details>
<summary>▶ Diagnosis</summary>

OFAT ignores interactions: the individually best levels need not be jointly best. A
single confirmation run gives no estimate of variability, so "40%" may be noise. **Fix:**
a fractional factorial/Plackett–Burman screen of the six components, then a response
surface design on the important ones, with centre-point replicates, randomized run
order, and replicated confirmation runs compared with replicated baseline runs.
</details>

---

## 🔎 The Reviewer's Perspective

- **"Which design was used, with how many runs, in what order?"**
- **"Is there an estimate of pure error (replicates or centre points)?"**
- **"Were aliasing and model adequacy (lack of fit, curvature) checked?"**
- **"Was the predicted optimum confirmed with replicated runs?"**

---

## 🛠️ Design Challenges

Three optimization (Q6) problems. For each, decide the **stage** you are in (screening,
refining, confirming) before choosing a design — then open the model answer and its
diagram.

### Challenge 1 · Synthetic biology · ⭐⭐ — a cell-free expression reaction

You must optimize a cell-free protein-expression reaction with 5 factors (Mg²⁺, K⁺,
DNA concentration, temperature, incubation time). Budget: about 40 reactions over
2 days.

<details>
<summary>▶ A model design</summary>

- **Day 1 — screening:** 2^(5−1) resolution V fractional factorial (16 runs) + 4 centre
  points = 20 runs, randomized. Main effects and two-factor interactions are estimable.
  Day is a block if the work spans days.
- **Day 2 — refine:** keep the 2–3 important factors; run a central composite or
  Box–Behnken design around the best region (~15 runs, including centre points).
- **Confirm:** 3–4 replicate reactions at the predicted optimum vs 3–4 at the baseline.
- **Randomize** pipetting order and plate positions; prepare master mixes to reduce
  pipetting error.

![Sequential optimization over two days: day one is a 16-run half-fraction factorial with 4 centre points to screen five factors, day two is a response-surface design on the two or three important factors, followed by a confirmation run comparing the predicted optimum with the baseline](figures/diagrams/13-optimization-doe-736ee465a8.png)
</details>

### Challenge 2 · Industrial microbiology · ⭐⭐ — a growth medium in 20 runs

You want to maximize biomass of a bacterium as a function of three factors already known to
matter: glucose, yeast extract and pH. The response is probably curved (there is an optimum
inside the range). You have 20 shake flasks. Design the experiment.

<details>
<summary>▶ A model design</summary>

- **Central composite design (CCD)** in coded units: **8 factorial points** (the corners
  of the cube, ±1), **6 axial points** (one factor at ±α, others at 0) and **6 centre points**
  = 20 runs. It estimates all linear, quadratic and two-factor interaction terms.
- **Centre points** give pure error and a check on reproducibility; spread them through the
  run order, not all at the start.
- **Ranges:** set ±1 to a realistic window around current conditions; check that axial
  points (α ≈ 1.68 for a rotatable 3-factor CCD) are physically possible (e.g. pH stays in a
  range the organism tolerates); use a face-centred CCD (α = 1) if not.
- **Randomize** run order; if flasks are run on two days, split the design into two
  orthogonal blocks (the factorial points and the axial points, each block with its share of the centre points).
- **Then:** fit the quadratic model, find the stationary point, confirm with replicate flasks.

![Composition of a 20-run central composite design for three factors: eight factorial corner points, six axial points and six centre points, together estimating linear, interaction and quadratic effects, run in random order](figures/diagrams/13-optimization-doe-bb0f7e9154.png)
</details>

### Challenge 3 · Plant biotechnology · ⭐⭐ — regenerating shoots from tissue culture

Shoot regeneration from leaf explants depends on the **ratio** of two hormones, an auxin and
a cytokinin, with a strong interaction. Previous work found nothing with either hormone
alone. You have 48 Petri dishes and growth-chamber space for all of them. Design the
experiment.

<details>
<summary>▶ A model design</summary>

- **A two-factor full factorial grid** is the right tool when there are only two factors
  and a strong interaction is expected: **4 auxin levels × 4 cytokinin levels = 16
  combinations**, including 0 for each, on a log-like scale (e.g. 0, 0.1, 0.5, 2.5 mg/L).
- **Replication:** 3 dishes per combination = 48 dishes; the **dish** is the unit
  (explants within a dish share medium) — score the % of explants regenerating per dish.
- **Blocks:** 3 chamber shelves (light may differ) as blocks, each with one dish of every
  combination in random positions (a randomized complete block design).
- **Analysis:** regeneration ~ shelf + auxin × cytokinin (as factors or a response surface);
  look at the shape of the interaction, then refine around the best region.

![Four by four factorial grid of auxin and cytokinin concentrations; each of the 16 combinations is replicated once on each of three shelves used as blocks, giving 48 dishes; the corner with both hormones at zero and the edges with one hormone alone are included](figures/diagrams/13-optimization-doe-3745ddd670.png)
</details>

---

## ✅ Check Your Understanding

**⭐ Q1.** List the four stages of the sequential DoE strategy.

**⭐ Q2.** What are centre points for?

**⭐⭐ Q3.** From the worked example, compute the main effect of glucose and explain what
it means.

**⭐⭐ Q4.** Why is OFAT especially misleading when factors interact?

**⭐⭐⭐ Q5.** A colleague wants to screen 11 factors affecting enzyme stability with
minimal runs. Propose a design, state what it cannot estimate, and describe the
follow-up.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1 — Sample answer:** *"Screen, move, model curvature, confirm."* — **✔ 10/10.**

> **Q2 — Sample answer:** *"To check the middle."* — **◑ 5/10.** Be specific: replicated
centre points estimate **pure error** and test for **curvature** (centre mean vs corner
mean).

> **Q3 — Sample answer:** *"62 − 59 = 3; glucose increases yield a little."* —
**✔ 9/10.** And note: within this range the effect is small relative to T and pH. That
does not mean glucose doesn't matter outside the range.

> **Q4 — Sample answer:** *"Because the best level of one factor depends on the
other."* — **✔ 10/10.**

> **Q5 — Sample answer:** *"A Plackett–Burman design with 12 runs."* — **✔ 9/10.** Add
the limits: it estimates main effects only, with interactions partially aliased. Follow
up the important factors with a full or higher-resolution factorial and then a response
surface; add centre points or replicates for error.

**Rubric:** name the design, its run count, what is aliased, and the next step.
</details>

---

## 🧾 Chapter Summary

| Concept | One-line takeaway |
|---|---|
| **DoE vs OFAT** | Vary factors together; estimate interactions; fewer runs. |
| **Sequential** | Screen → move → model curvature → confirm. |
| **Designs** | Plackett–Burman/fractional for screening; CCD/Box–Behnken for optima. |
| **Centre points** | Pure error and curvature. |
| **Model-guided** | Bayesian/ML optimization proposes next batches; principles still apply. |

**Traps to remember:** OFAT · unrandomized run order · no replicates · unconfirmed
optimum · ignored aliasing.

### 📇 Design Card — add these rows (Q6)

| Field | Your answer |
|---|---|
| Factors and ranges (coded −1/+1) | |
| Responses (and desirability weights) | |
| Design per stage and run count | |
| Confirmation plan | |

---

## 🔗 Go Deeper

- 📘 Biostat course: [Ch. 16 — Linear Regression](https://github.com/MdRasheduz-zaman/biostatistics/blob/main/chapters/16-linear-regression.md)
- Applications in pharmacy and bioengineering: ([N. Politis et al., 2017](https://doi.org/10.1080/03639045.2017.1291672); [Keskin Gündoğdu et al., 2016](https://doi.org/10.3109/07388551.2014.973014); [Yu et al., 2014](https://doi.org/10.1208/s12248-014-9598-3))

## 📚 References cited in this chapter

- Box GEP, Wilson KB (1951). On the Experimental Attainment of Optimum Conditions. *Journal of the Royal Statistical Society Series B: Statistical Methodology* 13:1-38. [doi:10.1111/j.2517-6161.1951.tb00067.x](https://doi.org/10.1111/j.2517-6161.1951.tb00067.x)
- Keskin Gündoğdu T, Deniz İ, Çalışkan G, Şahin ES, Azbar N (2016). Experimental design methods for bioengineering applications. *Critical Reviews in Biotechnology* 36:368-388. [doi:10.3109/07388551.2014.973014](https://doi.org/10.3109/07388551.2014.973014)
- Kumar V, Bhalla A, Rathore AS (2014). Design of experiments applications in bioprocessing: Concepts and approach. *Biotechnology Progress* 30:86-99. [doi:10.1002/btpr.1821](https://doi.org/10.1002/btpr.1821)
- Mandenius C, Brundin A (2008). Bioprocess optimization using design‐of‐experiments methodology. *Biotechnology Progress* 24:1191-1203. [doi:10.1002/btpr.67](https://doi.org/10.1002/btpr.67)
- N. Politis S, Colombo P, Colombo G, M. Rekkas D (2017). Design of experiments (DoE) in pharmaceutical development. *Drug Development and Industrial Pharmacy* 43:889-901. [doi:10.1080/03639045.2017.1291672](https://doi.org/10.1080/03639045.2017.1291672)
- PLACKETT RL, BURMAN JP (1946). THE DESIGN OF OPTIMUM MULTIFACTORIAL EXPERIMENTS. *Biometrika* 33:305-325. [doi:10.1093/biomet/33.4.305](https://doi.org/10.1093/biomet/33.4.305)
- Ryan EG, Drovandi CC, McGree JM, Pettitt AN (2016). A Review of Modern Computational Algorithms for Bayesian Optimal Design. *International Statistical Review* 84:128-154. [doi:10.1111/insr.12107](https://doi.org/10.1111/insr.12107)
- Vera Candioti L, De Zan MM, Cámara MS, Goicoechea HC (2014). Experimental design and multiple response optimization. Using the desirability function in analytical methods development. *Talanta* 124:123-138. [doi:10.1016/j.talanta.2014.01.034](https://doi.org/10.1016/j.talanta.2014.01.034)
- Weuster-Botz D (2000). Experimental design for fermentation media development: Statistical design or global random search?. *Journal of Bioscience and Bioengineering* 90:473-483. [doi:10.1016/s1389-1723(01)80027-x](https://doi.org/10.1016/s1389-1723%2801%2980027-x)
- Yang KK, Wu Z, Arnold FH (2019). Machine-learning-guided directed evolution for protein engineering. *Nature Methods* 16:687-694. [doi:10.1038/s41592-019-0496-6](https://doi.org/10.1038/s41592-019-0496-6)
- Yu LX, Amidon G, Khan MA, Hoag SW, Polli J, Raju GK, et al. (2014). Understanding Pharmaceutical Quality by Design. *The AAPS Journal* 16:771-783. [doi:10.1208/s12248-014-9598-3](https://doi.org/10.1208/s12248-014-9598-3)


---

[← Chapter 12](12-predictive-studies.md) · [Table of Contents](../README.md) · [Next: Chapter 14 — Screening Designs →](14-screening-designs.md)
