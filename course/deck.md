# The Loop — the deck, in prose

Eighteen slides. Each one carries **one idea**, what goes on the slide, and what you say.
Times add to 30 minutes of teaching and demo. The exercise and discussion follow.

Slides marked **CUT FIRST** are the ones to drop when you are running late. Decide now,
not at minute 40.

---

## 1 — Title  ·  1 min

**On the slide:** *The Loop: designing AI systems that don't guess.* Your name. Nothing else.

**What you say:**

Everyone in this room has used a chatbot. Some of you have used one for real work. Today is
not about that. Today is about what happens when you take that same model and put it inside a
business process that runs every night, on real money, with nobody watching. That is a
different discipline, and almost nobody teaches it. By the end of the hour you will be able to
draw one on a page and defend where the model belongs.

---

## 2 — The demo problem  ·  2 min

**On the slide:** Two sentences, large: *"It worked in the demo."* / *"It behaves differently
in week three."*

**What you say:**

Here is the pattern that costs companies real money. Somebody builds an AI system by asking a
model to handle the whole job. It demos beautifully. Three weeks later it is behaving
differently and nobody can say which part was reasoning and which part was luck — because
there is no seam between them. The fix is not a better model or a better prompt. The fix is
architecture: cut the job into pieces, do everything you can with rules, and spend the model
only where a rule genuinely cannot decide.

---

## 3 — The one idea  ·  2 min

**On the slide:** **Spend inference like money.**
Below it, smaller: *Every step you turn into a rule costs nothing, runs the same way twice,
and cannot be talked out of its answer.*

**What you say:**

This is the whole course in one line. Treat every call to a model as an expense you have to
justify — and not only in dollars. A rule is free, it is identical every time, and crucially
it cannot be argued with. A model is flexible, expensive, and persuadable. Both of those
properties matter, and the second one is the one people forget. If your safety check can be
talked out of its answer, you do not have a safety check.

This is not an anti-AI position. It is how you get an AI system a business can audit.

---

## 4 — The ladder  ·  3 min  ·  VISUAL: `teaching-2-the-ladder.svg`

**On the slide:** The three rungs. Code at the bottom, a skill in the middle, raw inference
at the top.

**What you say:**

Most people think the choice is binary: code, or AI. There are three rungs, and the middle
one is the one nobody has told you about.

Rung one is code. A rule. Same input, same output, forever. Free per run. It only works where
there is genuinely one right answer.

Rung three is raw inference: "read this and work out what to do." Maximum flexibility,
maximum variance, hardest to audit, most expensive. This is where most AI pilots live, and it
is exactly why they drift after the demo.

Rung two is a **skill**, and this is the commercial insight of the hour. A skill is a written
method the model follows: what to check, in what order, what disqualifies, what to produce.
It is a standard operating procedure written for a machine. The model still supplies judgment
— it no longer supplies the procedure. Moving work from rung three to rung two usually costs
one afternoon of writing down what your best person already does, and it buys you consistency,
reviewability, and a training document for humans as a side effect.

The design rule: **move every piece of work as far down the ladder as it will honestly go.**
Not further. Forcing a real judgment into a rule gives you a system that is confidently wrong,
which is worse than one that says "a human should look at this."

---

## 5 — How to tell which rung  ·  2 min

**On the slide:** *Would two competent people, given the same input and unable to confer,
produce the same output?*
Always → rung 1. Only with a shared written procedure → rung 2. Never → rung 3.

**What you say:**

This is the test you will use six times in the next hour, so take it seriously now. Two
competent people. Same input. They cannot talk to each other. Do they produce the same answer?

If always — write the rule. If only when they share a written procedure — then write that
procedure down, and that document is your skill. If never, no matter what — that is genuine
judgment, and now the real question begins: what checks it?

---

## 6 — The five kinds of step  ·  3 min

**On the slide:** The five types as a table: coordination, mechanical, thinking, test, gate.
One example each.

**What you say:**

Every step in a well-built loop is exactly one of five things, and being able to name which
is the core skill of the day.

**Coordination** binds, routes and records. It decides nothing. "Which case am I working on?"

**Mechanical** is a rule. Same input, same output. "Group these 311 alerts into 90 fixes."

**Thinking** is judgment a rule cannot make. "Does this actually matter in our situation?"

**Test** runs the real checks and compares against the before-state — not against hope.

