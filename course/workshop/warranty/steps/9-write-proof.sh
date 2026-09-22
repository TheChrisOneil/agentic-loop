#!/usr/bin/env bash
# STEP 9 — write-proof
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Write the decision record with all inputs, recomputed figures, model text, gate outcomes, and a SHA-256 checksum
#
# THIS STEP WRITES THE PROOF, and the design says it is checked this way:
#   Each record is SHA-256 checksummed over its canonical serialization, the checksum is chained to the prior record's checksum, and a nightly cron re-verifies the chain; any mismatch alerts the Warranty Operations Lead.
#
# The proof is written by code and checksummed. Evidence a model can edit is not evidence.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"

{
  echo "PROOF  $UNIT"
  echo "generated  $(date +%FT%T)  by $(basename "$0")"
  echo
  echo "UNIT"
  echo "  One warranty claim, identified by claim number, for one serial number."
  awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {print "  "$0}' "$MEM/units.tsv"
  echo
  echo "JUDGMENT"
  [ -f "$JUDGMENTS/$UNIT.tsv" ] && sed 's/^/  /' "$JUDGMENTS/$UNIT.tsv"
  echo
  echo "CHECKS RUN"
  echo "  TODO: list the checks that actually ran, and what they compared"
} > "$PROOF/$UNIT.txt"

shasum -a 256 "$PROOF/$UNIT.txt" | awk '{print $1}' > "$PROOF/$UNIT.sha"
ledger "$UNIT" "write-proof" ok "checksum $(cut -c1-12 < "$PROOF/$UNIT.sha")"
echo "  9 write-proof: proof written and checksummed"
