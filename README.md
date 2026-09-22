# Agentic Loop

Designing AI systems that don't guess: pipelines where code does the mechanical work and a
model is spent only on judgment — and the outcome is proved rather than asserted.

Built for a session at **EDGE Academy, Wichita State University**.

```
course/
  README.md              prerequisites and run order
  deck.md                the deck, in prose: every slide and what to say on it
  facilitator-guide.md    the run sheet
  exercise/              the student worksheet, helper prompts, discussion guide
  demo/                  a working loop: supplier invoices against purchase orders
  workshop/              the tool that turns a business process into one of these
```

## The class in one command

```bash
cd course/demo && make tick
```

Eleven invoice lines become nine units of work. Two close on arithmetic alone. Three are
refused before any model reads them. Four get one judgment each, and every one lands as a
proposal assigned to a named person. It runs with no API key and no network.

## The workshop

```bash
cd course/workshop && make start
```

It asks what your use case is, proposes a design with its assumptions listed first, shows you
the sequence diagram, discusses it with you, and — once a named person types *I accept* —
builds a running loop from it.

Five tools, and only one of them spends a model:

| | |
|---|---|
| `validate.sh` | 21 rules over a design. Deterministic |
| `render.sh` | design → Mermaid sequence diagram or flowchart. Deterministic |
| `generate.sh` | a described process → a validated design. **The one model call** |
| `accept.sh` | a named person, a typed phrase, an append-only chained register |
| `scaffold.sh` | a validated, accepted design → a loop that runs today |

## The idea it teaches

> An AI system you can trust in a business is mostly code, with judgment in the few places
> only judgment will do — and it proves its work rather than asking to be believed.
