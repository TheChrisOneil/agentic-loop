#!/usr/bin/env bash
# STEP 4 — order-and-cap
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Rank residual ambiguous claims by claim value then age and admit at most 60 to model assessment; the remainder go to the technician queue
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "order-and-cap" "$RESULT" "step 4, coordination, not yet implemented"
step_say "4" "order-and-cap" "coordination" "$RESULT"
