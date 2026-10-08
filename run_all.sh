#!/usr/bin/env bash
# Rebuild the whole project: literature retrieval/verification, survey, screening, figures, course.
# API responses are cached under literature/raw/, so re-runs are offline and deterministic unless the cache is cleared.
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/01_verify_references.py      # Crossref verification -> literature/core_references.bib
python3 scripts/02_europepmc_survey.py       # broad bibliometric survey -> data/field_*.csv
python3 scripts/02b_background_counts.py     # all-literature denominator -> data/background_year_counts.csv
python3 scripts/03_targeted_screen.py        # title-restricted search -> literature/screening_pool.csv
python3 scripts/04_screen.py                 # scripted title screening -> literature/screened_included.csv
Rscript scripts/05_figures.R                 # simulations + bibliometric map -> assets/*.png, data/sim_*.csv
rm -f Rplots.pdf
python3 scripts/06_screening_tables.py       # literature/screening_summary.md + data/screening_flow.csv
Rscript scripts/course/worked_examples.R > data/course_worked_examples.txt   # numbers used in the course
Rscript scripts/course/figures.R             # course figures -> assets/course/*.png
Rscript scripts/08_knit_subcourses.R         # subcourses/*/rmd/*.Rmd -> .build/subcourses/ (+ figures)
python3 scripts/07_build_course.py           # course_src/ + .build/ -> chapters/, subcourses/, README.md, REFERENCES.md;
                                             # Mermaid blocks -> assets/diagrams/*.png (needs: cd tools && npm install)
