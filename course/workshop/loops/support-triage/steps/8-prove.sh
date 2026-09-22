#!/usr/bin/env bash
# STEP 8 — prove
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Write the message list, the clustering, the coverage result and the routing, then checksum it
#
# THIS STEP WRITES THE PROOF, and the design says it is checked this way:
#   SHA-256 recorded at write time and re-checked before routing
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
  echo "  One case, being the set of messages about a single problem from one customer"
  awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {print "  "$0}' "$MEM/units.tsv"
  echo
  echo "JUDGMENT"
  [ -f "$JUDGMENTS/$UNIT.tsv" ] && sed 's/^/  /' "$JUDGMENTS/$UNIT.tsv"
  echo
  echo "CHECKS RUN"
  echo "  TODO: list the checks that actually ran, and what they compared"
} > "$PROOF/$UNIT.txt"

shasum -a 256 "$PROOF/$UNIT.txt" | awk '{print $1}' > "$PROOF/$UNIT.sha"
ledger "$UNIT" "prove" ok "checksum $(cut -c1-12 < "$PROOF/$UNIT.sha")"
step_say "8" "prove" "mechanical" "proof written and checksummed"
