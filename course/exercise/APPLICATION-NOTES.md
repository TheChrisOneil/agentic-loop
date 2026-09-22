# Application notes — running the loop yourself

Every command below has been run. Copy them one at a time and read what comes back; the point
is the output, not the typing.

**What you need:** a laptop with a terminal, `git`, and one LLM account in a browser — the free
tier is fine. No installation. No API key.

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
./check.sh
```

**You want:** `READY   33 checks passed`.

If anything says FAIL, read the `next:` line under it — it names what to do. Do not continue
until this is green; nothing below will work.

### A3 · Run one night of the invoice loop

```bash
cd demo
make clean && make tick
```

**Read the whole output.** Eleven invoice lines became nine units of work. Watch what happened
to each:

| | |
|---|---|
| Two units | closed by arithmetic. No model was involved at all |
| Three units | refused before any model read them — no purchase order, a supervised supplier, and one invoice whose memo field tried to instruct the system |
| Four units | got exactly one judgment each |

**The number to remember:** nine units, four model calls.

### A4 · Look at one refusal

```bash
cat outbox/NOPO-MERI.REFUSED.md
```

Every refusal names a **next human action**. Not "needs review" — a specific thing a specific
person does next.

### A5 · Look at what a human would approve from

```bash
cat proof/PO-1006.txt
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

### B1 · Write your use case

```bash
cd workshop
mkdir -p jobs/team-N          # use your team number
```

Open `jobs/team-N/use-case.txt` in any editor and describe your process in plain language.
What helps most:

- what the work is, and roughly how much of it there is
- who does it today, and what the exceptions look like
- what goes wrong, and what it costs when it does
- anything a person has to **judge** rather than look up

No format. Write it as you would explain it to a new colleague. Six to ten sentences.

### B2 · Read the method you are about to use

```bash
cat tooling/method/GENERATE.md
```

This is a **skill** — a written procedure a model follows: what to check, in what order, what
disqualifies, what to produce. It is rung 2 of the ladder from the deck. Skim it; you are about
to hand it to your assistant.

### B3 · Turn your use case into a design

Open ChatGPT or Claude in your browser. Paste **the whole of `GENERATE.md`**, then below it
paste your `use-case.txt`, then send.

The reply will start with `@meta`. Save it exactly as it comes back:

```bash
pbpaste > jobs/team-N/proposed.design      # macOS, after copying the reply
```

On Linux, or if that fails, open `jobs/team-N/proposed.design` in an editor and paste.

**Do not tidy it up.** The next step judges what the model produced, not what you would have
preferred it to produce.

### B4 · Let the validator judge it

```bash
tooling/validate.sh jobs/team-N/proposed.design
```

Twenty-one rules, each deterministic. You want `0 failed`.

Every failure names the fix. The four worth understanding when you see them:

| Rule | Refuses |
|---|---|
| **V7** | a judgment decomposition with nothing named as its check |
| **V13** | a thinking step that no test or gate follows |
| **V15** | a gate condition with no number, comparison or "never" |
| **V17** | a design where the *model* writes the proof |

### B5 · Fix and re-run

Edit the design, run B4 again. Repeat until it passes.

**This is the exercise.** Arguing with the validator is where the hour lands — every rule it
enforces is one the deck argued for.

### B6 · Write it up, so somebody else can evaluate it

```bash
tooling/brief.sh jobs/team-N/proposed.design
```

This writes two things beside your design, both produced **by a rule** — nothing in them is
written by a model, so they cannot flatter the design they describe:

- `jobs/team-N/BRIEF.md` — your assumptions first, then the unit, the steps, the gates, the
  proof and the KPIs, in a table somebody can read in two minutes
- `jobs/team-N/diagrams/` — the flow as a sequence and as a flowchart, saved as `.mmd` and,
  if `mmdc` is installed, as `.svg`

```bash
open jobs/team-N/diagrams/flow.svg        # macOS. Linux: xdg-open
```

No SVG? Paste the contents of either `.mmd` file into <https://mermaid.live>.

**This is what you hand to somebody who will not run anything.** Green is a rule, pink is the
judgment, amber is a gate, blue is a check — one look tells them how much of your process is
machinery and how much is judgment.

## Part C — build it  ·  10 minutes

### C1 · Accept it, by name

```bash
tooling/accept.sh jobs/team-N/proposed.design --by "Your Name, Your Role"
```

It shows you what you are accepting and asks you to type `I accept`. Anything else records
nothing and builds nothing.

**"the team" is refused.** An acceptance nobody signed is not an acceptance.

### C2 · Build the loop

```bash
tooling/scaffold.sh jobs/team-N/proposed.design loops/team-N
```

It refuses to build a design nobody accepted. That is C1 doing its job.

### C3 · Run your loop

```bash
cd loops/team-N
make tick
```

Three sample units go through **your** design. One is refused by **your** gate, carrying **your**
refusal text. A proof is written and checksummed.

### C4 · See what is left

```bash
make todo
```

Every step is a placeholder. The loop runs; nothing decides anything yet. That is deliberate —
you settled the shape before writing a line of logic, which is the cheapest order to do it in.

```bash
cat DESIGN.md        # your design, with the diagram, as the loop's own documentation
make ledger          # every transition, timestamped
```

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
| `command not found: make` | macOS: `xcode-select --install`. Then re-run `./check.sh` |
| The validator fails and you disagree with it | Good. Say so out loud — some rules are arguable, and the argument is the lesson |
| `REFUSED: this design has not been accepted` | Run C1 first. The gate is working |
| `CHANGED SINCE ACCEPTANCE` | You edited the design after accepting it. Accept the new version |
| Your assistant returns prose, not a design | It ignored the method. Tell it: *"Emit only the design file, starting with `@meta`. No commentary."* |
| Anything else | `KNOWN-ISSUES.md` at the repository root lists what is already understood |
