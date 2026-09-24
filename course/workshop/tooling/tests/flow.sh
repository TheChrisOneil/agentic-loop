#!/usr/bin/env bash
# The whole workshop, driven end to end with a stub model: new job -> design -> revision ->
# acceptance -> a running loop. No network, no tokens, no interactive terminal.
set -uo pipefail
T="$(cd "$(dirname "$0")/.." && pwd)"   # tooling
W="$(cd "$T/.." && pwd)"                # the workshop
export PATH="$T/tests/fake-bin-good:$PATH"
# Its own acceptance register: the real one is append-only and must not carry test rows.
# An explicit XXXXXX template: GNU mktemp rejects "-t name", and an empty path would fall back
# to the real register.
export ACCEPT_REGISTER="$(mktemp "${TMPDIR:-/tmp}/acceptances.XXXXXX")"
[ -n "$ACCEPT_REGISTER" ] || { echo "FAIL: mktemp gave no acceptances file; refusing to touch the real one"; exit 1; }
export USAGE_LEDGER="$(mktemp "${TMPDIR:-/tmp}/usage.XXXXXX")"
[ -n "$USAGE_LEDGER" ] || { echo "FAIL: mktemp gave no usage file; refusing to touch the real one"; exit 1; }
JOB=_flowtest
rm -rf "$W/jobs/$JOB" "$W/loops/$JOB"

fail() { echo "FAIL: $1"; rm -rf "$W/jobs/$JOB" "$W/loops/$JOB"; rm -f "$ACCEPT_REGISTER" "$USAGE_LEDGER"; exit 1; }

# 1. a new job, stopping at the decision
{ echo "$JOB"; echo "Test Owner, QA"; cat "$T/tests/fixtures/use-case.txt"; } \
  | "$T/start.sh" --new >/dev/null 2>&1
[ "$(cat "$W/jobs/$JOB/state" 2>/dev/null)" = designed ] || fail "state after intake is not 'designed'"
[ -f "$W/jobs/$JOB/BRIEF.md" ] || fail "no brief was written"
echo "PASS: a use case became a validated design and a brief"

# 2. a revision
{ echo "d"; echo "Cut the fan-out, it is too wide for one reviewer."; } \
  | "$T/start.sh" --job "$JOB" >/dev/null 2>&1
[ -f "$W/jobs/$JOB/proposed.v1.design" ] || fail "the previous version was not kept"
grep -q "fanout: 4" "$W/jobs/$JOB/proposed.design" || fail "the revision did not take effect"
echo "PASS: a revision kept the old version and changed the design"

# 3. a refused acceptance builds nothing
{ echo "a"; echo "sure"; } | "$T/start.sh" --job "$JOB" >/dev/null 2>&1
[ -d "$W/loops/$JOB" ] && fail "a folder was built without acceptance"
echo "PASS: a refused acceptance built nothing"

# 4. acceptance, then the build
{ echo "a"; echo "I accept"; } | "$T/start.sh" --job "$JOB" >/dev/null 2>&1
[ "$(cat "$W/jobs/$JOB/state")" = built ] || fail "state is not 'built'"
[ -x "$W/loops/$JOB/loop.sh" ] || fail "no loop was generated"
[ -f "$W/loops/$JOB/design/ACCEPTANCE.md" ] || fail "the acceptance did not travel with the build"
TICK=$( cd "$W/loops/$JOB" && make clean >/dev/null && ./loop.sh )   # captured, not piped: grep -q
case "$TICK" in *"worked 3"*) ;; *) fail "the generated loop does not tick" ;; esac
echo "PASS: accepted, built, and the generated loop ticks"

rm -rf "$W/jobs/$JOB" "$W/loops/$JOB"; rm -f "$ACCEPT_REGISTER" "$USAGE_LEDGER"
echo "PASS: cleaned up"
