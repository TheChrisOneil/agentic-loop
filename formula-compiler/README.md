# The formula compiler

A described business process becomes one or more Gas City formulas, and nothing is emitted
that the compiler cannot defend.

```bash
make compile DESIGN=../course/workshop/examples/invoices.design NAME=invoice-reconciliation
make conformance NAME=invoice-reconciliation
```

## What it does

```
use case (prose)
  → design            the workshop's schema, 25 rules            [existing]
  → formula           Gas City formulas v2 TOML                  [here]
  + check scripts     one per gate, refusing until implemented   [here]
  → gc formula show   the installed gc says whether it compiles  [conformance]
```

The front half is the loop workshop's: describe a process, one model call turns it into a
design, 25 rules judge the design, a named person accepts it. This is the **back half** — a
second emitter beside the loop emitter, reading the design through **the same parser**
(`course/workshop/tooling/lib/parse.awk`), so the two backends cannot disagree about what a
design says.

## How a design becomes a formula

| Design | Formula |
|---|---|
| `@meta.use_case`, `@assumptions`, `@unit`, `@kpis` | the `description` block and `[catalog]` |
| `@meta.approver` | the `notify` var, and the seat on any human step |
| step, type `thinking`, actor `model` | a step with `gc.provider` — the only step that reasons |
| step, type `thinking`, actor `human` | a step with `[steps.gate]` — a real bead that blocks until a person closes it |
| step, any other type | a plain step, instructed to do deterministic work only |
| `@gates` row | **its own step** carrying `[steps.check]`, plus a generated check script |
| `@evidence` | the writer step is told what proof to write and how it is checksummed |

Every emitted step carries its provenance — `eb.design_step` and `eb.design_type` — so a
compiled bead can be traced back to the line of the design it came from, and F17 can tell
whether a step that claims to be a control actually has one.

**Each gate becomes a step, not a promise inside one.** A gate expressed as a sentence in a
step's prompt is a request. A gate expressed as `[steps.check] mode = "exec"` is a script the
orchestrator runs, and everything downstream waits on it. That is the whole reason this target
is better than the bash loop.

Every generated check refuses until implemented, and says so. A gate that cannot run is not a
gate, so the compiler will not pretend otherwise by emitting a passing stub.

## The seventeen rules

`gc` checks that the graph is well formed. It does not check that the method is any good, and
it accepts several things silently — a check script that does not exist, an undeclared
`{{var}}`, a formula with no controls at all. Those are the gaps these rules cover.

| | Rule |
|---|---|
| F1 | the file is `<name>.toml` — `.formula.toml` is deprecated |
| F2 | `formula`, `[catalog].name` and the filename agree |
| F3 | `[requires] formula_compiler` is present |
| F4 | no bare `contract =` — that is the deprecated opt-in |
| F5 | **every check script exists and is executable** |
| F6 | no step carries two of `check`, `retry`, `drain`, and none carries `check` with `gate` |
| F7 | every `{{var}}` is declared, and none is `convoy_id` or `bead_id` |
| F8 | no inert construct is emitted — no `until` loop, no `vars.type` |
| F9 | at least two checks. A method with fewer than two controls is not governed |
| F10 | step ids are unique |
| F11 | every `needs` resolves |
| F12 | no step needs itself |
| F13 | every step is told to close with `gc.outcome` — silence reads as failure |
| F14 | `gc.kind` is not authored, except `scope` and `cleanup` |
| F15 | *(warning)* something in the method waits for a person |
| F16 | no step both runs a model and writes its own proof |
| F17 | a step from a gate-typed design step is actually guarded by a check step |

F5 is the one that matters most. It is the dropped-gate bug, at the formula layer: a control
that is declared, reported, and absent. `gc` compiles that formula happily.

## Commands

| | |
|---|---|
| `make compile DESIGN= NAME=` | design → formula and check scripts |
| `make conformance NAME=` | ask the installed `gc` to compile it, in a throwaway city |
| `make rules` | the sixteen, from the source |
| `make probe` | what `gc` itself enforces, derived by `probe.sh` |
| `make demo` | compile the worked example and confirm it |
| `make test` | every example end to end, plus the refusals |
| `make clean` | remove `build/` |

`make test` is the pre-flight: four examples compiled, four refusals proven, and `gc` asked.

## What it does not do yet

- **One formula, not several.** `scope: batch` and `scope: unit` should become a parent formula
  and a `[steps.drain]` item formula. Today every step goes in one formula.
- **No `extends`.** Shared method skeletons are not factored out.
- **No scopes.** Setup and teardown members, and `gc.on_fail = "abort_scope"`, are not emitted,
  so cleanup has nowhere correct to live.
- **The front door is the workshop's.** `make generate` still produces a design; this compiles
  one. They are not yet a single command.

## Reading order

1. `REFERENCE.md` — the formula surface, with the spec cited and each claim's provenance.
2. `probe.sh` — what `gc` enforces, derived against whatever `gc` you have.
3. `tooling/lib/emit-formula.awk` — the mapping above, in 160 lines.
4. `tooling/lib/validate-formula.awk` — the sixteen rules.
