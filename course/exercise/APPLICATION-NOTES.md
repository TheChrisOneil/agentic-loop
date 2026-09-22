# Application notes — running the loop yourself

Every command is `make`. Every one has been run. Copy them one at a time and read what comes
back; the point is the output, not the typing.

**What you need:** a laptop with a terminal, `git`, and the `claude` CLI with a key — your
instructor may provide a class key.

**No CLI?** Use `APPLICATION-NOTES-BROWSER.md` instead. Same design, same result, a few more
steps, and the cost is estimated rather than measured.

**macOS and Linux** work as written. **Windows:** use WSL2, or pair with somebody who has a Mac.

---

## Part A — see a working loop  ·  10 minutes

### A1 · Get the repository

```bash
git clone https://github.com/TheChrisOneil/agentic-loop.git
cd agentic-loop/course
```

### A2 · Check your machine

```bash
make ready
```

**You want:** `READY   37 checks passed`.

If anything says FAIL, read the `next:` line under it — it names what to do. Do not continue
until this is green; nothing below will work.

### A3 · Run one night of the invoice loop

```bash
cd demo
make clean && make tick
```

**Read the whole output.** Eleven invoice lines became nine units of work:

| | |
|---|---|
| Two units | closed by arithmetic. No model was involved at all |
| Three units | refused before any model read them — no purchase order, a supervised supplier, and one invoice whose memo field tried to instruct the system |
| Four units | got exactly one judgment each |

**The number to remember:** nine units, four model calls.

### A4 · Look at one refusal

```bash
make refusal
```

Every refusal names a **next human action**. Not "needs review" — a specific thing a specific
person does next.

### A5 · Look at what a human would approve from

```bash
make proof
```

You could approve or reject this without trusting the machine at all. That is the test for
whether something counts as proof.

### A6 · Watch a control fire

```bash
make demo-tamper
```

Somebody edits the proof after it was written. Delivery blocks, and the next daily sweep
reports the violation.

```bash
make demo-badmath
```

The judgment claims the adjustment is −72.00. The arithmetic says −720.00. A missing zero,
confidently asserted, caught by a step that costs nothing.

```bash
cd ..
```

---

## Part B — design your own  ·  25 minutes

### B1 · Start a job

```bash
cd workshop
make help                     # every command, in one list
make job NAME=team-N          # use your team number
```

It makes the folder, creates an empty use case, and opens your editor. Describe your process
in plain language. What helps most:

- what the work is, and roughly how much of it there is
- who does it today, and what the exceptions look like
- what goes wrong, and what it costs when it does
- anything a person has to **judge** rather than look up

No format. Write it as you would explain it to a new colleague. Six to ten sentences. Save and
close the editor.

### B2 · Read the method the wrapper will use

```bash
make method
```

This is a **skill** — a written procedure a model follows: what to check, in what order, what
disqualifies, what to produce. It is rung 2 of the ladder from the deck. Skim it. The wrapper
sends it, so the same use case produces the same shape twice.

### B3 · Run the wrapper

```bash
make generate NAME=team-N UC=jobs/team-N/use-case.txt
```

It does four things you would otherwise do by hand:

1. **Screens your text by a rule** before any model reads it — too short, too long, or text
   addressed to the system is refused with the next action named
2. **Sends the method and your use case**, and takes the design out of the reply
3. **Validates it, and iterates.** A rejected design goes back with the validator's findings,
   once. `REPAIRS=2` buys another round
4. **Records what it cost**

```bash
make cost
```

```
NRE   1 call(s)  $0.2181   designing the loop, paid once
RUN   0 call(s)  $0.0000   running it, per unit of work
```

**That NRE figure is the point.** Designing this loop cost about twenty cents, once. It is not
a running cost, and the deck's cost-per-completed-decision is the other number entirely.
Measure the first or you will quote the second wrong.

### B4 · Read what the validator said

The wrapper already ran it — and iterated once if the first design failed. Run it yourself to
see the twenty-one rules:

```bash
make check DESIGN=jobs/team-N/proposed.design
```

You want `0 failed`. Every failure names the fix. The four worth understanding:

| Rule | Refuses |
|---|---|
| **V7** | a judgment decomposition with nothing named as its check |
| **V13** | a thinking step that no test or gate follows |
| **V15** | a gate condition with no number, comparison or "never" |
| **V17** | a design where the *model* writes the proof |

### B5 · Fix and re-run

Edit the design, run B4 again. Repeat until it passes.

```bash
make history NAME=team-N      # what the wrapper did, in order, including any repair round
```

**This is the exercise.** Arguing with the validator is where the hour lands — every rule it
enforces is one the deck argued for.

### B6 · Write it up, so somebody else can evaluate it

```bash
make brief DESIGN=jobs/team-N/proposed.design
make show NAME=team-N
```

`make brief` writes two things beside your design, both produced **by a rule** — nothing in
them is written by a model, so they cannot flatter the design they describe:

- `BRIEF.md` — your assumptions first, then the unit, the steps, the gates, the proof and the
  KPIs, in a table somebody can read in two minutes
- `diagrams/` — the flow as a sequence and as a flowchart

`make show` opens the flowchart. **This is what you hand to somebody who will not run
anything.** Green is a rule, pink is the judgment, amber is a gate, blue is a check — one look
tells them how much of your process is machinery and how much is judgment.

---

## Part C — build it  ·  10 minutes

### C1 · Accept it, by name

```bash
make accept DESIGN=jobs/team-N/proposed.design BY="Your Name, Your Role"
```

It shows you what you are accepting and asks you to type `I accept`. Anything else records
nothing and builds nothing.

**"the team" is refused.** An acceptance nobody signed is not an acceptance.

### C2 · Build the loop

```bash
make scaffold DESIGN=jobs/team-N/proposed.design NAME=team-N
```

It refuses to build a design nobody accepted. That is C1 doing its job.

### C3 · Run your loop

```bash
cd loops/team-N
make tick
```

Three sample units go through **your** design. One is refused by **your** gate, carrying
**your** refusal text. A proof is written and checksummed. Each line shows the kind of step —
watch how much of the column is a rule and how little is judgment.

### C4 · See what is left

```bash
make todo        # every placeholder still to implement
make design      # the design this loop was built from
make ledger      # every transition, timestamped
```

The loop runs; nothing decides anything yet. That is deliberate — you settled the shape before
writing a line of logic, which is the cheapest order to do it in.

---

## What to hand in

1. `jobs/team-N/use-case.txt` — the process, in your words
2. `jobs/team-N/proposed.design` — passing 21/21
3. `jobs/team-N/BRIEF.md` and `diagrams/` — from step B6
4. One sentence: **which step is the judgment, and what checks it**

---

## When something goes wrong

| What you see | What to do |
|---|---|
| `command not found: make` | macOS: `xcode-select --install`. Then `make ready` |
| A make target prints its own usage | A variable is missing. The message shows the form |
| The validator fails and you disagree with it | Good. Say so out loud — some rules are arguable, and the argument is the lesson |
| `REFUSED: this design has not been accepted` | Run C1 first. The gate is working |
| `CHANGED SINCE ACCEPTANCE` | You edited the design after accepting it. Accept the new version |
| `REFUSED: the claude CLI is not installed` | Switch to `APPLICATION-NOTES-BROWSER.md` |
| Anything else | `KNOWN-ISSUES.md` at the repository root lists what is already understood |
