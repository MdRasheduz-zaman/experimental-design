"""One-off: turn '- **"Myth."** Reality' bullets under '## ⚠️ Common Misconceptions' into a 2-column table."""
import pathlib, re, sys
HEAD = "| ❌ The misconception | ✅ What is actually true — and what to do |\n|---|---|"
def convert(text):
    out, lines, i = [], text.split("\n"), 0
    while i < len(lines):
        out.append(lines[i])
        if lines[i].startswith("## ⚠️ Common Misconceptions"):
            i += 1; items = []
            while i < len(lines) and not lines[i].startswith("---"):
                l = lines[i]
                if l.startswith("- "): items.append(l[2:].strip())
                elif l.startswith("  ") and items: items[-1] += " " + l.strip()
                elif l.strip() and not l.startswith("|"): raise ValueError(f"unexpected line: {l}")
                elif l.startswith("|"): return text   # already converted
                i += 1
            rows = []
            for it in items:
                m = re.match(r'^\*\*(.+?)\*\*\s+(.*)$', it)
                if not m: raise ValueError(f"cannot parse: {it}")
                myth, fact = (s.replace("|", "\\|") for s in m.groups())
                rows.append(f"| **{myth}** | {fact} |")
            out += ["", HEAD, *rows, ""]
            continue
        i += 1
    return "\n".join(out)
for p in sys.argv[1:]:
    p = pathlib.Path(p); t = p.read_text(); n = convert(t)
    if n != t: p.write_text(n); print("converted", p)