**Gate** permits or refuses.

The exercise later asks you to label every step in your own process with one of these five.
Teams find that harder than they expect, and the steps they cannot label are usually the ones
that are secretly doing two jobs at once.

---

## 7 — Three rules that carry the value  ·  3 min

**On the slide:**
1. A gate's condition lives in code, never in a prompt.
2. A thinking step may never write a mechanical step's output.
3. A rule with no number, no "never," and no check is a suggestion.

**What you say:**

One. A prompt is a request. A rule is a rule. If your control is a sentence in a prompt asking
the model to be careful, you do not have a control — you have a hope with good grammar.

Two. Evidence a model can edit is not evidence. I will show you that one literally, in a
minute, on a running system.

Three. This one is for the policy writers in the room. "Be careful with large changes" gets
interpreted. "Refuse any change over 200 lines" gets obeyed. A rule needs a number, a "never,"
or a command that verifies it. Apply that test to your own company's policy documents on the
train home. It is uncomfortable.

---

## 8 — The loop, in order  ·  3 min  ·  VISUAL: `teaching-1-the-loop.svg`

**On the slide:** the flowchart. DECOMPOSE → SELECT → JUDGE → GATE → ATTEMPT → GATE → WORK →
VERIFY → PROVE → GATE → DELIVER.

**What you say:**

Here is the shape. Do not memorize the boxes; memorize the rhythm.

**Code prepares. Judgment decides. Code carries out and checks.**

Notice how much of this diagram is green — that is code. Notice that the pink box, the
judgment, appears once, and is surrounded on both sides by gates. Notice that the last box is
a proposal for a named human, and that the machine never approves its own work.

And notice the one box that is a different colour from everything else: decompose. That is the
next slide, and it is the one that decides whether the rest of this works at all.

---

## 9 — Decomposition: the highest-leverage decision  ·  4 min

**On the slide:** *What is ONE unit of work?* Then the three wrong answers for our invoice
example: one unit per line, one per supplier, one per (supplier, purchase order).

**What you say:**

Everything downstream inherits the unit boundary, so getting it wrong breaks the whole loop —
quietly, which is the dangerous part.

Take supplier invoices. If the unit is one invoice *line*, you get many small units that end
up arguing with each other about the same purchase order. If the unit is one *supplier*, you
get a handful of enormous units that nobody can review. If the unit is one *(supplier,
purchase order)* pair, you get the smallest thing that gets exactly one decision. Same data,
same model, same everything else — three different systems, one of which works.

Two things about this that people get backwards.

First: **what a unit is, is always domain knowledge** — including when the answer turns out to
be a rule. The rule did not remove the expertise. It captured it, once, somewhere it can be
read and corrected, instead of renting it from a model every single night.

Second: apply the two-people test *to the decomposition itself*. For invoices against purchase
orders, two buyers agree — so it is a rule, and we write it. For a 40-page contract broken into
obligations, two lawyers argue about where one obligation ends — so it is judgment, and now you
must answer the question most teams cannot: **if your decomposition is a model, what checks it?**

A bad fix fails a test. A bad decomposition produces units that each look fine and collectively
miss the thing that mattered. Nothing downstream catches it, because everything downstream
trusts the units.

---

## 10 — Fan-out: how wide  ·  2 min  ·  **CUT FIRST**

**On the slide:** Three questions: What do the units secretly share? What is the blast radius
if we are wrong? What can the humans downstream absorb?

**What you say:**

Once you have units, you have a second question that is easy to skip: how many run at once?

Only the first input is technical — what the units share that is not obvious. A database row,
a supplier's rate limit, one person's calendar. We once gave two workers isolated copies of a
repository and they still corrupted each other, because the isolation did not cover a shared
resource nobody had thought about.

But lead with the third input, because it is the business one. **Fan-out width is bounded by
downstream human capacity, not machine capacity.** Ninety correct proposals delivered on one
morning is not ninety units of value. It is a queue nobody finishes, and your reviewer starts
rubber-stamping somewhere around number twenty.

---

## 11 — The seats  ·  2 min  ·  **CUT FIRST**

**On the slide:** Coordinator — most capable. Implementer — cheapest. Reviewer — mid, **fresh
context**. Publisher — cheapest.

**What you say:**

Different work wants different models, and the price spread is large enough that this is a
budget decision, not a technical preference.

