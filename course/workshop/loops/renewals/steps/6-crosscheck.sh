#!/usr/bin/env bash
# STEP 6 — crosscheck
# TYPE:  test   (runs the real check, against the before-state)
# ACTOR: code
# SCOPE: unit
#
# From the design:
#   Confirm every changed clause appears in exactly one unit and none was dropped
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "crosscheck" "$RESULT" "step 6, test, not yet implemented"
echo "  6 crosscheck: $RESULT"
