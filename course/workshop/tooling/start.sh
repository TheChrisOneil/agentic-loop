#!/usr/bin/env bash
# THE WORKSHOP. One entry point.
#
#   ./start.sh            resume the job in progress, or begin a new one
#   ./start.sh --new      begin a new one regardless
#   ./start.sh --job X    resume a named job
#   ./start.sh --list     every job and where it stopped
#
# States: intake -> designed -> discussing -> accepted -> built
# Every transition is appended to jobs/<slug>/job.tsv. A job resumes exactly where it stopped.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"          # the tooling
ROOT="$(cd "$HERE/.." && pwd)"                 # the workshop: jobs, loops, memory, examples
JOBS="$ROOT/jobs"
REVISION_CAP="${REVISION_CAP:-3}"
mkdir -p "$JOBS"

state_of() { [ -f "$JOBS/$1/state" ] && cat "$JOBS/$1/state" || echo "unknown"; }
set_state() {
  printf '%s\n' "$2" > "$JOBS/$1/state"
  printf '%s\t%s\t%s\t%s\n' "$(date +%FT%T)" state "$2" "${3:-}" >> "$JOBS/$1/job.tsv"
}
open_jobs() { for d in "$JOBS"/*/; do [ -d "$d" ] || continue
    s=$(state_of "$(basename "$d")"); case "$s" in built|abandoned) ;; *) basename "$d" ;; esac; done; }
rule() { printf '%s\n' "────────────────────────────────────────────────────────────────────────────"; }

list_jobs() {
  printf '%-22s %-12s %s\n' JOB STATE "USE CASE"
  for d in "$JOBS"/*/; do [ -d "$d" ] || continue
    j=$(basename "$d")
    printf '%-22s %-12s %s\n' "$j" "$(state_of "$j")" "$(head -c 60 "$d/use-case.txt" 2>/dev/null | tr '\n' ' ')"
  done
}

# ---------------------------------------------------------------- new job
begin_new() {
  rule; echo "  A new job."; rule; echo
  read -r -p "  Short name for it (letters, digits, dashes): " SLUG
  case "$SLUG" in ""|*[!a-zA-Z0-9_-]*) echo "  That is not a usable name. Nothing was started."; exit 64 ;; esac
  [ -d "$JOBS/$SLUG" ] && { echo "  A job called $SLUG already exists. Resume it with --job $SLUG."; exit 1; }
  read -r -p "  Your name and role, for the record: " BY
  [ -n "$BY" ] || { echo "  A job needs an owner. Nothing was started."; exit 64; }

  mkdir -p "$JOBS/$SLUG"
  printf 'timestamp\tstage\tstatus\tdetail\n' > "$JOBS/$SLUG/job.tsv"
  printf '%s\n' "$BY" > "$JOBS/$SLUG/owner"
  set_state "$SLUG" intake "owner $BY"

  echo
  rule
  echo "  1. WHAT IS YOUR USE CASE?"
  rule
  cat <<'TXT'

  Describe the business process in your own words. What would help most:

    - what the work actually is, and roughly how much of it there is
    - who does it today, and what the exceptions look like
    - what goes wrong, and what it costs when it does
    - anything a person has to judge rather than look up

  There is no format. Write it as you would explain it to a new colleague.
  Finish with Ctrl-D on a blank line.

TXT
  cat > "$JOBS/$SLUG/use-case.txt"
  echo
  echo "  Got it. Working out a design."
  echo
  run_generate "$SLUG" ""
  present "$SLUG"
}

# ---------------------------------------------------------------- generate
run_generate() { # slug notes-file
  local slug="$1" notes="${2:-}" args
  mkdir -p "$JOBS/$slug/.scratch"
  args=(--name "$slug" --use-case "$JOBS/$slug/use-case.txt" --by "$(cat "$JOBS/$slug/owner")")
  [ -n "$notes" ] && args+=(--notes "$notes")
  if [ -n "${RECORDED:-}" ]; then args=(--name "$slug" --recorded "$RECORDED" --by "$(cat "$JOBS/$slug/owner")"); fi
  if ! "$HERE/generate.sh" "${args[@]}" >/dev/null 2>"$JOBS/$slug/.scratch/generate.err"; then
    echo
    echo "  The design could not be produced. What the validator said:"
    echo
    sed 's/^/    /' "$JOBS/$slug/.scratch/generate.err" | head -20
    echo
    echo "  The job is kept. Next human action: describe the process again with the missing"
    echo "  detail, or repair jobs/$slug/proposed.design by hand and run ./start.sh --job $slug."
    set_state "$slug" intake "generation refused"
    exit 1
  fi
  set_state "$slug" designed "validated"
}

# ---------------------------------------------------------------- present
present() { # slug
  local slug="$1"
  echo
  rule; echo "  2. HERE IS THE DESIGN I AM RECOMMENDING"; rule
  echo
  echo "  It rests on assumptions I made to fill the gaps in your description. They are listed"
  echo "  first, on purpose. Every one of them is a question for you."
  echo
  sed 's/^/  /' "$JOBS/$slug/BRIEF.md" | sed -n '1,/^  ## The steps/p'
  echo
  echo "  ... the full brief, the step table, the gates and the sequence diagram are in:"
  echo
  echo "      jobs/$slug/BRIEF.md"
  echo
  decide "$slug"
}

