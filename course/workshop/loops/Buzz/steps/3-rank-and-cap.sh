#!/usr/bin/env bash
# STEP 3 — rank-and-cap
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Admit only requests outside the routine band, order by requested increase and age, and cap the day
#
# THIS STEP CARRIES A GATE. The design attaches one to step 3, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   more than 60 percent of a calendar month's requests fall outside the routine band, or the admitted count exceeds the daily cap of 8
#
# THE REFUSAL, from the design:
#   The Credit Manager reviews the routine band thresholds against that month's requests and reissues the band within 2 working days before the queue is worked
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** more than 60 percent of a calendar month's requests fall outside the routine band, or the admitted count exceeds the daily cap of 8"
    echo
    echo "**Next human action:** The Credit Manager reviews the routine band thresholds against that month's requests and reissues the band within 2 working days before the queue is worked"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "rank-and-cap" refused "gate 3"
  step_say "3" "rank-and-cap" "gate" "REFUSED — The Credit Manager reviews the routine band thresholds against that month's requests and reissues the band within 2 working days before the queue is worked"
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

ledger "$UNIT" "rank-and-cap" "$RESULT" "step 3, coordination with a gate, placeholder condition"
step_say "3" "rank-and-cap" "coordination" "$RESULT"
