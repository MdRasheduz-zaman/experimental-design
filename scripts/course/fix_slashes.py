#!/usr/bin/env python3
"""Remove the spaces around slashes in prose, tables and diagram labels ("A / B" -> "A/B").

Code is left untouched: fenced code chunks (except ```mermaid, whose labels are text),
inline code spans, inline R (`r ...`) and everything outside string literals in .R files.

Usage:  python3 scripts/course/fix_slashes.py [--write] [paths...]
Without --write it only reports what it would change.
"""
import pathlib, re, sys

SLASH = re.compile(r"(?<=\S) +/ +(?=\S)")          # " / " between two non-space characters
PROSE_FENCE = {"mermaid"}                           # fenced blocks that are content, not code

def fix_text(s):
    """Apply the substitution outside inline code spans (which are hidden behind a placeholder,
    so that a slash sitting between two code spans is still fixed)."""
    spans = []
    def hide(m):
        spans.append(m.group(0)); return f"\x00{len(spans) - 1}\x00"
    s = SLASH.sub("/", re.sub(r"`[^`\n]*`", hide, s))
    return re.sub(r"\x00(\d+)\x00", lambda m: spans[int(m.group(1))], s)

def fix_markdown(text):
    out, lang = [], None
    for line in text.split("\n"):
        fence = re.match(r"\s*```+\s*\{?([A-Za-z]*)", line)
        if fence and lang is None:
            lang = fence.group(1).lower(); out.append(line); continue
        if lang is not None:
            if re.match(r"\s*```+\s*$", line):
                lang = None; out.append(line); continue
            out.append(fix_text(line) if lang in PROSE_FENCE else line); continue
        out.append(fix_text(line))
    return "\n".join(out)

def fix_r(text):
    """In R sources, only touch the inside of string literals (plot titles, labels, captions)."""
    return re.sub(r'"[^"\n]*"|\'[^\'\n]*\'', lambda m: SLASH.sub("/", m.group(0)), text)

def main(argv):
    write = "--write" in argv
    paths = [a for a in argv if not a.startswith("--")] or ["course_src", "subcourses", "scripts/course"]
    total = 0
    for root in paths:
        root = pathlib.Path(root)
        files = sorted(root.rglob("*")) if root.is_dir() else [root]
        for f in files:
            if f.suffix.lower() not in {".md", ".rmd", ".r"} or not f.is_file():
                continue
            if ".build" in f.parts or f.name == "fix_slashes.py":
                continue
            old = f.read_text()
            new = fix_r(old) if f.suffix.lower() == ".r" else fix_markdown(old)
            if new == old:
                continue
            for a, b in zip(old.split("\n"), new.split("\n")):
                if a != b:
                    total += 1
                    print(f"{f}\n  - {a.strip()[:150]}\n  + {b.strip()[:150]}")
            if write:
                f.write_text(new)
    print(f"\n{'changed' if write else 'would change'} {total} lines")

if __name__ == "__main__":
    main(sys.argv[1:])
