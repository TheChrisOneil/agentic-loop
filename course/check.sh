#!/usr/bin/env bash
# THE REHEARSAL, AS A SCRIPT.
#
# Runs every step of REHEARSAL.md that can run unattended, compares what happened against what
# should have happened, and names the next action for anything that failed.
#
#   ./check.sh           everything that needs no API key and no network
#   ./check.sh --live    also runs one real generation, which spends tokens
#
# It leaves the tree exactly as it found it. Exit 0 means the session will run.
set -uo pipefail
cd "$(dirname "$0")"
LIVE=0; [ "${1:-}" = "--live" ] && LIVE=1
PASS=0; FAIL=0; WARN=0
FAILED_STEPS=""

green() { printf '\033[32m%s\033[0m' "$1"; }
red()   { printf '\033[31m%s\033[0m' "$1"; }
amber() { printf '\033[33m%s\033[0m' "$1"; }
rule()  { printf '%s\n' "──────────────────────────────────────────────────────────────────────"; }

pass() { PASS=$((PASS+1)); printf '  %s  %s\n' "$(green PASS)" "$1"; }
warn() { WARN=$((WARN+1)); printf '  %s  %s\n            %s\n' "$(amber WARN)" "$1" "$2"; }
fail() { FAIL=$((FAIL+1)); FAILED_STEPS="$FAILED_STEPS
  - $1"
         printf '  %s  %s\n' "$(red FAIL)" "$1"
         [ -n "${3:-}" ] && printf '            wanted: %s\n' "$3"
         [ -n "${4:-}" ] && printf '            got:    %s\n' "$4"
         printf '            next:   %s\n' "$2"; }

# expect <label> <expected substring> <next action> -- <command...>
expect() {
  local label="$1" want="$2" next="$3"; shift 4
  local out last; out=$("$@" 2>&1)
  case "$out" in
    *"$want"*) pass "$label" ;;
    *) # the last non-empty line is the summary the command meant to leave you with.
       # Grepping for error-ish words surfaces legitimate refusals as if they were faults.
       # Show the line that SHOULD have matched — the one carrying the first word we wanted.
       # Falling back to "the last line" shows a trailing hint and diagnoses nothing.
       last=$(printf '%s' "$out" | grep -F "${want%% *}" | tail -1 | sed 's/^[[:space:]]*//')
       [ -z "$last" ] && last=$(printf '%s' "$out" | grep -v '^[[:space:]]*$' | tail -1 | sed 's/^[[:space:]]*//')
       fail "$label" "$next" "$want" "$last" ;;
  esac
}

echo
rule; echo "  Rehearsal check — $(date +%F)"; rule

# ---------------------------------------------------------------- 0. the machine
echo; echo "THE MACHINE"
for t in bash awk sed make git; do
  command -v "$t" >/dev/null && pass "$t is installed" \
    || fail "$t is missing" "install it — nothing below will run without it"
done
if command -v shasum >/dev/null || command -v sha256sum >/dev/null; then
  pass "a SHA-256 tool is installed"
else
  fail "no shasum or sha256sum" "install one — it is what makes the proof tamper-evident"
fi
command -v column >/dev/null && pass "column is installed" \
  || warn "column is not installed" "the tables print unformatted; make ledger may say \"no ledger yet\" when there is one (KNOWN-ISSUES 1)"
command -v claude >/dev/null && pass "the claude CLI is installed (optional)" \
  || warn "the claude CLI is not installed" "everything below still runs; only a live generation needs it"

# ---------------------------------------------------------------- 1. the demo
echo; echo "THE DEMO — the loop you run in front of the room"
( cd demo && make clean >/dev/null 2>&1 )
expect "one night runs: 9 units, 4 proposed, 3 refused" \
  "worked 7   proposed 4   refused 3   failed 0" \
  "cd demo && make tick, and read the error. If the counts differ, data/ was edited: git checkout demo/data" \
  -- make -C demo tick

expect "the cost ledger records every call" "4 model calls" \
  "cd demo && make report" -- make -C demo report
