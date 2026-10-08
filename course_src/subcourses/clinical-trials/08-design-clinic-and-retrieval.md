# Module 8 — Integrated Design Clinic and Retrieval Practice

> **Sub-course: Clinical-Study Biostatistics**
> [← Module 7](07-three-questions-worked-through.md) · [Sub-course home](README.md)

---

## 🧭 Learning Objectives

After this module you will be able to:

1. Audit a flawed draft report against a stated target effect.
2. Produce a missingness review and a sensitivity plan that targets the same effect.
3. Write a short methods-and-results note that states what remains unknown.
4. Retrieve the minimum elements of an answer to the questions this sub-course keeps returning to.

---

## Integrated design clinic

**Hypothetical case:** 160 randomized adults receive Drug A or usual care. The target is Week-24 blood
pressure regardless of rescue or discontinuation. Rescue is more frequent under usual care;
Week-24 measurements are missing for 25% of Drug A and 10% of usual care. The draft report excludes
rescue users, analyses complete cases and claims “effective” because p = 0.02.

Before opening the feedback, submit:

1. A precise effect definition and two collection decisions.
2. A critique of the exclusions and primary analysis.
3. A missingness review and same-target sensitivity plan.
4. An appropriate repeated-outcome model and the contrast to extract.
5. A four-sentence methods/results note specifying what remains unknown.

<details>
<summary>Compare your audit with this example</summary>

- Retain relevant post-rescue/discontinuation outcomes for the stated target and continue follow-up
  where possible. Discontinuation is not itself a missing measurement.
- Rescue-based exclusion changes the population/question and can introduce selection bias. A
  complete-case estimator needs assumptions; it is not justified solely by a small p-value.
- Review missingness by arm, visit and reason, with relevant observed predictors. Differential rates
  do not alone establish MNAR. Specify the primary assumptions and plausible MNAR departures.
- Follow the justified SAP model, including within-person dependence and the intended Week-24
  contrast. Do not substitute a treatment main effect automatically.
- The effect estimate, CI, analysis n, clinical threshold and sensitivity results were not supplied.
  Do not invent them. Withhold a definitive efficacy conclusion until those are available.

A possible note: “The intended contrast concerns Week-24 blood pressure by randomized assignment,
including relevant outcomes after rescue and discontinuation. The draft's rescue exclusions and
complete-case analysis require review against that target and the SAP. We will reconcile populations
and missingness, reproduce the planned contrast, and assess plausible missingness departures.
An efficacy conclusion requires the estimate, confidence interval, clinical context and robustness
results, which are not provided here.”

</details>

## Retrieval practice and short answers

| Question | Minimum elements to retrieve |
|---|---|
| Why is the SAP not standalone? | Protocol objective/design; operational detail; aligned versions |
| Does ITT remove all bias? | Assignment principle; missingness/measurement/selection remain |
| Is rescue therapy missing data? | No; an event affecting the target; measurement may still exist |
| Why not choose 5–10 imputations automatically? | Missing information and Monte Carlo precision; model compatibility |
| Does a mixed model solve dropout? | Explicit model/observation assumptions; MNAR sensitivity where appropriate |
| Why can 350 become 352? | Normal versus t-based power calculation; rounding; same simplified SD/effect |
| What does a small p-value leave unanswered? | Effect size/uncertainty, clinical relevance, assumptions and bias |
| What is required for an interim efficacy look? | Planned decision/error-control procedure and protected information |
| How do phase, layout and claim differ? | Development purpose; organization of comparisons; hypothesis |
| Do repeated animal readings increase treatment replication? | Identify assignment unit; readings remain nested |
| Is Phase I proof of safety? | Limited exposure and uncertainty; prespecified monitoring |
| Is a nonsignificant difference non-inferiority? | Justified margin, CI boundary and interpretable active-control comparison |
| How do you verify a report? | Trace results to data/derivations/code and reconcile definitions/counts |

Score practice answers on the correctness of the target, the proposed action, the stated assumption
and clarity. More detail is useful only when it helps answer the question within its time limit.

<!-- REFS -->

---

[← Module 7](07-three-questions-worked-through.md) · [Sub-course home](README.md)
