#!/usr/bin/env bash
# THE LOOP.
#
#   DECOMPOSE -> SELECT -> [ GATE -> JUDGE -> VERIFY -> GATE -> PROVE -> GATE -> DELIVER ]
#              code                  model     code     code    code     code     code
#
# Code prepares. Judgment decides. Code carries out and checks. The judgment is narrow and
# it is surrounded. Remove the model entirely and this loop still classifies every unit,
# refuses three of them, and closes two — which is the point.
set -uo pipefail
cd "$(dirname "$0")"
source ./config.sh
source ./lib/ledger.sh; ledger_init

echo "=== $(date +%F) tick ==================================================="
./steps/1-decompose.sh
./steps/2-match.sh
./steps/3-select.sh
echo

WORKED=0; PROPOSED=0; REFUSED=0; FAILED=0
while IFS=$'\t' read -r UNIT STATUS EXPOSURE <&3; do
  [ "$UNIT" = unit_id ] && continue
  echo "$UNIT  ($STATUS, \$$EXPOSURE)"
  WORKED=$((WORKED+1))
  ./steps/4-gate-pre.sh  "$UNIT" || { REFUSED=$((REFUSED+1)); echo; continue; }
  ./steps/5-judge.sh     "$UNIT" || { FAILED=$((FAILED+1)); echo; continue; }
  ./steps/6-verify.sh    "$UNIT" || { FAILED=$((FAILED+1)); ./scripts/trust-log.sh \
      "$(awk -F'\t' '$1=="call"{print $2}' "$JUDGMENTS/$UNIT.tsv")" fail >/dev/null; echo; continue; }
  ./steps/7-gate-post.sh "$UNIT" || { REFUSED=$((REFUSED+1)); echo; continue; }
  ./steps/8-prove.sh     "$UNIT"
  ./steps/9-deliver.sh   "$UNIT" && PROPOSED=$((PROPOSED+1)) || FAILED=$((FAILED+1))
  echo
done 3< "$MEM/tonight.tsv"   # fd 3 — stdin stays free for JUDGE_MODE=human

echo "=== worked $WORKED   proposed $PROPOSED   refused $REFUSED   failed $FAILED ==="
echo "    proposals in outbox/   proof in proof/   every transition in memory/ledger.tsv"
[ -s "$MEM/alerts.tsv" ] && { echo; echo "ALERTS:"; cat "$MEM/alerts.tsv"; }
exit 0
