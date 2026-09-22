#!/usr/bin/env bash
# STEP 4 — gate-scope
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse high-value or restricted counterparties before any clause is assessed
#
# THIS STEP CARRIES A GATE. The design attaches one to step 4, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
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
  step_say "4" "gate-scope" "gate" "REFUSED — Route to counsel before any clause is assessed, with the full diff attached"
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

ledger "$UNIT" "gate-scope" "$RESULT" "step 4, gate with a gate, placeholder condition"
step_say "4" "gate-scope" "gate" "$RESULT"
