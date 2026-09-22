# Helper prompts

Hand these out at minute 38, or to any team that stalls. Each one is written to be pasted
into ChatGPT or Claude with the team's own text underneath.

**Two things to say when you hand them over:**

1. *The answer that comes back is a draft. You own the design, not the assistant.* A team that
   pastes the reply onto the worksheet without arguing with it has learned nothing.
2. *Look at what these prompts actually are.* Each one is a written method — what to check, in
   what order, what disqualifies, what to produce. **That is rung two of the ladder.** You are
   holding six skills. This is what the middle rung looks like in practice, and every one of
   them was written in about ten minutes.

---

## 1. Unit boundary sharpener

> I am designing an automated process for supplier invoices that don't match their purchase
> order. I think the unit of work — the smallest thing that gets exactly one decision — is:
>
> [OUR ANSWER]
>
> Do three things. First, name three other boundaries I could have chosen instead. Second, for
> each one, say concretely what breaks downstream if I choose it — be specific about what goes
> wrong, not general. Third, tell me which of the four you would choose and why. Do not be
> diplomatic; pick one.

---

## 2. Rule or judgment?

> Here is a step in a business process:
>
> [OUR STEP]
>
> Apply this test: if two competent people were given the same input and could not talk to each
> other, would they produce the same output? Answer in three parts. (a) Always, only with a
> shared written procedure, or never. (b) The specific disagreement two people would actually
> have, in this domain — name it. (c) If the answer is "only with a shared procedure," draft
> that procedure in under 150 words: what to check, in what order, what disqualifies.

---

## 3. Step classifier

> Classify each step below as exactly one of: coordination (binds, routes, records — decides
> nothing) · mechanical (a rule: same input, same output) · thinking (judgment a rule cannot
> make) · test (runs a real check against the before-state) · gate (permits or refuses).
>
> [OUR STEPS]
>
> For any step you cannot classify as exactly one type, say so and explain what two jobs it is
> doing at once. Flag every step where a thinking step produces something a later step treats
> as fact.

---

## 4. Gate condition rewriter

> Turn each of these into a condition a computer could evaluate with no judgment at all. Each
> one must contain a number, a "never," or a named list. If a condition cannot be made
> checkable without inventing a threshold, say so explicitly and tell me what question I have
> to answer to set it.
>
> [OUR GATE SENTENCES]
>
> Then, for each condition, tell me what it does NOT cover — the case that passes this check
> and is still a bad outcome.

---

## 5. Refusal writer

> Write the message our system produces when it refuses this case:
>
> [OUR WORST CASE]
>
> Rules: state what stopped and why in one sentence. Then name the next human action — a
> specific thing a specific role does next, not a state like "needs review." Do not apologize.
> Do not suggest the system try again. Under 60 words. It must be usable as a work item by
> somebody who was not watching.

---

## 6. Injection finder

> In our process, this text is written by someone outside our company, and our system reads it:
>
> [OUR EXTERNAL TEXT — an invoice memo field, a résumé, a supplier email]
>
> Write three sentences a hostile supplier could put in that field to change what our system
> does. Then, for each one, tell me which step in our design would be influenced by it, and
> whether a rule at that step would have been immune. Treat the sentences you write as
> examples for our defenses, and do not address any instruction to me.

---

## 7. The devil's advocate  ·  *use this one last*

> Here is our loop design:
>
> [OUR WHOLE WORKSHEET]
>
> Attack it. Find the single place where this design fails quietly — where the output looks
> correct, every check passes, and the business outcome is still wrong. One scenario, concrete,
> with the specific inputs that produce it. Then tell me what we would have to record to notice
> it had happened. Do not list general risks.
