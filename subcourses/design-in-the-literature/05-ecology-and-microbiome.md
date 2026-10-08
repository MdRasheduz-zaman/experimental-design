# Module 5 — Ecology and the Microbiome: Ten Designs, Read From the Methods

> **Sub-course: Design in the Literature**
> [← Module 4](04-omics-and-bioinformatics.md) · [Sub-course home](README.md) · [Next: Module 6 — Neuroscience →](06-neuroscience.md)

---

## 🧭 Learning Objectives

After this module you will be able to:

1. Read a **split-plot** field experiment: which factor sits on the whole plot, which sits inside it, and why the hardware decides.
2. Identify the **replicate population** in an evolution experiment, and say what the ancestor is a control for.
3. Audit a **randomized field experiment on wild animals**, including what the act of measuring does to the subject.
4. Judge the **laboratory half** of an observational microbiome study: extraction batches, blank controls, attrition.
5. Name a **confound that cannot be removed**, state which comparison it ruins, and say what the authors did instead.
6. Read a **before–after–control–impact** design, and say what each of its two comparisons rules out.
7. Recognize a **reciprocal transplant**, and why local adaptation is an interaction rather than a main effect.
8. Treat **imperfect detection** as a design problem, not a nuisance.
9. Judge a **space-for-time** substitution, and name what it assumes.

---

## 🎯 The Big Picture

Ecology and microbiome work push every design idea in this course to its limit, because the units are
large, slow, expensive and uncooperative. You cannot randomize the weather, you cannot blind a
grassland, and an animal that will not be recaptured is missing data you can never recover.

So this field has developed the strongest discipline about three things: **what the unit is**, **what
was blocked when randomization was impossible**, and **what the controls in the laboratory are doing**
— because a microbiome dataset is half an ecological study and half a sequencing run, and each half
has its own failure modes.

**Papers 1–5 cover designs where something was manipulated or sampled.** **Papers 6–10 cover the
harder half of the field: what to do when you cannot manipulate at all.** A turbine is painted and a
solar farm is dismantled; genotypes are moved between environments because environments cannot be
moved; animals are counted through cameras that miss most of them; and sites of different ages stand
in for the passage of time. Each is a recognized design with a name, an assumption, and a
characteristic way of failing.

![A microbiome or ecology study has two halves that fail differently: the field half, where the risks are the wrong unit, unrandomizable factors and sample loss, and the laboratory half, where the risks are extraction batch effects, contamination and read-depth differences. A study is only as sound as the weaker half.](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-93ad37c1de.png)

---

## 📄 Paper 1 · A split-plot you can walk through — drought, nitrogen and wolf spiders

