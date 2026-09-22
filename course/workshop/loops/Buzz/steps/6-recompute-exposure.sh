#!/usr/bin/env bash
# STEP 6 — recompute-exposure
# TYPE:  test   (runs the real check, against the before-state)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Recompute increase ratio, exposure against revenue and worst days beyond terms from source data
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "recompute-exposure" "$RESULT" "step 6, test, not yet implemented"
step_say "6" "recompute-exposure" "test" "$RESULT"
