# The Loop V2 — full text for markup

Every word that appears on a slide, plus the speaker notes, in deck order. Edit this file directly, or leave a line starting with `>>` under anything you want changed. When the verbiage is settled it goes back into the slides.

**22 slides.** Source: `course/deck-v2/project/` · Artifact: https://claude.ai/artifact/2LkUiqh4HdXATQUhNBCy9J

---

## 1. `cover`

A working session for managers · second edition

### The Loop

What an AI-first company needs from a business person

TCO

NRE

OpEx: tokens + staff

KPI assets

audit traceability

deterministic by default

[Your name] · [Date] · EDGE Academy, Wichita State University

**Speaker notes.** This is the second edition of this session, and the frame has moved. The first edition asked whether you could evaluate an agent project. This one asks something harder and more useful: what does an AI-first company actually want from a business person? Not somebody who is excited about AI. Somebody who can run a project whose underpinning is AI the way you would run any other capital-and-operating project — with a total cost of ownership, a bounded design budget, a forecast operating cost that includes both tokens and people, and a way of knowing next quarter whether any of it is still true. Six things along the bottom of this slide. By the end of the hour you will have produced the last one, on a real process of your own. (1 min)

---

## 2. `the-ask`

The role, stated plainly

### We are not hiring people who are excited about AI

**The budget already assumes it**

Headcount plans, vendor pricing and productivity targets are increasingly written on the assumption that agents assist the process. The question is no longer whether.

**The costs behave differently**

Design cost is large and one-time. Operating cost is small, per unit, and unbounded. A manager who cannot separate them cannot forecast either.

**The output is probabilistic**

An occasional confident error is a property of the technology. Accepting a stated amount of that is a management decision, made in writing, by somebody named.

We are hiring people who can manage a project whose underpinning is AI. That is a different skill, and it is mostly an accounting and design skill.

**Speaker notes.** Say this one without hedging, because it is the thesis. Every company in this category now has more enthusiasm than it needs and less management than it needs. Three facts make the job what it is. First, it is already in the plan, so the interesting question moved from should we to how much and by when. Second, the cost structure is unusual: a large one-time design cost, then a very small per-unit operating cost that has no natural ceiling — those two behave nothing alike and they get budgeted in different places. Third, the thing you are buying produces lossy outcomes; it is probabilistic, not deterministic, and no amount of engineering removes that entirely. What it can do is bound it, which is most of what today is about. So the person we want is not the evangelist. It is the person who can put a number on all three. (3 min)

---

## 3. `six-artifacts`

The spine of the session · photograph this one

### Six things you must be able to produce

| # | The artifact | The question it answers | Who reads it |
|---|---|---|---|
| 1 | Total cost of ownership | What does this cost us over its life, including the people it does not replace | Finance, the sponsor |
| 2 | NRE budget | What does it cost to design and build, once, and how do we know when it is spent | The sponsor, procurement |
| 3 | Expected OpEx | Per period: token spend _and_ staffing, as one number | Finance, the process owner |
| 4 | Standing KPI assets | Is either number still true — asked every period, by a thing that runs itself | You, quarterly |
| 5 | A BPO pipeline design | Where our best practice lives so that it cannot be skipped | Engineering, audit |
| 6 | The deterministic split | Which steps are rules, which are judgment, and why each one is where it is | Engineering, risk |

**Four documents, one design, one argument.** You will produce number 6 yourselves today, on a real process, and it is the one the other five depend on.

**Speaker notes.** Six artifacts. This is the contents page for the rest of the hour and the honest answer to what does a business person do here. Notice what is not on the list: nothing about prompts, nothing about model selection, nothing about which vendor. Those are engineering decisions and you should not be making them. What you own is the money, the evidence, and the shape of the process. Notice also the order of dependence. Number six is first in logic even though it is last on the table: until somebody has decided which steps are rules and which are judgment, nobody can price the design, forecast the tokens, or tell you what the reviewers will be doing all day. That is why the exercise you run later produces number six. Get that right and the other five become arithmetic. Get it wrong and every number downstream is fiction. (3 min)

---

## 4. `determinism`

Artifact 6 · the line that governs everything else

### Deterministic by default. Probabilistic where it earns its place.

**Deterministic**

Same input, same output, every time. Costs nothing per run. Testable. Auditable. Can be proven to a regulator.

**Code, queries, thresholds, checksums, routing, arithmetic.**

**Probabilistic**

Same input, plausible output. Costs per run. Sometimes confidently wrong. Cannot be proven — only sampled and bounded.

**Reading unstructured text, weighing an exception, drafting a rationale.**

