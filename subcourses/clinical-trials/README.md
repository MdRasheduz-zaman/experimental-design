# Clinical-Study Biostatistics: From the Question to a Defensible Report — a hands-on sub-course

> Part of [**Designing Experiments in Biology — From Question to Protocol**](../../README.md).
> The main course teaches design principles for every field; this sub-course follows a single
> intervention study from the research question to a report that would survive an audit.

---

## Why this sub-course

A clinical study is the setting where design decisions are hardest to repair afterwards. The
protocol is registered, the analysis plan is dated, the data are monitored, and the final report
has to trace every number back to a source record. That discipline is worth learning even if you
never run a trial: it is the same chain of reasoning — question, estimand, unit, allocation,
analysis, uncertainty, claim — written down where other people can check it.

The running clinical example is **Drug A versus usual care for hypertension**, with a preclinical
example showing where the evidence begins. Every worked study here is hypothetical and is a
teaching example, not a ready-to-use clinical protocol.

## Who it is for

Students and early-career researchers in medicine, pharmacy, pharmacology, epidemiology,
biostatistics and preclinical research, and anyone who has to read a protocol, a statistical
analysis plan or a trial report critically. Prerequisites: main course Parts I–II (Chapters 1–8).
R is needed only for Module 7; the reasoning in every other module stands without it.

## How each module works

Each module explains a diagram, works an example with real arithmetic, and then asks you to
produce something *before* you open the feedback inside a collapsible ▶ block. Read the figures
with their walkthroughs: at each arrow, ask what decision or information passes to the next stage,
and what could go wrong there.

## Modules

| # | Module | Produce before reading the feedback |
|---|---|---|
| 1 | [Statistics and Bias Across the Whole Trial](01-statistics-and-bias-across-the-trial.md) | Annotate every stage of the lifecycle with one decision and one risk |
| 2 | [Estimands, the Analysis Plan and Data Quality](02-estimands-analysis-plan-and-data-quality.md) | A precise question, an analysis plan and a query workflow |
| 3 | [Sample Size, Noncompliance and Missing Data](03-sample-size-and-missing-data.md) | Reproduce the calculation; explain the imputation diagram |
| 4 | [Repeated Outcomes, Interim Analysis and Governance](04-repeated-outcomes-interim-and-governance.md) | A contrast, a sensitivity plan and a reproducibility record |
| 5 | [From Preclinical Evidence to Phase II](05-preclinical-to-phase-ii.md) | A development decision and the evidence needed to justify it |
| 6 | [Phase III and IV, Trial Layouts and Claims](06-phase-iii-layouts-and-claims.md) | Match designs to questions; interpret a non-inferiority interval |
| 7 | [Three Questions Worked From Beginning to Discussion](07-three-questions-worked-through.md) | Three complete question-to-discussion analyses |
| 8 | [Integrated Design Clinic and Retrieval Practice](08-design-clinic-and-retrieval.md) | A methods paragraph, a discrepancy note and short spoken answers |

Modules 1–4 are the core; 5–6 are the development-and-design map; 7–8 are practice. Eight study
sessions, one per module, is a workable pace.

## By the end, you should be able to

1. Explain how statistics contributes before, during and after data collection.
2. Distinguish randomization, concealment, masking and the sources of bias each one addresses.
3. Define a treatment effect before choosing a population, model or imputation procedure.
4. Turn a protocol into an auditable SAP and a validated analysis dataset.
5. Explain the assumptions behind sample-size inflation, missing-data analysis and interim decisions.
6. Report the intended contrast, its uncertainty, the clinical context and the limitations clearly.

## Scope and sources

The explanations, worked examples and exercises are an educational synthesis developed from public
seminar material on clinical-trial statistics; they are not transcripts, and no wording here should
be attributed to a presenter. Guidance documents are linked at their source. Where a cited source
supplied only an author and a year, it is left incomplete rather than completed by guessing.

| Reading | Purpose |
|---|---|
| [Gamble et al., SAP content guidance](https://doi.org/10.1001/jama.2017.18556) | Detailed analysis planning |
| [Kahan et al., estimands primer](https://www.bmj.com/content/384/bmj-2023-076316) | Link the question to design, collection and estimation |
| [Clark et al., early-phase SAP extension](https://www.bmj.com/content/376/bmj-2021-068177) | Planning early-phase analyses |
| [ICH E9(R1)](https://database.ich.org/sites/default/files/E9-R1_Step4_Guideline_2019_1203.pdf) | Estimands and robustness |
| [White et al., multiple imputation guidance](https://onlinelibrary.wiley.com/doi/full/10.1002/sim.4067) | Imputation-model and implementation considerations |
| [FDA adaptive-design guidance](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/adaptive-design-clinical-trials-drugs-and-biologics-guidance-industry) | Interim and adaptive design |
| [FDA E6(R3)](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/e6r3-good-clinical-practice-gcp) | GCP reference |
| [SPIRIT–CONSORT statements](https://www.consort-spirit.org/published-statements) | Current protocol and result-reporting guidance |

## Connections to the main course

- [Chapter 23 — Clinical and Preclinical (Animal) Research](../../chapters/23-clinical-and-preclinical.md)
- [Chapter 8 — Sample Size, Power and Precision](../../chapters/08-sample-size-and-power.md)
- [Chapter 25 — Pre-registration, Analysis Plans and Reporting](../../chapters/25-preregistration-and-reporting.md)
- [Chapter 26 — Capstone: The Design Clinic](../../chapters/26-capstone-design-clinic.md)
- [Module 3 of *Design in the Literature*](../design-in-the-literature/03-clinical-and-preclinical.md) — ten published clinical and preclinical designs, read from their methods sections

## How this sub-course is built

The sources are plain Markdown in [`course_src/subcourses/clinical-trials/`](../../course_src/subcourses/clinical-trials/).
Edit those, never the generated files here, then run `python3 scripts/07_build_course.py` from the
repository root: it resolves `[@key]` citations and renders the Mermaid blocks to PNGs under
`figures/diagrams/`.


