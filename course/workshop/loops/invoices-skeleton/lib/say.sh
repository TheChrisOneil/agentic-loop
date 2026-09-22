#!/usr/bin/env bash
# What a step prints. The TYPE is on the line on purpose: watching a tick should show the
# shape of the loop — how much of it is a rule, and how little of it is judgment.
# Colour only when stdout is a terminal, so piped output stays plain.
if [ -t 1 ]; then
  C_MECH=$'\033[32m'; C_COORD=$'\033[33m'; C_THINK=$'\033[35m'
  C_TEST=$'\033[36m'; C_GATE=$'\033[33m'; C_OFF=$'\033[0m'
else
  C_MECH=""; C_COORD=""; C_THINK=""; C_TEST=""; C_GATE=""; C_OFF=""
fi
step_say() { # id name type result
  local c=""
  case "$3" in
    mechanical)   c="$C_MECH"  ;; coordination) c="$C_COORD" ;;
    thinking)     c="$C_THINK" ;; test)         c="$C_TEST"  ;;
    gate)         c="$C_GATE"  ;;
  esac
  printf '  %2s %-22.22s %s%-14s%s %s\n' "$1" "$2" "$c" "[$3]" "$C_OFF" "$4"
}
