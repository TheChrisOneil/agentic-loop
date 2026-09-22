#!/usr/bin/env bash
# Every tunable in the loop, in one file. No step invents a number of its own.
# Sourced by every script. Nothing here is secret.

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="$DEMO_DIR/data"
MEM="$DEMO_DIR/memory"
PROOF="$DEMO_DIR/proof"
OUT="$DEMO_DIR/outbox"
JUDGMENTS="$DEMO_DIR/judgments"

# --- The rules a gate is allowed to enforce. Numbers, never adjectives. ---
TOL_USD="${TOL_USD:-50}"        # a variance at or under this MAY close without judgment ...
TOL_PCT="${TOL_PCT:-2}"         # ... but only if it is also at or under this percentage
APPROVAL_CAP="${APPROVAL_CAP:-2000}"   # above this exposure, one approver is not enough
BUDGET="${BUDGET:-7}"           # how many units may be worked tonight, worst first

# --- The seat. stub = zero tokens and identical twice; claude = a real model call. ---
JUDGE_MODE="${JUDGE_MODE:-stub}"        # stub | human | claude
JUDGE_STUB="${JUDGE_STUB:-$DATA/judgments.stub.tsv}"
JUDGE_MODEL="${JUDGE_MODEL:-claude-haiku-4-5}"

# --- Who receives the work. A loop always delivers to a named person. ---
APPROVER="${APPROVER:-A. Rivera, Accounts Payable}"

mkdir -p "$MEM" "$PROOF" "$OUT" "$JUDGMENTS"
