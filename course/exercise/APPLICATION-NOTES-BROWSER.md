# Application notes — the browser route

For anyone without the `claude` CLI. You paste into ChatGPT or Claude in a browser instead of
running the wrapper.

**Same design, same result.** Three differences, and the third is the interesting one:

1. You do the sending and the saving by hand
2. A failed design goes back to the assistant by hand, rather than automatically
3. **The cost is estimated, not measured** — a browser reports no token counts

**Part A is identical, and Part C is identical but for one command.** Follow
`APPLICATION-NOTES.md` for those. Only Part B changes, and this file replaces B2 and B3. The one
Part C difference is at the end of this file.

---

## B2 · Read the method you are about to paste

```bash
cd workshop
make method
```

A **skill** — a written procedure a model follows: what to check, in what order, what
disqualifies, what to produce. Rung 2 of the ladder from the deck.

Read it. You are about to hand it to your assistant, and it is the reason two people with the
same use case get the same shape of design.

## B3 · Build the prompt, paste it, save the reply

**Build the text to paste:**

```bash
cat tooling/method/GENERATE.md jobs/team-N/use-case.txt > /tmp/prompt.txt
```

Open `/tmp/prompt.txt`, select all, copy. Paste it into ChatGPT or Claude and send.

**The reply starts with `@meta`.** Copy it, all of it, and save it exactly as it came back:

```bash
pbpaste > jobs/team-N/proposed.design      # macOS
```

On Linux: `xclip -o > jobs/team-N/proposed.design`, or open the file in an editor and paste.

**Do not tidy it up.** The next step judges what the assistant produced, not what you would
have preferred it to produce.

**If it returns prose instead of a design,** tell it: *"Emit only the design file, starting
with `@meta`. No commentary."*

## B3b · Record what the call cost, as far as you can

```bash
make estimate NAME=team-N PROMPT=/tmp/prompt.txt REPLY=jobs/team-N/proposed.design MODEL=claude.ai
make cost
```

```
date  job     kind  model      in    out  thinking  cache_read  usd      source
…     team-N  nre   claude.ai  1602  677  unknown   unknown     unknown  estimated
```

Three things to notice, and they are the lesson:

**`source` says `estimated`.** The tokens were counted from the text at roughly four characters
each. Nobody measured them.

**There is no dollar figure.** The script will not guess one. A price it invented would sit in
the same column as a price somebody measured, and the whole purpose of the ledger is that you
can tell those apart.

**`thinking` and `cache_read` say `unknown`** — and those are where the real cost of a long
prompt lives. A browser will not tell you, so you cannot manage them.

The measured figure for this same call, from the instructor's ledger, is about **$0.22** — ten measured calls, mean $0.2275.

---

## Then rejoin the main notes

Go back to `APPLICATION-NOTES.md` at **B4 · Read what the validator said** and carry on.

One difference from there: B4 is the **first** time your design is judged, because no wrapper
validated it on the way in. A failure there is normal. Fix the design, run B4 again, and if the
assistant needs to do the fixing, paste the validator's findings back to it along with the
design.

`make history NAME=team-N` will show almost nothing on this route — the wrapper writes that
record, and you did its job by hand. That absence is itself worth noticing.

---

## Part C, on this route

C1 and C3 onward are unchanged. One command in C2's fallback does not exist for you.

**`make revise` needs the wrapper.** When the scaffolder refuses and the main notes tell you to
revise, you revise by pasting instead — hand the assistant the current design *and* the
refusal text, ask for the whole file back, and save it over `proposed.design` the same way you
did in B3. Then the remaining three steps are exactly as written:

```bash
make check  DESIGN=jobs/team-N/proposed.design
make accept DESIGN=jobs/team-N/proposed.design BY="Your Name, Your Role"
make scaffold DESIGN=jobs/team-N/proposed.design NAME=team-N
```

Accepting again is not optional here either. You changed the design, so the old signature does
not cover it.

**One refusal is more likely on this route.** The scaffolder counts the gates in your design
against the gates that reached the code, and refuses if they differ:

```
REFUSED: the design has 4 gate(s) and only 2 reached the code.
```

A hand-pasted design is the likeliest place for a gate to arrive malformed. If you see this,
nothing was left behind — the half-built loop is deleted. Go back through the revise steps
above. And say so in the room: a build that catches itself is the thing the session is about.
