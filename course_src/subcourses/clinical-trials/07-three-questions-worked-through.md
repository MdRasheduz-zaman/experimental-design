# Module 7 — Three Questions Worked From Beginning to Discussion

> **Sub-course: Clinical-Study Biostatistics**
> [← Module 6](06-phase-iii-layouts-and-claims.md) · [Sub-course home](README.md) · [Next: Module 8 — Integrated Design Clinic and Retrieval Practice →](08-design-clinic-and-retrieval.md)

---

## 🧭 Learning Objectives

After this module you will be able to:

1. Work a wet-lab, a computational and a clinical question through the same chain: question → design → data → checks → method → result → conclusion → discussion.
2. Identify the independent unit in each of the three settings and keep the analysis faithful to it.
3. Read R output for a paired comparison, a negative-binomial model with FDR control, and a baseline-adjusted linear model.
4. Limit each conclusion to what its design supports.

---

Each example follows the same chain: question → design → data → checks → method → result →
conclusion → discussion. The first uses a wet-lab experiment, the second dry-lab gene-expression
analysis, and the third a clinical trial. The numeric datasets below are teaching examples. They
show how to reason from data and code; they are not claims about a real drug, assay or participant
study.

## Wet-lab example: does a compound reduce an inflammatory signal?

**Research question.** In a cultured macrophage cell model stimulated with lipopolysaccharide (LPS),
does Compound A change secreted TNF-α compared with vehicle at 24 hours?

This is a narrow laboratory question about one cell model and a measured protein concentration. It
does not ask whether Compound A treats inflammation in people.

**Step 1 — Design before collecting data.** Use six independent culture runs, performed on separate
days from independently prepared cultures. On every run, split the same preparation between
LPS + vehicle and LPS + Compound A. The run is a block, so each treatment pair shares that run's
conditions. Randomize well positions within a run; code samples so the person reading the assay does
not know the treatment if practical. Average technical replicate wells within each sample before
the treatment comparison. They help measure assay precision but do not increase the six independent
culture runs.

Include a no-LPS reference to check that stimulation worked and a compound-only or suitable viability
control to check whether lower TNF-α simply reflects cell loss. The primary comparison remains the
paired LPS + Compound A versus LPS + vehicle contrast. Decide the primary endpoint, units, exclusions,
and handling of failed wells before examining the treatment pattern.

**Step 2 — Inspect the teaching data.** Values are illustrative pg/mL; one row is one independent
culture run after technical wells were averaged.

| Culture run | LPS + vehicle | LPS + Compound A | Paired reduction (vehicle − compound) |
|---:|---:|---:|---:|
| 1 | 100 | 82 | 18 |
| 2 | 112 | 93 | 19 |
| 3 | 96 | 80 | 16 |
| 4 | 108 | 94 | 14 |
| 5 | 104 | 88 | 16 |
| 6 | 99 | 81 | 18 |

Check that each run has both conditions, the units are consistent, values fall in the assay's valid
range, sample identities match the plate map, and exclusions have documented technical reasons.
Plot the paired values and the within-run differences. Pairing matters because the treatment contrast
is made inside each independent run.

**Step 3 — Choose the analysis.** Estimate the mean paired difference `Compound A − vehicle`. A
paired t interval uses the six independent within-run differences and assumes those differences are
reasonably represented by a normal distribution. With six runs, inspect the differences and treat the
interval as uncertain; a more complex model cannot manufacture independent runs. If the differences
are severely skewed or dominated by an error, investigate the assay and consider a robust or
randomization-based analysis specified for the design.

```r
wet <- data.frame(
  run = factor(1:6),
  vehicle = c(100, 112, 96, 108, 104, 99),
  compound = c(82, 93, 80, 94, 88, 81)
)
wet$difference <- wet$compound - wet$vehicle
wet$difference
# [1] -18 -19 -16 -14 -16 -18

fit_wet <- t.test(wet$compound, wet$vehicle, paired = TRUE)
fit_wet
```

