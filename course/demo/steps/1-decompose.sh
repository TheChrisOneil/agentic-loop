#!/usr/bin/env bash
# STEP TYPE: MECHANICAL  (a rule — same input, same output, zero tokens)
#
# Turns a pile of invoice lines and purchase-order lines into UNITS OF WORK.
#
# THE UNIT BOUNDARY IS (supplier, purchase order). That choice is domain knowledge, and it
# is the highest-leverage decision in this loop. Everything downstream inherits it.
#   one unit per invoice LINE  -> 11 units, several of them arguing about the same PO
#   one unit per SUPPLIER      -> 5 units, each an unreviewable lump
#   one unit per (supplier,PO) -> 9 units, each the smallest thing that gets ONE decision
#
# Two competent buyers, given these files and unable to confer, produce the same 9 units.
# That is the test that makes this a rule instead of a judgment.
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init

printf 'unit_id\tsupplier\tpo_id\tinv_lines\tinv_total\tpo_lines\tpo_total\texposure\n' > "$MEM/units.tsv"

awk -F'\t' -v OFS='\t' '
  FNR==1 { next }                                   # skip headers
  FILENAME ~ /purchase_orders/ {
      key = $2 SUBSEP $1
      po_total[key] += $4 * $5 ; po_lines[key]++
      supplier[key] = $2 ; po[key] = $1 ; seen[key] = 1 ; next
  }
  {
      pid = ($3 == "-" ? "NOPO" : $3)
      key = $2 SUBSEP pid
      inv_total[key] += $5 * $6 ; inv_lines[key]++
      supplier[key] = $2 ; po[key] = pid ; seen[key] = 1
  }
  END {
      for (k in seen) {
          exposure = inv_total[k] - po_total[k] ; if (exposure < 0) exposure = -exposure
          unit = (po[k] == "NOPO" ? "NOPO-" toupper(substr(supplier[k],1,4)) : po[k])
          printf "%s\t%s\t%s\t%d\t%.2f\t%d\t%.2f\t%.2f\n", \
                 unit, supplier[k], po[k], inv_lines[k]+0, inv_total[k]+0, \
                 po_lines[k]+0, po_total[k]+0, exposure
      }
  }
' "$DATA/purchase_orders.tsv" "$DATA/invoices.tsv" | sort >> "$MEM/units.tsv"

N=$(($(wc -l < "$MEM/units.tsv") - 1))
L=$(($(wc -l < "$DATA/invoices.tsv") - 1))
ledger "-" decompose ok "$L invoice lines and $(($(wc -l < "$DATA/purchase_orders.tsv") - 1)) purchase-order lines became $N units"
echo "decompose: $L invoice lines -> $N units of work"