The coordinator gets the best model, because its mistakes are *invisible* — a bad fix fails a
test, a bad judgment ships. The implementer gets the cheapest, because it is told exactly what
to do. The publisher gets the cheapest, because packaging is not judgment.

The reviewer is the interesting seat. It needs **fresh context** — it must judge work it did
not do and cannot see the reasoning behind. That matters more than its model size. Somebody
who watched you make a decision is a poor judge of that decision. That is true of people too,
and it is why we have audit committees.

---

## 12 — The record layer  ·  3 min

**On the slide:** Four things: durable work records · an append-only ledger · evidence written
by code · cost per unit.

**What you say:**

Everything so far is worthless if you cannot answer, three weeks later: what did this system
do, on what evidence, and who approved it?

**Durable work records** — the work item lives in the system of record, not inside the process
working on it. If a worker dies mid-task, the work is not lost.

**An append-only ledger.** You are not storing where the work *is*. You are storing how it got
there. "This ticket is assigned to a human" answers nothing. "It was triaged at 02:14, refused
at 02:31 because the fix was unsafe, and assigned at 02:33" is an audit trail.

**Evidence written by code, and tamper-evident.** Recall rule two.

**Cost per unit.** And here is my confession: on our first production system we built careful
gates, tamper-evident evidence, and a full state ledger — and we recorded usage for five runs
out of about 147, and our reported cost was zero dollars, because pricing was never configured.
We could not tell you what one fix cost. This is the most common hole in real AI systems and we
had it too. Nobody asks "should we keep doing this?" until month three, and the data you need to
answer had to be collected in month one.

The second system records it properly. One complete cycle — decide, execute, verify — costs
$1.38. That is a sentence you can take into a budget meeting. "Zero dollars, pricing was never
configured" is not.

---

## 13 — Maturity: autonomy is earned  ·  2 min

**On the slide:** watch → queue → auto. Under 10 runs · 10+ runs at 90% · 20+ runs at 95%.
Demotion is automatic.

**What you say:**

Everything so far describes a loop that behaves identically on night one and night two hundred.
Real systems should not.

Keep a second ledger, keyed by *type of task*. A task type that has run fewer than ten times
is in "watch" — a human reads every proposal. Ten runs at ninety percent verified, it earns a
review queue. Twenty runs at ninety-five percent, it may close on its own. Drop below the floor
and it is demoted automatically, and loudly.

Three things make this work. The tier is per task type, never global — "fix a typo" does not
vouch for "change a payment calculation." The tier never blocks the work; it decides only what
may happen after the checks pass. And demotion is automatic, so nobody has to be brave.

In business language: this is a probationary period with a number on it. Most organizations
grant autonomy by tenure or by vibe. This grants it by measured pass rate, and takes it back
the same way.

---

## 14 — Standing goals: done is a state  ·  2 min

**On the slide:** *Finished work does not close. It becomes a condition, re-checked every day,
forever.*

**What you say:**

This is the idea I would keep if I could only keep one.

In most workflows, finished work is finished. Here, finishing something creates a *check* that
the result is still true — a single command that passes while the work holds and fails the
moment it stops holding. That check runs every day, indefinitely. Work is never marked done;
it is monitored.

Two rules keep it honest. Test the condition against both states — it must pass on the good
case and fail on the broken one, or it is decoration. And if a script cannot check it, it is
not a goal: "customers are happier" is a wish; "no invoice over five hundred dollars was paid
without a matched purchase order line, in yesterday's ledger" is a goal.

Keep detection separate from repair. The daily sweep finds and reports. It never fixes.

---

## 15 — The contract: three lists  ·  2 min

**On the slide:** Runs solo · Needs my sign-off · Pages me.

**What you say:**

Before any of this runs unattended, somebody writes one page with three lists. What the system
may do alone. What it may prepare and never complete. And what stops the line and wakes
somebody up.

That third list is the one people write badly. It is not a list of errors. It is the list of
events where *continuing quietly* is the actual failure — the checks failed twice on the same
item, the budget was breached, something asked for a password, or the text the system was
reading appeared to contain instructions aimed at it.

This is the cheapest artifact in the entire course, it is written in plain English, and every
one of you could write one for your own team this afternoon. It is also the one that makes the
conversation about accountability concrete, which is the last discussion question of the day.

---

