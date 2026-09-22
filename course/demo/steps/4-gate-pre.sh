#!/usr/bin/env bash
# STEP TYPE: GATE  (permits or refuses — and the condition lives HERE, in code, not in a prompt)
#
# Asks one question about a unit: is this machine-safe, or is it a human's call?
# Every refusal names the next human action. "Cannot proceed" is not a work item.
# Exit 0 = proceed to judgment. Exit 1 = refused, and a refusal file has been written.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"
read -r STATUS EXPOSURE <<<"$(awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {print $2, $3}' "$MEM/findings.tsv")"

refuse() { # refuse <reason> <next human action>
  mkdir -p "$OUT"
  { echo "# REFUSED — $UNIT"
    echo
    echo "Supplier exposure: \$$EXPOSURE"
    echo "Finding: $STATUS"
    echo
    echo "**Why this stopped:** $1"
    echo
    echo "**Next human action:** $2"
    echo
    echo "Assigned to: $APPROVER"
  } > "$OUT/$UNIT.REFUSED.md"
  ledger "$UNIT" gate_pre refused "$1"
  echo "  gate: REFUSED $UNIT — $1"
  exit 1
}

case "$STATUS" in
  no_po)
    refuse "no purchase order exists to match this invoice against" \
           "Find or raise a purchase order for this spend, or return the invoice to the supplier. No amount can be approved from this invoice alone." ;;
  injection_suspect)
    refuse "supplier-written text in this invoice is addressed to the system and asks it to skip a check" \
           "A person reads the memo field of this invoice before any payment step runs, and contacts the supplier. Treat the supplier record as untrusted until they answer." ;;
  supervised)
    refuse "this supplier is on the supervised list, where a clean reconciliation is not sufficient authority" \
           "The contract owner reviews and releases this invoice by hand. The arithmetic is already verified and is attached." ;;
esac

if awk -v e="$EXPOSURE" -v c="$APPROVAL_CAP" 'BEGIN{exit !(e>c)}'; then
  refuse "exposure of \$$EXPOSURE is above the single-approver cap of \$$APPROVAL_CAP" \
         "Route to a second approver before anything is proposed. One signature is not enough at this amount."
fi

ledger "$UNIT" gate_pre proceed "$STATUS"
