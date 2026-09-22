#!/usr/bin/env bash
# For the path where somebody pastes into a browser assistant instead of running the wrapper.
#
#   cost-estimate.sh <job> <prompt file> <reply file> <model>
#
# A browser shows you no token counts, so this ESTIMATES them from the text and records the
# row as source=estimated. It records tokens only. It does not invent a dollar figure — a
# price this script guessed would read exactly like a price somebody measured, and the whole
# point of the ledger is that you can tell those apart.
#
# The dollar figure for the same call, measured with the CLI, is in the instructor's ledger.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
JOB="${1:?usage: cost-estimate.sh <job> <prompt file> <reply file> <model>}"
PROMPT="${2:?}"; REPLY="${3:?}"; MODEL="${4:-browser-assistant}"
for f in "$PROMPT" "$REPLY"; do [ -f "$f" ] || { echo "no such file: $f" >&2; exit 2; }; done

# Four characters per token is the common rough figure. It is rough, and the row says so.
est() { awk 'END{printf "%d", int((n+3)/4)}' n="$(wc -c < "$1" | tr -d ' ')" /dev/null; }
IN=$(awk -v n="$(wc -c < "$PROMPT" | tr -d ' ')" 'BEGIN{printf "%d", int((n+3)/4)}')
OUT=$(awk -v n="$(wc -c < "$REPLY"  | tr -d ' ')" 'BEGIN{printf "%d", int((n+3)/4)}')

U="${USAGE_LEDGER:-$ROOT/memory/usage.tsv}"
[ -s "$U" ] || printf 'date\tjob\tkind\tstage\tmodel\tin\tout\tthinking\tcache_read\tcache_write\tusd\tsource\n' > "$U"
printf '%s\t%s\tnre\tgenerate\t%s\t%s\t%s\tunknown\tunknown\tunknown\tunknown\testimated\n' \
  "$(date +%F)" "$JOB" "$MODEL" "$IN" "$OUT" >> "$U"

echo "  recorded: about $IN tokens in, $OUT tokens out — estimated from the text, not measured."
echo "  thinking tokens and cache reads are unknown: a browser does not report them,"
echo "  and they are where the real cost of a long prompt lives."