## 16 — Five rules, each learned by breaking something  ·  4 min

**On the slide:** the five, one line each.

**What you say:**

Each of these came out of a real failure. They are short because they were expensive.

**One: never claim more than you measured.** Our system reported "the base branch is fine"
when it had never checked the base branch. It now says "no baseline could be established —
attribution unknown." Boring, and true. In business terms: "sales are up" and "we did not
measure sales" are different sentences, and software will happily confuse them for you.

**Two: evidence a model can edit is not evidence.** An AI reviewer decided our verdict file
was wrong, rewrote it, and the corrected version let a change through. Its conclusion happened
to be right. The method destroyed the audit trail. Verdict files are now checksummed, and an
edited one blocks delivery. I will show you this working in three minutes.

**Three: a check that did not run is not a check that passed.** A test suite never executed
because an earlier command failed, and the system reported the overall result as "no worse
than before." Technically accurate. Functionally a lie.

**Four: a green metric is not a good outcome.** We forced a library to one version everywhere.
The security proof went green — every copy really was patched — and the build died, because
half the code expected the old shape. The measurement was correct and the result was a
disaster. Ask constantly: what does my metric *not* cover?

**Five: refusals must name the next human action.** "Cannot proceed" is useless. "No patched
version exists; a human must decide to pin, replace, or accept with a compensating control"
is a work item.

---

## 17 — LIVE: one night of invoices  ·  6 min  ·  DEMO

> **Placement:** the run sheet recommends moving this slide AFTER the team exercise, so
> the demo lands as the answer key rather than as an illustration. Run it here only if
> you are teaching a room that will not do the exercise.

**On the slide:** nothing. Switch to the terminal.

**What you say:** see `facilitator-guide.md` — the demo has its own script, beat by beat.
The short version: eleven invoice lines become nine units; two close on arithmetic alone;
three are refused without a model ever reading them; four get one judgment each; every one
lands as a proposal for a named person. Then you edit a proof file in front of them and watch
delivery block.

---

## 18 — The sentence to leave them with  ·  1 min

**On the slide, alone:**

> An AI system you can trust in a business is mostly code, with judgment in the few places
> only judgment will do — and it proves its work rather than asking to be believed.

**What you say:**

Read it aloud. Then stop talking. Do not add anything after this slide.

---
---

# Added slides — business objectives and engineering assessment

Five slides added after the first pass. Placement is given on each. Revised order:

`cover · demo-problem · objectives · unit-economics · one-idea · ladder · which-rung ·
five-types · three-rules · loop-order · reference-arch · decompose · fanout · seats ·
controls · record · maturity · goals · contract · five-rules · assess · live-demo · closing`

Twenty-three slides. Teaching time moves to roughly 36 minutes, so with a 20-minute exercise
this is a **75-minute session**. To hold 60 minutes, cut `fanout`, `seats` and `goals`, and
run the demo to three set pieces.

**Register.** The business slides — `objectives`, `unit-economics`, `controls`, `assess` —
use the vocabulary of process optimization and internal control, because that is the language
these students will manage in. The engineering slides — `reference-arch` above all — use
precise engineering terms and do not soften them. A manager who cannot read the second
register cannot assess the work.

---

## 3 — Two business objectives, stated before anything is built  ·  3 min  ·  AFTER `demo-problem`

**On the slide:** Objective 1 — relieve the constraint. Objective 2 — substitute cost
deliberately. Plus the failure condition.

**What you say:**

Before any architecture, name what you are buying. There are exactly two defensible objectives,
and they are in tension.

**Objective one: relieve the constraint.** In any exception-handling process — invoices,
claims, refunds, credit reviews — the binding constraint is not machine capacity. It is
*skilled human attention*. Theory of constraints tells you that improvement anywhere except
the constraint is an illusion. So the question is not "can the model do this work?" It is
"does this remove low-judgment work *from the constraint*?" A system that produces more things
for your senior analyst to read has optimized a non-constraint and made the process worse.

**Objective two: substitute cost, deliberately.** Labor cost falls only if token cost plus
engineering cost plus review cost falls faster. That is an exchange rate, and you should write
it down before you build, not discover it in month three. Most failed pilots never stated it.

**The failure condition, and put this on the board:** a system that increases reviewer load has
failed, even if every single output it produces is correct. Correctness is necessary. It is
not sufficient.

---

