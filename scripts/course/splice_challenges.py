"""One-off: replace the "## 🛠️ Design Challenge" section of each chapter with <dir>/NN.md (usage: splice_challenges.py <dir>)."""
import pathlib, re, sys
root = pathlib.Path(__file__).resolve().parents[2]
for new in sorted(pathlib.Path(sys.argv[1]).glob("[0-9][0-9].md")):
    ch = next((root / "course_src").glob(new.stem + "-*.md"))
    text = ch.read_text()
    m = re.search(r"^## 🛠️ Design Challenge.*?(?=^---\n\n## ✅)", text, flags=re.S | re.M)
    if not m:
        raise SystemExit(f"no Design Challenge section in {ch.name}")
    text = text[:m.start()] + new.read_text().rstrip() + "\n\n" + text[m.end():]
    ch.write_text(text); print("spliced", ch.name)
