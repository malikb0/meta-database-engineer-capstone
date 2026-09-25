#!/usr/bin/env python3
"""Resolve relative Markdown links and image references in this repository.

Scans the top-level docs and ``docs/*.md``, skips external URLs and anchor-only
targets, URL-decodes paths, and exits non-zero listing any missing local target.
Run from anywhere; paths are resolved relative to each Markdown file.
"""
from __future__ import annotations

import re
from pathlib import Path
from urllib.parse import unquote

LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "tel:", "data:")


def markdown_files(root: Path) -> list[Path]:
    named = [root / n for n in ("README.md", "CONTRIBUTING.md", "CHANGELOG.md", "NOTICE.md")]
    named += sorted((root / "docs").glob("*.md"))
    return [f for f in named if f.exists()]


def check(path: Path, root: Path) -> list[str]:
    missing: list[str] = []
    text = path.read_text(encoding="utf-8")
    for target in LINK_RE.findall(text):
        if target.startswith(SKIP_PREFIXES) or target.startswith("#"):
            continue
        clean = unquote(target.split("#", 1)[0]).strip("<>")
        if not clean:
            continue
        resolved = (path.parent / clean).resolve()
        if not resolved.exists():
            missing.append(f"{path.relative_to(root)} -> {target}")
    return missing


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    problems: list[str] = []
    for markdown in markdown_files(root):
        problems += check(markdown, root)
    if problems:
        print("Broken relative links:")
        for problem in problems:
            print(f"  [ ] {problem}")
        return 1
    print("All relative Markdown links resolve.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
