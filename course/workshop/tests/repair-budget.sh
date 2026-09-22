#!/usr/bin/env bash
# When the repair budget runs out, does it refuse — and does the refusal name the findings
# and the next human action, rather than shipping an unvalidated design?
set -uo pipefail
W="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$W/jobs/_budgettest"
OUT=$(PATH="$W/tests/fake-bin-always-bad:$PATH" GENERATE_MODEL=stub-model \
  "$W/generate.sh" --use-case "$W/tests/fixtures/use-case.txt" --name _budgettest --by "Test" 2>&1)
ST=$?
echo "$OUT" | head -12
echo
[ "$ST" -ne 0 ] && echo "PASS: refused, exit $ST" || { echo "FAIL: exited 0 on an invalid design"; exit 1; }
echo "$OUT" | grep -q "V3" && echo "PASS: the findings were shown" || { echo "FAIL: findings not shown"; exit 1; }
[ -f "$W/jobs/_budgettest/BRIEF.md" ] && { echo "FAIL: a brief was written from an invalid design"; exit 1; } \
  || echo "PASS: no brief was written"
rm -rf "$W/jobs/_budgettest"
