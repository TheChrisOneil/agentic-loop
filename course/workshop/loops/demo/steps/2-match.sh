#!/usr/bin/env bash
# STEP 2 — match
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Reconcile each unit by arithmetic and screen memo text for instructions
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "match" "$RESULT" "step 2, mechanical, not yet implemented"
step_say "2" "match" "mechanical" "$RESULT"
