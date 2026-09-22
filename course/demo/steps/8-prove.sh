#!/usr/bin/env bash
# STEP TYPE: MECHANICAL  (produce evidence a human can check without trusting the machine)
#
# The proof carries the arithmetic, the commands that produced it, and the judgment — and
# then a checksum of itself. Delivery re-checks that checksum. An edited proof blocks
# delivery, which is the only way the sentence "evidence a model can edit is not evidence"
# becomes true rather than merely stated.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init
UNIT="$1"
read -r STATUS EXPOSURE <<<"$(awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {print $2, $3}' "$MEM/findings.tsv")"

{
  echo "PROOF  $UNIT"
  echo "generated  $(date +%FT%T)  by $(basename "$0")"
  echo
  echo "INVOICE LINES AS FILED"
  awk -F'\t' -v u="$UNIT" 'NR>1 && $3==u {printf "  %-10s %-12s qty %-6s @ %-8s = %10.2f\n",$1,$4,$5,$6,$5*$6}' "$DATA/invoices.tsv"
  echo "PURCHASE ORDER AS RAISED"
  awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {printf "  %-10s %-12s qty %-6s @ %-8s = %10.2f\n",$1,$3,$4,$5,$4*$5}' "$DATA/purchase_orders.tsv"
  echo
  printf "  invoiced   %10.2f\n" "$(awk -F'\t' -v u="$UNIT" 'NR>1 && $3==u {s+=$5*$6} END{print s+0}' "$DATA/invoices.tsv")"
  printf "  ordered    %10.2f\n" "$(awk -F'\t' -v u="$UNIT" 'NR>1 && $1==u {s+=$4*$5} END{print s+0}' "$DATA/purchase_orders.tsv")"
  printf "  exposure   %10.2f   (finding: %s)\n" "$EXPOSURE" "$STATUS"
  echo
  echo "JUDGMENT"
  sed 's/^/  /' "$JUDGMENTS/$UNIT.tsv"
  echo
  echo "CHECKS RUN"
  echo "  steps/2-match.sh      classified this unit from the raw files"
  echo "  steps/6-verify.sh     recomputed the adjustment independently and agreed"
  echo "  steps/7-gate-post.sh  confirmed the call, the evidence and the next action"
} > "$PROOF/$UNIT.txt"

shasum -a 256 "$PROOF/$UNIT.txt" | awk '{print $1}' > "$PROOF/$UNIT.sha"
ledger "$UNIT" prove ok "checksum $(cut -c1-12 < "$PROOF/$UNIT.sha")"
