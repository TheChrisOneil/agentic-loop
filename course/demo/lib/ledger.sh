#!/usr/bin/env bash
# The append-only ledger. One line per state transition, written by code only.
# You are not storing where the work IS. You are storing how it got there.
ledger() { # ledger <unit> <step> <status> <detail>
  printf '%s\t%s\t%s\t%s\t%s\n' "$(date +%FT%T)" "$1" "$2" "$3" "${4:-}" >> "$MEM/ledger.tsv"
}
ledger_init() {
  [ -f "$MEM/ledger.tsv" ] || printf 'timestamp\tunit\tstep\tstatus\tdetail\n' > "$MEM/ledger.tsv"
}
