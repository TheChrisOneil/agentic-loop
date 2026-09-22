#!/usr/bin/env bash
# Every tunable in one file. No step invents a number of its own.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEM="$ROOT/memory"; OUTBOX="$ROOT/outbox"; PROOF="$ROOT/proof"; JUDGMENTS="$ROOT/judgments"

# From the design:
APPROVER="${APPROVER:-A. Rivera, Accounts Payable}"
FANOUT="${FANOUT:-7}"

# The judgment seat. stub = zero tokens and identical twice; claude = a real call.
JUDGE_MODE="${JUDGE_MODE:-stub}"
JUDGE_STUB="${JUDGE_STUB:-$ROOT/data/judgments.stub.tsv}"
JUDGE_MODEL="${JUDGE_MODEL:-claude-haiku-4-5}"

# While the gates are placeholders, this unit is refused so you can see a refusal happen.
FORCE_REFUSE_UNIT="${FORCE_REFUSE_UNIT:-U-003}"

. "$ROOT/lib/say.sh"
mkdir -p "$MEM" "$OUTBOX" "$PROOF" "$JUDGMENTS"