**The test.** If two competent people always agree on the answer, it is a rule. Write the rule.

**The cost.** Every step moved from probabilistic to deterministic removes a recurring charge permanently.

**The control.** A probabilistic step is never the last word. Something deterministic checks it.

**Speaker notes.** This is the single most important slide in the deck and it is not a technical distinction, it is a budgeting and risk distinction. Deterministic work gives you the same answer every time, costs nothing per run once written, can be unit tested, and can be shown to an auditor. Probabilistic work gives you a plausible answer, charges you every single time it runs, and is occasionally confidently wrong in a way you will not catch by looking at it. Both belong in the system. The discipline is that you default to the left column and you make the right column argue for itself. Three consequences. The test for which is which is the two-people test: if two competent colleagues always agree on the answer, you are looking at a rule that nobody has written down yet, and paying a model to rediscover it nightly is the most common way these projects waste money. The cost consequence is permanent — a step you convert from judgment to rule stops charging you forever. And the control consequence: a probabilistic step never gets the last word. Something deterministic always checks it. Hold onto that; it is where artifacts four and five come from. (4 min)

---

## 5. `tco`

Artifact 1

### Total cost of ownership — the whole stack, not the token bill

| Layer | Behaves as | What sits in it | Commonly missed |
|---|---|---|---|
| Design and build | NRE, one-time | Process mapping, decomposition, the loop itself, the controls | The mapping, charged to nobody |
| Inference | OpEx, per unit | Tokens: input, output, thinking, cache | Thinking and cache, unmetered |
| Human review | OpEx, per unit | The reviewer seat, the approver seat, the escalation | Usually the largest line |
| Platform | OpEx, fixed | Hosting, logging, storage of evidence, identity | Evidence retention, for years |
| Assurance | OpEx, fixed | Sampling, audit, model change regression, incident response | Re-verification after a model update |
| Rework | OpEx, variable | Defect rate × cost of the defect reaching a customer | Priced at zero in every pilot |
| End of life | NRE, one-time | Migration off, records retained, the manual process restarted | Never budgeted at all |

**Two of these are one-time and five recur.** A business case that shows only the first row and the second is not a TCO. It is a quote.

**Speaker notes.** Seven layers. Walk them once, and make the room notice the fourth column, because that is where business cases fail. The design layer is real work that somebody already did — the process mapping usually happened before the project existed and is charged to nobody, which understates NRE. Inference is the line everybody quotes and it is rarely the largest. Human review usually is. Platform includes evidence storage, and in a regulated setting you are retaining that for years. Assurance is the one that surprises people: when the vendor updates the model, your verification is stale and somebody has to re-run it, so a model update is a scheduled cost, not a free upgrade. Rework gets priced at zero in every pilot I have ever read. And end of life is never budgeted, which is how you end up unable to shut something down because nobody funded the exit. Two of these are one-time and five of them recur every period. If somebody hands you a business case with a token estimate and a licence fee, they have given you a quote, not a total cost of ownership. (4 min)

---

## 6. `nre`

Artifact 2

### The NRE budget — bounded, staged, and spendable only once

**Stage 1 · Map and baseline**

The process end to end, and today's cost per unit. **Exit:** a baseline number nobody disputes.

**Stage 2 · Decompose**

Rules separated from judgment; gates placed; proof defined. **Exit:** a design that passes its checks.

**Stage 3 · Build and verify**

The loop, the controls, the evidence. **Exit:** it runs, and it refuses what it should.

**Stage 4 · Pilot to tier**

Watch, then queue, then auto. **Exit:** a verified pass rate that earns the next tier.

**Fund one stage at a time.** Each has an exit condition written before it starts. A stage that cannot state its exit is a research project wearing a budget.

**NRE recurs when the process changes.** A regulation, a new product line or a model swap reopens stage 2. Budget a refresh, not a one-off.

**Speaker notes.** Non-recurring engineering is the design-time money, and the reason to separate it from operating cost is that it is the only part you fully control. Four stages, each with an exit condition agreed before it is funded. Map and baseline first, because a baseline you collect afterwards is not a baseline, it is an argument. Decompose second, and that is the stage where the real intellectual work happens. Build and verify third. Then pilot through the autonomy tiers. Fund one stage at a time. If a team cannot tell you the exit condition of the stage they are asking you to fund, you are being asked to fund research, which is a legitimate thing to fund but a different thing, and it should be labelled. The second box is the one people forget: NRE is non-recurring per design, not per lifetime. A regulatory change, a new product line, or the vendor deprecating your model all reopen stage two. Put a refresh in the plan at a stated cadence, or the first change order will look like a failure when it is just arithmetic. (4 min)

