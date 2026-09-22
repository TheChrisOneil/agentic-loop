#!/usr/bin/env bash
# The whole workshop, driven end to end with a stub model: new job -> design -> revision ->
# acceptance -> a running loop. No network, no tokens, no interactive terminal.
set -uo pipefail
W="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$W/tests/fake-bin-good:$PATH"
# Its own acceptance register: the real one is append-only and must not carry test rows.
export ACCEPT_REGISTER="$(mktemp -t acceptances)"
JOB=_flowtest
rm -rf "$W/jobs/$JOB" "$W/$JOB"

fail() { echo "FAIL: $1"; rm -rf "$W/jobs/$JOB" "$W/$JOB"; rm -f "$ACCEPT_REGISTER"; exit 1; }

# 1. a new job, stopping at the decision
{ echo "$JOB"; echo "Test Owner, QA"; cat "$W/tests/fixtures/use-case.txt"; } \
  | "$W/start.sh" --new >/dev/null 2>&1
[ "$(cat "$W/jobs/$JOB/state" 2>/dev/null)" = designed ] || fail "state after intake is not 'designed'"
[ -f "$W/jobs/$JOB/BRIEF.md" ] || fail "no brief was written"
echo "PASS: a use case became a validated design and a brief"

# 2. a revision
{ echo "d"; echo "Cut the fan-out, it is too wide for one reviewer."; } \
  | "$W/start.sh" --job "$JOB" >/dev/null 2>&1
[ -f "$W/jobs/$JOB/proposed.v1.design" ] || fail "the previous version was not kept"
grep -q "fanout: 4" "$W/jobs/$JOB/proposed.design" || fail "the revision did not take effect"
echo "PASS: a revision kept the old version and changed the design"

# 3. a refused acceptance builds nothing
{ echo "a"; echo "sure"; } | "$W/start.sh" --job "$JOB" >/dev/null 2>&1
[ -d "$W/$JOB" ] && fail "a folder was built without acceptance"
echo "PASS: a refused acceptance built nothing"

# 4. acceptance, then the build
{ echo "a"; echo "I accept"; } | "$W/start.sh" --job "$JOB" >/dev/null 2>&1
[ "$(cat "$W/jobs/$JOB/state")" = built ] || fail "state is not 'built'"
[ -x "$W/$JOB/loop.sh" ] || fail "no loop was generated"
[ -f "$W/$JOB/design/ACCEPTANCE.md" ] || fail "the acceptance did not travel with the build"
TICK=$( cd "$W/$JOB" && make clean >/dev/null && ./loop.sh )   # captured, not piped: grep -q
case "$TICK" in *"worked 3"*) ;; *) fail "the generated loop does not tick" ;; esac
echo "PASS: accepted, built, and the generated loop ticks"

rm -rf "$W/jobs/$JOB" "$W/$JOB"; rm -f "$ACCEPT_REGISTER"
echo "PASS: cleaned up"
