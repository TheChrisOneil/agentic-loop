#!/usr/bin/env bash
# STEP 7 — gate-post
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse an unusable call, missing evidence, or an unverified adjustment
#
# THE CONDITION, from the design:
#   recomputed adjustment differs from the claimed adjustment by more than 0.01
#
# THE REFUSAL, from the design:
#   Return both figures to the reviewer and have a person decide which is right
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** recomputed adjustment differs from the claimed adjustment by more than 0.01"
    echo
    echo "**Next human action:** Return both figures to the reviewer and have a person decide which is right"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "gate-post" refused "gate 7"
  step_say "7" "gate-post" "gate" "REFUSED — Return both figures to the reviewer and have a person decide which is right"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "gate-post" proceed "gate 7, placeholder condition"
step_say "7" "gate-post" "gate" "proceed"