---

## 7. `engineer-roi`

Artifact 2, continued · where the engineering return actually shows up

### The ROI on your engineers is an NRE number

Agentic tooling does not mostly make the running process cheaper. It makes **stage 2 and stage 3 shorter, more uniform, and more completely checked** — which lands in the NRE line, not the OpEx line.

| Claim | Measured here | Your baseline | Where it lands |
|---|---|---|---|
| Faster | Described process → validated design in **about 30 seconds**, for **$0.26** — mean of **29 priced calls** | [__ engineer-hours] to draft one by hand | Stage 2 duration |
| Better | **22 checks** run on every design, every time — including “this judgment step names no check” | [__ %] of hand designs reviewed against a checklist at all | Defect rate at stage 3 |
| More uniform | Two people, same process, same **shape** of design — the method is written down, not remembered | [__] house styles across [__] teams | Onboarding, handover |
| More completely checked | **46 rehearsal checks** run before anyone presents; **4 real defects** found by running, none by reading | [__] manual pre-flight steps, done from memory | Rework, avoided |

**The ratio to quote.** Engineer-hours saved at stage 2 and 3, against the tooling that saved them — both in the NRE column, same period, no forecasting required.

**The ratio not to quote.** Lines of code per day, or story points. Faster production of unverified work is a cost, and it shows up two stages later as rework.

**Speaker notes.** Somebody will ask what we get from giving engineers agentic tools, and the honest answer is that it almost never shows up where people look for it. It does not make the running process cheaper — that is the OpEx conversation and it is driven by architecture, not by tooling. It shows up in NRE, in stages two and three, as shorter elapsed time and fewer defects carried forward. Four claims, and the middle column is what this very session measured on its own tooling. A described process becomes a validated design in about thirty seconds for about twenty-six cents, which is the mean of twenty-nine separately priced calls; the comparison is however many engineer-hours it takes one of your people to draft the same thing by hand, and you should fill that bracket in with your own number before you quote any of this. Twenty-two checks run on every design every time, including the one that asks whether a judgment step names anything that checks it — a question a human reviewer asks when they are fresh and skips when they are not. The method is written down, so two people produce the same shape of design, which is what makes handover cheap. And forty-six rehearsal checks run before anybody stands up, which found four real defects, every one of them by running the thing rather than reading it. Then the last two boxes. Quote the ratio of engineer-hours saved against tooling cost, both inside NRE, both in the same period — no forecast, no discount rate, no argument. Do not quote lines of code or story points. Producing unverified work faster is not a saving; it is a cost that arrives two stages later wearing a different name. (4 min)

---

## 8. `opex`

Artifact 3

### Expected OpEx — tokens and staffing, as one number

units per period × [ token cost per unit + (review minutes × loaded rate [$__/hr]) ] + fixed platform + assurance

**Tokens are the small, volatile half**

Four meters, not one: input, output, thinking, cache. A ledger that records **unknown** rather than zero is the only honest one.

**Staffing is the large, sticky half**

Reviewer, approver, escalation, and the person who investigates refusals. **Replacing a person does not remove the cost of the seat.**

**Volume is the one that bites**

Per-unit cost falls; unit count rises because the system made it cheap to ask. Forecast the **volume**, not just the rate.

**Fan-out is bounded by review capacity, not by compute.** If two clerks can review forty units a day, a system that proposes four hundred has not saved anything. It has built a queue.

**Speaker notes.** Operating cost has two halves and the small one gets all the attention. Tokens first: there are four meters, not one, and input, output, thinking and cache are priced differently. Any ledger that writes a zero where it means unknown will mislead you, and it will mislead you in the optimistic direction. Second half, staffing, and this is the sentence to take away: replacing a person does not remove the cost of the seat. Somebody still reviews, somebody still approves, somebody still investigates the refusals — and in a regulated process the approver is often more senior than the person doing the work before. Third, volume. Per-unit cost goes down, which makes people ask for more units, so total spend goes up while every reported metric improves. Forecast the volume, not just the rate. And then the line at the bottom, which is the design constraint that ties OpEx back to architecture: fan-out is bounded by human review capacity, never by compute. A system that proposes ten times what your reviewers can check has not created throughput, it has created a backlog with a good dashboard. (4 min)

---

## 9. `unit-economics`

The unit that joins artifact 1 to artifact 3

### Cost per completed decision — never cost per request

token cost + (review minutes × loaded rate [$__/hr]) + (defect rate × rework cost)

**Term 2 dominates**

