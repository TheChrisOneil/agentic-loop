#!/usr/bin/env bash
# STEP 4 — gate-intake
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse messages carrying credentials or from senders that are not customers
#
# THE CONDITION, from the design:
#   the message contains an account credential, or the sender is not a known customer
#
# THE REFUSAL, from the design:
#   Hand the message to the security desk and do not place its text into any downstream system
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** the message contains an account credential, or the sender is not a known customer"
    echo
    echo "**Next human action:** Hand the message to the security desk and do not place its text into any downstream system"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-intake" refused "gate 4"
  step_say "4" "gate-intake" "gate" "REFUSED — Hand the message to the security desk and do not place its text into any downstream system"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-intake" proceed "gate 4, placeholder condition"
step_say "4" "gate-intake" "gate" "proceed"