**Step 4 — Read the output.** The mean difference is **−16.83 pg/mL**. The illustrative 95% CI is
**−18.76 to −14.91 pg/mL**; the paired t-test gives `t = −22.47`, `df = 5`, `p = 3.24 × 10⁻⁶`.
The interval estimates the mean change for this model and assay, under the analysis assumptions.
The small p-value says these particular paired data are difficult to reconcile with a zero mean
paired difference under the t-test model. It does not measure the probability that the drug works.

**Conclusion for this question.** “Across six illustrative independent macrophage culture runs,
LPS + Compound A had lower mean measured TNF-α than LPS + vehicle at 24 hours (mean paired difference
−16.83 pg/mL; 95% CI −18.76 to −14.91).”

**Discussion: what would you say next?** Confirm that LPS stimulation worked, inspect assay validity,
and check viability. If Compound A reduces viable cell number, reduced TNF-α may reflect fewer living
cells rather than a selective anti-inflammatory effect. Replicate the result with independently
prepared cultures, an orthogonal protein or transcript assay, and a preregistered or prespecified
analysis. Six runs provide limited evidence about between-run variability. Do not turn a cell-culture
concentration into a human effect or therapeutic recommendation.

**Your turn.** If each run had four technical wells per condition, would the analysis have 24 pairs?

<details>
<summary>Worked answer</summary>

No. Average valid technical wells within each run and condition using the stated assay rule. The
independent treatment comparison still has six paired culture runs. Treating 24 technical pairs as
independent would understate uncertainty because wells share their culture preparation and run.

</details>

## Dry-lab example: which genes differ in simulated RNA-seq data?

**Research question.** In a fictional experiment with cultured cells, which genes show evidence of
different expression between stimulated control cultures and stimulated cultures treated with
Compound A?

This is a dry-lab analysis of a gene-count matrix. In a real workflow, sequencing reads first pass
sample and base-quality checks, adapter trimming where needed, alignment or transcript quantification
against a named genome annotation, and assignment to genes. Counts and metadata must use the same
sample IDs. Here we begin at the count-matrix stage so the statistical reasoning stays visible.

**Step 1 — Design and data structure.** The reproducible code below simulates 200 genes in four
independent samples per condition. Eight genes are assigned a two-fold increase and four a two-fold
decrease in the simulation; the other genes have no assigned treatment effect. Negative-binomial
sampling adds realistic count variation. The random seed makes this teaching dataset repeatable.

The sample table says which columns belong to control and treatment. Every column name must match
one metadata row. Check for duplicated IDs, zero or implausible library totals, sample swaps, and
whether plots or sample relationships reveal an outlier or batch pattern. Real experiments should
balance treatment across sequencing/library-preparation batches; if batch is part of the design and
not confounded with treatment, prespecify a model such as `~ batch + condition`.

**Step 2 — Analyse counts with a count model.** RNA-seq counts are discrete and their variance
usually changes with their mean. DESeq2 estimates library size factors and gene-wise dispersion,
then fits a negative-binomial model. The design `~ condition` estimates the treated-versus-control
contrast. If testing thousands of genes, control the false-discovery rate; a raw p-value threshold
alone produces many false leads.

```r
# Requires Bioconductor package DESeq2; uses simulated counts, no downloaded data.
set.seed(2706)
n_genes <- 200L
n_per_group <- 4L
condition <- factor(rep(c("control", "treated"), each = n_per_group),
                    levels = c("control", "treated"))
sample_info <- data.frame(
  condition = condition,
  row.names = paste0("sample_", seq_along(condition))
)
base_mean <- rlnorm(n_genes, meanlog = log(120), sdlog = 0.8)
true_log2fc <- rep(0, n_genes)
true_log2fc[1:8] <- 1
true_log2fc[9:12] <- -1
size_factor <- c(0.85, 1.05, 0.95, 1.15, 0.90, 1.10, 1.00, 1.05)
counts <- sapply(seq_along(condition), function(j) {
  mu <- base_mean * size_factor[j] *
    if (condition[j] == "treated") 2^true_log2fc else 1
  rnbinom(n_genes, mu = mu, size = 10)
})
rownames(counts) <- paste0("gene_", sprintf("%03d", seq_len(n_genes)))
colnames(counts) <- rownames(sample_info)
stopifnot(identical(colnames(counts), rownames(sample_info)))

# Raw counts enter DESeq2; do not use TPM/FPKM as input to this model.
dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = round(counts), colData = sample_info, design = ~ condition
)
dds <- DESeq2::DESeq(dds, quiet = TRUE)
res <- DESeq2::results(
  dds, contrast = c("condition", "treated", "control"), alpha = 0.05
)
res <- res[order(res$padj), ]
head(as.data.frame(res)[, c("baseMean", "log2FoldChange", "pvalue", "padj")])
sum(res$padj < 0.05, na.rm = TRUE)
```

