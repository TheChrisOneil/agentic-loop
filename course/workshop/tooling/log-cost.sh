#!/usr/bin/env bash
# THE COST LEDGER. One row per model call, against the job that caused it.
#
#   log-cost.sh <job> <stage> <model> <cli-json-file>
#
# Records what the CLI reported, including the two numbers people forget:
#   thinking tokens  — hidden reasoning, billed as output
#   cache reads      — cached input costs a fraction of fresh input
#
# When a number cannot be read it is written "unknown", never 0. A zero you did not measure
# is the same lie as "the base branch is fine" when nothing checked the base branch.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
. "$HERE/lib/json.sh"

JOB="${1:?usage: log-cost.sh <job> <stage> <model> <json file>}"
STAGE="${2:?}"; MODEL="${3:?}"; JSON="${4:-}"
# Overridable so the tests do not write into the real ledger. Unlike the acceptance
# register this is a cost record, not an audit record: test rows are noise, not history.
U="${USAGE_LEDGER:-$ROOT/memory/usage.tsv}"
[ -s "$U" ] || printf 'date\tjob\tstage\tmodel\tin\tout\tthinking\tcache_read\tcache_write\tusd\tsource\n' > "$U"

g() { local v; v=$(json_get "$JSON" "$1" 2>/dev/null); [ -n "$v" ] && printf '%s' "$v" || printf 'unknown'; }

if [ -s "$JSON" ] && [ "$(json_tier)" != none ]; then
  IN=$(g usage.input_tokens);  OUT=$(g usage.output_tokens)
  THINK=$(g usage.output_tokens_details.thinking_tokens)
  CR=$(g usage.cache_read_input_tokens); CW=$(g usage.cache_creation_input_tokens)
  USD=$(g total_cost_usd)
  # "cli" only when the CLI actually gave us numbers. Saying cli over a row of unknowns
  # would name a source that reported nothing.
  if [ "$IN" = unknown ] && [ "$OUT" = unknown ] && [ "$USD" = unknown ]; then
    SRC="no-usage-returned"
  else
    SRC="cli"
  fi
else
  IN=unknown; OUT=unknown; THINK=unknown; CR=unknown; CW=unknown; USD=unknown
  SRC=$([ "$(json_tier)" = none ] && echo "no-json-parser" || echo "no-usage-returned")
fi

printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$(date +%F)" "$JOB" "$STAGE" "$MODEL" "$IN" "$OUT" "$THINK" "$CR" "$CW" "$USD" "$SRC" >> "$U"
