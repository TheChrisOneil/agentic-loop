#!/usr/bin/env bash
# THE MATURITY LAYER. Autonomy is earned per TYPE OF CALL, from logged evidence only.
#   trust-log.sh <call> pass|fail   record a run
#   trust-log.sh --tier <call>      what this call type has earned
#   trust-log.sh --render           the table
#
#   watch   under 10 runs, or under 90% verified  -> a human reads every proposal
#   queue   10+ runs at 90%+                      -> proposals wait in a review queue
#   auto    20+ runs at 95%+                      -> may close without a reader
# The tier never blocks the work. It decides only what may happen AFTER the checks pass.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
L="$MEM/trust.tsv"
[ -f "$L" ] || printf 'call\truns\tpasses\ttier\n' > "$L"

tier_for() { # runs passes
  local r="$1" p="$2"
  [ "$r" -eq 0 ] && { echo watch; return; }
  if   [ "$r" -ge 20 ] && awk -v p="$p" -v r="$r" 'BEGIN{exit !(p/r>=0.95)}'; then echo auto
  elif [ "$r" -ge 10 ] && awk -v p="$p" -v r="$r" 'BEGIN{exit !(p/r>=0.90)}'; then echo queue
  else echo watch; fi
}

case "${1:-}" in
  --tier)   awk -F'\t' -v c="$2" 'NR>1 && $1==c {print $4; f=1} END{if(!f) print "watch"}' "$L" ;;
  --render) printf '%-14s %6s %8s %7s  %s\n' CALL RUNS PASSES RATE TIER
            awk -F'\t' 'NR>1 {printf "%-14s %6d %8d %6.0f%%  %s\n",$1,$2,$3,($2?100*$3/$2:0),$4}' "$L" ;;
  "")       echo "usage: trust-log.sh <call> pass|fail | --tier <call> | --render" >&2; exit 64 ;;
  *)
    CALL="$1"; OUTCOME="${2:?pass or fail}"
    R=$(awk -F'\t' -v c="$CALL" 'NR>1 && $1==c {print $2}' "$L"); R=${R:-0}
    P=$(awk -F'\t' -v c="$CALL" 'NR>1 && $1==c {print $3}' "$L"); P=${P:-0}
    OLD=$(tier_for "$R" "$P"); R=$((R+1)); [ "$OUTCOME" = pass ] && P=$((P+1))
    NEW=$(tier_for "$R" "$P")
    T=$(mktemp); awk -F'\t' -v c="$CALL" 'NR==1 || $1!=c' "$L" > "$T"
    printf '%s\t%s\t%s\t%s\n' "$CALL" "$R" "$P" "$NEW" >> "$T"; mv "$T" "$L"
    rank() { case "$1" in watch) echo 0;; queue) echo 1;; auto) echo 2;; esac; }
    if [ "$(rank "$NEW")" -lt "$(rank "$OLD")" ]; then
      printf '%s\tDEMOTED\t%s\t%s -> %s (%s/%s)\n' "$(date +%F)" "$CALL" "$OLD" "$NEW" "$P" "$R" >> "$MEM/alerts.tsv"
      echo "ALERT: $CALL demoted $OLD -> $NEW" >&2
    fi
    echo "$NEW" ;;
esac
