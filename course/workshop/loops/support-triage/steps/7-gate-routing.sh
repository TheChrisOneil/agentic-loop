#!/usr/bin/env bash
# STEP 7 — gate-routing
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when a message belongs to no case or to more than one
#
# THE CONDITION, from the design:
#   a selected message belongs to no case, or to more than one
#
# THE REFUSAL, from the design:
#   Return the batch to the duty manager and have a person assign the orphaned messages by hand
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** a selected message belongs to no case, or to more than one"
    echo
    echo "**Next human action:** Return the batch to the duty manager and have a person assign the orphaned messages by hand"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-routing" refused "gate 7"
  step_say "7" "gate-routing" "gate" "REFUSED — Return the batch to the duty manager and have a person assign the orphaned messages by hand"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-routing" proceed "gate 7, placeholder condition"
step_say "7" "gate-routing" "gate" "proceed"
