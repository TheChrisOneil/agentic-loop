#!/usr/bin/env bash
# STEP 3 — select
# TYPE:  coordination   (binds, routes, records — it decides nothing)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Choose what is worked tonight, worst first, under a budget
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "select" "$RESULT" "step 3, coordination, not yet implemented"
step_say "3" "select" "coordination" "$RESULT"