**Step 3 — Interpret the computed result.** In the tested run (R 4.3.3, DESeq2 1.42.1),
nine genes have adjusted p-values below 0.05. Among the leading rows, `gene_005` has mean normalized
abundance about 94.9 counts, log2 fold change **+1.535**, raw p **2.30 × 10⁻⁷**, adjusted p
**4.59 × 10⁻⁵**; `gene_010` has log2 fold change **−1.307**, adjusted p **0.00160**. A log2 fold
change of +1 corresponds to twice the expression on the model's scale; +1.535 is about 2.9-fold.
The result table sorts by adjusted p-value. The code's FDR threshold applies across the tested genes,
not separately to whichever rows look most interesting.

**Conclusion for this question.** “In this simulated count matrix, the DESeq2 model identifies nine
genes with evidence of differential expression at 5% FDR. `gene_005` is higher and `gene_010` lower
in treated than control cultures by the estimated fold changes.”

**Discussion: what would this establish in a real experiment?** The simulation planted known effects,
but real data do not come with planted truth. For real samples, validate sample identity, genome and
annotation versions, library quality, batch balance and outliers before interpreting genes. Report
fold changes and uncertainty alongside adjusted p-values; low counts and small sample sizes can make
fold changes uncertain. Check the biological meaning with independently chosen validation and
replication. The 200-gene simulation is small for teaching and its count-generation assumptions are
known; nine discoveries are not evidence that the same genes respond in actual cells.

**Your turn.** If treatment and sequencing batch were perfectly confounded, could adding `batch` to
the model separate their effects?

<details>
<summary>Worked answer</summary>

No. If every control was sequenced in batch 1 and every treated sample in batch 2, condition and batch
are inseparable in these data. A model cannot identify which one caused the difference. Balance the
conditions across batches in the design, or be explicit that the effect cannot be separated here.

</details>

## Statistical example: estimate a treatment effect in a randomized trial

**Research question.** Among adults randomized to Drug A or usual care for hypertension, what is
the mean difference in systolic blood pressure at Week 12, adjusted for baseline pressure?

For this teaching analysis, define the contrast as **Drug A minus usual care**, so a negative value
favours Drug A for blood pressure reduction. The dataset is fictional and complete; it contains ten
participants per arm, baseline and Week-12 pressure in mmHg. A real trial would prespecify its
estimand, visit window, intercurrent-event strategy, missing-data plan and model before unblinding.

**Step 1 — Confirm the randomized comparison.** Keep participants in their assigned arms for this
assignment-based question, regardless of treatment received. Check unique IDs, allocation labels,
units, baseline/follow-up pairing and missing outcomes. Here there are ten complete records per arm
and no missing data by construction. In a real dataset, summarize participant flow and missingness;
ITT does not fill in missing Week-12 readings.

**Step 2 — Plot and summarize before fitting.** Inspect baseline balance descriptively, follow-up
values by arm and each participant's change. Randomization does not guarantee identical baselines,
so a prespecified baseline-adjusted analysis can improve precision. Do not decide whether to adjust
by testing baseline p-values.