# ---------------------------------------------------------------- the decision
decide() { # slug
  local slug="$1" rev
  rev=$(ls "$JOBS/$slug"/proposed.v*.design 2>/dev/null | wc -l | tr -d ' ')
  echo
  rule; echo "  3. LET'S DISCUSS IT"; rule
  cat <<TXT

  Nothing has been built and nothing has been decided.

    [d]  discuss — tell me what should change, and I will revise it
                   ($rev of $REVISION_CAP revisions used)
    [a]  accept  — you type "I accept" and your name goes on the design
    [s]  stop    — leave it here. The job resumes exactly where you left it

TXT
  read -r -p "  d, a or s: " CHOICE
  case "$(printf '%s' "$CHOICE" | tr '[:upper:]' '[:lower:]')" in
    d) discuss "$slug" ;;
    a) accept_it "$slug" ;;
    s) set_state "$slug" designed "stopped by the owner"
       echo; echo "  Stopped. Resume with:  ./start.sh --job $slug" ;;
    *) echo; echo "  Not a choice. Nothing changed. Resume with:  ./start.sh --job $slug" ;;
  esac
}

# ---------------------------------------------------------------- discuss
discuss() { # slug
  local slug="$1" rev notes
  rev=$(ls "$JOBS/$slug"/proposed.v*.design 2>/dev/null | wc -l | tr -d ' ')
  if [ "$rev" -ge "$REVISION_CAP" ]; then
    echo
    echo "  $REVISION_CAP revisions is the budget, and it is spent."
    echo "  Next human action: accept the design as it stands, or edit"
    echo "  jobs/$slug/proposed.design by hand and re-run ./validate.sh on it."
    decide "$slug"; return
  fi
  set_state "$slug" discussing "revision $((rev+1))"
  echo
  echo "  What should change? Be specific — a boundary, a gate, a number, an assumption you"
  echo "  disagree with. Finish with Ctrl-D."
  echo
  notes="$JOBS/$slug/notes.txt"
  { echo "### Revision $((rev+1)) — requested $(date +%FT%T)"; cat; echo; } >> "$notes"
  cp "$JOBS/$slug/proposed.design" "$JOBS/$slug/proposed.v$((rev+1)).design"
  echo
  echo "  Revising."
  run_generate "$slug" "$notes"
  echo
  echo "  What changed between the version you read and this one:"
  echo
  diff -u "$JOBS/$slug/proposed.v$((rev+1)).design" "$JOBS/$slug/proposed.design" \
    | sed -n '4,40p' | sed 's/^/    /' || true
  present "$slug"
}

# ---------------------------------------------------------------- accept + build
accept_it() { # slug
  local slug="$1"
  echo
  if ! "$HERE/accept.sh" "$JOBS/$slug/proposed.design" --by "$(cat "$JOBS/$slug/owner")"; then
    echo
    echo "  Not accepted. Nothing was built. The job is kept as it was."
    decide "$slug"; return
  fi
  set_state "$slug" accepted "$(cat "$JOBS/$slug/owner")"
  echo
  rule; echo "  4. BUILDING IT"; rule; echo
  mkdir -p "$ROOT/loops"
  if ! "$HERE/scaffold.sh" --force "$JOBS/$slug/proposed.design" "$ROOT/loops/$slug"; then
    set_state "$slug" accepted "scaffold refused"; exit 1
  fi
  set_state "$slug" built "loops/$slug/"
  echo
  ( cd "$ROOT/loops/$slug" && make tick ) || true
  echo
  rule; echo "  DONE"; rule
  cat <<TXT

  Your loop is in  loops/$slug/  and it runs today, with every step a placeholder.

    cd loops/$slug
    make todo     what is left to implement
    make ledger   what happened
    make tick     run it again

  The design it was built from, the brief, and who accepted it travel with it in
  loops/$slug/design/. Change the design and the acceptance stops covering it.

TXT
}

# ---------------------------------------------------------------- resume
resume() { # slug
  local slug="$1" st
  st=$(state_of "$slug")
  echo
  rule; echo "  Resuming $slug — last state: $st"; rule
  case "$st" in
    intake)     echo; echo "  This job has a description but no design yet."; echo
                run_generate "$slug" ""; present "$slug" ;;
    designed|discussing) present "$slug" ;;
    accepted)   echo; echo "  Accepted but not built."; accept_it "$slug" ;;
    built)      echo; echo "  Already built. The loop is in loops/$slug/."; echo ;;
    *)          echo; echo "  This job is in an unknown state. Its file is jobs/$slug/state." ;;
  esac
}

# ---------------------------------------------------------------- entry
case "${1:-}" in
  --list) list_jobs; exit 0 ;;
  --new)  begin_new; exit 0 ;;
  --job)  SLUG="${2:?--job needs a name}"; [ -d "$JOBS/$SLUG" ] || { echo "no job called $SLUG"; exit 2; }
          resume "$SLUG"; exit 0 ;;
esac

OPEN=$(open_jobs)
COUNT=$(printf '%s\n' "$OPEN" | grep -c . || true)
if [ "$COUNT" -eq 0 ]; then
  echo; echo "  No job in progress."
  begin_new
elif [ "$COUNT" -eq 1 ]; then
  resume "$OPEN"
else
  echo; echo "  More than one job is in progress:"; echo
  for j in $OPEN; do printf '    %-22s %s\n' "$j" "$(state_of "$j")"; done
  echo
  read -r -p "  Which one (or 'new'): " PICK
  [ "$PICK" = new ] && begin_new || { [ -d "$JOBS/$PICK" ] && resume "$PICK" || echo "  no job called $PICK"; }
fi
