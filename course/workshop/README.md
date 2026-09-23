# workshop — the design schema and its validator

Step 1 of the workshop agent: a machine-readable representation of an agentic loop, and a
deterministic gate over it.

```bash
make example              # the design of the working loop in ../demo — 20 passed, 0 failed
make broken               # a design that looks reasonable and fails 14 checks
make rules                # the 22 rules, in plain language
make check   DESIGN=my.design
make diagram DESIGN=my.design    # a Mermaid sequence diagram
make flow    DESIGN=my.design    # a Mermaid flowchart, colored by step type
make brief   DESIGN=my.design    # BRIEF.md and diagrams/ beside the design
```

## Layout

```
workshop/
  Makefile      the front door — make start, make test, make example
  tooling/      the scripts, their libraries, the schema, the method, the tests
  examples/     a library of designs to read, validate and scaffold without running a session
  memory/       the acceptance register and the cost ledger — the record, not the machinery
  jobs/         one folder per engagement: use case, design, brief, job ledger
  loops/        what got built
```

Every command works through `make`. The scripts are reachable directly at
`tooling/<name>.sh` when you want to read one.

## Why this exists

Everything downstream reads a design: the diagram renders from it, the scaffolder builds from
it, the discussion revises it. Nothing can be built until a design is a *thing* rather than a
paragraph.

And the validator answers the question the course keeps asking — **if your decomposition is a
model, what checks it?** The design generator will be a model. This is what checks it. It runs
before a design is ever shown to a student, it costs nothing, and it cannot be argued with.

The workshop tool is governed by the rules the workshop teaches. That is the point.

## The twenty-two rules

Run `make rules`. They fall into four groups:

| Group | Rules | What they enforce |
|---|---|---|
| Completeness | V1, V2, V5, V9, V10 | Nothing is left implicit |
| Accountability | V3, V4, V19, V20 | A named approver, an exit number, cost and quality KPIs |
| The course's own invariants | V7, V11, V12, V13, V15, V16, V17 | Judgment is isolated and surrounded; gates are checkable; evidence is not model-written |
| Honesty | V18, V20 | Tamper detection declared; an unmeasured baseline is warned, not hidden |

Two are worth calling out in the room:

- **V17 — the proof is written by a mechanical step.** A design that has the model write its own
  evidence is refused. "Evidence a model can edit is not evidence," as a gate rather than a slogan.
- **V13 — every thinking step is followed by a test or a gate.** A judgment nobody checks is
  refused, whatever the design says about it.

## Severity

`ERROR` blocks — exit code 1. `WARN` does not.

There is exactly one WARN that matters: an unmeasured KPI baseline. It is allowed, because
demanding a baseline nobody has would just teach people to invent one. It is warned every
single run, because it is the hole this course admits to having.

## Files

| File | What it is |
|---|---|
| `tooling/schema/DESIGN-FORMAT.md` | The format specification |
| `tooling/schema/design.template` | A blank design to copy |
| `tooling/validate.sh` | The validator — `--tsv` for machine output, `--rules` for the list |
| `examples/invoices.design` | The working loop in `../demo`, in this schema |
| `tooling/render.sh` | The renderer — `--flow`, `--md`, `--force` |
| `tooling/lib/parse.awk` | The parser both tools read the design with, so they cannot disagree |
| `tooling/lib/validate.awk`, `tooling/lib/render-*.awk` | The rule set and the two views |
| `examples/broken.design` | Fails 14 checks. Teaching material |

### Use-case samples

Five described processes, in the voice a process owner actually uses, for anyone who arrives
without one of their own. Each carries volume, who does it today, the exceptions, at least two
numeric thresholds, a named approver and a failure that already happened.

| File | The process | The judgment it hides |
|---|---|---|
| `examples/onboarding-kyc.use-case.txt` | Business-customer onboarding, 180/month | Whether the documents evidence the ownership claimed |
| `examples/prior-auth.use-case.txt` | Clinical prior authorization, 900/month | Whether the notes support medical necessity as the policy defines it |
| `examples/expense-audit.use-case.txt` | Expense report audit, 1,200 lines/month | Whether a line has a business purpose |
| `examples/grant-eligibility.use-case.txt` | Community grant screening, 140/cycle | Whether the project falls inside the funding scope |
| `examples/rfp-qualification.use-case.txt` | Inbound RFP bid/no-bid, 60/month | Whether we can meet the mandatory requirements as written |

Use one as the input to a generation:

```bash
make generate NAME=demo UC=examples/prior-auth.use-case.txt
```

