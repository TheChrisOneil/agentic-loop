#!/usr/bin/env bash
# STEP TYPE: GATE  (is the proof good enough to proceed?)
#
# Four conditions, all of them checkable. A judgment that cannot answer them is not usable,
# however confident it sounds.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"; J="$JUDGMENTS/$UNIT.tsv"
fail() { ledger "$UNIT" gate_post refused "$1"; echo "  gate: REFUSED $UNIT — $1"; exit 1; }

CALL=$(awk -F'\t' '$1=="call"{print $2}' "$J")
EV=$(awk -F'\t' '$1=="evidence"{print $2}' "$J")
NA=$(awk -F'\t' '$1=="next_action"{print $2}' "$J")

case "$CALL" in dispute|discount|duplicate|partial|not_on_po|typo) ;; *) fail "'$CALL' is not a permitted call" ;; esac
[ ${#EV} -ge 20 ] || fail "the judgment cites no usable evidence"
[ ${#NA} -ge 20 ] || fail "the judgment names no next human action"
[ -f "$MEM/.verified.$UNIT" ] || fail "the arithmetic was never independently recomputed"

ledger "$UNIT" gate_post proceed "$CALL"