Cut **review minutes** and you beat any token optimization

**Term 3 kills pilots**

Defects cost trust; reviewers re-check everything and term 2 goes **up**

**Term 1 is architecture**

Naive: **311** alerts to a model nightly. Designed: **12** judgments

**The diligence question:** ask for cost per _completed task_. Anyone who can only give you cost per request has bought an API, not built a system.

**Speaker notes.** This is the unit that joins the total cost of ownership to the operating forecast, and it is a cost-to-serve calculation you already know how to do. Three things follow. The second term usually dominates: a reviewer spending four minutes on a proposal at a loaded rate costs ten to a hundred times the model call, which is why architecture that reduces review minutes beats architecture that reduces token spend, every time. The third term is where pilots die, because a ten percent defect rate does not cost you ten percent — it costs you the reviewer's trust, after which they re-check everything and term two goes up rather than down. The first term is decided by architecture rather than model choice: our security pipeline receives three hundred and eleven alerts, a naive design sends all of them to a model every night forever, and the designed loop sends twelve judgments. Same inputs, same quality of outcome, and only one of them can afford the best model in the seat that actually needs it. Ask every vendor and every internal team for cost per completed task. (3 min)

---

## 10. `worked-budget`

A worked budget · every figure below was metered, or is blank

### What this session's own system cost

| Line | Kind | Figure | Source |
|---|---|---|---|
| One design generated from a described process | NRE | **$0.2557** mean | 29 priced calls |
| Designs generated in total | NRE | **34**, of which 5 unpriced | the ledger |
| Units entering one night's run | — | **9** | the run |
| Units refused before any model call | — | **3** | the run |
| Units closed by arithmetic alone | — | **2** | the run |
| Model calls actually made | OpEx | **4** of 9 units | the run |
| Price of those 4 calls | OpEx | [$__] — not metered | the judgment step is a stub here |
| Review minutes per proposed unit | OpEx | [__ min] — your number | measure before you start |

**Read the two gold cells as the lesson.** A ledger that wrote $0.00 there would look complete and be wrong. Unknown is a value. Zero is a claim.

**Speaker notes.** A worked budget, from the system that runs this session. The top half is measured: thirty-four designs generated, twenty-nine of them priced by the tool that made the call, mean twenty-five and a half cents. Five are unpriced because they came back without usage data, and the ledger says so rather than guessing. The middle is the architecture doing its job: nine units enter, three are refused before any model call because a rule caught them, two close on arithmetic alone, and only four ever reach a judgment. That ratio is the whole of unit economics in one line. Then the two gold cells, and these matter more than the black ones. The price of those four calls is not metered here, because the judgment step in the demo is a deliberate stub — so I will not put a number on it, and neither should a vendor who has not measured yours. Review minutes is your number, and you must collect it before you start, because you cannot reconstruct it afterwards. A ledger that wrote zero in either cell would look finished and be wrong. Unknown is a value. Zero is a claim. (3 min)

---

## 11. `assets`

Artifact 4

### Standing assets that keep asking whether the numbers are still true

| Asset | What it holds | Feeds | Costs to run |
|---|---|---|---|
| Cost ledger | Every call: tokens by meter, price, and whether the price was measured or estimated | NRE and OpEx, both | Nothing — a file append |
| Unit register | Every unit worked, its outcome, and which step decided it | Cost per completed decision | Nothing |
| Acceptance record | Who signed for which design, when, chained so an edit is visible | Audit, segregation of duties | Nothing |
| Evidence store | The proof behind each proposal, checksummed | Escaped defect rate | Storage, for the retention period |
| Pre-flight check | One command that asserts the whole system still behaves | Release decisions | Seconds of compute |

**All five are deterministic.** They are files and scripts. None of them calls a model, so none of them has an operating cost worth forecasting.

**Build them at stage 2, not after go-live.** Every one of them records something that cannot be reconstructed later.

**Speaker notes.** Artifact four is the one that separates a project from a pilot. Five assets, and the point of the fourth column is that they are nearly free: they are files and scripts, they are deterministic, and not one of them calls a model. The cost ledger records every call with its meters and whether the price was measured or estimated. The unit register records every unit and which step decided it, which is how you get cost per completed decision instead of cost per request. The acceptance record says who signed for which design, chained so that a later edit is visible rather than silent — that is segregation of duties made mechanical. The evidence store holds the proof behind each proposal, checksummed, so a reviewer can check without trusting. And the pre-flight check is one command that asserts the whole system still behaves, which is what lets you make a release decision in a minute instead of a meeting. The second box is the part people get wrong: build these at stage two, while you are designing, not after go-live. Every one of them records something that cannot be reconstructed afterwards, and the first time you need them is the first time you have an incident. (3 min)

