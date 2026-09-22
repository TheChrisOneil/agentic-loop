#!/usr/bin/env bash
# STEP 5 — safety-gate
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse any admitted claim that is missing a purchase date, has an unreadable photograph, or carries a screening flag from step 2
#
# THE CONDITION, from the design:
#   Refuse when purchase date is absent, or photograph count is 1 or more and readable photograph count is less than photograph count, or the instruction-flag count is 1 or more
#
# THE REFUSAL, from the design:
#   Warranty Operations Coordinator returns the claim to the submitting dealer with a named missing-field request and a 5-business-day response window
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** Refuse when purchase date is absent, or photograph count is 1 or more and readable photograph count is less than photograph count, or the instruction-flag count is 1 or more"
    echo
    echo "**Next human action:** Warranty Operations Coordinator returns the claim to the submitting dealer with a named missing-field request and a 5-business-day response window"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "safety-gate" refused "gate 5"
  echo "  5 safety-gate: REFUSED — Warranty Operations Coordinator returns the claim to the submitting dealer with a named missing-field request and a 5-business-day response window"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "safety-gate" proceed "gate 5, placeholder condition"
echo "  5 safety-gate: proceed"
