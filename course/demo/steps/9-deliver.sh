#!/usr/bin/env bash
# STEP TYPE: GATE, then DELIVER
#
# The last gate re-checks the proof's checksum. Then the loop hands a PROPOSAL to a named
# person. It never approves its own work, on any day, at any trust tier.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"

NOW=$(shasum -a 256 "$PROOF/$UNIT.txt" | awk '{print $1}')
WAS=$(cat "$PROOF/$UNIT.sha")
if [ "$NOW" != "$WAS" ]; then
  ledger "$UNIT" deliver blocked "proof checksum mismatch"
  echo "  deliver: BLOCKED $UNIT — the proof was edited after it was written"
  exit 1
fi

CALL=$(awk -F'\t' '$1=="call"{print $2}' "$JUDGMENTS/$UNIT.tsv")
ADJ=$(awk -F'\t' '$1=="adjustment"{print $2}' "$JUDGMENTS/$UNIT.tsv")
EV=$(awk -F'\t' '$1=="evidence"{print $2}' "$JUDGMENTS/$UNIT.tsv")
NA=$(awk -F'\t' '$1=="next_action"{print $2}' "$JUDGMENTS/$UNIT.tsv")
TIER=$("$DEMO_DIR/scripts/trust-log.sh" --tier "$CALL")

{
  echo "# PROPOSAL — $UNIT"
  echo
  echo "| | |"
  echo "|---|---|"
  echo "| Call | $CALL |"
  echo "| Adjustment | $ADJ |"
  echo "| Trust tier for this call type | $TIER |"
  echo "| Assigned to | $APPROVER |"
  echo
  echo "**Evidence:** $EV"
  echo
  echo "**Next action:** $NA"
  echo
  echo "**Proof:** \`proof/$UNIT.txt\` — checksum \`$(cut -c1-16 < "$PROOF/$UNIT.sha")\`"
  echo
  echo "Nothing here is approved. A named person approves it, or does not."
} > "$OUT/$UNIT.md"

"$DEMO_DIR/scripts/trust-log.sh" "$CALL" pass > /dev/null
ledger "$UNIT" deliver proposed "call=$CALL tier=$TIER"
echo "  deliver: PROPOSED $UNIT ($CALL, tier $TIER) -> outbox/$UNIT.md"
