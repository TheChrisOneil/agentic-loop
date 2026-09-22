#!/usr/bin/env bash
# STEP TYPE: COORDINATION  (binds, routes, records — it decides nothing)
#
# Chooses what gets worked tonight: everything the arithmetic could not close, worst first,
# capped at a budget. The cap is not a throttle. It is sized to what a human will genuinely
# read tomorrow morning. Ninety correct proposals delivered at once is a queue nobody finishes.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init

printf 'unit_id\tstatus\texposure\n' > "$MEM/tonight.tsv"
awk -F'\t' 'NR>1 && $2!="clean" && $2!="within_tolerance" {printf "%s\t%s\t%s\n", $1,$2,$3}' \
  "$MEM/findings.tsv" | sort -t$'\t' -k3 -nr > "$MEM/.queue"

head -n "$BUDGET" "$MEM/.queue" >> "$MEM/tonight.tsv"
WORKED=$(($(wc -l < "$MEM/tonight.tsv") - 1))
QUEUED=$(wc -l < "$MEM/.queue"); DEFERRED=$((QUEUED - WORKED))

# Units the arithmetic closed on its own never reach a model at all.
awk -F'\t' 'NR>1 && ($2=="clean" || $2=="within_tolerance") {print $1"\t"$2}' "$MEM/findings.tsv" \
  | while IFS=$'\t' read -r u s; do ledger "$u" select closed_by_rule "$s"; done
AUTO=$(awk -F'\t' 'NR>1 && ($2=="clean" || $2=="within_tolerance")' "$MEM/findings.tsv" | wc -l | tr -d ' ')

ledger "-" select ok "worked $WORKED of $QUEUED, deferred $DEFERRED, closed by rule $AUTO, budget $BUDGET"
echo "select: $AUTO units closed by rule, $WORKED worked tonight, $DEFERRED deferred (budget $BUDGET)"
rm -f "$MEM/.queue"
