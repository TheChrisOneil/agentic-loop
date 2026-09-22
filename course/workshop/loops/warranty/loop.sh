#!/usr/bin/env bash
# THE LOOP, generated from design/loop.design.
#
#   Triage and adjudicate dealer warranty claims on returned hardware, routing only genuinely ambiguous claims to a product expert.
#
# Batch steps run once. Unit steps run once per unit. A gate that refuses stops that unit and
# nothing else. Code prepares, judgment decides, code carries out and checks.
# Students reach this through:  make scaffold DESIGN=<design> NAME=<folder>
set -uo pipefail
cd "$(dirname "$0")"
source ./config.sh
source ./lib/ledger.sh; ledger_init

echo "=== $(date +%F) tick ============================================="

# ---- batch phase --------------------------------------------------------
for s in 1-pull-claims 2-enrich-and-screen 3-rule-adjudicate 4-order-and-cap ; do ./steps/$s.sh "-" || { echo "batch step $s failed"; exit 1; }; done

# Until the decomposition step is real, the sample units stand in for its output.
if [ ! -s "$MEM/units.tsv" ]; then
  cp data/units.sample.tsv "$MEM/units.tsv"
  ledger "-" seed placeholder "sample units copied — replace when the decomposition is real"
fi

WORKED=0; DELIVERED=0; REFUSED=0; FAILED=0
while IFS=$'\t' read -r UNIT LABEL VALUE <&3; do
  [ "$UNIT" = unit_id ] && continue
  [ "$WORKED" -ge "$FANOUT" ] && { ledger "$UNIT" select deferred "budget $FANOUT"; continue; }
  echo
  echo "$UNIT  ($LABEL)"
  WORKED=$((WORKED+1)); STOPPED=0
  for s in 5-safety-gate 6-assess-ambiguity 7-recompute-checks 8-consistency-gate 9-write-proof 10-route-proposal ; do
    ./steps/$s.sh "$UNIT" || { case "$s" in *gate*) REFUSED=$((REFUSED+1));; *) FAILED=$((FAILED+1));; esac; STOPPED=1; break; }
  done
  [ "$STOPPED" -eq 0 ] && DELIVERED=$((DELIVERED+1))
done 3< "$MEM/units.tsv"

echo
echo "=== worked $WORKED   delivered $DELIVERED   refused $REFUSED   failed $FAILED ==="
echo "    every transition is in memory/ledger.tsv"
exit 0
