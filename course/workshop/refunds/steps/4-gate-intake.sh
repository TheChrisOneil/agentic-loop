#!/usr/bin/env bash
# STEP 4 — gate-intake
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse high-value or repeat-refund accounts before anything is assessed
#
# THE CONDITION, from the design:
#   requested amount is more than 2000 USD, or the account has more than 3 refunds in 90 days
#
# THE REFUSAL, from the design:
#   Send to the fraud desk with the account history attached before any amount is released
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** requested amount is more than 2000 USD, or the account has more than 3 refunds in 90 days"
    echo
    echo "**Next human action:** Send to the fraud desk with the account history attached before any amount is released"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-intake" refused "gate 4"
  echo "  4 gate-intake: REFUSED — Send to the fraud desk with the account history attached before any amount is released"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-intake" proceed "gate 4, placeholder condition"
echo "  4 gate-intake: proceed"