expect "two units closed without a model" "2 closed by arithmetic alone" \
  "cd demo && make report" -- make -C demo report

expect "an edited proof blocks delivery" "the proof was edited after it was written" \
  "cd demo && make demo-tamper — this is the set piece of the session" -- make -C demo demo-tamper
expect "the daily sweep catches the tampered proof" "VIOLATED  every-proposal-carries-a-proof" \
  "cd demo && make demo-tamper" -- make -C demo demo-tamper

expect "a wrong number fails verification" "claimed -72.00, the arithmetic says -720.00" \
  "cd demo && make demo-badmath" -- make -C demo demo-badmath

expect "a tighter cap fires a gate that normally never fires" "above the single-approver cap" \
  "cd demo && make demo-cap" -- make -C demo demo-cap

expect "a budget of 3 defers the rest, on purpose" "3 worked tonight, 4 deferred" \
  "cd demo && make demo-narrow" -- make -C demo demo-narrow

# a person in the judgment seat, driven from a here-doc
( cd demo && make clean >/dev/null 2>&1 )
HUMAN=$(cd demo && printf 'dispute\n-720.00\nPO-1006 says 420.00 per seat and the invoice bills 480.00 with no signed amendment\nHold 720.00 and ask Vantage for a credit note\n' \
        | BUDGET=2 JUDGE_MODE=human ./loop.sh 2>&1)
case "$HUMAN" in
  *"verify: PASS PO-1006"*) pass "a person can sit in the judgment seat" ;;
  *) fail "human mode did not complete" "cd demo && BUDGET=2 JUDGE_MODE=human ./loop.sh, and answer the four prompts" ;;
esac
( cd demo && make clean >/dev/null 2>&1 )

# ---------------------------------------------------------------- 2. the workshop
echo; echo "THE WORKSHOP — the tool that builds a loop from a described process"
expect "the validator passes a good design" "21 passed, 0 failed" \
  "cd workshop && make example" -- make -C workshop example
expect "the validator fails a bad one" "10 passed, 14 failed" \
  "cd workshop && make broken" -- make -C workshop broken

RULES=$(make -C workshop rules 2>/dev/null | grep -c '^V')
[ "$RULES" -eq 21 ] && pass "all 21 rules are listed" \
  || fail "the rule list shows $RULES rules, expected 21" "cd workshop && make rules"

GATES=$(make -C workshop diagram DESIGN=examples/invoices.design 2>/dev/null | grep -c '^    alt ')
[ "$GATES" -eq 3 ] && pass "the diagram carries all 3 gates" \
  || fail "the diagram shows $GATES gates, expected 3" "cd workshop && make diagram DESIGN=examples/invoices.design"

SUITE=$(make -C workshop test 2>&1 | grep -cE '^PASS')
[ "$SUITE" -eq 11 ] && pass "the whole pipeline passes: 11 assertions" \
  || fail "the suite passed $SUITE assertions, expected 11" "cd workshop && make test, and read which one failed"

expect "the acceptance register verifies" "chain intact" \
  "cd workshop && make verify — a broken chain means a row was edited" -- make -C workshop verify

