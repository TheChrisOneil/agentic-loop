#!/usr/bin/env bash
# STEP 2 — enrich
# TYPE:  mechanical   (a rule: same input, same output, zero tokens)
# ACTOR: code
# SCOPE: batch
#
# From the design:
#   Attach order history, prior refunds and the stated reason code to each request
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="${1:--}"

# ------------------------------------------------------------------ YOUR LOGIC
# TODO: implement this step. It passes through until you do.
RESULT="placeholder"
# -----------------------------------------------------------------------------

ledger "$UNIT" "enrich" "$RESULT" "step 2, mechanical, not yet implemented"
step_say "2" "enrich" "mechanical" "$RESULT"
