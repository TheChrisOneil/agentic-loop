#!/usr/bin/env bash
# Autonomy is earned per kind of call, from logged evidence only.
#   watch  under 10 runs or under 90%   queue  10+ at 90%+   auto  20+ at 95%+
# The tier never blocks the work. It decides what may happen AFTER the checks pass.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
L="$MEM/trust.tsv"; [ -f "$L" ] || printf 'call\truns\tpasses\ttier\n' > "$L"
tier_for() { local r="$1" p="$2"
  [ "$r" -eq 0 ] && { echo watch; return; }
  if   [ "$r" -ge 20 ] && awk -v p="$p" -v r="$r" 'BEGIN{exit !(p/r>=0.95)}'; then echo auto
  elif [ "$r" -ge 10 ] && awk -v p="$p" -v r="$r" 'BEGIN{exit !(p/r>=0.90)}'; then echo queue
  else echo watch; fi; }
case "${1:-}" in
  --tier)   awk -F'\t' -v c="$2" 'NR>1 && $1==c {print $4; f=1} END{if(!f) print "watch"}' "$L" ;;
  --render) printf '%-16s %6s %8s %7s  %s\n' CALL RUNS PASSES RATE TIER
            awk -F'\t' 'NR>1 {printf "%-16s %6d %8d %6.0f%%  %s\n",$1,$2,$3,($2?100*$3/$2:0),$4}' "$L" ;;
  *) C="$1"; O="${2:?pass or fail}"
     R=$(awk -F'\t' -v c="$C" 'NR>1 && $1==c {print $2}' "$L"); R=${R:-0}
     P=$(awk -F'\t' -v c="$C" 'NR>1 && $1==c {print $3}' "$L"); P=${P:-0}
     OLD=$(tier_for "$R" "$P"); R=$((R+1)); [ "$O" = pass ] && P=$((P+1)); NEW=$(tier_for "$R" "$P")
     T=$(mktemp); awk -F'\t' -v c="$C" 'NR==1 || $1!=c' "$L" > "$T"
     printf '%s\t%s\t%s\t%s\n' "$C" "$R" "$P" "$NEW" >> "$T"; mv "$T" "$L"
     rank() { case "$1" in watch) echo 0;; queue) echo 1;; auto) echo 2;; esac; }
     [ "$(rank "$NEW")" -lt "$(rank "$OLD")" ] && echo "ALERT: $C demoted $OLD -> $NEW" >&2
     echo "$NEW" ;;
esac
