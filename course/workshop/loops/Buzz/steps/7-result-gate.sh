#!/usr/bin/env bash
# STEP 7 — result-gate
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when the recomputation disagrees or the assessment cites no payment figure
#
# THIS STEP CARRIES A GATE. The design attaches one to step 7, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   the recomputed increase ratio differs from the assessed ratio by more than 0.01, or the assessment quotes no days-beyond-terms figure, or the resulting limit exceeds 250000 USD without a Finance Director countersignature
#
# THE REFUSAL, from the design:
#   The Credit Manager opens the request and decides on the payment history directly
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** the recomputed increase ratio differs from the assessed ratio by more than 0.01, or the assessment quotes no days-beyond-terms figure, or the resulting limit exceeds 250000 USD without a Finance Director countersignature"
    echo
    echo "**Next human action:** The Credit Manager opens the request and decides on the payment history directly"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "result-gate" refused "gate 7"
  step_say "7" "result-gate" "gate" "REFUSED — The Credit Manager opens the request and decides on the payment history directly"
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

ledger "$UNIT" "result-gate" "$RESULT" "step 7, gate with a gate, placeholder condition"
step_say "7" "result-gate" "gate" "$RESULT"
