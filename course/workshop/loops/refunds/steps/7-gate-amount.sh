#!/usr/bin/env bash
# STEP 7 — gate-amount
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when the recomputed amount disagrees with the request
#
# THE CONDITION, from the design:
#   the recomputed refundable amount differs from the requested amount
#
# THE REFUSAL, from the design:
#   Return both figures to the agent who raised the request and have a person decide which is right
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** the recomputed refundable amount differs from the requested amount"
    echo
    echo "**Next human action:** Return both figures to the agent who raised the request and have a person decide which is right"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-amount" refused "gate 7"
  echo "  7 gate-amount: REFUSED — Return both figures to the agent who raised the request and have a person decide which is right"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-amount" proceed "gate 7, placeholder condition"
echo "  7 gate-amount: proceed"
