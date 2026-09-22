#!/usr/bin/env bash
# STEP 4 — gate-pre
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse no-PO, injection-suspect, supervised supplier, or over the cap
#
# THIS STEP CARRIES A GATE. The design attaches one to step 4, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   exposure over 2000 USD, or supplier on the supervised list, or no purchase order exists
#
# THE REFUSAL, from the design:
#   Route to a second approver, or raise a purchase order for this spend before any amount is approved
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** exposure over 2000 USD, or supplier on the supervised list, or no purchase order exists"
    echo
    echo "**Next human action:** Route to a second approver, or raise a purchase order for this spend before any amount is approved"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-pre" refused "gate 4"
  step_say "4" "gate-pre" "gate" "REFUSED — Route to a second approver, or raise a purchase order for this spend before any amount is approved"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: what this step does, if it does anything besides gate. gate work goes here.
RESULT="proceed"
# --------------------------------------------------------------- THEN THE GATE
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-pre" "$RESULT" "step 4, gate with a gate, placeholder condition"
step_say "4" "gate-pre" "gate" "$RESULT"
