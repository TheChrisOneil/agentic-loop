#!/usr/bin/env bash
# ASK THE SYSTEM TO CHANGE THE DESIGN.
#
# Students reach this through:  make revise NAME=<slug> ASK="what should change"
#
#   ./revise.sh <slug> "what should change"
#   ./revise.sh <slug>                        reads the request from stdin
#
# Each revision: the previous version is kept, the request is recorded, the design is produced
# again with the request attached, the diff is printed, and the call is costed. Arguing with a
# model is not free, and this prints what the argument has cost so far.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
CAP="${REVISION_CAP:-3}"
SLUG="${1:?usage: revise.sh <slug> \"what should change\"}"; shift || true
JOB="$ROOT/jobs/$SLUG"
[ -f "$JOB/proposed.design" ] || { echo "no design at jobs/$SLUG/proposed.design" >&2; exit 2; }
[ -f "$JOB/use-case.txt" ]    || { echo "no use case at jobs/$SLUG/use-case.txt" >&2; exit 2; }

REV=$(ls "$JOB"/proposed.v*.design 2>/dev/null | wc -l | tr -d ' ')
if [ "$REV" -ge "$CAP" ]; then
  echo "REFUSED: $CAP revisions is the budget for one job, and it is spent." >&2
  echo "         Next human action: accept the design as it stands, or edit" >&2
  echo "         jobs/$SLUG/proposed.design by hand and run  make check DESIGN=jobs/$SLUG/proposed.design" >&2
  exit 1
fi

if [ $# -gt 0 ] && [ -n "$*" ]; then
  ASK="$*"
else
  echo "What should change? Be specific — a boundary, a gate, a number, an assumption you"
  echo "disagree with. Finish with Ctrl-D."
  echo
  ASK="$(cat)"
fi
[ ${#ASK} -ge 10 ] || { echo "REFUSED: say what should change, in a sentence." >&2; exit 64; }

NEXT=$((REV+1))
cp "$JOB/proposed.design" "$JOB/proposed.v$NEXT.design"
{ echo "### Revision $NEXT — requested $(date +%FT%T)"; printf '%s\n\n' "$ASK"; } >> "$JOB/notes.txt"
printf '%s\trevise\trequested\trevision %s\n' "$(date +%FT%T)" "$NEXT" >> "$JOB/job.tsv"

echo "  revision $NEXT of $CAP — the version you read is kept as proposed.v$NEXT.design"
echo
"$HERE/generate.sh" --name "$SLUG" --use-case "$JOB/use-case.txt" --notes "$JOB/notes.txt" \
  --by "$(cat "$JOB/owner" 2>/dev/null || echo "${USER:-unknown}")" >/dev/null || exit 1

echo "  what changed:"
echo
# diff exits 1 when the files differ, which is the normal case here — capture first, then look,
# rather than letting pipefail read a successful comparison as a failure.
CHANGED=$(diff -u "$JOB/proposed.v$NEXT.design" "$JOB/proposed.design" 2>/dev/null | sed -n '4,60p' | grep -E '^[-+]' || true)
if [ -n "$CHANGED" ]; then printf '%s\n' "$CHANGED" | sed 's/^/    /'
else echo "    nothing changed — say it differently, or accept it as it stands"; fi
echo
awk -F'\t' -v j="$SLUG" 'NR>1 && $2==j {all++; if ($11 ~ /^[0-9.]+$/) {n++; s+=$11}}
  END{ if (n) printf "  this job has now cost $%.4f across %d model call(s) — every revision is one more\n", s, n;
       else if (all) printf "  %d model call(s) on this job, none of them priced — see make cost\n", all;
       else print "  no priced model calls on this job yet" }' \
  "${USAGE_LEDGER:-$ROOT/memory/usage.tsv}"
echo "  read it:  jobs/$SLUG/BRIEF.md        argue again:  make revise NAME=$SLUG ASK=\"...\""