---

## 12. `ops-plan`

Where the operations plan went

### The five reviews did not disappear. They became commands.

| Classic review | What it asked | Where it lives now | Run by |
|---|---|---|---|
| Product requirements | Do we agree what it must do? | The described process and the named unit of work | People |
| Preliminary design | Is the approach sound? | The design: steps classified, judgment isolated, gates placed — with its diagram | People, on a generated draft |
| Detailed design | Is it complete and internally consistent? | **22 checks**, run on every design, every time | Machine |
| Test readiness | Can we test it, and what counts as evidence? | Gate conditions as numbers; proof defined, and written by a mechanical step | Machine |
| Product release | Is it fit to ship, and who says so? | Acceptance by name on one version; the build refuses anything unsigned | A named person, then machine |

**The gain.** A calendar meeting became a command. It runs every time instead of once, and it leaves a record that minutes never did.

**The loss to guard.** Two of the five are still judgment. Automate those and you have a fast pipeline producing a well-formed answer to the wrong question.

**Speaker notes.** For anyone who has run a real program, this is the slide that makes the rest of it familiar. The old answer to traceability was the operations plan, and it named five reviews: product requirements, preliminary design, detailed design, test readiness, and product release. Each was a meeting, each produced minutes, and the minutes were your evidence. None of those reviews has gone away. What changed is where they live and who runs them. Requirements is still people, and it should be. Preliminary design is still people, but now they are reviewing a generated draft with a diagram rather than a blank page, which changes the meeting from drafting to judging. Detailed design has become twenty-two checks that run on every design every single time, and that is a straight upgrade, because a machine checks the fortieth design as carefully as the first. Test readiness has become gate conditions expressed as numbers and evidence defined before the build. And product release is an acceptance signature on one specific version, after which the build refuses anything unsigned. The gain is in the left box: the meeting became a command, so it runs continuously rather than quarterly, and it leaves a machine-readable record instead of minutes. But read the right box out loud, because it is the part a systems engineer will worry about, correctly. Two of those five reviews are irreducibly judgment. Automate them and you get a very fast pipeline producing an impeccably well-formed answer to the wrong question. (4 min)

---

## 13. `traceability`

Public companies and regulated processes · the design gates _are_ the audit trail

### Proving that every change was traceable

| What the auditor asks | The design gate that answers it | The record it leaves |
|---|---|---|
| What changed, exactly? | The design is a file, and the build refuses to run from anything else | Versioned design, diffable |
| Who approved it? | Acceptance gate: a named person, no group names accepted | Signature, name and role |
| Was it approved _before_ it ran? | The register is chained — a back-dated entry breaks the chain | Ordered, tamper-evident log |
| Does the running system match what was approved? | The build counts controls designed against controls built, and deletes the build if they differ | Build refusal, or parity |
| Can you prove this output was not altered? | Evidence is checksummed when written and re-verified on a sweep | Proof file, with its digest |
| Who can change the control itself? | Maker, checker, approver are separate seats by design | Segregation, demonstrable |

**SOX §404** · change management is a general IT control over financial reporting. **21 CFR Part 11** · secure, computer-generated, time-stamped audit trails. **HIPAA §164.312(b)** · audit controls.

**The new gap: the model is a change you did not make.** A vendor updates it, behavior moves, and no change record exists on your side. Version the model in the record, and re-verify on change.

**Speaker notes.** If you work at a public company, or anywhere near money or patients, this is the slide your auditor cares about and it is the reason the gates exist at all. Read the table as three columns of one sentence: the question, the mechanism, the artifact. What changed — the design is a file and the build will not run from anything else, so there is always a diffable object. Who approved it — a named person, and the tool refuses the team as a signatory, which sounds pedantic until you are the one being asked who signed. Was it approved before it ran — the register is chained, so a back-dated entry breaks the chain visibly rather than sitting there looking plausible. Does the running system match what was approved — the build counts the controls in the design against the controls it actually wrote, and deletes its own output if they disagree. Can you prove the output was not altered — checksums, verified on a sweep, not on request. And who can change the control — separate seats, which is ordinary segregation of duties expressed in software. The regulations at the bottom left are the usual three in our world, and your counsel will tell you which apply. The box on the right is the genuinely new problem, and it is worth saying slowly: the model is a change you did not make. Your vendor updates it, the behavior of your control environment moves, and nothing in your change management system records that anything happened. So put the model and its version in the record beside the design, and treat a model change as a change requiring re-verification. Very few companies do this yet. It is going to be an audit finding. (5 min)

