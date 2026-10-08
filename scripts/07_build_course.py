"""Build the GitHub-rendered course from course_src/ into chapters/.

Authors write citations as [@key] or [@key1; @key2] using keys from
literature/core_references.tsv. This script:
  * replaces each citation with linked short forms, e.g. ([Lazic et al., 2018](https://doi.org/...)),
  * appends a "References cited in this chapter" list with full entries,
  * writes REFERENCES.md (every reference used anywhere in the course),
  * fails loudly on unknown keys, so no unverified reference can slip in.
Metadata comes from the cached Crossref records verified by 01_verify_references.py.
"""
import csv, hashlib, json, os, re, shutil, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC, OUT = ROOT / "course_src", ROOT / "chapters"
CACHE = ROOT / "literature" / "raw" / "crossref"
OUT.mkdir(exist_ok=True)

refs = {r["key"]: r["doi"] for r in csv.DictReader(open(ROOT / "literature" / "core_references.tsv"), delimiter="\t")}

def meta(key):
    doi = refs[key]
    m = json.loads((CACHE / (re.sub(r"[^A-Za-z0-9]", "_", doi) + ".json")).read_text())
    people = [a for a in m.get("author", []) if "family" in a] or [a for a in m.get("editor", []) if "family" in a]
    groups = [a["name"] for a in m.get("author", []) if "name" in a and "family" not in a]
    year = None
    for f in ("published-print", "published-online", "issued", "published"):
        dp = (m.get(f) or {}).get("date-parts")
        if dp and dp[0] and dp[0][0]:
            year = dp[0][0]; break
    if people:
        fam = [p["family"] for p in people]
        short = fam[0] if len(fam) == 1 else (f"{fam[0]} & {fam[1]}" if len(fam) == 2 else f"{fam[0]} et al.")
        full_auth = ", ".join(f"{p['family']} {''.join(w[0] for w in re.split(r'[ .-]+', p.get('given', '')) if w)}" for p in people[:6])
        if len(people) > 6:
            full_auth += ", et al."
    else:
        short = full_auth = groups[0] if groups else "Anonymous"
    title = re.sub(r"<[^>]+>", "", (m.get("title") or [""])[0]).strip()
    title = re.sub(r"\s+", " ", title)
    venue = re.sub(r"<[^>]+>", "", (m.get("container-title") or [m.get("publisher", "")])[0] if m.get("container-title") else m.get("publisher", ""))
    vol = m.get("volume", ""); pg = m.get("page", "") or m.get("article-number", "")
    loc = f" {vol}" if vol else ""
    loc += f":{pg}" if pg else ""
    return {"short": f"{short}, {year}", "full": f"{full_auth} ({year}). {title}. *{venue}*{loc}.", "doi": m["DOI"], "sort": f"{short}{year}"}

CITE = re.compile(r"\[(@[A-Za-z0-9_]+(?:\s*;\s*@[A-Za-z0-9_]+)*)\]")
used_all = {}
errors = []

def doi_url(doi):
    """Some DOIs contain parentheses (e.g. 10.1016/S0140-6736(07)61602-X). Unescaped, they end a
    Markdown link early, so the citation renders as broken text. Percent-encode them."""
    for ch, esc in (("(", "%28"), (")", "%29"), ("<", "%3C"), (">", "%3E"), (" ", "%20")):
        doi = doi.replace(ch, esc)
    return "https://doi.org/" + doi

def render(text, used):
    def sub(mo):
        keys = [k.strip()[1:] for k in mo.group(1).split(";")]
        parts = []
        for k in keys:
            if k not in refs:
                errors.append(k); continue
            md = meta(k); used[k] = md; used_all[k] = md
            parts.append(f"[{md['short']}]({doi_url(md['doi'])})")
        return "(" + "; ".join(parts) + ")"
    # leave inline code spans (`...`) untouched so documentation of the syntax is not parsed
    out = []
    for i, block in enumerate(re.split(r"(^```.*?^```[ \t]*$)", text, flags=re.S | re.M)):
        if i % 2:                      # fenced code block: copy verbatim
            out.append(block); continue
        for j, span in enumerate(re.split(r"(`[^`\n]+`)", block)):
            out.append(span if j % 2 else CITE.sub(sub, span))
    return "".join(out)

