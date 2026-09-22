#!/usr/bin/env bash
# THE SENTINEL. Finished work does not close — it becomes an invariant, re-checked forever.
# This script reports. It never repairs. Detection and repair stay separate.
set -uo pipefail
source "$(dirname "$0")/../config.sh"
VIOLATED=0
shopt -s nullglob
for g in "$DEMO_DIR"/goals/*.md; do
  name=$(basename "$g" .md)
  [ "$(awk -F': *' '/^status:/{print $2;exit}' "$g")" = retired ] && continue
  pred=$(sed -n 's/^predicate: *//p' "$g" | head -1)
  if ( cd "$DEMO_DIR" && eval "$pred" ) >/dev/null 2>&1; then
    echo "OK        $name"
    printf '%s\t%s\tsatisfied\n' "$(date +%F)" "$name" >> "$MEM/goal-ledger.tsv"
  else
    echo "VIOLATED  $name"
    printf '%s\t%s\tVIOLATED\n' "$(date +%F)" "$name" >> "$MEM/goal-ledger.tsv"
    printf '%s\tGOAL VIOLATED\t%s\t%s\n' "$(date +%F)" "$name" "$(sed -n 's/^on-violation: *//p' "$g")" >> "$MEM/alerts.tsv"
    VIOLATED=1
  fi
done
exit $VIOLATED