**Grassland mesocosm experiment (2026)** ([Zhang et al., 2026](https://doi.org/10.1002/ece3.74165)), in *Ecology and Evolution*. The clearest
split-plot in this sub-course, and its layout is forced by physical hardware.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13454221/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "To examine the effects of wolf spiders on soil fauna, microbial communities, soil N availability
> and litter decomposition under ambient conditions, drought, N addition, and their combination, we
> employed a **full-factorial field experiment**" in a temperate grassland "fenced since 2013".
>
> The two climate factors are applied to whole plots. "The drought treatment was simulated by
> intercepting **66% of the natural rainfall** from May to August using **rainout shelters**", with
> "watertight aluminum plates ... vertically inserted around the drought plots to a depth of 1 m below
> the soil surface to prevent external subsurface water from permeating". Nitrogen was added "by
> spraying dissolved NH4NO3 evenly across designated plots at a rate of **10 g N m−2 year−1**", and —
> the detail to notice —
>
> > "**non-N plots received an equivalent volume of purified water to control for water addition**".
>
> The predator factor is applied *inside* each plot: "We installed **paired mesocosms in each plot** ...
> resulting in **48 mesocosms across 24 plots**", each 75 cm on a side, mesh-walled, "buried 15 cm into
> the soil to minimize potential exchange of soil fauna between paired mesocosms" and "positioned at
> least 1 m apart". "We added **two locally collected wolf spiders to one mesocosm of each pair**", a
> density of "3.56 individuals m−2, which was **higher than the mean field density** observed at our
> site (1.48 ± 1.1 individuals m−2), but **lower than the maximum** observed field density ... (8
> individuals m−2)". In total, "48 female wolf spiders (**6 blocks × 4 treatments per block** × 2
> spiders per plot) were relea[sed]".
>
> Sub-sampling and analysis match the layout: "soil samples were collected ... at **three random
> locations** beneath the litterbags in each mesocosm", and "the three samples per mesocosm were
> **combined**". Then: "For each response variable, spider-mediated regulation was calculated as the
> **within-pair difference** between spider-present and spider-absent mesocosms **within the same
> plot**", and the community analysis used "factorial permutational multivariate analysis of variance
> (PERMANOVA), with **permutations constrained within blocks** to account for the randomized block
> design".

### The design, drawn

![Six blocks each contain four plots receiving the four combinations of drought and nitrogen; inside every plot sits a pair of mesocosms, one with two wolf spiders and one without, so the climate factors are whole-plot treatments and the predator factor is a sub-plot treatment analysed as a within-pair difference](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-84527fe0ed.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **The hardware chooses the split-plot.** A rainout shelter is a 2.5 m sloped roof on a steel frame
  with aluminium plates driven a metre into the ground. You cannot put one over a 75 cm mesocosm and
  not its neighbour. So drought has to be a whole-plot factor, while spider presence — two animals
  dropped into a mesh box — can be a sub-plot factor. That asymmetry is not a compromise; it is what
  split-plot designs are *for*, and it has a direct consequence: the sub-plot factor is tested with
  far more precision than the whole-plot factors
  ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **The pairing is the analysis.** "The within-pair difference between spider-present and
  spider-absent mesocosms within the same plot" means every plot contributes one number for the
  spider effect, with plot-level soil, shading, slope and shelter differenced away. This is the same
  move as Module 3's crossover and Module 4's paired platform comparison: make the comparison inside
  the unit that carries the nuisance variation
  ([Ch. 5](../../chapters/05-blocking-and-batches.md)).
- **"An equivalent volume of purified water."** The nitrogen was delivered dissolved in water, so
  non-N plots would otherwise have received less water as well as less nitrogen. The control isolates
  nitrogen by matching the vehicle. This is the ecological twin of a vehicle control in pharmacology
  ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **The dose is justified against reality.** 3.56 spiders m⁻² is above the site's mean of 1.48 but
  below the observed maximum of 8. That one sentence answers the obvious objection — that the effect
  is an artefact of an impossible density — with field data rather than assertion
  ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **"Permutations constrained within blocks."** The multivariate test is told about the blocking.
  Permuting freely across all 48 mesocosms would shuffle block differences into the null distribution
  and make the test wrong in a way that is invisible in the output. The analysis mirrors the layout —
  the question this sub-course asks at step 5 of every audit.
- **The title reports a null.** The published title ends "Without Detectable Functional Cascades":
  spiders altered the fauna and microbes but did not detectably change soil N availability or litter
  decomposition. With 6 blocks, that is an honest "not detectable", not a demonstrated absence
  ([Ch. 8](../../chapters/08-sample-size-and-power.md)).

</details>

---

## 📄 Paper 2 · Six populations per treatment — experimental evolution of virulence

**Experimental evolution study (2026)** ([Su et al., 2026](https://doi.org/10.7554/elife.107936)), in *eLife*. A 2 × 2 × 2 factorial in which the
experimental unit is a *population*, not a cell.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13271738/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "We experimentally evolved two *S. aureus* isogenic variants of USA300 JE2 ..., MRSA and MSSA, **with
> or without a host** and **sub-MIC antibiotic** exposure." The strains differ by one thing: "one with
> existing resistance (mecA+ ...) and one with a **transposon insertion in mecA** (mecA−)".
>
> > "For each ancestor, we passaged **six independently evolving populations** under each condition
> > **12 times**, for a total of **48 evolved *S. aureus* populations**."
>
> And in the figure legend: "MRSA and MSSA were passaged 12 times with or without hosts, in the
> presence or absence of a sub-MIC of the antibiotic oxacillin. **Each treatment consisted of six
> independently evolving replicate populations.**"
>
> The controls are concurrent and structural: "We conducted **every step of the evolution experiment on
> the same timeline**. For example, all replicates across treatments were grown in liquid media at the
> same time ... **Populations passaged without a host served as the control.** Mutations that were
> solely unique to host-exposed populations would more likely contribute to the traits of interest,
> compared to mutations that were in common between the host-exposed and no-host treatments. Similar
> comparisons could be made with the oxacillin-exposed and no-oxacillin populations."
>
> The ancestor is measured too — virulence figures show "respective ancestral virulence" as reference
> lines, with "standard errors of **technical replicates** of ancestral virulence". Divergence was
> analysed both ways: "pairwise differences **between the ancestor and each evolved population** to
> compare rates of evolution across treatments, and pairwise differences **between replicate
> populations within each treatment** to compare the degree of divergence".

### The design, drawn

![Two strains crossed with host present or absent and antibiotic present or absent gives eight treatments; each treatment holds six independently evolving populations passaged twelve times, for forty-eight evolved populations, with the ancestor measured as the baseline and the no-host and no-antibiotic arms serving as concurrent controls](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-13feebbd20.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **Six populations, not six colonies.** Each population evolves independently for 12 passages.
  Evolution is stochastic: the same selection pressure can produce different mutations in different
  lineages, which is precisely what the paper measures ("divergence between replicate populations
  within each treatment"). Sampling six colonies from *one* evolved population would measure
  within-population variation and tell you nothing about whether the treatment reliably produces the
  trait ([Ch. 3](../../chapters/03-experimental-unit-and-replication.md)).
- **The two ancestors are a one-gene contrast.** Isogenic variants differing by a transposon insertion
  in *mecA* make "resistance" a manipulable factor rather than a property of two unrelated clinical
  isolates. Compare Module 2's standard for knockdown specificity: the strength of a genetic
  comparison is how little else differs
  ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **The factorial is the question.** "Host and antibiotic *jointly* select" is an interaction claim,
  and only a factorial can support it. Running host-exposure and antibiotic-exposure experiments
  separately would give two main effects and no way to see that the combination does something
  neither does alone ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **Concurrent controls, stated as such.** "Every step ... on the same timeline" rules out the classic
  experimental-evolution artefact in which the control was passaged last month, in a different
  incubator, with a different media batch. The control is not just an arm; it is an arm that ran
  *alongside* ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **"Technical replicates of ancestral virulence" is exact language.** The ancestor was not evolved
  six times, so it has no biological replicates in the evolutionary sense — repeating its assay
  measures assay noise. Calling that *technical* rather than sliding it into the same *n* is the
  distinction Module 2 spent a whole paper on.
- **Where to be careful.** Mutations in *codY* and *saeRS* "did not occur across all replicate
  populations", and "five out of six populations evolved from the MSSA ancestor had a mutation in
  either gene". With six populations, a count of 5/6 versus, say, 2/6 is suggestive, not decisive —
  the design is powered to detect reliable phenotypic shifts, not to estimate the frequency of a
  particular mutational route ([Ch. 8](../../chapters/08-sample-size-and-power.md)).

</details>

---

## 📄 Paper 3 · Randomization in the wild, and the measurement as a treatment — Northern cardinals

**Cardinal stress experiment (2026)** ([Slevin et al., 2026](https://doi.org/10.1038/s41598-026-42507-x)), in *Scientific Reports*. A genuinely
randomized, paired experiment on free-living animals — and it reports its own design to ARRIVE.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC12988219/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "We used a **three-group (two treatments and one control), two-sample study design** comparing
> samples from individual male Northern cardinals' first and second samples." The treatments,
> "administered between pre- and post-treatment captures separated by approximately 11 days", were "(a)
> STI [simulated territorial intrusion], (b) Temporary Hold, or (c) no treatment as the control".
>
> The ARRIVE items are reported item by item. On size, with unusual candour:
>
> > "**42 male cardinals** were captured and sampled twice. 11 males were in the Temporary Hold group,
> > 14 males were in the STI group, and 18 were in the Control group (1 male was captured in the first
> > and second sample year and therefore placed in different treatment groups **to avoid
> > pseudo-replication**: Control 1st year and STI 2nd year). **Sample size was not decided a priori
> > but was by necessity small** because it is difficult to capture songbirds more than once in such a
> > short period of time; a maximum sample target was set to 20 birds per group."
>
> On allocation: "Males were **randomly assigned** to treatment group with a random number generator
> using Microsoft Excel. **Neighboring males never received treatment during the same period to avoid
> confounding effects.**" On blinding: "MCS was aware of group allocation during the data collection,
> but **not during data processing or analysis, as random sample IDs were assigned** for the latter
> stages."
>
> The stimulus was deliberately varied: "we used a **unique stimulus each time** for a male, we **never
> used a familiar male's songs** in a recording (current or former neighbor), and we ran each STI at a
> **random time** between sunrise and 1100". Exposure was equalized by rule: "we repeated STIs until
> capture to avoid unintended potential recovery from a challenge that ended before a bird was
> successfully recaptured", giving "a range of 2–7 STIs received".
>
> The analysis differences each bird against itself: "**A random effect of bird ID was not needed
> because we calculated all values as the difference between each bird's paired samples.**" Sequencing
> batch was included "as a predictor to assess any impact of the sequencing run".
>
> And then the finding that makes the control group indispensable:
>
> > "**Because the Control group's mean beta diversity was > 0, our capturing protocol alone may be
> > enough to alter the microbiome**."

**Denominator check:** The paper reports 42 unique males but 43 bird-year records across
11, 14 and 18 group memberships: one male participated in both years, in different groups.
Unique birds and records are different counts. Its stated reason for changing that bird's group
does not itself eliminate repeated-bird dependence; consider how year and bird identity enter the analysis.

### The design, drawn

![Forty-two male cardinals were captured, sampled, randomly assigned to simulated territorial intrusion, temporary hold or control, then recaptured about eleven days later and sampled again; each bird is compared with itself as a difference, and the control group provides the background change against which to compare added treatments](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-2f9b32f38a.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **The control group measures background change.** Control birds undergo capture, handling and sampling without the added treatment. Their change captures background variation over time, including possible handling effects, natural drift and assay variation. Without an unhandled comparison, these components cannot be separated. The control still provides the relevant background against which to compare the added treatments ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **The stimulus was replicated, not just the birds.** A single playback recording used on every bird
  would make the *recording* the thing being tested: any response could be a quirk of that track, and
  the effective sample size for "song of an intruding male" would be one. Using a unique stimulus per
  male, never a neighbour's song, replicates the stimulus as well as the subject
  ([Ch. 3](../../chapters/03-experimental-unit-and-replication.md)).
- **"Neighboring males never received treatment during the same period."** Territories are adjacent;
  a loudspeaker in one bird's territory is audible from the next. Separating neighbours in time reduces the risk of
  spillover — the same problem as treatment contamination between adjacent field
  plots ([Ch. 5](../../chapters/05-blocking-and-batches.md)).
- **Differencing replaces the random effect.** One change score per independent bird removes the need for a bird intercept for the two measurements forming that score. However, the same bird appearing in two years contributes two change scores: that repeated identity can still induce dependence. Differencing does not automatically eliminate every repeated-measures level.
- **Blinding where it was still possible.** The researcher knew the treatment in the field —
  unavoidable, since someone has to play the recording — but analysed coded samples. That is exactly
  the rewrite Module 3's final question asked for, performed in the paper
  ([Ch. 4](../../chapters/04-randomization-and-blinding.md)).
- **The sample size statement is a model of honesty.** "Not decided a priori but was by necessity
  small", with a stated target of 20 per group that recapture reality cut to 11, 14 and 18. Compare
  with silently reporting *n* = 42 and letting the reader assume it was planned. Note also the
  consequence the authors flag themselves: a result "non-significant after multiple test correction"
  is reported as such ([Ch. 8](../../chapters/08-sample-size-and-power.md)).

<details>
<summary>▶ Pseudoreplication of the stimulus</summary>

If you test 40 birds with one song recording, you have 40 replicates of *the bird* and one replicate
of *the stimulus*. Any claim of the form "cardinals respond to intruder song" then rests on *n* = 1
for the thing in the claim, because the recording's particular pitch, timing and quality are
inseparable from the treatment.

The same error appears across biology under different names: one batch of a compound, one
knock-out clone, one donor's cells, one reference genome. The test is always the same question —
**is the thing my conclusion is about replicated, or only the thing I measured?**
([Ch. 3](../../chapters/03-experimental-unit-and-replication.md))
</details>

</details>

---

## 📄 Paper 4 · The laboratory half of a wild study — puffin gut microbiota

**Atlantic puffin microbiota study (2026)** ([Hanski et al., 2026](https://doi.org/10.1098/rsos.252018)), in *Royal Society Open Science*. Nothing in
the field could be randomized. The bench work was randomized anyway.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13561090/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "A total of **153 faecal samples** were collected in July 2021 from **seven British populations**"
> across Wales, Shetland, the Hebrides, Orkney and the Firth of Forth.
>
> Then the design decision that defines this paper:
>
> > "Faecal samples were **randomized into eight batches of up to 23 samples for DNA extraction**. ... A
> > **negative control (DNAse-free H2O) was included in each DNA extraction batch at a varying
> > position** to account for potential systematic cross-contamination between [samples]."
>
> The controls were then used: "A total of **eight amplicon sequence variants (ASVs) were detected
> across all negative DNA extractio[n controls]". And batch was also modelled: "All dyadic beta
> regression models included **DNA extraction batch similarity** (same vs different extraction batch)
> as well as **read depth difference** of the sample pair as fixed effects."
>
> Attrition was severe, sequential and reported plainly: "Samples with fewer than 100 reads were first
> removed as sequencing failures (**n = 72**), reducing the dataset from **153 to 81 samples**." A
> second, coverage-based threshold followed — rarefaction curves "supported a sequencing depth
> threshold of **5000 reads**, below which a substantial proportion of samples remained incomplete.
> Samples below this threshold (**n = 25**) were removed" — leaving "adults (n = 13) and chicks
> (n = 41) from **six populations**". The sampling
> was also unbalanced by circumstance, and the analysis was narrowed rather than confounded: "**Only
> chick samples were included**, as **adult samples were available for only three of the six
> populations**."
>
> Correlation structure was handled explicitly: "To account for the inherent autocorrelation of
> pairwise values, all dyadic models included a **multi-membership random effect**".

### The design, drawn

![One hundred and fifty-three faecal samples from seven puffin populations were randomized across eight DNA extraction batches, each containing a water negative control at a varying position; seventy-two samples failed sequencing, leaving eighty-one, and extraction batch and read depth were included as fixed effects in the models](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-6dfea7aec5.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **Randomization you can still do when nothing else is randomizable.** Age, island, diet and weather
  were all fixed before the researchers arrived. But *which batch a sample is extracted in* is
  entirely under their control — and if samples had been extracted island by island, extraction batch
  would be perfectly confounded with population, and the paper's main comparison would be
  uninterpretable. Randomizing samples across batches converts a potential confounder into noise
  ([Ch. 4](../../chapters/04-randomization-and-blinding.md),
  [Ch. 5](../../chapters/05-blocking-and-batches.md)).
- **"At a varying position" is the detail that shows the controls were thought about.** A blank always
  placed in well A1 can only detect contamination that reaches well A1. Moving it around turns one
  control into a probe of the whole plate. And the controls were read: eight ASVs appeared in them,
  which is what makes a decontamination step evidence-based rather than ritual
  ([Ch. 17](../../chapters/17-microbiology-microbiome.md)).
- **Batch was randomized *and* modelled.** Randomization stops batch from aligning with the
  biological factor; including batch similarity as a fixed effect removes the variance it still
  contributes. Doing both is belt and braces, and the second is only honest because the first was
  done — adjusting for a batch variable that is perfectly confounded with your factor of interest
  removes your effect along with the batch.
- **Losing 72 of 153 samples is the real cost of wild sampling.** Faecal samples from burrows degrade,
  and low-biomass samples fail. The number is stated, the threshold (<100 reads) is stated, and the
  analysis proceeds on 81. What a reader should then ask is whether failure was *random*: if the
  poorest-quality samples came disproportionately from one island, the surviving dataset is no longer
  representative of the seven populations it set out to describe. The paper lets you see this
  happening: sampling covered **seven** populations, the analyses report **six**, and the figure
  legend maps only the "islands for which samples were successfully sequenced" — one population was
  lost entirely. The two thresholds are also worth separating. The first (<100 reads) removes
  failures; the second (<5000 reads) removes samples that worked but were not sequenced deeply enough
  to describe a community, and it is justified by rarefaction curves rather than by convention. Final
  analysed n: 13 adults and 41 chicks, out of 153 samples collected.
- **Narrowing beats confounding.** Adults were sampled at only three of six populations. Comparing
  populations using all samples would mix "which island" with "adult or chick". Restricting the
  population comparison to chicks answers a smaller question cleanly instead of a bigger one
  ambiguously ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **The pairwise model needs a pairwise correction.** In a dyadic analysis each sample appears in many
  pairs, so the rows are not independent. The multi-membership random effect is the structural fix —
  the same logic as blocking, applied to the shape of the dataset rather than the field.

</details>

---

## 📄 Paper 5 · A confound the authors name — benthic microbes in a seagrass meadow

**Seagrass benthic survey (2026)** ([Serrano et al., 2026](https://doi.org/10.1128/msphere.00431-26)), in *mSphere*. Purely observational, nested, and
notable for stating out loud which comparison it cannot make.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13621858/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "Sediment samples were collected at low tide from Bodega Harbor on 7 July 2018 across **three
> different sites**: Mason's Marina (inner estuary), Westside Park (mid estuary), and Campbell Cove
> (outer estuary). **At each site, four sediment cores were taken from vegetated (seagrass) and
> non-vegetated (bare sediment) habitats** using a 10 × 10 cm PVC core."
>
> The confound appears in the same paragraph, in the authors' own words:
>
> > "At Westside Park, **no clearly unvegetated sediments were found adjacent to the seagrass habitat**,
> > so 'bare sediments' here refer to both low and high mudflat samples collected **at a location
> > slightly farther away** from seagrass beds."
>
> Elsewhere they add that those cores "were collected **much farther away** from seagrass beds compared
> to all other sites" and "**higher up the beach slope**", and that the sub-categories were checked
> before being merged: "Our initial data analysis suggested that high vs low mudflat sediment cores
> did not exhibit distinct benthic community assemblages, and because of this similarity, we
> ultimately grouped all cores into a si[ngle category]".
>
> The laboratory controls are standard and reported: "DNA was extracted from raw sediment (0.25 g of
> sediment) and Ludox-processed samples **in triplicate**"; "to monitor potential kit contamination,
> **blank controls containing water were included** during the DNA extraction"; "all PCRs were
> performed in a **sterilized laminar-flow hood**"; and "potential contaminants were identified using
> the R package **decontam** ... with the prevalence method and a contaminant classification threshold
> of 0.5".
>
> The result that follows from the layout: communities "showed a **strong separation by sampling
> sites**", and Westside Park bare sediments were "the most distinct benthic community in both 16S and
> 18S metabarcoding data sets".

### The design, drawn

![Three estuary sites each provide four seagrass cores and four bare-sediment cores, but at the middle site no bare sediment existed next to the seagrass, so those cores came from farther away and higher up the slope; habitat and location are therefore confounded at that one site, and the most distinct community in the dataset is exactly those cores](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-c19bdc060b.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **A confound created by the world, not by carelessness.** The design calls for bare sediment beside
  seagrass at every site. At one site, that sediment does not exist. The choice was then between
  dropping the site or taking cores from farther away — and there is no third option that keeps
  "habitat" clean. What makes this good practice is that the compromise is written in the methods, so
  the Westside Park habitat contrast can be read as "habitat **plus** location" instead of being
  mistaken for a clean comparison ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **It matters because the confounded cores carry the biggest result.** The most distinct community in
  the dataset is exactly the one taken from a different place on the shore. A reader who skipped the
  methods would attribute that distinctness to the absence of seagrass; the methods say it could as
  easily be tidal elevation and distance from the meadow.
- **Nested, not crossed in practice.** Four cores per habitat per site are sub-samples of a site ×
  habitat combination, not independent replicates of "seagrass" in general. The design supports "these
  three sites differ" far better than "seagrass meadows differ from bare sediment", because there are
  three sites and one harbour ([Ch. 3](../../chapters/03-experimental-unit-and-replication.md)).
- **Triplicate extractions are technical, and the paper calls them that.** Extracting the same core's
  sediment three times measures extraction variability. It does not create three cores.
- **Merging the sub-categories was tested before being done.** High and low mudflat cores were
  compared, found no detected difference, and only then pooled. A non-significant comparison does not establish equivalence; pooling needs a biological rationale and sensitivity checks. Pooling first and checking never is how a real
  difference disappears into a group mean.
- **The contamination controls are the baseline, not a bonus.** Water blanks, a laminar-flow hood and
  `decontam` with a stated threshold. In low-biomass samples — sediment is not low-biomass, but swabs,
  blood and tissue are — kit and reagent contaminants can dominate the result, so a microbiome paper
  without extraction blanks has an unmeasured control condition
  ([Ch. 17](../../chapters/17-microbiology-microbiome.md)).

</details>

---

## 📄 Paper 6 · Before, after, and somewhere that did not change — painting turbine blades

**Wind turbine blade painting study (2026)** ([May et al., 2026](https://doi.org/10.1002/ece3.74017)), in *Ecology and Evolution*. The
canonical ecological design for an intervention applied to places rather than organisms.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13575504/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "**Employing a Before–After–Control–Impact experiment using long-term fatality searches**, bird"
> collisions were compared before and after one blade of selected turbines was painted black.
>
> The layout is within a single wind farm: "**Four turbines had painted rotor blades (red) while the
> other turbines functioned as controls (blue)**", and "To assess the effect of the patterned blades on
> fatality rates, **one of the three rotor blades was painted black at four wind turbines spread within
> the wind farm**."
>
> The intervention dates were staggered, not simultaneous:
>
> > "The blades of the following wind turbines were painted on the dates indicated: **RU-18
> > (01.12.2020), RU-22 (29.09.2021), RU-28 (28.09.2021), and RU-33 (05.1**[2.2021])"
>
> The motivation is stated as a gap between knowing and fixing: "knowledge on the efficacy of mitigation
> measures is however limited as **the route from documenting an impact to successful mitigation is
> often very long** ... and requires collaborative action".

### The design, drawn

![Within one wind farm, four turbines have one blade painted black on four different dates while the remaining turbines stay unpainted as controls; fatality searches continue throughout, giving both a before-and-after comparison within each turbine and a contemporaneous comparison with controls](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-0ef1ed612e.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **BACI exists because neither comparison works alone.** A before–after comparison is confounded with
  everything that changes over time; a control–impact comparison is confounded with everything that
  differs between places. Taking the difference of differences cancels both, provided the two sites
  would have tracked each other in the absence of the intervention
  ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **Controls inside the same wind farm are a tight block.** Painted and unpainted turbines share
  weather, terrain, bird flyways and search crews. The nuisance variation most likely to differ between
  distant sites is held constant by proximity
  ([Ch. 5](../../chapters/05-blocking-and-batches.md)).
- **Staggered start dates are an unplanned strength.** Because the four turbines were painted on four
  different dates spanning a year, any abrupt event — a change in search protocol, an exceptional
  migration — cannot align with all four interventions. This is the same logic as
  [Module 3's stepped wedge](03-clinical-and-preclinical.md), where randomizing the timing is what
  separates the intervention from the calendar
  ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **Four impact turbines is the sample size.** Fatalities are counted on turbines, so *n* = 4 in the
  impact arm however many carcasses are found. Collision events are also rare and highly variable, which
  is why "long-term fatality searches" is doing as much work as the design
  ([Ch. 8](../../chapters/08-sample-size-and-power.md)).
- **The assumption to state out loud.** BACI assumes parallel trends: that painted and control turbines
  would have changed identically without the paint. It is untestable after the fact, but it becomes more
  plausible the longer the "before" period is and the more similar the sites — which is why both of
  those are design choices, not incidental details.

</details>

---

## 📄 Paper 7 · The same design, around an event you did not cause — removing solar panels

**Photovoltaic module removal study (2026)** ([Cheng et al., 2026](https://doi.org/10.3390/ani16132063)), in *Animals*. A BACI built on an
opportunity rather than a manipulation.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13359581/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> "In this study, we used the **planned removal of PVMs from Jiaogang Lake as a natural experiment** to
> evaluate changes in waterbird communities."
>
> The design is named and the control justified:
>
> > "To rigorously assess the ecological impacts of PVM removal, a **Before-After-Control-Impact (BACI)
> > design** was implemented. **Two adjacent freshwater lakes** near the Huaihe River, **Jiaogang Lake
> > (Impact site) and Huajia Lake (Control site)**, were selected as the study areas ... **Both lakes
> > share a subtropical humid m**[onsoon climate]"
>
> And the control's qualification is explicit: "the adjacent Huajia Lake (spanning approximately 22.8
> km²) **remained completely free from any PVM installations or subsequent removal events during the
> entire study period**. Its **ecological and hydrological conditions remained undisturbed, making it an
> ideal reference site to account for natural interannual**" variation.
>
> The question was not previously asked: "most studies focus on the positive or negative impacts of PVM
> installations on the local ecology ... However, there is a **lack of answers to questions such as what
> will happen when they are removed**."

### The design, drawn

![Two adjacent lakes with the same climate are surveyed before and after photovoltaic modules are removed from one of them; the researchers did not control the removal or its timing, so the design is a natural experiment with a before-after-control-impact structure](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-b6b79adf07.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **Read this beside Paper 6 — the design is the same, the control is not.** In the turbine study the
  researchers chose which turbines to paint. Here the removal was going to happen anyway. The BACI
  structure is identical, but only the first can rule out that the intervention was placed where it was
  for reasons related to the outcome ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **One impact site and one control site is *n* = 1 per arm.** Surveying many birds does not change
  that: the intervention was applied to a lake. The design supports a well-documented case study of two
  lakes, and the generalization to "PVM removal restores waterbird diversity" rests on judgement about
  how typical these lakes are, not on replication
  ([Ch. 3](../../chapters/03-experimental-unit-and-replication.md)).
- **"Adjacent" and "same climate" are the control's credentials, and they are stated.** A control site
  is only useful if it would have tracked the impact site. Sharing a river system, a climate and a
  region is the argument; it is an argument, not a proof
  ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **Natural experiments are worth running when the alternative is nothing.** Nobody will install and
  remove a solar farm to answer an ecological question. The right response to a design that cannot be
  randomized is not to avoid the question but to document the comparison carefully and state its limits
  — exactly what naming it a "natural experiment" does
  ([Ch. 11](../../chapters/11-observational-and-causal.md)).

</details>

---

## 📄 Paper 8 · Moving the genotypes, not the environment — switchgrass and its rust

**Switchgrass local adaptation study (2026)** ([VanWallendael et al., 2025](https://doi.org/10.1111/nph.70313)), in *New Phytologist*.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC12489299/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> The design has a name and a logic: "The **traditional test for local adaptation is a reciprocal
> transplant experiment** ... in which **individuals from each environment are transplanted to common
> gardens both in their local environment and foreign environments**."
>
> The implementation is large: "we examined locally adapted switchgrass (*Panicum virgatum*), and its
> leaf rust pathogen (*Puccinia novopanici*) **across a latitudinal range in North America**. We grew
> switchgrass genotypes in **10 replicated multiyear common gardens, measuring rust severity from
> natural**" infection.
>
> The two-sided question is what makes it unusual: "In coevolving species, **parasites locally adapt to
> host populations as hosts locally adapt to resist parasites**. **Parasites often outpace host local
> adaptation** since they have rapid life cycles, but host diversity, the strength of selection, and
> external environmental influence can result in complex outcomes."
>
> And the conclusion is conditional: "our results suggest that **both hosts and parasites can be
> simultaneously locally adapted, especially when parasites impose less selection than other
> environmental factors**."

### The design, drawn

![Switchgrass genotypes from several latitudes are planted together in ten common gardens spanning that latitudinal range, so each genotype is grown both at home and away; rust infection comes from local pathogen populations, making the pathogen a second factor that also varies by garden](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-36b37d8cad.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **A common garden separates genotype from environment; a *reciprocal* transplant separates local
  adaptation from general vigour.** One garden tells you which genotypes grow best there. Gardens at
  every source environment tell you whether each genotype does best *at home* — which is a
  genotype × environment interaction, not a main effect
  ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **"Replicated multiyear" carries two design decisions.** Replication within garden separates
  genotype effects from plot-to-plot soil variation; multiple years separate adaptation from a single
  unusual season. Either alone would leave the interaction confounded with something
  ([Ch. 5](../../chapters/05-blocking-and-batches.md)).
- **Natural infection makes the pathogen a factor you did not assign.** Letting rust arrive on its own
  means each garden carries its local pathogen population, so the design simultaneously tests host and
  parasite local adaptation. The cost is that pathogen pressure is observed rather than controlled —
  gardens differ in inoculum for reasons unrelated to the experiment
  ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **The conclusion names the condition under which it holds.** Both species can be locally adapted
  "especially when parasites impose less selection than other environmental factors". That is an
  interaction statement with a boundary, which is what a design across ten environments can support —
  and far more useful than an unconditional claim.

</details>

---

## 📄 Paper 9 · You cannot count what you cannot see — occupancy and detection

**Red panda camera-trap study (2026)** ([Fu et al., 2026](https://doi.org/10.1002/ece3.74208)), in *Ecology and Evolution*.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13477828/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> The survey is large and spatially structured: "**197 infrared camera sites were established** ...
> Camera traps were deployed using a **combination of systematic grid and habitat-optimized placement**.
> First ... a **grid of approximately 1 km × 1 km was overlaid** to cover different elevations and major
> habitat types, and **preset survey units were determined for each grid cell.**"
>
> But placement within each cell was deliberately not random:
>
> > "**Within each unit, rather than placing the camera mechanically at the grid center, specific sites
> > with frequent animal activity and good imaging conditions were preferentially selected**, such as
> > animal trails, water sources, forest gaps".
>
> The consequence is acknowledged: "the **RAI is influenced by factors such as camera-trap placement,
> differences in detection probability among species and individuals, and animal activity rhythms**.
> Therefore, when using RAI as a proxy for relative population size, **the results should be interpreted
> with caution**."
>
> The modelling guards against a different problem: "Spearman correlation analysis was conducted among
> all environmental variables. When the **absolute correlation coefficient |r| > 0.7** between any two
> variables, **models containing both variables were excluded to avoid multicollinearity**. Finally,
> **occupancy modeling** was conducted ... Models were ranked based on **Akaike's information criterion
> (AIC)**, and **models with ΔAIC ≤ 2 were considered the top models. When multiple top models were
> identified, model-averaging was applied**."

### The design, drawn

![A one-kilometre grid defines survey units across the reserve, but within each unit cameras are placed where animals are likely to pass rather than at the grid centre; occupancy modelling then separates whether a site is occupied from whether an animal was detected there, while a correlation threshold removes collinear environmental covariates](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-c2af3b3b44.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **Imperfect detection is measurement error with a direction.** A species not photographed may be
  absent or merely unseen, and the two are confounded in any raw count. Occupancy models separate them
  by using repeated visits to the same site: a species detected on some occasions and not others gives
  an estimate of detection probability, which then corrects the occupancy estimate
  ([Ch. 15](../../chapters/15-measurement-and-benchmarking.md)).
- **The grid and the placement rule pull in opposite directions, deliberately.** The grid ensures the
  reserve is covered evenly, which is a sampling-design virtue. Placing cameras on trails maximizes
  detections, which is a statistical-power virtue — and biases what the camera represents, since a
  trail is not an average piece of forest. Naming the trade-off and flagging the index as needing
  caution is the honest handling ([Ch. 9](../../chapters/09-descriptive-studies.md)).
- **Dropping collinear covariates is a modelling decision with design consequences.** A threshold of |r| > 0.7 flags strong correlation, not perfect collinearity. Separate coefficients can become unstable and depend on which covariates enter the model. Excluding correlated pairs reduces that instability but changes the adjustment and interpretation; more informative sampling may help distinguish effects.
- **Model averaging across ΔAIC ≤ 2 is an admission of uncertainty, correctly handled.** When several
  models fit nearly equally well, selecting one and reporting its coefficients hides the fact that the
  data did not distinguish them. Averaging propagates that ambiguity into the estimates
  ([Ch. 12](../../chapters/12-predictive-studies.md)).

</details>

---

## 📄 Paper 10 · Space is not time — a chronosequence that tests itself

**Restoration planting chronosequence (2026)** ([Watson et al., 2026](https://doi.org/10.1111/mec.70552)), in *Molecular Ecology*. The paper
that takes the commonest shortcut in ecology and then checks whether it works.

**Source audit:** [Open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13594986/). Record the section or figure supporting each design claim before reading the interpretation.

### What the methods say

> The shortcut is defined first: "Many restoration studies ... have adopted a **chronosequence study
> design that use geographical space as a proxy for time** since restoration interventions. **These
> cross-sectional studies involve collecting data at**" sites of different ages at one moment.
>
> This study does both: "we employed high-throughput amplicon sequencing ... to examine soil fungal
> communities **at two time points (December 2014 and April 2020) across a well-studied restoration
> planting chronosequence** at Mt Bold, South Australia", with "**cleared (degraded), restoration
> planting and ecological reference sites**" as the three states. Plantings occurred "**between 2005 and
> 2009 ... using consistent practices**".
>
> And then the critical self-assessment:
>
> > "because **each planting year was represented by a different site, planting age was partly
> > confounded with site identity**. The apparent chronosequence pattern therefore **cannot be
> > attributed unequivocally to time since restoration and may partly reflect unmeasured differences
> > among sites**. Nevertheless, **resampling the same sites in 2020 allowed us to assess within-site
> > change through time and showed that the apparent cross-sectional recovery pattern did not
> > correspo**[nd to the within-site trajectory]"
>
> The conclusion follows from that contrast: "Our longitudinal resampling study identified changes
> consistent with **continued functional recovery over 6 years, despite little additional progress in
> whole fungal community recovery**", and "We support previous studies that have **urged caution when
> drawing cause-effect and future recovery conclusions from cross-sectional chronosequence studies**."

### The design, drawn

![Sites planted in different years are sampled at one time point to build a chronosequence, but because each planting year is a different site, age is confounded with site identity; resampling the same sites six years later provides a within-site trajectory, and the two do not agree](figures/diagrams/subcourses-design-in-the-literature-05-ecology-and-microbiome-2d4a58ccb5.png)

### Reading it

<details>
<summary>Compare with the course interpretation after completing your audit</summary>

- **Space-for-time substitution assumes that older sites are what younger sites will become.** That
  holds only if sites differ in nothing but age. Here each planting year is a different location, so
  site and age are the same variable — the identical structure as
  Paper 5's seagrass confound above, and the authors name it with the same clarity
  ([Ch. 11](../../chapters/11-observational-and-causal.md)).
- **Resampling the same sites converts a cross-sectional design into a longitudinal one.** The second
  visit is what makes each site its own control, differencing away everything fixed about the place —
  the same move as Paper 3's cardinals differencing each bird against itself
  ([Ch. 7](../../chapters/07-treatment-structures.md)).
- **The disagreement between the two views is the paper's most valuable result.** It is direct evidence,
  within one study system, that the cross-sectional shortcut can mislead — which is far more persuasive
  than an argument that it might. Any design whose assumption can be tested with modest extra effort
  should test it ([Ch. 15](../../chapters/15-measurement-and-benchmarking.md)).
- **Three states, not two.** Cleared, planted, and an ecological reference. Without the reference there
  is no target: "more similar to reference" is only meaningful if reference sites were measured the
  same way at the same times ([Ch. 6](../../chapters/06-controls-and-comparators.md)).
- **Separating functional from compositional recovery is what makes the null informative.** Composition
  barely moved while functional profiles kept changing. Measuring only one would have produced either
  "restoration works" or "restoration has stalled", and both would have been wrong.

</details>

---

## Independent transfer task · Counterfactuals in the field

A treated group changes between two captures, and a handled control group changes too. List explanations for control-group change. State the treatment contrast you can estimate and one additional comparison needed to isolate a handling effect.

Use the [evidence worksheet and assessment criteria](README.md#evidence-worksheet).
Submit your diagram, source-backed reasoning and one remaining uncertainty before looking at the
sample answers. More than one redesign may be defensible; justify yours against the stated constraint.

---

## ⚠️ Common Misconceptions

| ❌ The misconception | ✅ What is actually true — and what to do |
|---|---|
| **"A split-plot is a compromised factorial."** | It is the correct design when a factor needs hardware that covers an area. Paper 1's rainout shelter cannot be assigned to one 75 cm mesocosm, so drought *must* be a whole-plot factor. |
| **"If you cannot randomize in the field, randomization does not apply."** | Paper 4 randomized samples across eight DNA extraction batches. The lab half of an observational study is fully under your control. |
| **"Adjusting for batch statistically is as good as randomizing it."** | Only if batch is not confounded with your factor. Extract island by island and adjusting for batch removes the island effect too. Randomize first, then adjust. |
| **"Negative controls are a formality."** | Paper 4 found eight ASVs in its blanks, and moved the blank's plate position so it could probe the whole plate. Controls you never read are decoration. |
| **"Six replicate populations is a small experiment."** | Six *independently evolving* populations is the unit count that matters in Paper 2; a hundred colonies from one population would still be *n* = 1. |
| **"One playback recording tested on 40 birds is n = 40."** | For a claim about intruder song it is *n* = 1 stimulus. Paper 3 used a unique stimulus per male, and never a neighbour's song. |
| **"A control group that receives nothing is wasted effort."** | Paper 3 measures background change in handled control birds. It cannot isolate capture effects from natural temporal change, but it can compare added treatments against that background. |
| **"Reporting a confound is admitting a flaw."** | Paper 5's bare-sediment cores had to come from farther away. Naming it lets the reader downgrade one contrast instead of misreading the whole study. |
| **"Losing samples is just smaller n."** | Paper 4 lost 72 of 153. The question is whether loss was random; non-random failure changes which population the surviving data describe. |
| **"PERMANOVA handles the design automatically."** | Paper 1 had to constrain permutations within blocks. A test given the wrong null structure is wrong invisibly. |
| **"A before-and-after comparison shows the intervention worked."** | It is confounded with everything else that changed meanwhile. Papers 6 and 7 both add a control site so the difference of differences can be taken. |
| **"A natural experiment is as good as an experiment."** | Paper 7's removal happened anyway, so nothing rules out that it was scheduled for reasons related to the site. Paper 6's researchers chose which turbines to paint. |
| **"A common garden tests local adaptation."** | One garden tests which genotypes grow best there. Local adaptation is a home advantage — a genotype × environment interaction — and needs gardens at each source environment (Paper 8). |
| **"Not detecting a species means it is absent."** | It may be unseen. Occupancy models use repeated visits to estimate detection probability and correct the occupancy estimate (Paper 9). |
| **"Placing cameras where animals go is just efficient."** | It raises detections and makes the site unrepresentative of the area it stands for. Paper 9 states the trade-off and flags its index as needing caution. |
| **"Older sites show what younger sites will become."** | Only if sites differ in nothing but age. In Paper 10 each planting year is a different place, and resampling showed the cross-sectional pattern did not match within-site change. |
| **"Collinear covariates can be separated with enough data."** | They cannot — the problem is in the sampled landscape. Paper 9 drops models containing pairs with |r| > 0.7 rather than reporting one as if the other were held constant. |

---

## ✅ Check Your Understanding

**⭐ Q1.** In Paper 1, name the whole-plot factors and the sub-plot factor, and say which physical
object forced that arrangement.

**⭐⭐ Q2.** Paper 1's non-nitrogen plots received "an equivalent volume of purified water". What would
be confounded with nitrogen if they had received nothing?

**⭐⭐ Q3.** Paper 4 both randomized samples across extraction batches *and* included extraction batch
as a fixed effect. Explain why doing only the second would have been dangerous.

**⭐⭐⭐ Q4.** Paper 3's control birds showed a mean β-diversity change greater than zero. State what
this implies about the two treatment effects, and what it would have cost the study to omit the
control group.

**⭐⭐⭐ Q5.** In Paper 5, the most distinct microbial community in the entire dataset came from the one
set of cores whose location differed. Write two sentences a reviewer could send the authors that
accepts the constraint but pins down the claim.

---

**⭐⭐ Q6.** Papers 6 and 7 use the same BACI structure. Name the one feature of Paper 6's design that
Paper 7 cannot have, and say what inference it protects.

**⭐⭐ Q7.** Paper 8 grew genotypes in ten common gardens spanning their source range. Explain why a
single common garden could not test local adaptation, using the words "main effect" and "interaction".

**⭐⭐⭐ Q8.** In Paper 9, cameras were placed on trails rather than at grid centres. Describe the
trade-off this creates, and say which of the paper's two outputs — the relative abundance index or the
occupancy estimate — is more damaged by it.

**⭐⭐⭐ Q9.** Paper 10 found that its cross-sectional chronosequence pattern did not match the within-site
change over six years. Explain how both results can come from the same sites, and say what this implies
for any chronosequence study that samples only once.

---

## 📝 Sample Answers & Assessment

<details>
<summary>▶ Show sample answers</summary>

> **Q1:** *"Whole plot: drought (66% rainfall interception) and nitrogen addition (10 g N m⁻² yr⁻¹),
> in 6 blocks of 4 plots. Sub-plot: wolf spiders present or absent, as a pair of mesocosms inside
> every plot. The rainout shelter forced it — a 2.5 m sloped roof with aluminium plates driven a
> metre into the soil covers a whole plot and cannot be applied to one 75 cm mesocosm and not its
> neighbour."* — **Example answer.**

> **Q2:** *"Water. The nitrogen was sprayed on dissolved in water, so the N plots received extra
> moisture as well as extra nitrogen — and this is a drought experiment, where moisture is the other
> factor being manipulated. Without a water-only control, any 'nitrogen effect' could be a small
> irrigation effect."* — **Example answer.**

> **Q3:** *"Because adjustment only works when batch and the biological factor are not confounded. If
> samples had been extracted island by island, extraction batch and population would be the same
> variable, and putting batch in the model would absorb the population differences the study is
> about — producing a null result that looks like biology. Randomizing first guarantees the two are
> separable; adding batch afterwards then only mops up residual noise."* — **Example answer.**

> **Q4:** *"It implies that part of the change seen in the STI and Temporary Hold groups is caused by
> the shared procedure — mist-netting, bagging, three blood draws — and not by the assigned treatment.
> Both treatment effects must therefore be read as differences from the control, not as absolute
> changes. Omitting the control group would have made the entire procedural footprint invisible, and
> every reported effect would have been inflated by it with no way to tell by how much."* — **Example answer.**

> **Q5:** *"We accept that no unvegetated sediment existed adjacent to the Westside Park seagrass, and
> that taking cores farther away and higher up the slope was the only workable option. We ask only
> that the abstract and discussion describe the Westside Park contrast as habitat combined with tidal
> position rather than as a seagrass-versus-bare comparison, since this is the most distinct community
> in the dataset and the two explanations cannot be separated at that site."* — **Example answer.**

> **Q6:** *"Paper 6's researchers chose which turbines to paint, so the intervention was allocated by
> the experimenters rather than by circumstance; Paper 7's solar-panel removal was going to happen
> regardless, at a site and time chosen by someone else for their own reasons. Experimenter allocation
> protects against the possibility that the intervention was placed where it was for reasons connected
> to the outcome — for example, panels being removed from a lake precisely because it was already
> changing."* — **Example answer.**

> **Q7:** *"A single common garden estimates the main effect of genotype: which genotypes perform best
> in that one environment. Local adaptation is not that — it is the claim that each genotype performs
> best in its own home environment, which means the ranking of genotypes changes from garden to garden.
> That is a genotype × environment interaction, and an interaction cannot be estimated without varying
> both factors, so gardens are needed at each source environment."* — **Example answer.**

> **Q8:** *"Placing cameras on trails, at water sources and in forest gaps raises the detection rate,
> which improves the precision of anything estimated per camera; but it means each camera represents a
> deliberately atypical patch of its grid cell, so the sampled sites are not representative of the
> landscape. The relative abundance index is the more damaged output: it is essentially a detection
> rate, so it scales directly with how good the placements were, and the paper says so. The occupancy
> estimate is more robust because the model separates detection probability from occupancy — though it
> is not immune, since the occupancy being estimated is occupancy of trail-like sites rather than of
> the cell as a whole."* — **Example answer.**

> **Q9:** *"The cross-sectional comparison contrasts different sites that were planted in different
> years, so its apparent trend with age includes any systematic differences between those places — soil,
> slope, prior land use. The longitudinal comparison follows each site against itself, so those fixed
> site differences cancel and what remains is real change over the six years. They can disagree because
> the first is partly a between-site effect wearing the costume of a time effect. For a chronosequence
> sampled only once, the implication is that its trend cannot be read as a recovery trajectory at all:
> site identity and age are the same variable, and nothing in the data can separate them."* — **Example answer.**
</details>

---

## 🧾 Module Summary

| Paper | Design | The lesson it teaches best |
|---|---|---|
| Grassland mesocosms ([Zhang et al., 2026](https://doi.org/10.1002/ece3.74165)) | Split-plot in 6 blocks, paired sub-plots | Hardware decides which factor is the whole plot; difference within the pair |
| *S. aureus* evolution ([Su et al., 2026](https://doi.org/10.7554/elife.107936)) | 2 × 2 × 2 factorial, 6 populations per cell | The replicate population is the unit; the ancestor is the baseline |
| Cardinal stress experiment ([Slevin et al., 2026](https://doi.org/10.1038/s41598-026-42507-x)) | Randomized, paired pre/post in the wild | Replicate the stimulus; a do-nothing arm measures the measurement |
| Puffin microbiota ([Hanski et al., 2026](https://doi.org/10.1098/rsos.252018)) | Observational, randomized extraction batches | Randomize the lab half even when the field half is fixed |
| Seagrass sediments ([Serrano et al., 2026](https://doi.org/10.1128/msphere.00431-26)) | Nested observational sampling | Name the confound you cannot remove, and say which contrast it limits |
| Turbine blade painting ([May et al., 2026](https://doi.org/10.1002/ece3.74017)) | Manipulative BACI, staggered starts | Two comparisons, each closing what the other cannot |
| Solar panel removal ([Cheng et al., 2026](https://doi.org/10.3390/ani16132063)) | BACI around a natural experiment | Same structure, weaker control over the intervention |
| Switchgrass gardens ([VanWallendael et al., 2025](https://doi.org/10.1111/nph.70313)) | Reciprocal transplant, 10 gardens | Local adaptation is an interaction, not a main effect |
| Red panda cameras ([Fu et al., 2026](https://doi.org/10.1002/ece3.74208)) | Occupancy with detection probability | Not seeing is not absence; placement is a trade-off |
| Restoration chronosequence ([Watson et al., 2026](https://doi.org/10.1111/mec.70552)) | Space-for-time, then resampled | The shortcut tested itself, and failed |

---

## 🔗 Go Deeper

- Main course: [Ch. 3 — The Experimental Unit and Replication](../../chapters/03-experimental-unit-and-replication.md) ·
  [Ch. 5 — Blocking and Batches](../../chapters/05-blocking-and-batches.md) ·
  [Ch. 7 — Treatment Structures](../../chapters/07-treatment-structures.md) ·
  [Ch. 11 — Observational and Causal Designs](../../chapters/11-observational-and-causal.md) ·
  [Ch. 17 — Microbiology and the Microbiome](../../chapters/17-microbiology-microbiome.md)
- Foundational: ([Hurlbert, 1984](https://doi.org/10.2307/1942661)) on pseudoreplication in field ecology
- Then design your own: [Ch. 26 — The Design Clinic](../../chapters/26-capstone-design-clinic.md)

## 📚 References cited in this chapter

- Cheng L, Dai B, Wei Z, Cheng S (2026). Rapid Avian Diversity Recovery Following Photovoltaic Module Removal: Rebounds in Larger Waterbirds Composition and Habitat Restoration in Lake Littoral Areas. *Animals* 16:2063. [doi:10.3390/ani16132063](https://doi.org/10.3390/ani16132063)
- Fu Y, Chen M, Feng B, Duan M, Yang Z, He K, et al. (2026). Temporal and Spatial Responses of Chinese Red Pandas to Anthropogenic Disturbance in Meigu Dafengding National Nature Reserve, Sichuan. *Ecology and Evolution* 16:e74208. [doi:10.1002/ece3.74208](https://doi.org/10.1002/ece3.74208)
- Hanski E, Bates K, Hughes R, Newell M, Penn A, Raulo A, et al. (2026). Age-related changes in the gut microbiota of a long-lived seabird suggest divergence from mammalian models. *Royal Society Open Science* 13:RSOS252018. [doi:10.1098/rsos.252018](https://doi.org/10.1098/rsos.252018)
- Hurlbert SH (1984). Pseudoreplication and the Design of Ecological Field Experiments. *Ecological Monographs* 54:187-211. [doi:10.2307/1942661](https://doi.org/10.2307/1942661)
- May R, Hernández Gómez MÁ, Aguirre Martínez JL, Andreu Miguel J (2026). Efficacy of Painting Wind Turbine Blades as a Mitigation Measure to Reduce Bird Collisions in a Mediterranean Wind Farm. *Ecology and Evolution* 16:e74017. [doi:10.1002/ece3.74017](https://doi.org/10.1002/ece3.74017)
- Serrano GA, De Santiago A, Pereira TJ, Marcelino Barros M, Bik HM (2026). Location and habitat specificity structure benthic microbial assemblages in a temperate seagrass ecosystem. *mSphere* 11:e00431-26. [doi:10.1128/msphere.00431-26](https://doi.org/10.1128/msphere.00431-26)
- Slevin MC, Houtz JL, Vitousek MN, Anderson RC (2026). Challenges associate with microbiome diversity, glucocorticoids, and condition in a wild songbird. *Scientific Reports* 16:8511. [doi:10.1038/s41598-026-42507-x](https://doi.org/10.1038/s41598-026-42507-x)
- Su M, Hoang KL, Penley M, Davis MH, Gresham JD, Morran LT, et al. (2026). Host and antibiotic jointly select for greater virulence in Staphylococcus aureus. *eLife* 14:RP107936. [doi:10.7554/elife.107936](https://doi.org/10.7554/elife.107936)
- VanWallendael A, Wijewardana C, Bonnette J, Vormwald L, Fritschi FB, Boe A, et al. (2025). Local adaptation of both plant and pathogen: an arms‐race compromise in switchgrass rust. *New Phytologist* 248:1527-1541. [doi:10.1111/nph.70313](https://doi.org/10.1111/nph.70313)
- Watson CD, Lem AJ, Bissett A, Cando‐Dumancela C, Gardner MG, Hodgson RJ, et al. (2026). Restoration Plantings Promote Functional Recovery of Soil Fungi. *Molecular Ecology* 35:e70552. [doi:10.1111/mec.70552](https://doi.org/10.1111/mec.70552)
- Zhang B, Zhang Z, Ma W, Wang Z (2026). Drought and Nitrogen Addition Modulate Wolf Spider‐Associated Responses in a Detrital Food Web Without Detectable Functional Cascades. *Ecology and Evolution* 16:e74165. [doi:10.1002/ece3.74165](https://doi.org/10.1002/ece3.74165)


---

[← Module 4](04-omics-and-bioinformatics.md) · [Sub-course home](README.md) · [Next: Module 6 — Neuroscience →](06-neuroscience.md)
