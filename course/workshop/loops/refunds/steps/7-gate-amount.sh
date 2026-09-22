#!/usr/bin/env bash
# STEP 7 — gate-amount
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when the recomputed amount disagrees with the request
#
# THIS STEP CARRIES A GATE. The design attaches one to step 7, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
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
  step_say "7" "gate-amount" "gate" "REFUSED — Return both figures to the agent who raised the request and have a person decide which is right"
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

ledger "$UNIT" "gate-amount" "$RESULT" "step 7, gate with a gate, placeholder condition"
step_say "7" "gate-amount" "gate" "$RESULT"
