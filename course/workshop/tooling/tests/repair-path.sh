#!/usr/bin/env bash
# Does the generator feed the validator's findings back and try again?
# A stub model fails the first attempt on purpose, then passes.
set -uo pipefail
T="$(cd "$(dirname "$0")/.." && pwd)"   # tooling
W="$(cd "$T/.." && pwd)"                # the workshop
export USAGE_LEDGER="$(mktemp "${TMPDIR:-/tmp}/usage.XXXXXX")"
trap 'rm -f "$USAGE_LEDGER"' EXIT
rm -rf "$W/jobs/_repairtest"
PATH="$T/tests/fake-bin:$PATH" GENERATE_MODEL=stub-model \
  "$T/generate.sh" --use-case "$T/tests/fixtures/use-case.txt" --name _repairtest --by "Test" >/dev/null 2>&1
ST=$?
echo "--- job ledger ---"
column -t -s$'\t' "$W/jobs/_repairtest/job.tsv"
echo
grep -q "repairing" "$W/jobs/_repairtest/job.tsv" \
  && echo "PASS: the findings were fed back and a second attempt was made" \
  || { echo "FAIL: no repair attempt was recorded"; exit 1; }
grep -q "attempt 2 passed the validator" "$W/jobs/_repairtest/job.tsv" \
  && echo "PASS: the second attempt passed" || { echo "FAIL: second attempt did not pass"; exit 1; }
[ "$ST" -eq 0 ] && echo "PASS: generate exited 0" || { echo "FAIL: generate exited $ST"; exit 1; }
rm -rf "$W/jobs/_repairtest"
