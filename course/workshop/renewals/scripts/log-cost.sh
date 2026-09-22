#!/usr/bin/env bash
# One line per model call, against the unit that caused it. Recorded from the first run,
# including the zeros — you cannot answer "is this worth doing?" from data you never collected.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
U="$MEM/usage.tsv"
[ -f "$U" ] || printf 'date\tunit\tstage\tmodel\tin_tokens\tout_tokens\test_usd\n' > "$U"
case "${3:-}" in
  claude-haiku*)  RIN=1.00;  ROUT=5.00 ;;
  claude-sonnet*) RIN=3.00;  ROUT=15.00 ;;
  claude-opus*)   RIN=10.00; ROUT=50.00 ;;
  *) RIN=0; ROUT=0 ;;
esac
USD=$(awk -v i="${4:-0}" -v o="${5:-0}" -v ri="$RIN" -v ro="$ROUT" 'BEGIN{printf "%.6f",(i*ri+o*ro)/1000000}')
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$(date +%F)" "$1" "$2" "$3" "${4:-0}" "${5:-0}" "$USD" >> "$U"