**Step 3 — Fit the prespecified ANCOVA model.** Regress Week-12 pressure on assigned arm and baseline
pressure. With `control` as the reference, the `armtreated` coefficient estimates the adjusted
mean difference. This simple model assumes a linear baseline relationship and a common baseline
slope in both arms. Trial-specific diagnostics and design features can motivate other terms; do not
add them by searching for significance.

```r
control_baseline <- c(150, 155, 148, 160, 152, 157, 149, 154, 151, 158)
treat_baseline   <- c(151, 156, 149, 161, 153, 158, 150, 155, 152, 159)
control_week12 <- c(142, 148, 139, 151, 143, 149, 140, 146, 142, 150)
treat_week12   <- c(136, 143, 134, 146, 137, 144, 135, 141, 137, 145)
trial <- data.frame(
  arm = factor(rep(c("control", "treated"), each = 10),
               levels = c("control", "treated")),
  baseline = c(control_baseline, treat_baseline),
  week12 = c(control_week12, treat_week12)
)
fit <- lm(week12 ~ arm + baseline, data = trial)
coef(summary(fit))["armtreated", ]
confint(fit)["armtreated", ]
```

**Step 4 — Interpret magnitude, precision and model assumptions.** The estimated adjusted difference
is **−6.27 mmHg**, with 95% CI **−6.97 to −5.58**; the model-based standard error is **0.33 mmHg**.
The interval describes uncertainty under this model and sample. It does not incorporate every source
of uncertainty, such as model misspecification or a different population. In this constructed example
the estimate is very precise because the data were deliberately made regular; actual small trials
rarely warrant that confidence.

**Conclusion for this question.** “In this fictional complete dataset, mean Week-12 systolic pressure
was estimated to be 6.27 mmHg lower under assignment to Drug A than usual care after baseline
adjustment (95% CI 5.58 to 6.97 mmHg lower).”

**Discussion.** Decide whether this difference matters clinically using a justified clinical context,
not the p-value alone. The example assumes complete follow-up, correct randomization, reliable
measurement, a linear baseline relationship and a common slope. It is too small and artificial to
support a treatment recommendation. A real interpretation would also discuss harms, adherence,
rescue/discontinuation, missing-data sensitivity, multiplicity and how the enrolled population
relates to the target population. If outcomes are missing, align the estimand and sensitivity analyses
rather than silently analysing only completers.

**Your turn.** If the CI excluded zero but its entire range were only −0.2 to −0.1 mmHg, would that
alone show an important benefit?

<details>
<summary>Worked answer</summary>

No. It would be evidence of a difference under the model, but clinical importance depends on the
outcome scale, patient relevance, treatment burden and a justified meaningful-difference threshold.
Statistical significance does not define clinical value.

</details>

## Compare the reasoning across the three examples

| Step | Wet-lab assay | Dry-lab RNA-seq | Randomized clinical trial |
|---|---|---|---|
| Independent unit | Culture run / biological preparation | Biological sample / library | Randomized participant |
| Data | Protein concentration per condition and run | Gene counts per sample | Blood pressure per assigned participant and visit |
| Main method | Paired mean difference | Negative-binomial model plus FDR control | Baseline-adjusted linear model |
| Main result | −16.83 pg/mL paired difference | Fold change and adjusted p-value per gene | −6.27 mmHg adjusted difference |
| Main caution | Technical wells do not increase biological n | Batch/design confounding and many tests | Missingness and target effect assumptions |
| Scope of conclusion | This assay and culture model | This simulated matrix (or, in practice, sampled tissues) | This fictional randomized comparison |

The same discipline runs through all three: define the question, identify the unit, preserve the design
in the analysis, report the estimate with uncertainty, and limit the conclusion to the evidence. A
significant result answers only a statistical question under assumptions; the discussion explains
whether the result is credible, meaningful and applicable, and what experiment should come next.

<!-- REFS -->

---

[← Module 6](06-phase-iii-layouts-and-claims.md) · [Sub-course home](README.md) · [Next: Module 8 — Integrated Design Clinic and Retrieval Practice →](08-design-clinic-and-retrieval.md)
