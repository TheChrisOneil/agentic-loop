# The Loop — a one-hour class on designing AI systems that don't guess

Everything needed to run the session: the deck, the run sheet, the student exercise, and a
working loop you can execute live in front of the room.

`deck.md` is the source of record for the framework. Everything else here supports it.

```
course/
  README.md                    you are here — prerequisites and run order
  deck.md                      the deck, in prose: every slide, and what to say on it
  facilitator-guide.md         the minute-by-minute run sheet, with the demo cues
  exercise/
    worksheet.md               the student deliverable — one page, six boxes
    helper-prompts.md          prompts to hand teams that get stuck
    discussion.md              the five questions, with what each one is fishing for
  demo/
    README.md                  the step-by-step walkthrough, with what to say at each step
    loop.sh  Makefile  steps/  the working loop
```

---

## Prerequisites

### For you, the person teaching

| | Needed | Check it |
|---|---|---|
| A terminal on macOS or Linux | bash, awk, sed, sort, shasum — all preinstalled | `make -C demo tick` prints a full night |
| A projector or screen share | the demo is terminal text, so use a large font | 18pt minimum, dark-on-light reads better in a bright room |
| The two diagrams | `../../eb-city/docs/diagrams/teaching-1-the-loop.svg` and `teaching-2-the-ladder.svg` | open both before the session starts |
| 15 minutes of rehearsal | run `make tick`, `make demo-tamper`, `make demo-badmath` once each | you want to know what scrolls past |

**No API key is required.** The demo's judgment step runs in `stub` mode by default: recorded
answers, zero tokens, no network. That is a deliberate teaching decision, not a limitation —
the loop behaves identically whether the judgment comes from a model, a recorded answer, or a
person in the room, and showing that is half the lesson.

Optional: if you have the `claude` CLI installed and want a live model call, run
`JUDGE_MODE=claude make tick`. Rehearse it first. A live call can refuse, stall, or answer
differently than it did yesterday — which is itself a usable teaching moment, if you planned
for it.

### For the students

Each student brings **their own laptop** and **one LLM account — free tier is sufficient**,
any vendor. No installation, no administrator rights, no API keys.

All session materials are published online: the worksheet, the helper prompts, and the demo
walkthrough. Nothing is printed.

They will need working internet. The helper prompts in `exercise/helper-prompts.md` are the
only part of the session that depends on it.

> **One facilitation note.** The exercise was designed on paper, and paper produces more
> argument per table than screens do. With laptops open, say explicitly at the start: *one
> laptop per table for the prompts, three pairs of eyes on the page.* Otherwise you get four
> people typing and nobody deciding.

### Room

Tables of four. The exercise fails at tables of eight — one person writes and seven watch.

---

## Run order

1. Read `deck.md` end to end. It is written as prose, so you can read it as a script the
   first time you teach it and abandon it the second time.
2. Print the worksheet, one per team, plus a few spares.
3. Run `cd demo && make clean && make tick` once, an hour before, on the machine you will
   present from.
4. Follow `facilitator-guide.md` in the room.

## The demo, in one line each

```bash
cd demo
make tick          # one night: 11 invoice lines -> 9 units -> 4 judgments -> 4 proposals
make report        # what happened, from the ledger, including what it cost
make demo-tamper   # somebody edits the proof; delivery blocks; the daily sweep pages
make demo-badmath  # the judgment asserts a wrong number; the arithmetic catches it
make demo-cap      # lower the approval cap; a gate fires that never fired before
JUDGE_MODE=human make tick   # somebody in the room is the model; the loop does not notice
make demo-narrow   # a budget of three; watch four units get deferred, on purpose
make clean         # start the night over
```