for d in workshop/loops/*/; do
  n=$(basename "$d")
  OUT=$(cd "$d" && make clean >/dev/null 2>&1; make tick 2>&1)
  case "$OUT" in
    *"worked 3   delivered 2   refused 1"*) pass "the $n loop ticks" ;;
    *) fail "the $n loop does not tick" "cd workshop/loops/$n && make clean && make tick" ;;
  esac
  ( cd "$d" && make clean >/dev/null 2>&1 )
done

# ---------------------------------------------------------------- 3. the materials
echo; echo "THE MATERIALS"
for f in deck.md facilitator-guide.md REHEARSAL.md exercise/worksheet.md exercise/helper-prompts.md exercise/discussion.md; do
  [ -s "$f" ] && pass "$f is present" || fail "$f is missing or empty" "restore it from git"
done

# ---------------------------------------------------------------- 4. optional live run
if [ "$LIVE" -eq 1 ]; then
  echo; echo "A LIVE GENERATION — this spends tokens"
  if ! command -v claude >/dev/null; then
    fail "the claude CLI is not installed" "install it, or drop --live"
  else
    cat > /tmp/check-usecase.txt <<'TXT'
We review supplier credit limit increase requests. About sixty a month arrive from the sales
team. Each asks to raise a customer's limit, and carries the customer's payment history and the
reason sales wants it. One credit analyst works the queue. Most are routine. The hard ones are
where the payment history is good but the requested increase is large relative to the
customer's size, which needs somebody who knows the sector. It takes about five days.
TXT
    ROWS_BEFORE=$(wc -l < workshop/memory/usage.tsv 2>/dev/null || echo 0)
    OUT=$(cd workshop && tooling/generate.sh --use-case /tmp/check-usecase.txt --name _check --by "Rehearsal" 2>&1)
    case "$OUT" in
      *"0 failed"*)
        pass "a described process became a validated design"
        # The call must leave a priced row. A generator that spends money and records nothing
        # is the hole this course admits to having.
        ROWS_AFTER=$(wc -l < workshop/memory/usage.tsv 2>/dev/null || echo 0)
        LAST=$(awk -F'\t' 'END{print $11"\t"$10}' workshop/memory/usage.tsv 2>/dev/null)
        SRC=${LAST%%	*}; USD=${LAST##*	}
        if [ "$ROWS_AFTER" -gt "$ROWS_BEFORE" ] && [ "$SRC" = cli ]; then
          pass "the call was costed: \$$USD, from the CLI"
        else
          fail "the generation recorded no priced row" \
               "cd workshop && make cost — the row should say source=cli" \
               "a new row in memory/usage.tsv with source=cli" \
               "rows ${ROWS_BEFORE}->${ROWS_AFTER}, source=${SRC:-none}"
        fi
        # Kept, not deleted. The design it produced is the interesting part of a live run,
        # and erasing it every time is why a failure here was hard to explain.
        printf '            kept at workshop/jobs/_check — proposed.design, BRIEF.md, job.tsv\n'
        rm -f /tmp/check-usecase.txt ;;
      *)
        # Keep the evidence. A failure message that points at a file the script just deleted
        # is worse than no message: it sends the reader somewhere that no longer exists.
        fail "the live generation did not produce a valid design" \
             "the job is kept at workshop/jobs/_check — read job.tsv, then .scratch/raw.txt for what the model actually returned" \
             "a design that passes the validator" \
             "$(printf '%s' "$OUT" | grep -v '^[[:space:]]*$' | tail -1 | sed 's/^[[:space:]]*//')"
        echo
        echo "            what the job recorded:"
        sed 's/^/              /' workshop/jobs/_check/job.tsv 2>/dev/null | tail -6
        if [ -s workshop/jobs/_check/.scratch/raw.err ]; then
          echo "            what the CLI said on stderr:"
          sed 's/^/              /' workshop/jobs/_check/.scratch/raw.err | head -5
        fi
        if [ -f workshop/jobs/_check/.scratch/raw.txt ]; then
          echo "            first line of the model reply:"
          printf '              %s\n' "$(head -1 workshop/jobs/_check/.scratch/raw.txt)"
        fi
        echo ;;
    esac
  fi
fi

# ---------------------------------------------------------------- the verdict
echo; rule
if [ "$FAIL" -eq 0 ]; then
  printf '  %s   %d checks passed, %d warning(s)\n' "$(green 'READY')" "$PASS" "$WARN"
  echo
  echo "  The session will run on this machine. Read REHEARSAL.md before the day anyway —"
  echo "  it tells you what to say, which this script cannot."
else
  printf '  %s  %d passed, %d failed, %d warning(s)\n' "$(red 'NOT READY')" "$PASS" "$FAIL" "$WARN"
  echo "  What failed:$FAILED_STEPS"
  echo
  echo "  Each failure above names the next action. Work through them in order —"
  echo "  the first one is often the cause of the rest."
fi
rule; echo
exit $([ "$FAIL" -eq 0 ] && echo 0 || echo 1)
