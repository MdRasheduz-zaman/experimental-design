"""Targeted, title-restricted search used to build the screening pool.

Design terms must occur in the TITLE; field terms anywhere in title/abstract.
Top 60 most-cited per field are pooled, de-duplicated, and written to
literature/screening_pool.csv for title/abstract screening.
"""
import csv, importlib.util
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("s", ROOT / "scripts" / "02_europepmc_survey.py")
# reuse FIELDS and the cached getter without re-running the survey body
src = (ROOT / "scripts" / "02_europepmc_survey.py").read_text().split("year_rows, total_rows")[0]
ns = {"__file__": str(ROOT / "scripts" / "02_europepmc_survey.py")}; exec(src, ns)
TITLE = ('(TITLE:"experimental design" OR TITLE:"study design" OR TITLE:"design of experiments" OR TITLE:"sample size" '
         'OR TITLE:"statistical power" OR TITLE:"power analysis" OR TITLE:"replicates" OR TITLE:"replication" '
         'OR TITLE:"pseudoreplication" OR TITLE:"batch effect" OR TITLE:"batch effects" OR TITLE:"best practices" '
         'OR TITLE:"guidelines" OR TITLE:"pitfalls" OR TITLE:"reproducibility" OR TITLE:"rigor" OR TITLE:"randomization" '
         'OR TITLE:"benchmarking" OR TITLE:"reporting")')
seen, pool, counts = {}, [], []
for field, fq in ns["FIELDS"].items():
    q = f"{TITLE} AND {fq} AND (FIRST_PDATE:[1990-01-01 TO 2026-12-31])"
    js = ns["get"]({"query": q, "pageSize": 60, "sort": "CITED desc", "resultType": "lite"}, "T_" + ns["slug"](field))
    counts.append({"field": field, "identified": js["hitCount"]})
    for it in js["resultList"]["result"]:
        k = it.get("doi") or it.get("pmid") or it.get("id")
        if k in seen:
            seen[k]["fields"] += "; " + field; continue
        row = {"id": k, "fields": field, "title": it.get("title", ""), "authors": it.get("authorString", ""),
               "journal": it.get("journalTitle", ""), "year": it.get("pubYear", ""), "doi": it.get("doi", ""),
               "pmid": it.get("pmid", ""), "pubtype": "review" if "review" in str(it.get("pubType","")).lower() else "",
               "cited_by": it.get("citedByCount", "")}
        seen[k] = row; pool.append(row)
with open(ROOT / "literature" / "screening_pool.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(pool[0])); w.writeheader(); w.writerows(pool)
with open(ROOT / "data" / "targeted_identified.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["field", "identified"]); w.writeheader(); w.writerows(counts)
print(sum(c["identified"] for c in counts), "identified;", len(pool), "unique in pool")
