# Known issues

Recorded, not fixed. Each entry names the files, what actually happens, and what a fix would
be. Nothing here breaks the session as it runs today on macOS.

Last reviewed: 2026-09-22.

Paths are given as files, not line numbers — a line number is wrong after the next edit and
sends the reader to the wrong place with confidence.

Layout: the scripts live in `course/workshop/tooling/`, the acceptance register in
`course/workshop/memory/`, engagements in `jobs/`, and what was built in `loops/`.

---

## 1. A missing `column` reports "no data" instead of "I could not look"

**Severity: correctness.** This is the only entry that can mislead a reader.

Every scaffolded loop's Makefile, and the four already generated:

```make
ledger: ; @column -t -s'\t' memory/ledger.tsv 2>/dev/null || echo "no ledger yet — run make tick"
cost:   ; @column -t -s'\t' memory/usage.tsv  2>/dev/null || echo "no usage yet"
```

On a machine without `column`, `make ledger` prints *"no ledger yet"* while the ledger sits in
`memory/ledger.tsv`. The tool reports absence when it means it could not read.

That is rule 3 of the five — *a check that did not run is not a check that passed* — broken in
our own code.

**Where:** `course/workshop/tooling/scaffold.sh` (the generator of these lines), and the same two lines
in `loops/refunds/Makefile`, `loops/renewals/Makefile`, `loops/support-triage/Makefile`,
`loops/warranty/Makefile`.

**Fix:** distinguish the two cases — test the file's existence first, then fall back to `cat`
when `column` is absent, and say which happened.

---

## 2. `column` with no fallback at all

Three display-only call sites abort rather than degrade:

```
course/demo/Makefile                          make units, make findings
course/workshop/tooling/tests/repair-path.sh
```

`column` is util-linux. Present on macOS and on WSL, absent in Git Bash.

**Impact:** cosmetic. Nothing decides anything from these.

**Fix:** `|| cat` on each.

---

## 3. `shasum` is assumed present

Ten call sites use `shasum -a 256`. It is a perl script — always on macOS, usually on Ubuntu.
`sha256sum` is coreutils and is always on Linux.

| File | What it hashes |
|---|---|
| `course/workshop/tooling/accept.sh` ×3 | The design content, the register's chain link, the chain re-verification |
| `course/demo/steps/8-prove.sh` | Writes the proof checksum |
| `course/demo/steps/9-deliver.sh` | Re-checks it before delivery |
| `course/workshop/tooling/scaffold.sh` | The line generated into every scaffolded prove step |
| `loops/*/` prove steps | The same line, already written out |

**Impact:** on a host without perl, proof writing and the acceptance register both fail.

**Fix:** one helper preferring `sha256sum`, falling back to `shasum -a 256`, failing loudly if
neither exists. Regenerate the four scaffolded loops rather than hand-editing them. Both tools
produce identical digests, so existing register rows still verify — worth proving, not assuming.

---

## 4. Untested on GNU awk and on WSL

The code is 155 awk invocations deep and has only ever run against BSD awk on macOS. Two
BSD-versus-GNU differences were hit and fixed during the build (a builtin name collision on
`exp`, and a line-continuation rule), so the remaining risk is believed low.

**Believed low is not tested.** Nobody has run `make test` under WSL or under `gawk`.

**Fix:** run the suite once on a Windows machine with WSL2, and once with `gawk` aliased over
`awk` on any Linux host.

---

## 5. Native Windows and Git Bash are unsupported

Everything is bash plus `make`. PowerShell will not run it. Git Bash lacks `make` by default
and lacks `column`.

**Not a defect, a scope statement.** Recorded so nobody discovers it in a classroom.

The session itself does not need any of this: students need a laptop, a browser and an LLM
account. The tooling is the instructor's.

---

## 6. `tooling/start.sh` cannot be driven by a single piped stream

The intake and discussion steps read with `cat`, which consumes stdin to end-of-file. A script
piping `slug, owner, use-case, choice` in one stream loses everything after the use case.

**Impact:** interactive use is unaffected — Ctrl-D ends each block as intended. Automation must
invoke `start.sh` once per phase, which is what `tooling/tests/flow.sh` does.

**Fix:** read the free-text blocks from a file descriptor separate from the menu prompts, or
accept `--use-case <file>` in `start.sh` the way `generate.sh` already does.

---

## 7. The job ledger names the configured model, not the binary that ran

`tooling/generate.sh` logs `GENERATE_MODEL`. When a stub `claude` is first on `PATH`, the ledger still
reads `model claude-opus-5` while nothing of the sort was called.

**Impact:** confusing in tests. In production the two always agree.

**Fix:** log the resolved binary path alongside the model id.

---

## 8. Three dead rows in the acceptance register

`course/workshop/memory/acceptances.tsv` rows 8, 9 and 10 record absolute paths under
`/Users/thechrisoneil/software/course/...` for jobs that were deleted. They came from testing,
before `tooling/accept.sh` began storing paths relative to the workshop root.

**They are left in place on purpose.** The register is append-only and chained; rewriting
history to tidy it would break the chain and would be the wrong lesson. `accept.sh --verify`
reports the chain intact at 10 rows.

**Fix:** none. This is what an audit trail looks like.

---

## 9. `demo/` is hand-written, and is often assumed to be generated

`course/demo/` predates the workshop by a day and contains the only working logic in the repo
— the arithmetic, the duplicate detection, the injection screen, the checksum that blocks a
tampered proof. No file in it carries a scaffolder marker.

`course/workshop/examples/invoices.design` **describes** that demo; it does not produce it. The
scaffolder emits placeholders, not logic.

**Impact:** a reader who assumes the workshop regenerates `demo/` may delete it. That would cost
the session every moment where a control visibly fires, and would leave `make example` without
a subject.

**Fix:** state the relationship in `course/README.md` and `course/workshop/README.md`.

---

## 10. A live generation can fail for reasons outside the repo

`./check.sh --live` and `tooling/generate.sh` both depend on the `claude` CLI reaching a model.
When they fail, the cause is usually not the code:

| What the CLI says | What it means |
|---|---|
| `credit balance is too low` | The account is out of credit. Nothing here can fix it |
| a model id error | `GENERATE_MODEL` names a model this account cannot reach. Try `GENERATE_MODEL=claude-sonnet-5` |
| nothing on stderr, empty reply | Network, proxy, or the CLI is not signed in — `claude -p "say ok"` on its own tests that |

**The job is kept on failure** at `workshop/jobs/_check/`. Read `job.tsv`, then
`.scratch/raw.err` for what the CLI said and `.scratch/raw.txt` for what came back.

**Impact:** the session does not need this. Everything else runs with no key, and the demo is
what you present. `--live` is only for rehearsing a generation in front of the room.

---

## 11. The deck lives outside this repo

`course/deck.md` is the source of record for the content. The presented deck is a private
Artifact, and the two are kept in step by hand.

**Impact:** an edit made in the Artifact and not mirrored into `deck.md` is lost to anyone
working from the repo.

**Fix:** decide which one is authoritative and say so in the README.
