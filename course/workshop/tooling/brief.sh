#!/usr/bin/env bash
# Turn a validated design into something a person can read and evaluate: the brief, and both
# diagrams archived as files. Deterministic — nothing here is written by a model.
#
#   ./brief.sh <design file>        writes BRIEF.md and diagrams/ beside the design
#
# generate.sh calls this, and so does anyone who wrote a design by hand.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DESIGN="${1:?usage: brief.sh <design file>}"
[ -f "$DESIGN" ] || { echo "no such design file: $DESIGN" >&2; exit 2; }

if ! "$HERE/validate.sh" "$DESIGN" >/dev/null 2>&1; then
  echo "REFUSED: this design does not pass the validator, so no brief is written." >&2
  echo "         Run:  tooling/validate.sh $DESIGN" >&2
  exit 1
fi

DIR="$(cd "$(dirname "$DESIGN")" && pwd)"
DIA="$DIR/diagrams"; mkdir -p "$DIA"
"$HERE/render.sh"        "$DESIGN" > "$DIA/sequence.mmd"
"$HERE/render.sh" --flow "$DESIGN" > "$DIA/flow.mmd"
SVG=""
if command -v mmdc >/dev/null; then
  mmdc -i "$DIA/sequence.mmd" -o "$DIA/sequence.svg" >/dev/null 2>&1 || true
  mmdc -i "$DIA/flow.mmd"     -o "$DIA/flow.svg"     >/dev/null 2>&1 || true
  [ -s "$DIA/sequence.svg" ] && SVG=yes
fi

{
  awk -f "$HERE/lib/parse.awk" -f "$HERE/lib/brief.awk" "$DESIGN"
  echo
  echo "## The flow it proposes"
  echo
  if [ -n "$SVG" ]; then
    echo "Pictures, for reading: [\`diagrams/sequence.svg\`](diagrams/sequence.svg) and"
    echo "[\`diagrams/flow.svg\`](diagrams/flow.svg). Open either one — no tooling needed."
    echo
  fi
  echo "### Step by step, with every gate"
  echo
  echo '```mermaid'; cat "$DIA/sequence.mmd"; echo '```'
  echo
  echo "### The same design as a flowchart, coloured by the kind of step"
  echo
  echo "Green is a rule. Pink is the judgment. Amber is a gate. Blue is a check."
  echo
  echo '```mermaid'; cat "$DIA/flow.mmd"; echo '```'
} > "$DIR/BRIEF.md"

echo "  $DIR/BRIEF.md"
echo "  $DIA/  $(ls "$DIA" | tr '\n' ' ')"
