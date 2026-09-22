#!/usr/bin/env bash
# STEP 8 — consistency-gate
# TYPE:  gate   (permits or refuses — the condition lives HERE, in code)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Refuse when the model conclusion contradicts any recomputed check, when duplicate-serial count is 1 or more, or when the model cites no photograph for an impact-damage claim
#
# THE CONDITION, from the design:
#   Refuse when the model conclusion disagrees with any recomputed field, or duplicate-serial count is 1 or more, or an impact-damage finding cites zero photographs
#
# THE REFUSAL, from the design:
#   Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record
#
# This condition may never move into a prompt. A prompt is a request. A rule is a rule.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

refuse() {
  { echo "# REFUSED — $UNIT"
    echo
    echo "**Why this stopped:** Refuse when the model conclusion disagrees with any recomputed field, or duplicate-serial count is 1 or more, or an impact-damage finding cites zero photographs"
    echo
    echo "**Next human action:** Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUTBOX/$UNIT.REFUSED.md"
  ledger "$UNIT" "consistency-gate" refused "gate 8"
  echo "  8 consistency-gate: REFUSED — Senior Product Technician opens the claim, inspects the unit and photographs directly, and records a written adjudication in the claim record"
  exit 1
}

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: replace this placeholder with the real condition, expressed in code.
#       Until you do, one sample unit is refused so you can see a refusal happen.
if [ "$UNIT" = "$FORCE_REFUSE_UNIT" ]; then refuse; fi
# -----------------------------------------------------------------------------

ledger "$UNIT" "consistency-gate" proceed "gate 8, placeholder condition"
echo "  8 consistency-gate: proceed"
