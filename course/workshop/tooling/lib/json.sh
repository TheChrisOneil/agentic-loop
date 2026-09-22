#!/usr/bin/env bash
# Reading one value out of the CLI's JSON. Three tiers, and the tier is recorded — a ledger
# that cannot say how it knew a number is not much better than one with no number in it.
json_tier() {
  if   command -v python3 >/dev/null 2>&1; then echo python3
  elif command -v jq      >/dev/null 2>&1; then echo jq
  else echo none; fi
}
json_get() { # <file> <dotted.path>   -> the value, or empty
  local f="$1" p="$2"
  case "$(json_tier)" in
    python3) python3 -c '
import json,sys
try: d=json.load(open(sys.argv[1]))
except Exception: sys.exit(0)
for k in sys.argv[2].split("."):
    d = d.get(k) if isinstance(d, dict) else None
    if d is None: sys.exit(0)
print(d)' "$f" "$p" ;;
    jq) jq -r --arg p "$p" 'getpath($p|split("."))//empty' "$f" 2>/dev/null ;;
    *)  : ;;   # no parser: the caller records "unknown", never 0
  esac
}
