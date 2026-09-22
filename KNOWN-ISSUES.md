# Known issues

Recorded, not fixed. Each entry names the files, what actually happens, and what a fix would
be. Nothing here breaks the session as it runs today on macOS.

Last reviewed: 2026-09-22.

Paths are given as files, not line numbers — a line number is wrong after the next edit and
sends the reader to the wrong place with confidence.

Layout: the scripts live in `course/workshop/tooling/`, the acceptance register in
`course/workshop/memory/`, engagements in `jobs/`, and what was built in `loops/`.

---

## 1. `column` is assumed present, and its absence now degrades rather than lies

`column` formats the tables in `make ledger`, `make cost`, `make units`, `make findings` and
`accept.sh --list`. It is util-linux: present on macOS and WSL, absent in Git Bash.

Every call now falls back to `cat`, so a missing `column` costs you alignment and nothing else.
It no longer reports "no ledger yet" when the ledger is present — that reading of absence for
"I could not look" was rule 3 broken in our own code, and it is fixed.

**Impact:** cosmetic.

**Fix:** none needed. Recorded because a reader on Git Bash will notice unformatted tables.

---

## 2. `shasum` is assumed present

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

## 3. Untested on GNU awk and on WSL

The code is 155 awk invocations deep and has only ever run against BSD awk on macOS. Two
BSD-versus-GNU differences were hit and fixed during the build (a builtin name collision on
`exp`, and a line-continuation rule), so the remaining risk is believed low.

**Believed low is not tested.** Nobody has run `make test` under WSL or under `gawk`.

**Fix:** run the suite once on a Windows machine with WSL2, and once with `gawk` aliased over
`awk` on any Linux host.

---

## 4. Native Windows and Git Bash are unsupported

Everything is bash plus `make`. PowerShell will not run it. Git Bash lacks `make` by default
and lacks `column`.

**Not a defect, a scope statement.** Recorded so nobody discovers it in a classroom.

The session itself does not need any of this: students need a laptop, a browser and an LLM
account. The tooling is the instructor's.

---

## 5. `tooling/start.sh` cannot be driven by a single piped stream

The intake and discussion steps read with `cat`, which consumes stdin to end-of-file. A script
piping `slug, owner, use-case, choice` in one stream loses everything after the use case.

**Impact:** interactive use is unaffected — Ctrl-D ends each block as intended. Automation must
invoke `start.sh` once per phase, which is what `tooling/tests/flow.sh` does.

**Fix:** read the free-text blocks from a file descriptor separate from the menu prompts, or
accept `--use-case <file>` in `start.sh` the way `generate.sh` already does.

---

## 6. Cost is recorded for the generator only

`memory/usage.tsv` covers `tooling/generate.sh`, which is the only place the workshop spends a
model. The judgment step inside a scaffolded loop logs nothing yet — the generated
`scripts/log-cost.sh` still takes token counts as arguments and is passed zeros.

**Impact:** you can price designing a loop — that is the `nre` line in `make cost`. You cannot
yet price running one, so the `run` line reads zero and says so rather than implying free.

**Fix:** have the generated judge step ask the CLI for `--output-format json` and call the same
`log-cost.sh` the workshop uses.

---

## 7. The job ledger names the configured model, not the binary that ran

`tooling/generate.sh` logs `GENERATE_MODEL`. When a stub `claude` is first on `PATH`, the ledger still
reads `model claude-opus-5` while nothing of the sort was called.

**Impact:** confusing in tests. In production the two always agree.

**Fix:** log the resolved binary path alongside the model id.

---

## 8. Three dead rows in the acceptance register, and the note that explains them

`course/workshop/memory/acceptances.tsv` rows 8, 9 and 10 record acceptances made during
development, under the tree's former path, for jobs (`claims`, `_flowtest`) that were deleted
afterwards. A reader checking those paths finds nothing, which looks like corruption.

**They are left in place, and row 11 is a `note` explaining them.** The register is append-only
and chained: removing a row would break the chain and destroy the property the register exists
to demonstrate. A ledger is corrected by appending, never by editing.

```bash
tooling/accept.sh --note "..." --by "Name, Role"
```

Since row 7, `accept.sh` records paths relative to the workshop root, and the flow test writes
to its own scratch register — so no further rows of this kind can appear.

**Fix:** none, and that is the point. `tooling/accept.sh --verify` reports the chain intact at
11 rows.

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

## 11. The first generation after a method edit costs roughly double

`tooling/method/GENERATE.md` is the stable prefix of every generation prompt, so it is cached.
Edit it and the next call pays to build the cache again.

Measured over thirteen calls in `memory/usage.tsv`:

| | Calls | Mean |
|---|---|---|
| Warm cache (`cache_read` ~25,000) | 10 | **$0.2275** |
| Cold cache (`cache_read` 0) | 3 | **$0.4029** |

Within the warm figure, cost tracks **output length**, not prompt length — the longest design
on record cost $0.2722 and the shortest $0.2159. Lengthening the method therefore costs
almost nothing per call, because the method is the part that is cached.

**Impact:** none on correctness. It matters only if you edit the method during a session and
then quote the next figure as typical.

**Fix:** none. Read `cache_read` in `make cost` — a zero there explains the number above it.

---

## 12. Drawing the diagrams needs mmdc, and says so when it is missing

`make brief` writes `diagrams/sequence.mmd` and `flow.mmd` always. Turning them into `.svg`
needs `mmdc` (`npm install -g @mermaid-js/mermaid-cli`).

Without it you get the two `.mmd` files, a note on stderr, and a line in the brief saying no
pictures were drawn and how to see them anyway. `check.sh` fails when a job has `.mmd` but no
`.svg`, so it cannot pass unnoticed.

**Impact:** a reader who will not run anything needs the pictures. Install `mmdc` before the
session, or paste a `.mmd` into <https://mermaid.live>.

**`mmdc` may be on your PATH in one shell and not another.** It installs under the active node
version — here `~/.nvm/versions/node/v18.18.2/bin` — which nvm adds to an interactive shell.
A shell that does not source nvm, or one a conda environment has reordered, will not find it.
`command -v mmdc` in the shell you are actually using is the check that matters.

An earlier `.svg` is **deleted** when rendering fails, rather than left beside a newer `.mmd`.
A stale picture of a design you have since revised is worse than no picture.

**Fix:** none needed — the dependency is real and the absence is now reported.

---

## 13. The deck lives outside this repo

`course/deck.md` is the source of record for the content. The presented deck is a private
Artifact, and the two are kept in step by hand.

**Impact:** an edit made in the Artifact and not mirrored into `deck.md` is lost to anyone
working from the repo.

**Fix:** decide which one is authoritative and say so in the README.
