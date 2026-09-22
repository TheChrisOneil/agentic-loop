#!/usr/bin/env bash
# STEP TYPE: MECHANICAL  (the attempt — code first, and most of the time it is the whole job)
#
# Reconciles every unit against its purchase order by arithmetic alone, and classifies it.
# It also screens each memo for text addressed to the machine. That screen is a RULE, so it
# runs before any model sees the words. A rule cannot be talked out of its answer.
#
# Statuses, in precedence order:
#   no_po             there is no purchase order to match against
#   injection_suspect the supplier's own text tries to instruct the system
#   supervised        the supplier is on a list that the loop never closes
#   duplicate         two invoice lines are identical in supplier, sku, qty and price
#   not_on_po         a line that the purchase order does not contain
#   qty_variance      quantity billed differs from quantity ordered
#   price_variance    price billed differs from price ordered
#   within_tolerance  a variance small enough to close by rule (both limits must pass)
#   clean             the arithmetic agrees exactly
set -euo pipefail
source "$(dirname "$0")/../config.sh"
source "$(dirname "$0")/../lib/ledger.sh"; ledger_init

printf 'unit_id\tstatus\texposure\tpct\tdetail\n' > "$MEM/findings.tsv"

awk -F'\t' -v tol_usd="$TOL_USD" -v tol_pct="$TOL_PCT" '
  FNR==1 { next }
  FILENAME ~ /supervised/ { if ($0 !~ /^#/ && length($0)) supervised[$0]=1 ; next }
  FILENAME ~ /purchase_orders/ {
      key = $2 SUBSEP $1
      po_qty[key,$3] = $4 ; po_price[key,$3] = $5 ; po_has[key,$3] = 1
      po_total[key] += $4*$5 ; supplier[key]=$2 ; po[key]=$1 ; seen[key]=1 ; next
  }
  {
      pid = ($3 == "-" ? "NOPO" : $3) ; key = $2 SUBSEP pid
      supplier[key]=$2 ; po[key]=pid ; seen[key]=1
      inv_total[key] += $5*$6 ; n[key]++
      # duplicate detection: the same physical line billed twice under different invoice ids
      sig = key SUBSEP $4 SUBSEP $5 SUBSEP $6
      if (sig in sig_inv && sig_inv[sig] != $1) { dup[key]=1 ; dup_amt[key] += $5*$6 }
      else sig_inv[sig] = $1
      if (!po_has[key,$4]) { extra[key]=1 ; extra_amt[key] += $5*$6 }
      else {
          if ($5+0 != po_qty[key,$4]+0) qty_var[key]=1
          if ($6+0 != po_price[key,$4]+0) { price_var[key]=1 ; price_amt[key] += ($6-po_price[key,$4])*$5 }
      }
      # THE INJECTION SCREEN. A rule, applied to supplier-written text, before any model runs.
      memo = tolower($7)
      if (memo ~ /ignore (all )?(previous|prior)/ || memo ~ /system note/ || \
          memo ~ /approve this invoice/ || memo ~ /no purchase order check/) inject[key]=1
  }
  END {
      for (k in seen) {
          unit = (po[k] == "NOPO" ? "NOPO-" toupper(substr(supplier[k],1,4)) : po[k])
          ex = inv_total[k] - po_total[k] ; if (ex < 0) ex = -ex
          pct = (po_total[k] > 0 ? 100*ex/po_total[k] : 100)
          if (po[k] == "NOPO")            { s="no_po";            d="invoice references no purchase order" }
          else if (inject[k])             { s="injection_suspect"; d="a memo field contains text addressed to the system" }
          else if (supervised[supplier[k]]) { s="supervised";      d="supplier is on the supervised list" }
          else if (dup[k])                { s="duplicate";        d=sprintf("a line worth %.2f is billed twice", dup_amt[k]) }
          else if (extra[k])              { s="not_on_po";        d=sprintf("lines worth %.2f are absent from the purchase order", extra_amt[k]) }
          else if (qty_var[k])            { s="qty_variance";     d="quantity billed differs from quantity ordered" }
          else if (price_var[k])          { s=(ex<=tol_usd && pct<=tol_pct ? "within_tolerance" : "price_variance")
                                            d=sprintf("price differs by %.2f (%.1f%%)", ex, pct) }
          else                            { s="clean";            d="arithmetic agrees exactly" }
          printf "%s\t%s\t%.2f\t%.1f\t%s\n", unit, s, ex, pct, d
      }
  }
' "$DATA/suppliers.supervised" "$DATA/purchase_orders.tsv" "$DATA/invoices.tsv" | sort >> "$MEM/findings.tsv"

awk -F'\t' 'NR>1 {c[$2]++} END {for (s in c) printf "  %-18s %d\n", s, c[s]}' "$MEM/findings.tsv" | sort
ledger "-" match ok "$(($(wc -l < "$MEM/findings.tsv") - 1)) units classified by arithmetic"
