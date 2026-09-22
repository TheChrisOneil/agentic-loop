#!/usr/bin/env bash
# STEP 1 — decompose
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Group invoice lines and purchase order lines into units by supplier and order
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "decompose" "$RESULT" "step 1, mechanical, not yet implemented"
step_say "1" "decompose" "mechanical" "$RESULT"
