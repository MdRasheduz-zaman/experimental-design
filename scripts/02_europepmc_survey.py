"""Structured literature survey of experimental-design work across biological fields.

For each field the query is  DESIGN_TERMS AND (field terms), searched in
title/abstract/keywords of Europe PMC. Outputs:
  data/field_year_counts.csv      hits per field per year (2000-2025)
  data/field_totals.csv           total hits, reviews vs. research articles
  literature/survey_top_cited.csv top-cited reviews and research articles per field
  literature/search_strategy.md   the exact queries, for the Methods section
"""
import csv, json, time
from pathlib import Path
import requests

ROOT = Path(__file__).resolve().parents[1]
API = "https://www.ebi.ac.uk/europepmc/webservices/rest/search"
RAW = ROOT / "literature" / "raw" / "europepmc"; RAW.mkdir(parents=True, exist_ok=True)

DESIGN = ('(TITLE_ABS:"experimental design" OR TITLE_ABS:"study design" OR TITLE_ABS:"sample size" '
          'OR TITLE_ABS:"statistical power" OR TITLE_ABS:"power analysis" OR TITLE_ABS:"design of experiments" '
          'OR TITLE_ABS:"randomization" OR TITLE_ABS:"randomisation" OR TITLE_ABS:"pseudoreplication" '
          'OR TITLE_ABS:"batch effect" OR TITLE_ABS:"biological replicates" OR TITLE_ABS:"reproducibility")')

FIELDS = {
    "Molecular & cell biology": '(TITLE_ABS:"molecular biology" OR TITLE_ABS:"cell biology" OR TITLE_ABS:"qPCR" OR TITLE_ABS:"western blot" OR TITLE_ABS:"cell culture" OR TITLE_ABS:"microscopy")',
    "Biochemistry & structural biology": '(TITLE_ABS:"biochemistry" OR TITLE_ABS:"enzyme kinetics" OR TITLE_ABS:"enzyme assay" OR TITLE_ABS:"protein structure" OR TITLE_ABS:"binding assay")',
    "Biotechnology & bioprocessing": '(TITLE_ABS:"biotechnology" OR TITLE_ABS:"bioprocess" OR TITLE_ABS:"fermentation" OR TITLE_ABS:"response surface" OR TITLE_ABS:"metabolic engineering" OR TITLE_ABS:"protein engineering")',
    "Microbiology & microbiome": '(TITLE_ABS:"microbiology" OR TITLE_ABS:"microbiome" OR TITLE_ABS:"microbiota" OR TITLE_ABS:"bacterial" OR TITLE_ABS:"16S rRNA")',
    "Pharmacy & pharmacology": '(TITLE_ABS:"pharmacology" OR TITLE_ABS:"pharmaceutical" OR TITLE_ABS:"pharmacokinetic" OR TITLE_ABS:"drug formulation" OR TITLE_ABS:"quality by design")',
    "Plant & animal breeding": '(TITLE_ABS:"plant breeding" OR TITLE_ABS:"animal breeding" OR TITLE_ABS:"field trial" OR TITLE_ABS:"genomic selection" OR TITLE_ABS:"livestock" OR TITLE_ABS:"crop")',
    "Genetics": '(TITLE_ABS:"genetics" OR TITLE_ABS:"genetic association" OR TITLE_ABS:"QTL" OR TITLE_ABS:"heritability" OR TITLE_ABS:"Mendelian randomization")',
    "Genomics & epigenomics": '(TITLE_ABS:"genomics" OR TITLE_ABS:"GWAS" OR TITLE_ABS:"genome-wide" OR TITLE_ABS:"ChIP-seq" OR TITLE_ABS:"ATAC-seq" OR TITLE_ABS:"DNA methylation")',
    "Transcriptomics (bulk & single-cell)": '(TITLE_ABS:"transcriptomics" OR TITLE_ABS:"RNA-seq" OR TITLE_ABS:"RNA sequencing" OR TITLE_ABS:"microarray" OR TITLE_ABS:"single-cell")',
    "Proteomics & metabolomics": '(TITLE_ABS:"proteomics" OR TITLE_ABS:"metabolomics" OR TITLE_ABS:"lipidomics" OR TITLE_ABS:"mass spectrometry")',
    "Multi-omics & systems biology": '(TITLE_ABS:"multi-omics" OR TITLE_ABS:"multiomics" OR TITLE_ABS:"systems biology" OR TITLE_ABS:"integrative omics")',
    "Functional genomics screens": '(TITLE_ABS:"CRISPR screen" OR TITLE_ABS:"genetic screen" OR TITLE_ABS:"high-throughput screening" OR TITLE_ABS:"RNAi screen" OR TITLE_ABS:"Perturb-seq")',
    "Bioinformatics & computational biology": '(TITLE_ABS:"bioinformatics" OR TITLE_ABS:"computational biology" OR TITLE_ABS:"benchmarking" OR TITLE_ABS:"simulation study" OR TITLE_ABS:"pipeline")',
    "Data science, ML & health informatics": '(TITLE_ABS:"machine learning" OR TITLE_ABS:"deep learning" OR TITLE_ABS:"data science" OR TITLE_ABS:"informatics" OR TITLE_ABS:"electronic health records")',
    "Medical & clinical sciences": '(TITLE_ABS:"clinical trial" OR TITLE_ABS:"randomized controlled trial" OR TITLE_ABS:"cohort study" OR TITLE_ABS:"case-control" OR TITLE_ABS:"diagnostic accuracy")',
    "Preclinical animal research": '(TITLE_ABS:"animal model" OR TITLE_ABS:"animal study" OR TITLE_ABS:"preclinical" OR TITLE_ABS:"mice" OR TITLE_ABS:"rodent")',
    "Neuroscience": '(TITLE_ABS:"neuroscience" OR TITLE_ABS:"neuroimaging" OR TITLE_ABS:"fMRI" OR TITLE_ABS:"electrophysiology" OR TITLE_ABS:"behavioral")',
    "Ecology & evolution": '(TITLE_ABS:"ecology" OR TITLE_ABS:"evolution" OR TITLE_ABS:"experimental evolution" OR TITLE_ABS:"field experiment")',
}
YEARS = range(2000, 2026)

