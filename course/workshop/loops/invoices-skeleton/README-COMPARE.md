# The same design, twice

This folder was scaffolded from `../../jobs/invoices/proposed.design`. **`course/demo/` is the
finished version of that same design**, written by hand before the scaffolder existed.

The whole chain is there to read: `jobs/invoices/use-case.txt` says what the process is,
`proposed.design` is the design, `BRIEF.md` and `diagrams/` present it, `design/ACCEPTANCE.md`
in this folder records who signed for it, and these `steps/` are what came out.

**One thing to be straight about:** that design was written by hand to describe the working
loop, and the use case was written afterwards to say what the loop is for. The order was
design-then-description, not description-then-design. `jobs/invoices/job.tsv` records that.

So the two are the before and after of the question students ask last: *what does it look like
when you actually fill a step in?*

```bash
make tick                                    # this skeleton runs
diff steps/6-verify.sh ../../../demo/steps/6-verify.sh
```

## The structure is identical

Nine steps, same ids, same names, same types — the scaffolder produced the same nine files the
hand-written loop has:

```
1-decompose   2-match   3-select   4-gate-pre   5-judge
6-verify      7-gate-post   8-prove   9-deliver
```

## The work that remains, measured

Lines of code, comments and blanks excluded:

| Step | Skeleton | Working | You write |
|---|---|---|---|
| 1 decompose | 7 | 31 | 24 |
| 2 match | 7 | 48 | 41 |
| 3 select | 7 | 15 | 8 |
| 4 gate-pre | 20 | 38 | 18 |
| 5 judge | 32 | 41 | 9 |
| 6 verify | 7 | 32 | 25 |
| 7 gate-post | 20 | 13 | **−7** |
| 8 prove | 21 | 28 | 7 |
| 9 deliver | 7 | 37 | 30 |
| **Total** | **128** | **283** | **155** |

Three things worth saying out loud from that table.

**The scaffold is 45% of the finished loop.** Not a stub — the ledger, the gates' conditions
and refusal text, the proof and its checksum, and the judgment step's three modes are all
written. What remains is the domain logic: the arithmetic, the matching, the screening.

**The two most expensive steps are `match` and `deliver`** — 41 and 30 lines. Both are
mechanical. The judgment step needs 9 more lines, and most of that is the prompt.

**Step 7 is negative.** The scaffolded gate is *longer* than the working one, because the
scaffolder writes a general refusal path and the real gate turned out to need less. The
generated code is not always a floor.

## What this shows a room

Put the two files side by side on the projector:

```bash
diff steps/2-match.sh ../../../demo/steps/2-match.sh
```

The skeleton already knows this step is **mechanical**, that it runs **per batch**, what it is
**for**, and that it must write to the ledger. It does not know how to reconcile an invoice
against a purchase order. That is the line between what a design can settle and what a person
still has to do — and it is exactly where the hour's argument lands.
