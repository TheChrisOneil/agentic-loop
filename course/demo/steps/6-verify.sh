#!/usr/bin/env bash
# STEP TYPE: TEST  (runs the real check, and compares against the before-state)
#
# The judgment claimed an adjustment. This step recomputes that number from the raw files,
# independently, and refuses to agree unless the two match to the cent.
#
# THIS IS THE RULE "a thinking step may never write a mechanical step's output" IN FORCE.
# The model interprets. The arithmetic is never taken from it.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"
CALL=$(awk -F'\t' '$1=="call"{print $2}' "$JUDGMENTS/$UNIT.tsv")
CLAIMED=$(awk -F'\t' '$1=="adjustment"{print $2}' "$JUDGMENTS/$UNIT.tsv")

EXPECTED=$(awk -F'\t' -v u="$UNIT" -v call="$CALL" '
  FNR==1 { next }
  FILENAME ~ /purchase_orders/ && $1==u { po_qty[$3]=$4; po_price[$3]=$5; has[$3]=1; next }
  $3==u {
      sig = $4 SUBSEP $5 SUBSEP $6
      if (sig in seen && seen[sig] != $1) dup += $5*$6 ; else seen[sig]=$1
      if (!has[$4]) extra += $5*$6
      else if ($6+0 != po_price[$4]+0) price += ($6-po_price[$4])*$5
  }
  END {
      if (call=="duplicate")        printf "%.2f", -dup
      else if (call=="not_on_po")   printf "%.2f", -extra
      else if (call=="dispute" || call=="discount" || call=="typo") printf "%.2f", -price
      else                          printf "%.2f", 0
  }
' "$DATA/purchase_orders.tsv" "$DATA/invoices.tsv")

if awk -v a="$CLAIMED" -v b="$EXPECTED" 'BEGIN{d=a-b; if(d<0)d=-d; exit !(d<=0.01)}'; then
  : > "$MEM/.verified.$UNIT"
  ledger "$UNIT" verify pass "claimed $CLAIMED, recomputed $EXPECTED"
  echo "  verify: PASS $UNIT (claimed $CLAIMED, recomputed $EXPECTED)"
  exit 0
fi
rm -f "$MEM/.verified.$UNIT"
ledger "$UNIT" verify fail "claimed $CLAIMED, recomputed $EXPECTED"
echo "  verify: FAIL $UNIT — the judgment claimed $CLAIMED, the arithmetic says $EXPECTED"
exit 1
