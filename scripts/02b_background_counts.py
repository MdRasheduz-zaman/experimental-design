"""Background: all Europe PMC records with an abstract, per year (denominator for growth)."""
import csv, time, requests
rows = []
for y in range(2000, 2026):
    r = requests.get("https://www.ebi.ac.uk/europepmc/webservices/rest/search",
                     params={"query": f"PUB_YEAR:{y} AND HAS_ABSTRACT:y", "format": "json", "pageSize": 1, "resultType": "idlist"}, timeout=60)
    rows.append({"year": y, "all_with_abstract": r.json()["hitCount"]}); time.sleep(0.2)
with open("data/background_year_counts.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=["year", "all_with_abstract"]); w.writeheader(); w.writerows(rows)
print(rows[0], rows[10], rows[20], rows[-1])
