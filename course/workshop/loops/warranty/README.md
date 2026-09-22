# Triage and adjudicate dealer warranty claims on returned hardware, routing only genuinely ambiguous claims to a product expert.

Generated from `design/loop.design`. 10 steps, 3 gates, one unit of work:
**One warranty claim, identified by claim number, for one serial number.**.

```bash
make tick     # run it now — every step is a placeholder and it still ticks end to end
make todo     # what is left to implement
make ledger   # what happened
```

## Run it before you write anything

The loop works today. Every step logs, the gates refuse one sample unit, the proof is written
and checksummed, and the ledger fills. Nothing decides anything real yet.

That is on purpose: settle the shape before you write the logic. If the flow feels wrong when
you watch it run, change `design/loop.design` and scaffold again — that is far cheaper than
discovering it after the code is written.

## Then replace the placeholders

`make todo` lists them. Each step file carries its type, its actor, and the line from the
design that describes it. Four rules hold while you work:

1. **A gate's condition stays in code.** Every gate file already has its condition in the
   header. Move it into the `if`, never into a prompt.
2. **The judgment step never writes a number a later step checks.** It interprets. It does not
   compute.
3. **The proof is written by code** and checksummed. Each record is SHA-256 checksummed over its canonical serialization, the checksum is chained to the prior record's checksum, and a nightly cron re-verifies the chain; any mismatch alerts the Warranty Operations Lead.
4. **Every refusal names the next human action.** They are already written into the gate files,
   from the design.

## What is not here yet

Standing goals, and a baseline for the KPIs in `DESIGN.md`. Both are ordinary work, and both
are the difference between a loop that runs and a loop you can defend.