## 4 — The unit that matters: cost per completed decision  ·  3 min  ·  AFTER `objectives`

**On the slide:** the cost-to-serve formula, and the naive-versus-designed comparison.

**What you say:**

Here is the metric, and it is a cost-to-serve calculation you already know how to do:

> **Cost per completed decision = token cost + (review minutes × loaded hourly rate) +
> (defect rate × rework cost)**

Three things follow immediately.

The second term usually dominates. If a reviewer spends four minutes on a proposal at a loaded
rate, the human cost of one decision is frequently ten to a hundred times the model cost. That
is why the architecture that reduces *review minutes* beats the architecture that reduces
token spend.

The third term is where pilots die. A ten percent defect rate does not cost you ten percent.
It costs you the reviewer's trust, after which they re-check everything and your review minutes
per unit go **up**.

And the first term is decided by architecture, not by model choice. Our security pipeline:
three hundred and eleven alerts arrive; a naive design sends all three hundred and eleven to a
model every night, forever; the designed loop sends twelve judgments and lets code do the rest.
Same inputs, same model, same outcome quality — and one of them can afford the best model for
the seat that needs it.

**The diligence question, and it is the one you will use as managers:** ask for cost per
*completed task*, never cost per request. Anyone who can only tell you the second has not
built a system, they have bought an API.

---

## 11 — The reference architecture, in engineering terms  ·  4 min  ·  AFTER `loop-order`

**On the slide:** the nine layers as a table: layer · responsibility · the property to demand.

**What you say — and change register here deliberately. Tell them you are doing it:**

I am going to speak like an engineer for four minutes, because you will be managing people who
talk like this, and a manager who cannot read the specification cannot assess the work.

Nine layers. For each one, there is a property you demand, and each property is testable.

The **trigger** must be idempotent: running it twice must not produce the work twice.
**Decomposition** must be deterministic and total — same input, same units, and every input
accounted for — with stable identifiers, so tonight's unit 42 is the same thing as last
night's. **Dispatch** must enforce mutual exclusion on anything the units share; ours share a
repository, so they run strictly one at a time, and that is a correctness requirement, not a
throttle. **Execution** runs in an isolated working copy with a bounded blast radius, and
production credentials are not in its environment — the "stop and ask" rule is enforced by the
secret simply not being there. **Verification** must share no state with execution, or it is
not independent. **Policy gates** must fail closed: when a check cannot run, the answer is
refuse, never proceed. **Evidence** must be tamper-evident — a checksum is sufficient and
costs nothing. The **ledger** must be append-only and monotonic. And **maturity** must demote
automatically on measured failure.

Every one of those is a yes-or-no question you can ask an engineer, and every one of them has
a demonstration. "Show me a gate refusing something" takes thirty seconds. If it takes longer
than that, the property is aspirational.

---

## 15 — You already have a framework for this: segregation of duties  ·  3 min  ·  AFTER `seats`

**On the slide:** maker · checker · approver · control, mapped onto the four seats. Then the
three lines of defence.

**What you say:**

Nothing in this architecture is new to your controls coursework. It is the same framework, with
a machine in one of the chairs.

**Maker, checker, approver.** The implementer makes. The reviewer checks — with fresh context,
which is the machine equivalent of "the checker did not prepare the entry." The named human
approves. And the deterministic gate is the **control**, the one party in the system that
cannot be persuaded. You would not let the person who raised the purchase order sign off the
invoice against it. That principle does not lapse when the maker is a machine.

**The three lines of defence map exactly.** First line: the loop's own gates, inside the
process. Second line: the standing-goals sweep and the trust ledger, monitoring the process
independently and continuously. Third line: the append-only ledger, which is what audit reads.

Say this plainly, because it is the sentence that converts a sceptical CFO: **we are not
inventing a governance model for AI. We are implementing the one you already require, in a
process that happens to have a machine in it.**

---

## 21 — How to assess an engineer's agentic system  ·  4 min  ·  BEFORE `live-demo`

**On the slide:** six questions, each with the answer that should worry you.

**What you say:**

You will not build these. You will be asked to approve them, fund them, or explain them to a
regulator. Six questions, in order of how much they tell you.

**One. What, other than the model, decides that a task is complete?** A good answer names a
deterministic check. A bad answer is "we prompt it to verify its own work." That system grades
its own homework, and its reliability curve bends the wrong way at exactly the moment you scale
it.

