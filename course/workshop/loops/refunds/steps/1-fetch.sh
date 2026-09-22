#!/usr/bin/env bash
# STEP 1 — fetch
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Pull refund requests over 500 dollars from the payments system
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "fetch" "$RESULT" "step 1, mechanical, not yet implemented"
step_say "1" "fetch" "mechanical" "$RESULT"
