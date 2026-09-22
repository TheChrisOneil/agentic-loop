#!/usr/bin/env bash
# COST ACCOUNTING, from the first run rather than from month three.
# One line per model call, against the unit that caused it. In stub mode the cost is
# genuinely zero — and recording the zero is the point. You cannot answer "is this worth
# doing?" from data you did not collect.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
U="$MEM/usage.tsv"
[ -f "$U" ] || printf 'date\tunit\tstage\tmodel\tin_tokens\tout_tokens\test_usd\n' > "$U"
IN="${4:-0}"; OUT_T="${5:-0}"
case "$3" in
  claude-haiku*) RIN=1.00; ROUT=5.00 ;;
  claude-sonnet*) RIN=3.00; ROUT=15.00 ;;
  claude-opus*|claude-fable*) RIN=10.00; ROUT=50.00 ;;
  *) RIN=0; ROUT=0 ;;
esac
USD=$(awk -v i="$IN" -v o="$OUT_T" -v ri="$RIN" -v ro="$ROUT" 'BEGIN{printf "%.6f",(i*ri+o*ro)/1000000}')
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$(date +%F)" "$1" "$2" "$3" "$IN" "$OUT_T" "$USD" >> "$U"