**Two. Show me the unit of work, and tell me who chose that boundary.** If nobody can name the
person and the reasoning, the boundary was inherited from whatever was easy to code.

**Three. When did a gate last refuse something?** A control that has never fired has never been
tested. Ask for the date and the ledger entry.

**Four. What is the cost per completed unit, and where is that recorded?** If the answer arrives
as a monthly API invoice, there is no cost model, only a bill.

**Five. What would automatically reduce this system's autonomy?** If the answer is "we would
notice and turn it off," autonomy is governed by attention, which is the constraint you were
trying to relieve.

**Six. Where can text written outside your company reach a model, and what rule stands in front
of it?** Every process in this room reads supplier text, candidate text, or customer text. That
is an injection surface, and a rule in front of it is a control. A sentence in a prompt is not.

Write these six down. They are the entire hour, in the form you will actually use it.

---
---

# Reframed opening — the manager's frame

Six slides added or rewritten at the front, in the order the request specified: **set up the
goals, define the problems, then give a method.** Deck is now **28 slides**.

Revised order: `cover · session-goals · agentic-labor · demo-problem · where-it-applies ·
objectives · kpis · unit-economics · conversion-method · one-idea · ladder · …`

---

## 1 — Cover, reframed  ·  1 min

**On the slide:** *The Loop — how to propose, evaluate and end an autonomous agent project.*
Five chips: architecture · prompts that produce code · cost control · security · the economics
of agentic labor.

**What you say:** Open on the frame, not the technology. Autonomous agent systems are arriving
in your processes whether or not you sponsor them, and the people who approve, fund and
eventually retire them are managers, not engineers. That means working literacy in five things.
You will not write any of it. You will be asked to sign for it.

---

## 2 — Three decisions you will be asked to make  ·  2 min  ·  NEW

**On the slide:** Propose · Evaluate · End.

**What you say:** Two of these three are the ones nobody prepares you for. Proposing is easy;
everybody has an idea. Evaluating means reading somebody else's system and knowing which
questions separate a system from a demo. Ending means having agreed, in advance, the number on
which you shut it down. Most pilots in this market do not end on a decision — they end on
exhaustion, when the sponsor stops asking. That is the most expensive way to end a project,
because you pay twice: once in spend, and once in the organization's willingness to try again.

---

## 3 — What agentic labor actually is  ·  3 min  ·  NEW  ·  the load-bearing definition

**On the slide, read it out:**

> Agentic labor is building an operating system around a model, so it can be run **like an
> organization** — with delegation, verification, budgets and earned trust — instead of like a
> chatbot.

Then the contrast table: one conversation vs defined seats · you check it vs an independent
party checks · unbounded spend vs a budget per unit · assumed trust vs earned and revoked
trust · no record vs an append-only record.

**What you say:** Every row in that table is a management practice you already run on human
teams. You already delegate to defined roles. You already separate the person who does the work
from the person who checks it. You already give a budget, grant authority on evidence, take it
back, and keep records because your auditors require them. None of this is new management. It
is the management you already do, applied to a worker that is faster, cheaper, tireless, and
occasionally confidently wrong.

**The line to land:** the model supplies the intelligence; the operating system supplies the
honesty.

---

## 4 — Four ways these projects fail  ·  3 min  ·  REWRITTEN

**On the slide:** four numbered failures — drift after the demo · replacing a person does not
replace the cost · no agreed KPI · the contract still buys hours.

**What you say:** Not one of these four is a model problem. Number two is the one that damages
careers: the tokens, the engineering, the review, the rework and the governance all remain. You
moved a cost from one line to five lines, and only one of those five was on your business case.
Number three: the pilot ends by exhaustion, and the data you needed was never collected. Number
four we come back to, because it changes how you write the RFP.

---

## 5 — If RPA can do it, RPA should do it  ·  3 min  ·  NEW  ·  the scoping rule

**On the slide:** rule-shaped work → RPA and ordinary software. Judgment-shaped work → the
residue agentic systems are for. The test, and the failure mode.

**What you say:** Robotic process automation already handles rule-shaped work, and does it
better than any agent will: cheaper, deterministic, fully auditable. If the decision rule can be
written down, writing it down is the correct answer and this session does not apply. What is
left is the judgment — the exceptions, the disputes, the cases where somebody reads a situation.
That residue has no RPA equivalent.

