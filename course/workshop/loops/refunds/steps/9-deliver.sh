#!/usr/bin/env bash
# STEP 9 — deliver
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Write a release proposal assigned to the named approver
#
# THIS STEP CARRIES A GATE. The design attaches one to step 9, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   proof checksum differs from the checksum recorded when it was written
#
# THE REFUSAL, from the design:
#   Stop the release and have the refunds owner establish who edited the proof and when
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** proof checksum differs from the checksum recorded when it was written"
    echo
    echo "**Next human action:** Stop the release and have the refunds owner establish who edited the proof and when"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "deliver" refused "gate 9"
  step_say "9" "deliver" "gate" "REFUSED — Stop the release and have the refunds owner establish who edited the proof and when"
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

ledger "$UNIT" "deliver" "$RESULT" "step 9, coordination with a gate, placeholder condition"
step_say "9" "deliver" "coordination" "$RESULT"