`prior-auth` was generated as a check and passed 22 of 22 on the first attempt, no repairs.
It is also the one that carries a regulated-data constraint, which is worth watching: PHI in
the description should show up as a constraint in the design, not as a sentence nobody acted on.

## The renderer

A design becomes a diagram **by a rule, never by a model**. Same design in, same bytes out —
so the picture cannot disagree with the design it depicts. That is the entire reason it is not
drawn by the thing that proposed the design.

Two behaviors are deliberate and worth demonstrating in the session:

- **It validates first.** A design that fails a rule is not rendered at all. A picture of a
  design nobody checked is worse than no picture. `--force` overrides and labels the output.
- **It refuses to drop a control.** If a gate names a step that does not exist, nothing is
  rendered and the gate is named. A diagram quietly missing a gate is the exact failure this
  course is about.

Views: `--seq` (default) is the sequence diagram, with every gate as an `alt` block whose
refusal branch goes to the named approver. `--flow` is the loop shape, colored by step type in
the same palette as the deck.

Verified with the Mermaid CLI: both views of `examples/invoices.design` render clean.

## The scaffolder

A validated design becomes a running loop.

```bash
tooling/scaffold.sh examples/refunds.design loops/refunds
cd loops/refunds && make tick        # it runs now, with every step a placeholder
make todo                      # what is left to implement
```

What it generates: `loop.sh` (batch steps once, unit steps per unit, gates that stop one unit
and nothing else), one `steps/<id>-<name>.sh` per step carrying its **type, actor, scope and
the design line that describes it**, the ledger, the trust ledger, the cost log, sample units,
a `Makefile`, and a `DESIGN.md` with the sequence diagram embedded.

**It runs before a line of logic is written.** That is the point — settle the shape while
changing it is still cheap. Three sample units tick through, one is refused by a gate carrying
the design's own refusal text, and the proof is written and checksummed.

Four things are generated, not left to the team:

| Generated | Why it is not a TODO |
|---|---|
| Every gate's condition and refusal, in the file header | They came from the design. Moving one into a prompt is the failure the course is about |
| A gate on **any** step, not only a gate-typed one | A design may guard a delivery step or a selection step. The build refuses if fewer gates reach the code than the design names |
| The proof step, with its checksum | Evidence a model can edit is not evidence |
| The judgment step's three modes | The loop must be identical whether a model, a recording or a person answers |
| The ledger, on every step | You cannot add an audit trail later |

It refuses an invalid design, and refuses to overwrite a directory without `--force`.

## The generator

The only piece that spends a model, and it is **rung 2, not rung 3**: the model is handed a
written method (`tooling/method/GENERATE.md`) and a schema it must fill, so the same use case produces
the same shape twice.

```bash
tooling/generate.sh --use-case process.txt --name warranty --by "Team 4"
tooling/generate.sh --recorded examples/refunds.design --name demo   # zero tokens, offline
make test                                                      # the repair path, with a stub model
```

Four controls, each tested:

| Control | Behavior |
|---|---|
| **The intake is screened by a rule** | Text addressed to the system is refused *before any model reads it*. Too short and over-long descriptions are refused with the next human action named |
| **The validator checks the generator** | A generated design is validated before anyone sees it. This is the answer to "if your decomposition is a model, what checks it?" |
| **One bounded repair** | A rejected design goes back with the findings, once. `REPAIRS` sets the budget |
| **It refuses rather than ships** | Budget exhausted → the findings are printed, no brief is written, and the draft is left for a human |
| **Every call is costed, and split** | `memory/usage.tsv` records input, output, **thinking** and **cache** tokens plus the CLI's dollar figure, tagged **`nre`** or **`run`** |

**Assumptions come first.** The method requires every gap the model filled to be declared, and
the brief prints them above everything else. A design whose assumptions are buried reads as
authoritative and stops the discussion it should start.

**Numbers it was not given** are proposed explicitly and recorded as assumptions —
*"assumed a single-approver cap of 2000 USD; confirm with finance"* — never presented as fact.

**The brief is rendered by rule**, from the design, like the diagram. Nothing in it is written
by a model, so it cannot flatter the design it describes.

### NRE is not cost-to-serve

`make cost` totals the two separately, and the distinction is the one a manager needs:

```
NRE   1 call(s)  $0.2540   designing the loop, paid once
RUN   0 call(s)  $0.0000   running it, per unit of work
cost per unit of work: not yet measured — no run-time calls recorded
```

**NRE** is non-recurring engineering: the model call that turns a described process into a
design. It is paid once and amortized over every unit the loop ever handles. A design costing
a quarter of a dollar is not a running cost, and reporting it as one makes a pilot look
expensive for a reason that disappears after day one.