def target_for(src):
    rel = src.relative_to(BUILD) if BUILD in src.parents else src.relative_to(SRC)
    if rel.parts[0] == "subcourses":
        # Preserve the folder hierarchy for the standalone sub-courses.
        out = ROOT.joinpath(*rel.parts)
    elif rel.name == "README.md" and len(rel.parts) == 1:
        out = ROOT / "README.md"
    else:
        out = OUT / rel.name
    out.parent.mkdir(parents=True, exist_ok=True)
    return out

BUILD = ROOT / ".build"                       # knitted sub-course Markdown (scripts/08_knit_subcourses.R)
DIAG = ROOT / "assets" / "diagrams"
MMDC = ROOT / "tools" / "node_modules" / ".bin" / "mmdc"

def run_mmdc(inp, outp, tries=3):
    """Run mermaid-cli; return None on success, else the error message."""
    env = dict(os.environ, PUPPETEER_SKIP_DOWNLOAD="1")
    for attempt in range(tries):                    # headless Chrome occasionally times out
        r = subprocess.run([str(MMDC), "-i", str(inp), "-o", str(outp), "-e", "png", "-s", "2", "-b", "white",
                            "-c", str(ROOT / "tools" / "mermaid-config.json"),
                            "-p", str(ROOT / "tools" / "puppeteer-config.json")],
                           capture_output=True, text=True, env=env)
        if r.returncode == 0:
            return None
    return next((l for l in r.stderr.splitlines() if "Error" in l), r.stderr[-400:])

# Shared colour classes for diagrams: write `node:::trt` in a block and the classDef is added here.
PALETTE = {
    "trt":  "fill:#fbd5c2,stroke:#eb6834,stroke-width:2px,color:#0b0b0b",   # treatment / group 1 (orange)
    "ctl":  "fill:#cfe0f6,stroke:#2a78d6,stroke-width:2px,color:#0b0b0b",   # control / group 2 (blue)
    "pos":  "fill:#e6dcf7,stroke:#4a3aa7,stroke-width:2px,color:#0b0b0b",   # third group / positive control (purple)
    "ok":   "fill:#d4f2e6,stroke:#1baf7a,stroke-width:2px,color:#0b0b0b",   # good choice (green)
    "bad":  "fill:#fde2e2,stroke:#d03b3b,stroke-width:2px,color:#0b0b0b",   # flaw / avoid (red)
    "note": "fill:#f6f6f4,stroke:#9a9893,color:#0b0b0b",                    # neutral annotation (grey)
}

def with_palette(src):
    used = set(re.findall(r":::(\w+)", src))
    defs = [f"  classDef {c} {PALETTE[c]}\n" for c in sorted(used & PALETTE.keys())
            if not re.search(rf"^\s*classDef {c}\b", src, flags=re.M)]
    return src + "".join(defs)

def diagram_info(text, stem):
    """Locate ```mermaid blocks; return (match, source, alt text, cached PNG path) for each."""
    info = []
    for mo in re.finditer(r"^```mermaid\n(.*?)^```[ \t]*$", text, flags=re.S | re.M):
        src = with_palette(mo.group(1))
        alt = re.search(r"^%%\s*alt:\s*(.+)$", src, flags=re.M)
        # Name by content only: inserting a diagram must not rename (and so re-render) the ones below it.
        h = hashlib.sha1(src.encode()).hexdigest()[:10]
        info.append((mo, src, alt.group(1).strip() if alt else "Diagram", DIAG / f"{stem}-{h}.png"))
    return info

