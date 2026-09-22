#!/usr/bin/env bash
# STEP 4 — intake-gate
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse a request lacking payment history or an account on credit hold
#
# THIS STEP CARRIES A GATE. The design attaches one to step 4, so the step does its own
# work and then refuses on this condition — a gate the design names is a gate the code runs.
#
# THE CONDITION, from the design:
#   fewer than 6 months of payment history on the account, or the account carries an open credit hold flag, or unpaid invoices over 60 days past due exceed 0
#
# THE REFUSAL, from the design:
#   The Credit Analyst returns the request to the originating salesperson naming the missing history or the hold, with a 3 working day resubmission date
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** fewer than 6 months of payment history on the account, or the account carries an open credit hold flag, or unpaid invoices over 60 days past due exceed 0"
    echo
    echo "**Next human action:** The Credit Analyst returns the request to the originating salesperson naming the missing history or the hold, with a 3 working day resubmission date"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "intake-gate" refused "gate 4"
  step_say "4" "intake-gate" "gate" "REFUSED — The Credit Analyst returns the request to the originating salesperson naming the missing history or the hold, with a 3 working day resubmission date"
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

ledger "$UNIT" "intake-gate" "$RESULT" "step 4, gate with a gate, placeholder condition"
step_say "4" "intake-gate" "gate" "$RESULT"
