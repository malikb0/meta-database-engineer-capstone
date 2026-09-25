#!/usr/bin/env bash
# Portable, dependency-light readiness checks for an ordinary checkout.
# The full gate lives in the orchestration workspace; this script is the public
# fallback used by `make verify` and CI.
set -uo pipefail

fail=0
ok()  { echo "  [x] $1"; }
bad() { echo "  [ ] $1"; fail=$((fail + 1)); }
hdr() { printf '\n%s\n' "$1"; }

cd "$(dirname "$0")/.." || exit 2

hdr "Requirements"
if [[ -f requirements.txt ]]; then
  if ! grep -vE '^\s*(#|$)' requirements.txt | grep -qvE '=='; then
    ok "requirements.txt present and fully pinned"
  else
    bad "requirements.txt has unpinned entries"
  fi
  [[ -f Pipfile ]] && bad "legacy Pipfile present" || ok "no legacy Pipfile"
else
  bad "requirements.txt missing"
fi

hdr "Python syntax"
if python3 -m compileall -q scripts >/dev/null 2>&1; then
  ok "scripts compile"
else
  bad "scripts failed to compile"
fi

hdr "Documentation links"
if python3 scripts/check_links.py; then
  ok "relative links resolve"
else
  bad "broken relative links (see above)"
fi

hdr "Mermaid diagrams"
if command -v mermaid-lint >/dev/null 2>&1; then
  for f in README.md docs/*.md; do
    [[ -f "$f" ]] || continue
    if mermaid-lint "$f" >/dev/null 2>&1; then ok "mermaid: $f"; else bad "mermaid: $f"; fi
  done
elif command -v nbtool >/dev/null 2>&1; then
  for f in README.md docs/*.md; do
    [[ -f "$f" ]] || continue
    if nbtool check --mermaid "$f" >/dev/null 2>&1; then ok "mermaid: $f"; else bad "mermaid: $f"; fi
  done
else
  echo "  [i] no Mermaid linter installed — skipping"
fi

printf '\n== verify.sh: %d failure(s) ==\n' "$fail"
[[ "$fail" == "0" ]]