def get(params, tag):
    cache = RAW / f"{tag}.json"
    if cache.exists():
        return json.loads(cache.read_text())
    for attempt in range(5):
        try:
            r = requests.get(API, params={**params, "format": "json"}, timeout=60)
            if r.status_code == 200:
                js = r.json(); cache.write_text(json.dumps(js)); time.sleep(0.15); return js
        except requests.RequestException:
            pass
        time.sleep(2 * (attempt + 1))
    raise RuntimeError(f"Europe PMC failed for {tag}")

def slug(s):
    return "".join(c if c.isalnum() else "_" for c in s)[:40]

year_rows, total_rows, top_rows = [], [], []
for field, fq in FIELDS.items():
    base = f"{DESIGN} AND {fq}"
    for y in YEARS:
        js = get({"query": f"{base} AND PUB_YEAR:{y}", "pageSize": 1, "resultType": "idlist"}, f"{slug(field)}_{y}")
        year_rows.append({"field": field, "year": y, "hits": js["hitCount"]})
    rng = "AND (FIRST_PDATE:[2000-01-01 TO 2026-12-31])"
    n_all = get({"query": f"{base} {rng}", "pageSize": 1, "resultType": "idlist"}, f"{slug(field)}_all")["hitCount"]
    n_rev = get({"query": f'{base} {rng} AND PUB_TYPE:"review"', "pageSize": 1, "resultType": "idlist"}, f"{slug(field)}_rev")["hitCount"]
    total_rows.append({"field": field, "total": n_all, "reviews": n_rev, "non_reviews": n_all - n_rev})
    for kind, extra in (("secondary (review)", 'AND PUB_TYPE:"review"'),
                        ("primary (research/methods)", 'AND NOT PUB_TYPE:"review"')):
        js = get({"query": f"{base} {rng} {extra}", "pageSize": 25, "sort": "CITED desc", "resultType": "lite"},
                 f"{slug(field)}_top_{kind[:3]}")
        for rank, it in enumerate(js.get("resultList", {}).get("result", []), 1):
            top_rows.append({"field": field, "category": kind, "rank": rank, "title": it.get("title", ""),
                             "authors": it.get("authorString", ""), "journal": it.get("journalTitle", ""),
                             "year": it.get("pubYear", ""), "doi": it.get("doi", ""), "pmid": it.get("pmid", ""),
                             "cited_by": it.get("citedByCount", "")})
    print(f"{field}: total={n_all} reviews={n_rev}", flush=True)

def dump(path, rows):
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
dump(ROOT / "data" / "field_year_counts.csv", year_rows)
dump(ROOT / "data" / "field_totals.csv", total_rows)
dump(ROOT / "literature" / "survey_top_cited.csv", top_rows)

with open(ROOT / "literature" / "search_strategy.md", "w") as fh:
    fh.write("# Europe PMC search strategy\n\nDate of search: run date of this script.\n\n")
    fh.write(f"Design block (D):\n\n```\n{DESIGN}\n```\n\nPer-field query = D AND field block, 2000-2026.\n\n")
    for f, q in FIELDS.items():
        fh.write(f"- **{f}**: `{q}`\n")
print("done")
