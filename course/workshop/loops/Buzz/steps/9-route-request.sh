#!/usr/bin/env bash
# STEP 9 — route-request
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Write a proposal assigned to the named approver
#
# THIS STEP CARRIES A GATE. The design attaches one to step 9, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   record checksum differs from the checksum written at step 8, or the approver field is never set to a machine account
#
# THE REFUSAL, from the design:
#   Hold the request and have the ERP systems owner establish who edited the record and when
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** record checksum differs from the checksum written at step 8, or the approver field is never set to a machine account"
    echo
    echo "**Next human action:** Hold the request and have the ERP systems owner establish who edited the record and when"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "route-request" refused "gate 9"
  step_say "9" "route-request" "gate" "REFUSED — Hold the request and have the ERP systems owner establish who edited the record and when"
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

ledger "$UNIT" "route-request" "$RESULT" "step 9, coordination with a gate, placeholder condition"
step_say "9" "route-request" "coordination" "$RESULT"
