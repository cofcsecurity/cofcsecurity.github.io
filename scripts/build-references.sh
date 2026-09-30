#!/usr/bin/env bash
# Compile every references/*.tex into static/files/<name>.pdf
set -euo pipefail
cd "$(dirname "$0")/.."
out=static/files
build=$(mktemp -d)
trap 'rm -rf "$build"' EXIT
for tex in references/*.tex; do
  name=$(basename "$tex" .tex)
  pdflatex -interaction=nonstopmode -halt-on-error -output-directory "$build" "$tex" >"$build/$name.log" 2>&1 \
    || { tail -40 "$build/$name.log"; echo "FAILED: $tex" >&2; exit 1; }
  cp "$build/$name.pdf" "$out/$name.pdf"
  echo "built $out/$name.pdf"
done