---

## 14. `kpis`

### The KPIs the assets feed

| KPI | Comes from | What it tells you | Decision it drives |
|---|---|---|---|
| Cost per completed decision | Ledger + register | True cost to serve | Fund, re-scope, defund |
| Review minutes per unit | Register | Whether the constraint was relieved | Continue, or admit it was not |
| Verified pass rate, per task type | Register + evidence | Competence, by class of work | Promote or demote autonomy |
| Refusal rate, and refusal quality | Register | Whether the controls are real | Tighten the gates, or trust them |
| NRE burn against stage exits | Ledger | Whether design is converging | Fund the next stage, or stop |
| Escaped defect rate | Evidence store | What reached a customer or the books | **Stop** — not negotiable |

**Baseline first.** Measure the manual process before you start, or you can never claim an improvement — only assert one.

**The RFP shifts.** Time and materials buys hours in a process where hours are not the input. Buy **verified completed units**.

**Speaker notes.** Six numbers, and notice the second column, which is new in this edition: every KPI names the asset it comes from. A KPI with no asset behind it is an intention. Cost per completed decision is the funding number. Review minutes per unit is the honest one, because it says whether the constraint was actually relieved, and it is the number most pilots avoid measuring. Verified pass rate per task type governs autonomy promotion. Refusal rate tells you whether the controls are real — a system that has never refused anything has never been tested. NRE burn against stage exits is the one you watch during design: if stage two keeps consuming budget without reaching its exit condition, that is your early warning, not the go-live date. And escaped defect rate stops the project, with no discussion. Two procurement notes. Baseline the manual process first. And shift the RFP: time and materials prices hours in a process where hours are not the input, so buy verified completed units instead, which moves delivery risk to the party that controls the architecture. (4 min)

---

## 15. `cadence`

Artifact 4, in operation

### The standing review, and the number you stop on

| When | What gets re-examined | Who owns the answer |
|---|---|---|
| Every run | Refusals, failures, and any proof that did not verify | The process owner |
| Monthly | Cost per completed decision, against the forecast in the business case | You |
| Quarterly | Review minutes per unit, and whether the autonomy tier should move | You, with the process owner |
| On model change | The whole verification set, re-run. A vendor upgrade invalidates your evidence | Engineering, reported to you |
| On process change | Stage 2 reopens. New NRE, new acceptance, new signature | You |

**Name the approver while everyone is optimistic.** Somebody signs, by name. “The team” is not an approver.

**Name the exit number too.** The KPI value at which you end this project, written down before it launches.

**Speaker notes.** The assets only matter if something reads them on a schedule, so here is the schedule. Every run, somebody looks at refusals and failures — not to overrule them, but because a refusal is information and an unexamined refusal is waste. Monthly, cost per completed decision against the forecast in the business case you signed; that comparison is the whole point of having written a forecast. Quarterly, review minutes, and the autonomy tier decision. On model change, the whole verification set re-runs, because a vendor upgrading the model invalidates your evidence and nobody sends you a letter about it. On process change, stage two reopens with new money and a new signature. Then the two boxes, and these are the ones that get skipped because they are uncomfortable. Name the approver by name, while everyone is still optimistic, because after an incident nobody volunteers. And name the exit number: the value of a KPI at which you end the project. Writing that down before launch is the single clearest signal that a proposal is honest. (3 min)

---

## 16. `pipeline`

Artifact 5

### A pipeline that locks in the best practice, so it cannot be skipped

**1 · Describe**

The process, in the owner's own words. No template, no jargon.

**2 · Decompose**

One method, written down. Rules out, judgment isolated, gates placed.

**3 · Check**

The house rules, run by a machine. Not a reviewer on a good day.

**4 · Accept**

A named signature on a specific version. Changing it voids it.

**5 · Build**

Generated from the accepted design. Refuses if the two disagree.

**A best practice that lives in a document is advice.** The same practice as a check in stage 3 is a control. Only one of them survives a deadline.

**Every arrow is deterministic.** One model call sits inside step 2. The rest of the pipeline costs nothing to run and cannot be talked out of a check.

