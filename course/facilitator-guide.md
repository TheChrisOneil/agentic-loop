# Run sheet — the manager track

**Sixteen slides presented, fourteen held in an appendix.** The deck opens on why this is on a
manager's desk and ends on a live system. The appendix keeps the economics detail and the
engineering specification for the questions that will come.

## The sixteen, with timings

| # | Slide | Min | The one thing it does |
|---|---|---|---|
| 1 | cover | 1 | Names the five literacies: architecture, prompts that produce code, cost control, security, economics |
| 2 | **why-now** | 3 | Budgets already assume this. The ask is "more with less" — and it carries exposure |
| 3 | session-goals | 2 | Propose · Evaluate · End |
| 4 | agentic-labor | 3 | The definition: run the model like an organization, not a chatbot |
| 5 | demo-problem | 3 | Four failures, none of them the model |
| 6 | where-it-applies | 3 | If RPA can do it, RPA should do it |
| 7 | kpis | 4 | Six numbers, and the RFP shift from hours to verified units |
| 8 | conversion-method | 3 | The seven-step spine |
| 9 | **intake** | 4 | Human gates · where information lives · digital accessibility · regulated content · attack vectors |
| 10 | ladder | 3 | Code, a written method, raw inference |
| 11 | five-types | 3 | Coordination, mechanical, thinking, test, gate |
| 12 | decompose | 4 | The unit boundary |
| 13 | controls | 3 | Segregation of duties — the framework they already own |
| 14 | assess | 4 | Six questions to put to an engineer |
| 15 | live-demo | 5 | Nine units, four model calls, a blocked tamper |
| 16 | closing | 1 | The sentence |

**Teaching and demo: 49 minutes.** With an 18-minute exercise and 4 minutes of discussion, the
manager track is a **71-minute session**. Ask for 75.

**To hold a hard 60:** cut `ladder` (3) and `session-goals` (2), run the exercise to 15 minutes
and the demo to two set pieces (3). Lands at 60 with nothing left over.

## The appendix — slides 17 to 30

`objectives · unit-economics · one-idea · which-rung · three-rules · loop-order ·
reference-arch · fanout · seats · record · maturity · goals · contract · five-rules`

They sit after the closing slide, in presentation order, so you can jump to one when asked.
Three are worth knowing by name:

- **reference-arch** — the nine engineering layers with the property to demand of each. Go here
  the moment somebody asks "what do I actually ask the engineer for?"
- **unit-economics** — the cost-to-serve formula behind KPI one.
- **five-rules** — the failure stories. If the room is engaged and you have the time, this is
  the best five minutes in the deck.

## Register, and why it switches

The presented track is in the language of process optimization and internal control. The
appendix's `reference-arch` is in precise engineering language and is not softened.

If you take that slide out of the appendix, **say the switch out loud**: *"I am going to speak
like an engineer for four minutes, because you will be managing people who talk like this, and
a manager who cannot read the specification cannot assess the work."*

## Before you walk in

**The day before:** run `./check.sh` (one minute), then work through `REHEARSAL.md` end to end. Twenty minutes, and every expected
line in it came from a real run, so a difference means something is actually wrong.

**On the day:**

```bash
cd demo && make clean && make tick && make report
```

Leave the terminal open on that output. Font at 18pt or larger.

Publish the worksheet link and have it on screen as the exercise starts. Nothing is printed.

---

## Running the exercise

**Set it up in 60 seconds, then stop talking.**

> Four people per table, one laptop open between you. You have one page and eighteen minutes. Every team has the same
> business process: supplier invoices that do not match their purchase order. Roughly four
> hundred invoices a month, and the finance team currently opens every one by hand. Six boxes
> on the page. Fill them in. I will interrupt you once.

**Seven minutes in — the interruption.** Stand up and say one thing:

> Most of you have written a thinking step that decides *and* does. Go back and look. If your
> model both judges the exception and writes the adjustment, ask yourselves: what happens when
> it is wrong, and how would you know?

Then sit down. That single interruption fixes more worksheets than ten minutes of coaching.

**Circulating — the three things worth correcting, in priority order:**

1. **A unit that is not a unit.** "The invoice inbox" is not a unit. Ask: "what is the smallest
   thing that gets exactly one decision?" Keep asking until the answer is a noun with a
   boundary.
2. **A gate written as a sentence.** "Check the amount is reasonable" is not a gate. Ask them
   for the number. If they cannot name it, that is the finding — *they do not currently have
   that control either, they have a person exercising judgment nobody wrote down.*
3. **Three thinking steps.** Ask which two could be rules if somebody wrote the procedure down.
   Usually both.

**Teams with a laptop who want to run it:** point them at
`exercise/APPLICATION-NOTES.md` — clone, check, see the demo, write a use case, get a design
from their own assistant, argue with the validator, accept it, build it. Every command in it
has been run.

**Teams who finish early:** hand them the second page of the worksheet — write the three-list
contract for their loop, and one standing goal with a predicate that could actually fail.

---

## Running the demo as the answer key

Do not walk through all nine steps. You have six minutes. Run three things:

1. `make tick` — let it scroll. Then say: **nine units, four model calls.** Point at the two
   that closed on arithmetic and the three that were refused before any model read them.
2. `make demo-tamper` — the proof is edited, delivery blocks, the daily sweep pages.
   This is the moment. Let the silence sit for a second after it prints.
3. `make report` — four model calls, and the cost column that exists from night one.

Then the closing question:

> If you deleted the judgment step entirely, how much of this loop still works?

Almost all of it. **That is a well-built loop, not a wasted one.** That question is also
discussion question five, so it hands you straight into the last four minutes.

---

## What "good" looks like on a worksheet

You are not grading. You are looking for four signals:

- The unit is a noun with a boundary, and the team can say who decided it.
- Exactly one thinking step, and they can defend why the other candidates are rules.
- At least one gate condition that contains a number.
- A refusal message that names a next human action, not a state.

A team that has all four in eighteen minutes has understood the hour.

---

## Questions you will get, and short answers

**"Isn't this just workflow automation with extra steps?"**
Mostly yes — and that is the point. The novelty is not the loop. It is being deliberate about
the two or three places where the loop cannot be automated, and surrounding exactly those.

**"What if the model is good enough that I don't need the gates?"**
The gates are not there because the model is weak. They are there because a model can be
argued with and a rule cannot. Better models do not fix that property; they make it harder to
notice.

**"Who is accountable when it's wrong?"**
The named person on the proposal. That is why the last step of every loop in this course
assigns one. This is discussion question one — do not answer it in full here, let the room do it.

**"How much does this cost to build?"**
The demo in `demo/` is about four hundred lines of shell and no dependencies. The expensive
part was never the code. It was deciding what a unit of work is.
