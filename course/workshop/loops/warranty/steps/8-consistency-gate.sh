#!/usr/bin/env bash
# STEP 8 — consistency-gate
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when the model conclusion contradicts any recomputed check, when duplicate-serial count is 1 or more, or when the model cites no photograph for an impact-damage claim
#
# THIS STEP CARRIES A GATE. The design attaches one to step 8, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   Refuse when the model conclusion disagrees with any recomputed field, or duplicate-serial count is 1 or more, or an impact-damage finding cites zero photographs
#
# THE REFUSAL, from the design:
#   Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** Refuse when the model conclusion disagrees with any recomputed field, or duplicate-serial count is 1 or more, or an impact-damage finding cites zero photographs"
    echo
    echo "**Next human action:** Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "consistency-gate" refused "gate 8"
  step_say "8" "consistency-gate" "gate" "REFUSED — Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record"
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

ledger "$UNIT" "consistency-gate" "$RESULT" "step 8, gate with a gate, placeholder condition"
step_say "8" "consistency-gate" "gate" "$RESULT"