**Speaker notes.** Artifact five is where your firm's expertise stops being tribal and starts being enforceable. Five steps. Describe, in the process owner's own words, because a template collects what the template asked for and misses what makes the process hard. Decompose, using one written method, so two people produce the same shape of answer. Check, against your house rules, run by a machine — and that word machine is doing the work in this sentence. Accept, a named signature on a specific version, where changing the design voids the signature. Build, generated from the accepted design, refusing if the two disagree. Now the two boxes. A best practice written in a document is advice, and advice is the first thing to go when a deadline arrives; the same practice expressed as a check in step three is a control, and a control does not have a bad week. And look at the arrows: every one of them is deterministic. There is exactly one model call in this entire pipeline, inside step two. Everything else is code, costs nothing per run, and cannot be persuaded to skip a check. That is what locking in a best practice actually looks like. (4 min)

---

## 17. `lock-in`

The ladder · where a practice should live

### Three rungs, and you climb down whenever you can

**Rung 1 · Code**

Deterministic. Free per run. Testable. **Default here.** A threshold, a lookup, a checksum, a routing rule.

**Rung 2 · Skill**

A written procedure the model follows: what to check, in what order, what disqualifies. Same input, same **shape** of output.

**Rung 3 · Raw inference**

Ask and hope. Costs every time, varies every time. **Must argue for itself** and must be checked by rung 1.

**The management question is never “which model.”** It is “why is this on rung 3?” — and a good team can answer it step by step, without defensiveness.

**Speaker notes.** Here is the engineering register, and managers should be fluent in it because it is how you assess the work. Three rungs. Rung one is code: deterministic, free to run, testable, and where everything belongs until proven otherwise. Rung two is a skill, which is a written procedure the model follows — what to check, in what order, what disqualifies, what to produce. It does not make the output deterministic, but it makes the shape of the output repeatable, which is what lets two people hand work to each other. Rung three is raw inference: ask the model and hope. It costs every time and it varies every time. Both of the lower rungs are things your firm owns; rung three is something you rent. The question to ask in any design review is not which model are we using, it is why is this step on rung three — and a competent team will walk you down the list step by step without getting defensive, because they have already had the argument internally. If the answer is that it has always been that way, you have found budget. (3 min)

---

## 18. `decompose`

The method · you run steps 3 to 6 in the exercise

### Converting a business process into an agentic process

| # | Step | Output |
|---|---|---|
| 1 | Map the process end to end | Inputs, steps, outputs, exceptions, and today's cost baseline |
| 2 | Remove the rule-shaped work | Send it to code first. What remains is the candidate |
| 3 | Name the **unit of work** | The smallest thing that gets one decision |
| 4 | Classify every remaining step | Coordination, mechanical, thinking, test, gate |
| 5 | Isolate the judgment | One per unit. Three judgments usually means two hidden rules |
| 6 | Place the gates and define proof | Conditions in code; evidence a human can check without trust |
| 7 | Name the approver and the exit number | Who signs, and the KPI on which you shut it down |

Steps 1 and 2 price artifact 1. Steps 3 to 6 _are_ artifact 6. Step 7 is artifact 4.

**Speaker notes.** The spine of the method, and notice the line under the table: this is not a separate activity from the budgeting we have been doing, it is where those numbers come from. Steps one and two are what let you price the total cost of ownership, because you cannot cost a process you have not mapped. Steps three through six produce artifact six, the deterministic split, which is the thing everything else depends on. And step seven is artifact four, the standing review, decided while everyone is still optimistic. Step three is the highest-leverage decision in the whole method: name the unit of work, the smallest thing that gets one decision. Step five is the one that saves the most money — if your design has three judgments in one unit, two of them are almost certainly rules nobody has written down. In the exercise you will run steps three through six on a real process, on one page, in about eighteen minutes. (3 min)

---

## 19. `assess`

Assessing the engineering, without being an engineer

### Seven questions, and what a weak answer sounds like

| Ask | A weak answer |
|---|---|
| What is the unit of work? | “It processes invoices.” No unit means no cost per unit |
| Which single step is the judgment? | “The model handles the whole thing” |
| What checks that judgment, and is the check deterministic? | “We ask the model to double-check itself” |
| Show me a refusal. What did it say? | “It has not refused anything yet” — then it is untested |
| What proof does a reviewer read, and who wrote it? | Proof written by the same step that made the claim |
| What is the cost per completed decision? | A price per thousand tokens |
| How do you know the build matches the approved design? | “We reviewed it” — ask what _counts_ it |

**None of these requires you to read code.** All of them are answerable in one sentence by a team that has done the work, and answerable in a paragraph by a team that has not.

