#!/usr/bin/env bash
# When the repair budget runs out, does it refuse — and does the refusal name the findings
# and the next human action, rather than shipping an unvalidated design?
set -uo pipefail
T="$(cd "$(dirname "$0")/.." && pwd)"   # tooling
W="$(cd "$T/.." && pwd)"                # the workshop
export USAGE_LEDGER="$(mktemp "${TMPDIR:-/tmp}/usage.XXXXXX")"
trap 'rm -f "$USAGE_LEDGER"' EXIT
rm -rf "$W/jobs/_budgettest"
OUT=$(PATH="$T/tests/fake-bin-always-bad:$PATH" GENERATE_MODEL=stub-model \
  "$T/generate.sh" --use-case "$T/tests/fixtures/use-case.txt" --name _budgettest --by "Test" 2>&1)
ST=$?
echo "$OUT" | head -12
echo
[ "$ST" -ne 0 ] && echo "PASS: refused, exit $ST" || { echo "FAIL: exited 0 on an invalid design"; exit 1; }
echo "$OUT" | grep -q "V3" && echo "PASS: the findings were shown" || { echo "FAIL: findings not shown"; exit 1; }
[ -f "$W/jobs/_budgettest/BRIEF.md" ] && { echo "FAIL: a brief was written from an invalid design"; exit 1; } \
  || echo "PASS: no brief was written"
rm -rf "$W/jobs/_budgettest"
