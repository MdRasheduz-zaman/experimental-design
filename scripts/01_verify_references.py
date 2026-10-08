"""Verify every core reference against Crossref and build references.bib.

For each DOI in literature/core_references.tsv: fetch Crossref metadata, check
that the expected keyword occurs in the title, and write a BibTeX entry. Items
that fail are reported in literature/verification_report.tsv so they can be
corrected or dropped; nothing is written to literature/core_references.bib unless it resolved.
"""
import csv, json, re, sys, time, unicodedata
from pathlib import Path
import requests
GREEK = {'α': r'$\alpha$', 'β': r'$\beta$', 'γ': r'$\gamma$', 'κ': r'$\kappa$', 'μ': r'$\mu$', 'ω': r'$\omega$', 'δ': r'$\delta$'}

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "literature" / "core_references.tsv"
RAW = ROOT / "literature" / "raw" / "crossref"
RAW.mkdir(parents=True, exist_ok=True)
HEAD = {"User-Agent": "experimental-design-review/1.0 (mailto:md.rasheduzzaman.ugoe@gmail.com)"}

def norm(s):
    s = unicodedata.normalize("NFKD", s or "").lower()
    return re.sub(r"[^a-z0-9+*δΔ ]", " ", s)

def tex(s):
    s = (s or "").replace("&amp;", "&")
    s = re.sub(r"<[^>]+>", "", s)
    for a, b in [("\\", ""), ("&", r"\&"), ("%", r"\%"), ("_", r"\_"), ("#", r"\#"),
                 ("Δ", r"$\Delta$"), ("–", "--"), ("—", "---"), ("’", "'"), ("‘", "`"),
                 ("“", "``"), ("”", "''"), ("ä","{\\\"a}"), ("ö","{\\\"o}"), ("ü","{\\\"u}"),
                 ("é","{\\'e}"), ("è","{\\`e}"), ("á","{\\'a}"), ("ó","{\\'o}"), ("í","{\\'i}"),
                 ("ç","{\\c c}"), ("ñ","{\\~n}"), ("ø","{\\o}"), ("å","{\\aa}"), ("ß","{\\ss}"),
                 ("Ö","{\\\"O}"), ("Ü","{\\\"U}"), ("ã","{\\~a}"), ("ê","{\\^e}"), ("ı","i"),
                 ("ő","{\\H o}"), ("ł","{\\l}"), ("č","{\\v c}"), ("š","{\\v s}"), ("ž","{\\v z}"),
                 ("ń","{\\'n}"), ("ć","{\\'c}"), ("ř","{\\v r}"), ("ě","{\\v e}"), ("ò","{\\`o}"),
                 ("‐", "-"), ("‑", "-"), (" ", " "), (" ", " ")]:
        s = s.replace(a, b)
    for a, b in GREEK.items():
        s = s.replace(a, b)
    return s

def fetch(doi):
    cache = RAW / (re.sub(r"[^A-Za-z0-9]", "_", doi) + ".json")
    if cache.exists():
        return json.loads(cache.read_text())
    r = requests.get(f"https://api.crossref.org/works/{doi}", headers=HEAD, timeout=30)
    if r.status_code == 200:
        msg = r.json()["message"]
    else:                                   # e.g. arXiv preprints are registered with DataCite, not Crossref
        r = requests.get(f"https://api.datacite.org/dois/{doi}", headers=HEAD, timeout=30)
        if r.status_code != 200:
            return None
        a = r.json()["data"]["attributes"]
        msg = {"DOI": a["doi"], "title": [a["titles"][0]["title"]], "type": "posted-content",
               "author": [{"family": c.get("familyName", c.get("name", "")), "given": c.get("givenName", "")}
                          for c in a.get("creators", [])],
               "issued": {"date-parts": [[int(a["publicationYear"])]]},
               "container-title": [a.get("publisher") if isinstance(a.get("publisher"), str) else "arXiv"],
               "is-referenced-by-count": a.get("citationCount", 0), "source": "DataCite"}
    cache.write_text(json.dumps(msg))
    time.sleep(0.1)
    return msg

def bib(key, m):
    title = (m.get("title") or [""])[0]
    authors = []
    for a in (m.get("author") or m.get("editor") or []):
        if "family" in a:
            authors.append(f"{tex(a['family'])}, {tex(a.get('given',''))}".strip(", "))
        elif "name" in a:
            authors.append("{" + tex(a["name"]) + "}")
    year = None
    for f in ("published-print", "published-online", "issued", "published"):
        dp = (m.get(f) or {}).get("date-parts")
        if dp and dp[0] and dp[0][0]:
            year = dp[0][0]; break
    typ = m.get("type", "")
    people = [x for x in authors if not x.startswith("{")]
    groups = [x for x in authors if x.startswith("{")]
    authors = (people[:10] + ["others"]) if len(people) > 10 else (people + groups if people else groups)
    if len(authors) > 11:
        authors = authors[:10] + ["others"]
    fields = {"title": "{" + tex(title) + "}", "author": "{" + (" and ".join(authors) or "Anonymous") + "}",
              "year": str(year), "doi": m["DOI"]}
    if typ in ("book", "monograph", "edited-book"):
        entry = "book"; fields["publisher"] = tex(m.get("publisher", ""))
    else:
        entry = "article"
        fields["journal"] = tex((m.get("container-title") or [""])[0])
        for k_src, k_dst in (("volume", "volume"), ("issue", "number"), ("page", "pages")):
            if m.get(k_src):
                fields[k_dst] = tex(str(m[k_src])).replace("-", "--") if k_src == "page" else str(m[k_src])
        if not m.get("page") and m.get("article-number"):
            fields["pages"] = str(m["article-number"])
    body = ",\n".join(f"  {k} = {v}" if k in ("title", "author") else f"  {k} = {{{v}}}" for k, v in fields.items())
    return f"@{entry}{{{key},\n{body}\n}}\n", title, year, fields.get("journal", fields.get("publisher", ""))

rows = list(csv.DictReader(open(SRC), delimiter="\t"))
report, entries = [], []
for r in rows:
    m = fetch(r["doi"])
    if m is None:
        report.append({**r, "status": "DOI_NOT_FOUND", "title": "", "year": "", "venue": "", "cited_by": ""}); continue
    entry, title, year, venue = bib(r["key"], m)
    ok = norm(r["expect"]) in norm(title) or r["expect"].lower() in title.lower()
    report.append({**r, "status": "OK" if ok else "TITLE_MISMATCH", "title": title, "year": year,
                   "venue": venue, "cited_by": m.get("is-referenced-by-count", "")})
    if ok:
        entries.append(entry)

out = ROOT / "literature" / "verification_report.tsv"
with open(out, "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(report[0].keys()), delimiter="\t"); w.writeheader(); w.writerows(report)
(ROOT / "literature" / "core_references.bib").write_text("\n".join(entries))
bad = [x for x in report if x["status"] != "OK"]
print(f"{len(report)} checked, {len(entries)} OK, {len(bad)} problems")
for x in bad:
    print(x["key"], x["status"], "|", x["title"][:100])
