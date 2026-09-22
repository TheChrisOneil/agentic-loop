# Rehearsal sheet

Run this once, start to finish, on the machine you will present from. Every expected line
below was copied from a real run — if yours differs, something is wrong and the step says what.

Twenty minutes. Do it the day before, not an hour before.

```bash
cd ~/…/agentic-loop/course        # wherever you cloned it
```

---

## 0 · The machine  ·  1 min

```bash
for t in bash awk sed make git; do command -v $t >/dev/null && echo "ok   $t" || echo "MISSING $t"; done
command -v shasum >/dev/null && echo "ok   shasum" || echo "MISSING shasum"
```

**Expect:** six `ok` lines.

☐ If anything says MISSING, stop. Nothing below will work, and `shasum` is what makes the
proof tamper-evident.

---

# Part 1 — the demo

The loop you run live in front of the room. **No API key, no network.**

## 1 · One night  ·  2 min

```bash
cd demo && make clean && make tick
```

**Expect the last line:**
```
=== worked 7   proposed 4   refused 3   failed 0 ===
```

☐ Read the whole scroll once. You are going to narrate it, so know where the refusals land:
`NOPO-MERI` (no purchase order), `PO-1008` (the injected memo), `PO-1004` (supervised supplier).

**If the counts differ:** something edited `data/`. `git checkout demo/data` and rerun.

## 2 · What it cost  ·  1 min

```bash
make report
```

**Expect:**
```
  4 model calls, $0.0000
  2 closed by arithmetic alone
```

☐ Nine units, four model calls. That is the number you say out loud.

## 3 · The tamper  ·  2 min  — *the moment of the session*

```bash
make demo-tamper
```

**Expect, at the end:**
```
  deliver: BLOCKED PO-1003 — the proof was edited after it was written

>>> and the next daily sweep finds it:
VIOLATED  every-proposal-carries-a-proof
OK        no-payment-without-a-matched-po
```

☐ Practise the pause. Let the silence sit for a beat after `VIOLATED` before you say anything.

## 4 · The wrong number  ·  1 min

```bash
make demo-badmath
```

**Expect:**
```
  verify: FAIL PO-1006 — the judgment claimed -72.00, the arithmetic says -720.00
```

☐ A missing zero, confidently asserted, caught by a step that costs nothing.

## 5 · A gate that normally never fires  ·  1 min

```bash
make demo-cap
```

**Expect:** five `REFUSED` lines instead of the usual three, two of them naming the
`$500` single-approver cap.

☐ The line to use: *a control that has never fired is a control you have never tested.*

## 6 · A person in the judgment seat  ·  3 min

```bash
make clean && BUDGET=2 JUDGE_MODE=human ./loop.sh
```

It stops and asks you four questions. Answer:

```
call>                dispute
adjustment>          -720.00
evidence>            PO-1006 says 420.00 per seat and the invoice bills 480.00 with no signed amendment
next human action>   Hold 720.00 and ask Vantage for a credit note
```

**Expect:**
```
  judge: PO-1006 -> dispute
  verify: PASS PO-1006 (claimed -720.00, recomputed -720.00)
  deliver: PROPOSED PO-1006 (dispute, tier watch) -> outbox/PO-1006.md
```

☐ Now run it again and answer `-72.00` instead. It fails verification. **The seat is
untrustworthy, whoever sits in it** — that is the strongest line in the demo.

```bash
cd ..
```

---

# Part 2 — the workshop

The tool that turns a described process into a loop. Students see this after the exercise.

## 7 · The validator  ·  1 min

```bash
cd workshop && make example
```

**Expect:**
```
  21 passed, 0 failed, 1 warning(s)
```

☐ The one warning is the unmeasured cost baseline. It is deliberate and it is the admission
you make on the record slide.

## 8 · A design that fails  ·  1 min

```bash
make broken
```

**Expect:**
```
  10 passed, 14 failed, 0 warning(s)
```

☐ Read two failures aloud in the session — V17 *the proof is written by a thinking step*, and
V7 *the decomposition is a judgment and nothing checks it*.

```bash
make rules        # all 21, in plain language
```

## 9 · The diagram  ·  1 min

```bash
make diagram DESIGN=examples/invoices.design | head -20
```

**Expect:** a `sequenceDiagram`, and three `alt` blocks — one per gate.

☐ Optional, if `mmdc` is installed: `make svg DESIGN=examples/invoices.design` writes
`build/sequence.svg` and `build/flow.svg`.

## 10 · The whole pipeline  ·  4 min

```bash
make test
```

**Expect 11 lines, all beginning `PASS`.** No network, no tokens, nothing left behind.

☐ This covers: a use case becoming a validated design, a revision keeping the old version, a
refused acceptance building nothing, and the built loop ticking.

## 11 · The record  ·  1 min

```bash
make verify
make jobs
```

**Expect:**
```
chain intact — 10 row(s)
```
and two jobs, both `built`.

☐ `make register` shows the acceptance rows if you want to project one.

## 12 · A live generation  ·  3 min  — *only if you will demo it*

Needs the `claude` CLI and a working key. **Skip it if you will not run it live.**

```bash
tooling/generate.sh --use-case /tmp/my-process.txt --name rehearsal --by "Your Name"
```

**Expect:** `21 passed, 0 failed` and three files under `jobs/rehearsal/`.

☐ Then clean up: `rm -rf jobs/rehearsal`

**If it refuses:** read the message. It names the next action — too short, too long, or text
addressed to the system.

---

# Part 3 — the room

☐ **Deck open** and paged through once, end to end
☐ **Worksheet link** published and tested from a phone
☐ **Terminal font at 18pt or larger** — the demo is text, and the back row is real
☐ **Screen lighting dimmable** independently of the room lights
☐ `make clean` run in `demo/` so the session starts from nothing

---

## If something fails

| Symptom | Almost always |
|---|---|
| `make: command not found` | Xcode command line tools missing — `xcode-select --install` |
| Counts differ in the demo | `data/` was edited — `git checkout demo/data` |
| `make test` fails on the flow test | A leftover job — `rm -rf workshop/jobs/_flowtest workshop/loops/_flowtest` |
| A generated loop will not tick | `make clean` inside it, then `make tick` |
| Acceptance says NOT ACCEPTED | The design changed after it was accepted. That is the control working |

Anything else: `KNOWN-ISSUES.md` at the repo root lists what is already understood.
