#!/usr/bin/env bash
# STEP 10 — route-proposal
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Deliver the proposal to the assigned technician, or to the regional manager when claim value is 2000 USD or more
#
# THIS STEP CARRIES A GATE. The design attaches one to step 10, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   Refuse to auto-route when claim value is 2000 USD or more; such a claim is never delivered to a technician for final approval
#
# THE REFUSAL, from the design:
#   Regional Manager reviews the proposal and the evidence record and issues pay or deny within 2 business days
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** Refuse to auto-route when claim value is 2000 USD or more; such a claim is never delivered to a technician for final approval"
    echo
    echo "**Next human action:** Regional Manager reviews the proposal and the evidence record and issues pay or deny within 2 business days"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "route-proposal" refused "gate 10"
  step_say "10" "route-proposal" "gate" "REFUSED — Regional Manager reviews the proposal and the evidence record and issues pay or deny within 2 business days"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: what this step does, if it does anything besides gate. coordination work goes here.
RESULT="proceed"
# --------------------------------------------------------------- THEN THE GATE
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "route-proposal" "$RESULT" "step 10, coordination with a gate, placeholder condition"
step_say "10" "route-proposal" "coordination" "$RESULT"
