"""Fetch the open-access full texts quoted by the *Design in the Literature* sub-course.

Every paper discussed there is quoted verbatim from its methods section. This script downloads
those full texts from Europe PMC into literature/papers/ so the quotations can be checked against
the source. The PMC identifiers are read from the sub-course pages themselves, so the list cannot
drift away from what the course actually cites.

The files are not kept in version control: each paper remains under its own publisher licence, and
Europe PMC is the canonical copy. Run this once after cloning if you want to verify quotations.

    python3 scripts/09_fetch_fulltexts.py            # fetch what is missing
    python3 scripts/09_fetch_fulltexts.py --force     # refetch everything
"""
import re, sys, time
from pathlib import Path
import requests

ROOT = Path(__file__).resolve().parents[1]
PAGES = sorted((ROOT / "subcourses" / "design-in-the-literature").glob("[0-9]*.md"))
OUT = ROOT / "literature" / "papers"
API = "https://www.ebi.ac.uk/europepmc/webservices/rest/{}/fullTextXML"
FORCE = "--force" in sys.argv

ids = sorted({m for p in PAGES for m in re.findall(r"PMC\d{6,9}", p.read_text())})
if not ids:
    sys.exit("No PMC identifiers found — run this from a built course (chapters/ and subcourses/ present).")
OUT.mkdir(parents=True, exist_ok=True)

fetched = skipped = failed = 0
for pmcid in ids:
    dest = OUT / f"{pmcid}.xml"
    if dest.exists() and not FORCE:
        skipped += 1
        continue
    for attempt in range(6):                      # Europe PMC returns transient 503s under load
        try:
            r = requests.get(API.format(pmcid), timeout=60)
            if r.status_code == 200 and r.text.lstrip().startswith("<"):
                dest.write_text(r.text); fetched += 1
                break
            if r.status_code == 404:
                print(f"{pmcid}: no full text in the OA subset"); failed += 1
                break
        except requests.RequestException as e:
            print(f"{pmcid}: {e}")
        time.sleep(2 * (attempt + 1))
    else:
        print(f"{pmcid}: gave up after 6 attempts"); failed += 1
    time.sleep(0.5)                               # be polite to the API

print(f"{len(ids)} cited papers: {fetched} fetched, {skipped} already cached, {failed} unavailable")