**RUN** is cost-to-serve — one unit of work going through the loop. This is the number that
belongs in *cost per completed decision*, and it is the one the deck argues you must know.

Totalling them together misleads in both directions: a cheap design makes running the loop
look free, and an expensive one makes it look fatal. The ledger refuses to blur them.

The RUN line reads zero today because a scaffolded loop's judgment step is still a placeholder
that records nothing — see KNOWN-ISSUES 7. The column exists from the first run, which is the
point the record slide makes.

## The acceptance gate

Nothing is built from a design nobody put their name to.

```bash
tooling/accept.sh examples/refunds.design --by "M. Okafor, Refunds Team Lead"
tooling/accept.sh --status examples/refunds.design
tooling/accept.sh --verify        # recompute the register's hash chain
```

Four properties, and each one is a control rather than a convention:

| Property | What it refuses |
|---|---|
| **Acceptance is of this content, for this design file** | A design edited after acceptance reports `CHANGED SINCE ACCEPTANCE`, and the scaffolder refuses it. Identical content in another project is a separate decision — accountability is per project, not per byte-string |
| **A named person, never a collective** | `--by "the team"`, `"we"`, `"the system"` are refused. A role containing the word "team" is fine — *Refunds Team Lead* is a person |
| **A typed phrase** | The acceptor types `I accept`. Anything else records nothing and builds nothing |
| **An append-only, chained register** | Each row carries a hash of the row before it. Editing an old row breaks the chain, and `--verify` names the row |

Revocation is a row, never a deletion:

```bash
tooling/accept.sh --revoke examples/renewals.design --by "J. Lindqvist, Commercial Counsel" \
  --reason "Counterparty changed the indemnity clause after review"
```

The register keeps the acceptance and the revocation, in order. That is the difference between
a log and an audit trail.

Every scaffolded loop carries `design/ACCEPTANCE.md` — who accepted what content, and when.

**`jobs/invoices/` is the one complete chain** — use case, design, brief, diagrams, acceptance,
and the loop scaffolded from it in `loops/invoices-skeleton/`, whose finished counterpart is
`course/demo/`. The other loops were scaffolded straight from `examples/`, which is what that
folder is for.

## Three worked use cases

Each is a validated design plus the loop scaffolded from it. All three tick end to end.

| Folder | Use case | What it exercises |
|---|---|---|
| `loops/refunds/` | Refund requests over 500 dollars | **A person in the judgment seat** — no model anywhere. `JUDGE_MODE=human make tick` |
| `loops/renewals/` | Contract renewals with changed terms | **A judgment decomposition**, so V7 forces the design to say what checks it |
| `loops/support-triage/` | Inbound messages grouped into cases | **An intake gate as a security control** — credentials and unknown senders stop at step 4 |

## `make start` — the whole thing, as one conversation

```bash
make start
```

It looks for a job in progress. If there is none it asks **"what is your use case?"**, and from
there the flow runs itself:

```
intake  ->  designed  ->  discussing  ->  accepted  ->  built
```

1. **Intake.** You describe the process in your own words. No format.
2. **A design comes back unprompted** — assumptions first, then the unit, the steps, the gates,
   the proof and the sequence diagram. It has already passed the validator; a design that
   fails is never shown.
3. **Discuss it.** `[d]` and you say what should change. The previous version is kept, the
   design is revised, and the diff is printed. Three revisions is the budget.
4. **Accept it.** `[a]`, then you type `I accept`. Your name goes in the register.
5. **It builds.** The loop is scaffolded and ticks in front of you.

`[s]` stops at any point. The job resumes exactly where it stopped — `make start` finds it, and
`make jobs` lists every job and its state. Every transition is appended to `jobs/<slug>/job.tsv`.

## The pipeline, end to end

```bash
tooling/generate.sh --use-case process.txt --name warranty    # free text  -> design + brief
#   read jobs/warranty/BRIEF.md, argue with it, edit the design
tooling/accept.sh jobs/warranty/proposed.design --by "R. Nakamura, Warranty Operations Lead"
tooling/scaffold.sh jobs/warranty/proposed.design loops/warranty
cd loops/warranty && make tick
```

Verified on a fresh use case: 250 warranty claims a month, described in plain prose, became a
10-step design that passed all 21 rules on the first attempt, with 12 declared assumptions and
one judgment step. Accepted, scaffolded, and ticking in under a minute after that.

## Next

The job state machine — "do I have a job in progress, and if not, what is your use case?" —
is the only piece of the workshop flow still missing.