def render_missing(todo, batch=10):
    """Render all uncached diagrams with few mmdc calls (browser starts); fall back to one at a time."""
    DIAG.mkdir(parents=True, exist_ok=True)
    tmp_in, tmp_out = DIAG / ".tmp-batch.md", DIAG / ".tmp-batch-out.md"
    def attempt(part, tries):
        tmp_in.write_text("\n\n".join(f"```mermaid\n{src}```" for src, _ in part) + "\n")
        err = run_mmdc(tmp_in, tmp_out, tries)
        if err is None:
            for k, (_, png) in enumerate(part, 1):
                (DIAG / f".tmp-batch-out-{k}.png").rename(png)
        return err
    for b in range(0, len(todo), batch):
        part = todo[b:b + batch]
        if attempt(part, 2) is not None:
            for one in part:                        # isolate the failing diagram
                err = attempt([one], 3)
                if err is not None:
                    sys.exit(f"Mermaid render failed for {one[1].name}:\n{err}")
        print(f"rendered {min(b + batch, len(todo))}/{len(todo)} new diagrams", flush=True)
    for f in DIAG.glob(".tmp-batch*"):
        f.unlink()

def insert_images(text, target, info):
    """Replace each mermaid block with its rendered PNG."""
    out, last = [], 0
    for mo, _, alt, png in info:
        # Some previews restrict resources to the document's directory. Keep the
        # render cache centrally, but publish a copy beside the readable chapter.
        local_png = target.parent / "figures" / "diagrams" / png.name
        local_png.parent.mkdir(parents=True, exist_ok=True)
        if not local_png.exists() or local_png.read_bytes() != png.read_bytes():
            shutil.copyfile(png, local_png)
        rel = local_png.relative_to(target.parent).as_posix()
        out.append(text[last:mo.start()])
        # Standard Markdown images work in viewers that do not render raw HTML.
        alt = alt.replace("\\", "\\\\").replace("[", "\\[").replace("]", "\\]")
        out.append(f'![{alt}]({rel})\n')
        last = mo.end() + 1
    out.append(text[last:])
    return "".join(out)

# Pass 1: resolve citations and find diagrams in every file. Pass 2: render what is missing, then write.
sources = sorted(SRC.rglob("*.md")) + sorted(BUILD.rglob("*.md"))
pages = []
for src in sources:
    used = {}
    body = render(src.read_text(), used)
    if used and "<!-- REFS -->" in body:
        lst = "\n".join(f"- {u['full']} [doi:{u['doi']}]({doi_url(u['doi'])})" for u in sorted(used.values(), key=lambda x: x["sort"].lower()))
        body = body.replace("<!-- REFS -->", "## 📚 References cited in this chapter\n\n" + lst + "\n")
    else:
        body = body.replace("<!-- REFS -->", "")
    target = target_for(src)
    stem = "-".join(target.relative_to(ROOT).with_suffix("").parts).replace("chapters-", "")
    pages.append((body, target, stem, diagram_info(body, stem)))

todo = {png: src for *_, info in pages for _, src, _, png in info if not png.exists()}
if todo:
    render_missing([(src, png) for png, src in todo.items()])
# Renders are content-addressed, so a rebuilt page leaves its previous PNGs behind. They are kept by
# default because open Markdown previews and older copies of the course still refer to them; without
# pruning, though, assets/diagrams/ grows without bound. `--prune` removes the ones this build does
# not reference, in the central cache and in the copies published beside each page.
for body, target, stem, info in pages:
    target.write_text(insert_images(body, target, info))

if "--prune" in sys.argv:
    live = {png.name for *_, info in pages for *_, png in info}
    removed = freed = 0
    for d in [DIAG] + sorted({t.parent / "figures" / "diagrams" for _, t, _, _ in pages}):
        for old_png in d.glob("*.png"):
            if old_png.name not in live:
                freed += old_png.stat().st_size; old_png.unlink(); removed += 1
    print(f"pruned {removed} unreferenced diagram files ({freed / 1e6:.1f} MB)")

if errors:
    sys.exit(f"Unknown citation keys: {sorted(set(errors))}")

lines = ["# 📚 References", "", "Every reference cited anywhere in the course. Each was resolved by DOI against Crossref "
         "(see `scripts/01_verify_references.py`); none was typed by hand.", ""]
lines += [f"- {u['full']} [doi:{u['doi']}]({doi_url(u['doi'])})" for u in sorted(used_all.values(), key=lambda x: x["sort"].lower())]
(ROOT / "REFERENCES.md").write_text("\n".join(lines) + "\n")
print(f"built {len(sources)} files; {len(used_all)} distinct references cited")
