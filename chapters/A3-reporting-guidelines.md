# Appendix C — Reporting Guidelines by Study Type

> [← Appendix B](A2-design-card-and-checklist.md) · [Table of Contents](../README.md) · [📚 Full reference list](../REFERENCES.md)

Reporting guidelines are most useful **before** an experiment: every item corresponds to a
design decision. Find your study type, read the guideline, and add its items to your
Design Card.

| Study type | Guideline | Design decisions it forces | Course chapter |
|---|---|---|---|
| Randomized trial — protocol | SPIRIT ([Chan et al., 2013](https://doi.org/10.1136/bmj.e7586)) | full methods before enrolment | 23, 25 |
| Randomized trial — report | CONSORT 2025 ([Hopewell et al., 2025](https://doi.org/10.1136/bmj-2024-081123)); CONSORT 2010 ([Schulz et al., 2010](https://doi.org/10.1136/bmj.c332)) | allocation sequence and concealment, blinding, primary outcome, sample size | 4, 23 |
| Statistical analysis plan | SAP guidance ([Gamble et al., 2017](https://doi.org/10.1001/jama.2017.18556)) | models, covariates, missing data, multiplicity | 25 |
| Trials of AI interventions | CONSORT-AI ([Liu et al., 2020](https://doi.org/10.1038/s41591-020-1034-x)) | algorithm version, inputs, human–AI interaction | 12, 23 |
| Observational epidemiology | STROBE ([von Elm et al., 2007](https://doi.org/10.1016/s0140-6736%2807%2961602-x)) | study base, confounders, selection | 9, 11 |
| Mendelian randomization | STROBE-MR ([Skrivankova et al., 2021](https://doi.org/10.1001/jama.2021.18236)) | instruments, assumptions, sensitivity analyses | 11 |
| Diagnostic accuracy | STARD 2015 ([Bossuyt et al., 2015](https://doi.org/10.1136/bmj.h5527)) | reference standard, patient spectrum, blinded reading | 15 |
| Prediction models (incl. ML) | TRIPOD ([Collins et al., 2015](https://doi.org/10.7326/m14-0697)); TRIPOD+AI ([Collins et al., 2024](https://doi.org/10.1136/bmj-2023-078378)) | sample size, data splits, calibration, external validation | 12 |
| Supervised ML in biology | DOME ([Walsh et al., 2021](https://doi.org/10.1038/s41592-021-01205-4)) | data provenance, split independence, optimization, evaluation | 12, 22 |
| Animal experiments | ARRIVE 2.0 ([Percie du Sert et al., 2020](https://doi.org/10.1371/journal.pbio.3000410)) | unit, randomization, blinding, sample size, inclusion criteria | 23 |
| Livestock & food-safety trials | REFLECT ([Sargeant et al., 2010](https://doi.org/10.4315/0362-028x-73.3.579)) | pen/herd clustering, allocation, outcomes | 19 |
| Experimental pharmacology | BJP guidance ([Curtis et al., 2018](https://doi.org/10.1111/bph.14153); [Curtis et al., 2022](https://doi.org/10.1111/bph.15868)) | ≥ 5 independent units/group, randomization, blinding, normalization | 18 |
| qPCR/digital PCR | MIQE ([Bustin et al., 2009](https://doi.org/10.1373/clinchem.2008.112797)); dMIQE ([Huggett et al., 2013](https://doi.org/10.1373/clinchem.2013.206375)) | RNA quality, efficiency, reference genes, controls | 16 |
| Enzyme kinetics | STRENDA ([Tipton et al., 2014](https://doi.org/10.1016/j.pisc.2014.02.012)) | assay conditions, substrate range, replication | 16 |
| Biocatalysis | biocatalysis reporting guidelines ([Gardossi et al., 2010](https://doi.org/10.1016/j.tibtech.2010.01.001)) | reaction conditions, enzyme form | 18 |
| Human microbiome | STORMS ([Mirzayi et al., 2021](https://doi.org/10.1038/s41591-021-01552-x)) | controls, batches, confounders, contamination | 17 |
| Metabolomics | MSI ([Sumner et al., 2007](https://doi.org/10.1007/s11306-007-0082-2)); mQACC QA/QC ([Kirwan et al., 2022](https://doi.org/10.1007/s11306-022-01926-3)) | QC samples, run order, identification levels | 21 |
| Chromatin profiling (ChIP-seq) | ENCODE guidelines ([Landt et al., 2012](https://doi.org/10.1101/gr.136184.111)) | replicates, controls, depth, concordance | 20 |
| Systematic reviews | PRISMA 2020 ([Page et al., 2021](https://doi.org/10.1136/bmj.n71)); PRISMA-EcoEvo ([O'Dea et al., 2021](https://doi.org/10.1111/brv.12721)) | search, screening, risk of bias | — |
| Data sharing (all) | FAIR principles ([Wilkinson et al., 2016](https://doi.org/10.1038/sdata.2016.18)) | metadata, identifiers, access, licences | 9, 22 |

## 📚 References cited in this chapter

- Bossuyt PM, Reitsma JB, Bruns DE, Gatsonis CA, Glasziou PP, Irwig L, et al. (2015). STARD 2015: an updated list of essential items for reporting diagnostic accuracy studies. *BMJ*:h5527. [doi:10.1136/bmj.h5527](https://doi.org/10.1136/bmj.h5527)
- Bustin SA, Benes V, Garson JA, Hellemans J, Huggett J, Kubista M, et al. (2009). The MIQE Guidelines: Minimum Information for Publication of Quantitative Real-Time PCR Experiments. *Clinical Chemistry* 55:611-622. [doi:10.1373/clinchem.2008.112797](https://doi.org/10.1373/clinchem.2008.112797)
- Chan AW, Tetzlaff JM, Gotzsche PC, Altman DG, Mann H, Berlin JA, et al. (2013). SPIRIT 2013 explanation and elaboration: guidance for protocols of clinical trials. *BMJ* 346:e7586-e7586. [doi:10.1136/bmj.e7586](https://doi.org/10.1136/bmj.e7586)
- Collins GS, Reitsma JB, Altman DG, Moons KGM (2015). Transparent Reporting of a multivariable prediction model for Individual Prognosis Or Diagnosis (TRIPOD): The TRIPOD Statement. *Annals of Internal Medicine* 162:55-63. [doi:10.7326/m14-0697](https://doi.org/10.7326/m14-0697)
- Collins GS, Moons KGM, Dhiman P, Riley RD, Beam AL, Van Calster B, et al. (2024). TRIPOD+AI statement: updated guidance for reporting clinical prediction models that use regression or machine learning methods. *BMJ* 385:e078378. [doi:10.1136/bmj-2023-078378](https://doi.org/10.1136/bmj-2023-078378)
- Curtis MJ, Alexander S, Cirino G, Docherty JR, George CH, Giembycz MA, et al. (2018). Experimental design and analysis and their reporting II: updated and simplified guidance for authors and peer reviewers. *British Journal of Pharmacology* 175:987-993. [doi:10.1111/bph.14153](https://doi.org/10.1111/bph.14153)
- Curtis MJ, Alexander SPH, Cirino G, George CH, Kendall DA, Insel PA, et al. (2022). Planning experiments: Updated guidance on experimental design and analysis and their reporting III. *British Journal of Pharmacology* 179:3907-3913. [doi:10.1111/bph.15868](https://doi.org/10.1111/bph.15868)
- Gamble C, Krishan A, Stocken D, Lewis S, Juszczak E, Doré C, et al. (2017). Guidelines for the Content of Statistical Analysis Plans in Clinical Trials. *JAMA* 318:2337. [doi:10.1001/jama.2017.18556](https://doi.org/10.1001/jama.2017.18556)
- Gardossi L, Poulsen PB, Ballesteros A, Hult K, Švedas VK, Vasić-Rački Đ, et al. (2010). Guidelines for reporting of biocatalytic reactions. *Trends in Biotechnology* 28:171-180. [doi:10.1016/j.tibtech.2010.01.001](https://doi.org/10.1016/j.tibtech.2010.01.001)
- Hopewell S, Chan AW, Collins GS, Hróbjartsson A, Moher D, Schulz KF, et al. (2025). CONSORT 2025 statement: updated guideline for reporting randomised trials. *BMJ* 389:e081123. [doi:10.1136/bmj-2024-081123](https://doi.org/10.1136/bmj-2024-081123)
- Huggett JF, Foy CA, Benes V, Emslie K, Garson JA, Haynes R, et al. (2013). The Digital MIQE Guidelines: Minimum Information for Publication of Quantitative Digital PCR Experiments. *Clinical Chemistry* 59:892-902. [doi:10.1373/clinchem.2013.206375](https://doi.org/10.1373/clinchem.2013.206375)
- Kirwan JA, Gika H, Beger RD, Bearden D, Dunn WB, Goodacre R, et al. (2022). Quality assurance and quality control reporting in untargeted metabolic phenotyping: mQACC recommendations for analytical quality management. *Metabolomics* 18:70. [doi:10.1007/s11306-022-01926-3](https://doi.org/10.1007/s11306-022-01926-3)
- Landt SG, Marinov GK, Kundaje A, Kheradpour P, Pauli F, Batzoglou S, et al. (2012). ChIP-seq guidelines and practices of the ENCODE and modENCODE consortia. *Genome Research* 22:1813-1831. [doi:10.1101/gr.136184.111](https://doi.org/10.1101/gr.136184.111)
- Liu X, Cruz Rivera S, Moher D, Calvert MJ, Denniston AK, Chan AW, et al. (2020). Reporting guidelines for clinical trial reports for interventions involving artificial intelligence: the CONSORT-AI extension. *Nature Medicine* 26:1364-1374. [doi:10.1038/s41591-020-1034-x](https://doi.org/10.1038/s41591-020-1034-x)
- Mirzayi C, Renson A, Furlanello C, Sansone SA, Zohra F, Elsafoury S, et al. (2021). Reporting guidelines for human microbiome research: the STORMS checklist. *Nature Medicine* 27:1885-1892. [doi:10.1038/s41591-021-01552-x](https://doi.org/10.1038/s41591-021-01552-x)
- O'Dea RE, Lagisz M, Jennions MD, Koricheva J, Noble DWA, Parker TH, et al. (2021). Preferred reporting items for systematic reviews and meta‐analyses in ecology and evolutionary biology: a PRISMA extension. *Biological Reviews* 96:1695-1722. [doi:10.1111/brv.12721](https://doi.org/10.1111/brv.12721)
- Page MJ, McKenzie JE, Bossuyt PM, Boutron I, Hoffmann TC, Mulrow CD, et al. (2021). The PRISMA 2020 statement: an updated guideline for reporting systematic reviews. *BMJ*:n71. [doi:10.1136/bmj.n71](https://doi.org/10.1136/bmj.n71)
- Percie du Sert N, Hurst V, Ahluwalia A, Alam S, Avey MT, Baker M, et al. (2020). The ARRIVE guidelines 2.0: Updated guidelines for reporting animal research. *PLOS Biology* 18:e3000410. [doi:10.1371/journal.pbio.3000410](https://doi.org/10.1371/journal.pbio.3000410)
- Sargeant JM, O’connor AM, Gardner IA, Dickson JS, Torrence ME, Dohoo CMPIR, et al. (2010). The REFLECT Statement: Reporting Guidelines for Randomized Controlled Trials in Livestock and Food Safety: Explanation and Elaboration. *Journal of Food Protection* 73:579-603. [doi:10.4315/0362-028x-73.3.579](https://doi.org/10.4315/0362-028x-73.3.579)
- Schulz KF, Altman DG, Moher D (2010). CONSORT 2010 Statement: updated guidelines for reporting parallel group randomised trials. *BMJ* 340:c332-c332. [doi:10.1136/bmj.c332](https://doi.org/10.1136/bmj.c332)
- Skrivankova VW, Richmond RC, Woolf BAR, Yarmolinsky J, Davies NM, Swanson SA, et al. (2021). Strengthening the Reporting of Observational Studies in Epidemiology Using Mendelian Randomization. *JAMA* 326:1614. [doi:10.1001/jama.2021.18236](https://doi.org/10.1001/jama.2021.18236)
- Sumner LW, Amberg A, Barrett D, Beale MH, Beger R, Daykin CA, et al. (2007). Proposed minimum reporting standards for chemical analysis. *Metabolomics* 3:211-221. [doi:10.1007/s11306-007-0082-2](https://doi.org/10.1007/s11306-007-0082-2)
- Tipton KF, Armstrong RN, Bakker BM, Bairoch A, Cornish-Bowden A, Halling PJ, et al. (2014). Standards for Reporting Enzyme Data: The STRENDA Consortium: What it aims to do and why it should be helpful. *Perspectives in Science* 1:131-137. [doi:10.1016/j.pisc.2014.02.012](https://doi.org/10.1016/j.pisc.2014.02.012)
- von Elm E, Altman DG, Egger M, Pocock SJ, Gøtzsche PC, Vandenbroucke JP (2007). The Strengthening the Reporting of Observational Studies in Epidemiology (STROBE) statement: guidelines for reporting observational studies. *The Lancet* 370:1453-1457. [doi:10.1016/s0140-6736(07)61602-x](https://doi.org/10.1016/s0140-6736%2807%2961602-x)
- Walsh I, Fishman D, Garcia-Gasulla D, Titma T, Pollastri G, Capriotti E, et al. (2021). DOME: recommendations for supervised machine learning validation in biology. *Nature Methods* 18:1122-1127. [doi:10.1038/s41592-021-01205-4](https://doi.org/10.1038/s41592-021-01205-4)
- Wilkinson MD, Dumontier M, Aalbersberg IJ, Appleton G, Axton M, Baak A, et al. (2016). The FAIR Guiding Principles for scientific data management and stewardship. *Scientific Data* 3:160018. [doi:10.1038/sdata.2016.18](https://doi.org/10.1038/sdata.2016.18)


---

[← Appendix B](A2-design-card-and-checklist.md) · [Table of Contents](../README.md) · [📚 Full reference list](../REFERENCES.md)