**Speaker notes.** You will sit in reviews where you are the least technical person in the room, and these seven questions are enough. What is the unit of work — no unit means no cost per unit and no KPI. Which single step is the judgment — if the answer is that the model handles the whole thing, nobody has decomposed anything. What checks the judgment, and is the check deterministic — asking the model to check itself is not a control, it is the same coin flipped twice. Show me a refusal, and read what it said; a system that has never refused anything has never been tested, and a refusal with no reason in it will not survive an audit. What proof does a reviewer read and who wrote it — proof written by the step that made the claim is worthless, and this one catches real designs regularly. Cost per completed decision, not per thousand tokens. And the last one is the newest: how do you know the build matches the design that was approved — the good answer names something that counts, not somebody who looked. Note the line at the bottom. None of this requires reading code. A team that has done the work answers each in a sentence. (4 min)

---

## 20. `four-bugs`

Evidence, against our own interest

### Four bugs, in the tool that teaches this

| What it did | What it said while doing it |
|---|---|
| Dropped a gate from the built loop | _“Scaffolded 9 steps and 3 gates”_ — the design had four |
| Dropped a gate from the diagram | Blamed the design for a step that was plainly there |
| Kept yesterday's picture of a revised design | _“No pictures were drawn”_ — while two old ones sat beside it |
| Answered about a different project entirely | A real acceptance, a real name, a real timestamp. Wrong design |

**Every one was silent.** Each looked exactly like success, and each would have shipped.

**None was found by reading the code.** All four turned up by running it and comparing the output with the design.

This is the argument of the session, found four times in the tool built to make it.

**Speaker notes.** Say this one plainly and do not soften it. Four bugs, in this workshop's own tooling, found during rehearsal in the days before this class. A gate that existed in the design and not in the built loop. The same gate missing from the diagram, with the tool blaming the design. A revised design whose old pictures stayed on disk looking current. And a command that reported a genuine acceptance — real name, real timestamp — for a project nobody had asked about. Every one of them looked like success. Not one was found by reading the code; every one turned up by running the thing and comparing what came out against what the design said. Notice how directly that connects to the traceability slide: three of these four would have produced a clean-looking audit trail for a system that did not match its approved design. That is the whole argument. You cannot reason your way to correctness. You have to check, and the check has to be something other than the thing being checked. (3 min)

---

## 21. `exercise`

The hands-on · about 40 minutes

### You will produce artifact 6, and watch it become a system

**A · Describe**

A process your team actually runs, in your own words. One paragraph.

**B · Design**

One model call turns it into a design. **22 checks** judge it. You revise until it passes.

**C · Accept**

Sign it, by name. Watch what happens when you then edit it.

**D · Build and run**

A working loop is generated from your design. Three units go through it. One is refused by **your** gate.

**Exactly one model call** in the whole exercise, and the ledger will show you what it cost. Everything else is code.

**Hand in one sentence:** which step is the judgment, and what checks it.

**Speaker notes.** Four parts, about forty minutes, and everything runs through one command each time. Describe a process your team actually runs — not a hypothetical, because the hypotheticals are always too tidy. Then one model call turns your paragraph into a design, and twenty-two checks judge it; expect to fail some of them, and expect to disagree with at least one, which is the most valuable moment in the session. Accept it by name, then edit it and watch the system refuse to build, because your signature covered a different version. Then build, and run three units through a loop generated from your own design, one of which will be refused by a gate you wrote, carrying refusal text you wrote. Two things to watch. There is exactly one model call in the entire exercise and the cost ledger will show you what it was, which is the unit economics argument made concrete rather than asserted. And what you hand in is one sentence: which step is the judgment, and what checks it. If you can write that sentence about a process at work on Monday, this session did its job. (2 min)

---

## 22. `closing`

What to take to work on Monday

### The job is to make an uncertain thing accountable

**Separate NRE from OpEx** in every business case you read. Two of the seven cost layers are one-time; five recur.

**Ask for cost per completed decision.** A price per thousand tokens is a quote, not a cost.

**Default to deterministic.** Make every probabilistic step argue for itself, and have something mechanical check it.

**Name the signer and the exit number** before launch, and put the model's version in the record beside the design.

You will not build these systems. You will be asked to sign for them.

**Speaker notes.** Close on the four things that transfer. Separate design cost from operating cost in every business case you are handed, because almost none of them do it for you and the two behave nothing alike. Ask for cost per completed decision, and treat a price per thousand tokens as what it is, which is a quote from a supplier rather than a cost to your business. Default to deterministic, make every probabilistic step argue for its place, and insist that something mechanical checks it — that single habit is most of the risk management in this field. And name the signer and the exit number before launch, with the model's version recorded beside the design, because a vendor's upgrade is a change to your control environment that nobody will tell you about. Then the last line, which is why this session exists. You are not going to build these systems. You are going to be asked to sign for them, and probably sooner than you expect. (2 min)

---

