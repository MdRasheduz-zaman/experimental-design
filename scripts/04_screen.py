"""Rule-based title screening of the pool (stage 1), documented for the PRISMA-style flow.

Include: title contains a design/rigour concept. Exclude: biological 'replication'
(viral/DNA/genome), clinical-management guidelines, retracted items.
Output: literature/screened_included.csv, data/screening_flow.csv
"""
import csv, re
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
pool = list(csv.DictReader(open(ROOT / "literature" / "screening_pool.csv")))
INC = re.compile(r"experimental design|study design|design of experiments|designing|sample size|statistical power|power analys|"
                 r"pseudoreplicat|batch effect|best practice|pitfall|reproducib|replicab|rigou?r|benchmark|reporting|"
                 r"minimum information|replicates|randomi[sz]ation|guideline[s]? for (the )?(design|analysis|report)|"
                 r"statistical (design|analysis|consideration)|bias|quality control|recommendation", re.I)
EXC = re.compile(r"(virus|viral|hcv|hiv|hepatitis|dna|genome|plasmid|norovirus|dengue|sars|influenza|cov)\b.*replicat|"
                 r"replicat\w* (of|in) (the )?(\w+ )?(virus|hcv|hiv|dna|genome)|"
                 r"retracted|clinical practice guideline|management of|diagnosis and management|treatment guideline|"
                 r"bethesda system|classification of", re.I)
flow = {"pooled_unique": len(pool), "excluded_off_topic": 0, "included_stage1": 0}
inc = []
for r in pool:
    t = r["title"]
    if INC.search(t) and not EXC.search(t):
        inc.append(r)
    else:
        flow["excluded_off_topic"] += 1
flow["included_stage1"] = len(inc)
with open(ROOT / "literature" / "screened_included.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(pool[0])); w.writeheader(); w.writerows(inc)
with open(ROOT / "data" / "screening_flow.csv", "w", newline="") as fh:
    w = csv.writer(fh); w.writerow(["stage", "n"]); [w.writerow(kv) for kv in flow.items()]
print(flow)
