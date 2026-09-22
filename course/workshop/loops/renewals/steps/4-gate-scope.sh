#!/usr/bin/env bash
# STEP 4 — gate-scope
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse high-value or restricted counterparties before any clause is assessed
#
# THE CONDITION, from the design:
#   contract value is over 250000 USD, or the counterparty is on the restricted list
#
# THE REFUSAL, from the design:
#   Route to counsel before any clause is assessed, with the full diff attached
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** contract value is over 250000 USD, or the counterparty is on the restricted list"
    echo
    echo "**Next human action:** Route to counsel before any clause is assessed, with the full diff attached"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-scope" refused "gate 4"
  echo "  4 gate-scope: REFUSED — Route to counsel before any clause is assessed, with the full diff attached"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-scope" proceed "gate 4, placeholder condition"
echo "  4 gate-scope: proceed"
