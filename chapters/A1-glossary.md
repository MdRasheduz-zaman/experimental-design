# Appendix A — Glossary

> [← Chapter 26](26-capstone-design-clinic.md) · [Table of Contents](../README.md) · [Appendix B — Design Card →](A2-design-card-and-checklist.md)

Terms are grouped alphabetically. The chapter where each is developed is in brackets.

| Term | Definition |
|---|---|
| **α-design (alpha-lattice)** | Resolvable incomplete-block design for many entries; each replicate split into small blocks. [19] |
| **ADEMP** | Aims, Data-generating mechanisms, Estimands, Methods, Performance measures — plan for simulation studies. [15, 22] |
| **Allocation concealment** | Preventing those enrolling units from knowing or predicting the next assignment. [4] |
| **Augmented design** | Unreplicated new entries plus replicated checks in every block. [14, 19] |
| **Batch** | Samples processed together (extraction, library, run, plex); a block in omics. [5] |
| **Biological replicate** | Independent biological material (animal, plant, patient, independent culture). [3] |
| **Bland–Altman analysis** | Agreement analysis using mean difference (bias) and 95% limits of agreement. [15] |
| **Blinding (masking)** | Hiding group membership from those treating, measuring or analysing. [4] |
| **Block** | Group of similar units; complete blocks contain every treatment, incomplete blocks contain connected subsets. [5] |
| **Centre point** | DoE run at the middle of all factor ranges; estimates pure error and curvature. [13] |
| **Circular analysis** | Selecting data using an effect, then testing that effect in the same data. [24] |
| **Cluster-randomized trial** | Groups (clinics, villages) are randomized; inflate *n* by the design effect. [23] |
| **Collider** | A variable caused by two others; adjusting for it creates spurious association. [11] |
| **Compositional data** | Data that carry only relative information (e.g. sequencing proportions). [17] |
| **Confounding** | A third factor causes both exposure/treatment and outcome, distorting the comparison. [1, 11] |
| **Crossover design** | Each unit receives several treatments in random order with washout. [7, 18] |
| **DAG** | Directed acyclic graph encoding causal assumptions; guides adjustment. [11] |
| **Design effect** | Inflation of variance from clustering: 1 + (m − 1)ρ. [3, 9, 23] |
| **Design of experiments (DoE)** | Planned multi-factor experiments for screening and optimization. [13] |
| **Design space** | (QbD) Region of input settings within which product quality is assured. [18] |
| **Desirability function** | Combines several responses into one 0–1 optimization criterion. [13] |
| **Experimental unit** | Smallest entity independently assigned to a treatment; can differ by factor. Report assignment units and biological/run replication separately. [3, 7] |
| **Estimand** | Target quantity: population, treatment/exposure contrast, outcome and time; e.g. mean treatment difference at 48 h. [2] |
| **Equivalence** | Evidence that an effect lies within pre-specified bounds of practical insignificance; requires an equivalence analysis, not just p > 0.05. [8] |
| **External validation** | Testing a predictive model on data from a different setting or population. [12] |
| **Factorial design** | All combinations of factor levels; estimates main effects and interactions. [7] |
| **False discovery rate (FDR)** | Expected proportion of false positives among declared discoveries. [14] |
| **Fractional factorial** | Subset of a full factorial; fewer runs, some effects aliased. [13] |
| **G × E** | Genotype-by-environment interaction. [19] |
| **Grouped cross-validation** | CV in which all samples from one unit (patient, family, study) stay in the same fold. [12] |
| **HARKing** | Hypothesizing after the results are known. [25] |
| **Immortal-time bias** | Bias from defining exposure using information after time zero. [11] |
| **Interaction** | When the effect of one factor depends on the level of another. [7] |
| **Intra-class correlation (ρ, ICC)** | Share of variance between clusters; how alike sub-units within a unit are. [3] |
| **Leakage** | Information from test data influencing training or model selection. [12] |
| **Mendelian randomization** | Using genetic variants as instruments for causal inference. [11] |
| **Mixed model** | Model with fixed and random effects; mirrors hierarchical designs. [3] |
| **Mixture design** | Design for components that must sum to a fixed total. [18] |
| **Mock community** | Defined mix of known microbes used as a positive control. [6, 17] |
| **Negative control** | Condition expected to show no effect; estimates background. [6] |
| **Nuisance factor** | Source of variation that affects the outcome but is not of interest. [5] |
| **OFAT** | One factor at a time — inefficient and blind to interactions. [7, 13] |
| **Observational unit** | Entity measured, possibly a sub-unit of the experimental unit. [3] |
| **Partially replicated (p-rep) design** | Only a fraction of entries replicated; used with spatial models. [19] |
| **Plackett–Burman design** | Screening design estimating main effects with few runs. [13] |
| **Pooled QC sample** | Mixture of all samples, injected repeatedly to monitor and correct drift. [21] |
| **Positive control** | Condition known to produce an effect; shows the assay can detect one. [6] |
| **Power** | Probability of detecting an effect of a given size if it exists. [8] |
| **Pre-registration** | Time-stamped plan of hypotheses, design and analysis before data collection. [25] |
| **Pseudobulk** | Aggregating single-cell counts per donor (and cell type). [20] |
| **Pseudoreplication** | Treating non-independent observations as independent replicates. [3] |
| **Randomization** | Allocation by a random process; balances unknown confounders on average. [4] |
| **RCBD** | Randomized complete block design. [5, 10, 19] |
| **Registered report** | Article reviewed and accepted in principle before data collection. [25] |
| **Rescue experiment** | Restoring the perturbed gene/protein to show the effect is on-target. [6, 10] |
| **Response surface** | Model (often quadratic) of a response over continuous factors. [13] |
| **Sampling frame** | The list from which a sample is actually drawn. [9] |
| **Smallest effect size of interest** | The smallest effect that would matter; basis for power. [8] |
| **Split-plot design** | Hard-to-change factor on large units, easy factor on sub-units. [7] |
| **Stratification** | Sampling or randomizing separately within subgroups. [4, 9] |
| **Target-trial emulation** | Designing an observational analysis as if it were a specified randomized trial. [11] |
| **Technical replicate** | Repeated measurement of the same biological material. [3] |
| **Type M/Type S error** | Exaggerated magnitude/wrong sign among significant results. [8, 24] |
| **Z′ factor** | Assay-quality metric from positive- and negative-control separation. [14] |

---

[← Chapter 26](26-capstone-design-clinic.md) · [Table of Contents](../README.md) · [Appendix B — Design Card →](A2-design-card-and-checklist.md)
