# Discussion — 10 minutes, five questions

You will not get through all five. Pick two, and keep the fifth for the close — it is the one
that sets up the final slide.

For each: the question as you ask it, what it is fishing for, and the answer that means the
room got it.

---

### 1. Your loop proposes an action and a person approves it. Who is accountable when it's wrong?

**Fishing for:** the realization that "the AI did it" is not an available answer, and that
approval without proof is not approval — it is rubber-stamping with extra steps.

**The room got it when** somebody says the approver is accountable, *and* somebody else
immediately objects that this is only fair if the approver was given evidence they could
actually check. That objection is the design requirement. Write it on the board:
**you may not hold someone accountable for approving something you did not let them verify.**

**If it stalls:** ask how many proposals per morning that person can genuinely read. Then ask
what their approval means at ninety.

---

### 2. Where in your loop could a supplier, a customer or a candidate inject text that changes the machine's behaviour?

**Fishing for:** the recognition that their input is written by someone outside the company,
and a model reading it to decide what to do can be steered by it.

**The room got it when** a team points at their own decomposition step and goes quiet. If the
thing that decides *what work exists* is a model reading supplier text, everything downstream
inherits the attacker's framing.

**The line to land:** our invoice demo caught it with a rule, before any model read the words.
**A rule cannot be talked out of its answer.** That is a security property, not a cost
property, and it is the strongest argument for pushing work down the ladder.

---

### 3. What is your version of "the metric was green and the outcome was bad"?

**Fishing for:** a real example from their own industry. Everybody has one.

**The room got it when** the examples come from operations rather than from software —
on-time delivery measured at dispatch, call handling time, "tickets closed." The lesson
transfers: the measurement was correct and the result was a disaster.

**Follow up with:** *what does your metric not cover?* Then: *who is responsible for asking
that question, and how often?* Usually nobody, and never.

---

### 4. What does your loop do at 2am when the thing it depends on is down?

**Fishing for:** the difference between failing and pretending.

**Nothing is an acceptable answer.** Stopping is an acceptable answer. Queueing is an
acceptable answer. What is not acceptable is proceeding on a stale or empty result and
reporting success — which is exactly what software does by default, unless somebody writes the
check.

**The story to tell if you have time:** our test suite never ran, because an earlier command
failed. The system reported "no worse than before." Technically accurate, functionally a lie.

---

### 5. If you removed the AI step entirely, how much of your loop still works?

**Ask this one last.** It is the bridge to the closing slide.

**Fishing for:** the recognition that a well-designed loop is mostly machinery, and the model
is a small expensive component inside it.

**The room got it when** somebody answers "almost all of it" and sounds slightly disappointed.
Then say:

> That is a well-built loop, not a wasted one. The parts that still work are the parts you can
> audit, price, test and hand to a regulator. The part you removed is the part you were going
> to have to defend anyway.

Then go to the last slide and read it.