**Say the failure mode plainly:** most failed agentic projects automated something RPA already
did, at many times the cost and a fraction of the auditability. Before you fund anything, ask
which side of the line it sits on and make somebody defend the answer.

---

## 7 — The KPIs you govern it with  ·  4 min  ·  NEW

**On the slide:** six KPIs, each with what it tells you and the decision it drives. Plus two
notes: baseline first, and the RFP shift.

**What you say:** Agree these before the project starts, because most cannot be reconstructed
afterwards. *Review minutes per unit* is the honest one — it says whether the constraint was
actually relieved, and it is the number most pilots avoid measuring. *Refusal rate* tells you
whether the controls are real. *Escaped defect rate* stops the project, with no discussion.

**Then the procurement point:** time and materials prices hours, in a process where hours are
not the input. Buy **verified completed units**. That single change moves delivery risk to the
party that controls the architecture.

---

## 9 — The conversion method  ·  3 min  ·  NEW  ·  the spine of the session

**On the slide:** seven steps — map the process end to end · remove the rule-shaped work · name
the unit of work · classify every remaining step · isolate the judgment · place the gates and
define proof · name the approver and the exit number.

**What you say:** This is the spine, and the rest of the session fills in each step, so
photograph it. Step one is a process map you already know how to draw, plus the cost baseline.
Step three is the highest-leverage decision in the method. Step seven is the one that gets
skipped: name the approver, and name the number on which you end the project, while everyone is
still optimistic. In the exercise you run steps three through six on a real process.

---
---

# Final shape — the manager track

The deck is ordered as **16 presented slides, then a 14-slide appendix**. Two slides were added
at the front of the session.

## 2 — The decision is no longer *whether*  ·  3 min  ·  NEW  ·  the pre-slide

**On the slide:** three panels — it is in the plan already · so the ask is "more with less" ·
and it carries exposure. Then the closing line.

**What you say:**

Start here, before the title means anything. This is not a pilot category any more, and the
reason it is on your desk is budgetary: team and corporate plans are increasingly written on the
assumption that agents assist business processes. Once that assumption is in a plan, the question
you get asked is not "should we use AI." It is **do more with less — how much less, and by when.**

That question needs tools to answer honestly, and that is most of this session. But it has a
second half that rarely makes it into a budget line: **what exposure are you accepting?** These
systems produce lossy outcomes — probabilistic, not deterministic — and an occasional confident
error is a property of the technology, not a defect you can patch out. They read text written by
people outside your company. They touch regulated data.

Accepting that exposure is a management decision. It should be made explicitly, in writing, by
somebody named. That is what today is for.

> You are not being asked to believe in this. You are being asked to price it, govern it, and
> accept a stated amount of risk.

---

## 9 — Survey the process before you price it  ·  4 min  ·  NEW  ·  method step 1

**On the slide:** five dimensions, each with what you collect and what a bad answer means.

| Dimension | Collect | A bad answer |
|---|---|---|
| Human gates | every approval today: who, what authority, what evidence, **regulatory or discretionary** | nobody can list them |
| Where information lives | per input: system of record, email body, PDF, shared drive, a person's head | "it's in the inbox" |
| Digital accessibility | retrievable by query or interface, or only by a human opening it | retrieval needs a human |
| Regulated content | PII, PHI, PCI, confidentiality; permissible vendors, retention, redaction | unknown |
| Attack vectors | who **outside the company** writes text this process reads; credentials; blast radius | "nobody" |

**What you say:**

This is the step that decides whether there is a project at all.

Human gates: list every approval that exists today, and mark which are required by regulation.
Regulatory gates stay, whatever the technology does.

Digital accessibility is where budgets die quietly. If retrieval needs a human opening an
attachment, that is your first and largest cost line, and it is an ordinary integration project
you should scope separately rather than bury inside an AI business case.

Regulated content is a legal answer, not an engineering one. It decides which vendors you may
use at all, what retention terms apply, and what must be redacted before any model call.

Attack vectors: suppliers write invoices, candidates write résumés, customers write emails. All
of that text reaches your system. The answer is almost never "nobody."

**The rule to leave them with:** a process that fails accessibility or regulated content is not a
candidate yet. Fix retrieval and data handling first — those are ordinary projects with ordinary
costs, and doing them anyway makes the process better.
