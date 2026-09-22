#!/usr/bin/env bash
# STEP 7 — gate-coverage
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when a clause belongs to no unit or to more than one
#
# THE CONDITION, from the design:
#   a changed clause appears in no unit, or in more than one
#
# THE REFUSAL, from the design:
#   Return the clause list to the contracts owner and have a person reconcile it before review
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** a changed clause appears in no unit, or in more than one"
    echo
    echo "**Next human action:** Return the clause list to the contracts owner and have a person reconcile it before review"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-coverage" refused "gate 7"
  step_say "7" "gate-coverage" "gate" "REFUSED — Return the clause list to the contracts owner and have a person reconcile it before review"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-coverage" proceed "gate 7, placeholder condition"
step_say "7" "gate-coverage" "gate" "proceed"
