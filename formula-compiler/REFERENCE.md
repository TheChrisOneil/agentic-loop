# The Gas City formula surface

What a formula can contain, established locally, for the purpose of writing a compiler
that emits them.

## What a formula is

`gc formula --help`, verbatim:

> A formula is a reusable TOML method for how multi-step work should be done (a bead is the
> work itself).

That sentence is the whole reason this is a good compile target. A design describes a method.
A formula *is* a method. The unit of work is not in either of them — it arrives as a bead.

## How this was established, and what is missing

`gc formula --help` points at `docs/reference/specs/formula-spec-v2.md`. **That file is not on
this machine** — the gc install is a single binary and ships no docs. Everything below comes
from four local sources, and each claim says which:

| Mark | Source |
|---|---|
| **probed** | `./probe.sh` — a throwaway city, one malformed formula at a time, against the installed gc |
| **corpus** | 96 unique `*.formula.toml` files on disk (576 paths, deduplicated by content) |
| **schema** | `gc formula show --json-schema` — the compiled-recipe shape |
| **help** | `gc <cmd> --help` |

Anything not marked is not established. Get the upstream spec before shipping a compiler: the
gaps below are gaps in *my* knowledge, not proof of absence.

## The file

```toml
formula = "name"                 # corpus: in every file
version = 1                      # corpus: 88 of 96
description = """..."""          # corpus: in every file — prose for humans
contract = "graph.v2"            # corpus: 78 of 96, always this value
target_required = true           # corpus: 64
extends = "other-formula"        # corpus: 49 — inheritance
internal = true                  # corpus: 40 — hide from the catalog
type = "expansion"               # corpus: 14, always this value
phase = "vapor"                  # corpus: 1
pour = <bool>                    # schema only
root_only = <bool>               # schema; probed: a formula with no steps reports Root only: true

[requires]
formula_compiler = ">=2.0.0"     # corpus: 14 — the v2 opt-in. See "Two compilers" below

[catalog]
name = "name"                    # corpus: 24
description = "one line"         # corpus: 24
```

**Not enforced (probed):** `formula` need not match the filename or `[catalog].name` — a file
named `name-mismatch.formula.toml` declaring `formula = "WRONGNAME"` compiles and reports
itself as WRONGNAME. An unknown top-level key is accepted silently.

## `[vars]`

```toml
[vars.<name>]
description = "what it is"       # corpus: on every var
default = "value"                # corpus: 259 across all files
required = true                  # corpus: 96
type = "..."                     # schema only
pattern = "..."                  # schema only — regex
enum = ["a", "b"]                # schema only
```

Substituted into step text as `{{name}}`. `gc formula show --var k=v` previews resolution;
rig-scoped `formula_vars` in `city.toml` supply defaults per rig (**help**).

**Not enforced (probed):** `{{undeclared}}` in a step description compiles clean and stays
literal. A required var with no value is listed, not refused, at `show` time.

## `[[steps]]`

```toml
[[steps]]
id = "load-inputs"               # REQUIRED (probed)
title = "Load and validate"      # REQUIRED unless using expand (probed)
description = """..."""          # the instruction body — optional (probed)
description_file = "steps/x.md"  # corpus: 188 — must resolve, or hard load error (probed)
needs = ["other-id"]             # corpus: 210 — the DAG edge
condition = "..."                # corpus: 25
expand = ...                     # corpus: 23 — late-bound expansion
expand_vars = ...                # corpus: 17
metadata = { "gc.run_target" = "gc.run-operator", "gc.provider" = "claude" }
```

`description` and `description_file` are alternatives; the corpus prefers the file (188 vs 71),
which matters for a compiler — long prompt bodies belong in their own files.

### `[steps.check]` — the deterministic gate

```toml
[steps.check]
max_attempts = 1                 # REQUIRED, >= 1 (probed)
[steps.check.check]
mode = "exec"                    # REQUIRED — only exec is supported (probed)
path = ".gc/scripts/checks/x.sh" # REQUIRED (probed)
timeout = "2m"                   # corpus: 57
```

**This is the gate primitive.** A shell script the runtime runs, not a thing the step promises
to do. `research-decision`'s gate says it outright: the citation check "must not be waived by
a model."

**Not enforced (probed):** the script at `path` need not exist. A formula referencing a check
that was never written compiles clean.

### `[steps.retry]`

```toml
[steps.retry]
max_attempts = 2
on_exhausted = "hard_fail"       # hard_fail | soft_fail (probed)
```

### `[steps.drain]` — fan-out over a convoy

```toml
[steps.drain]
formula = "item-formula"         # REQUIRED (probed)
context = "separate"             # separate | shared (probed)
member_access = "read"           # read | exclusive (probed)
on_item_failure = "skip_remaining"  # skip_remaining | continue (probed)
max_units = 10                   # corpus: 2
[steps.drain.item]
single_lane = true               # corpus: 13
```

This is the parent/item split — the formula equivalent of a batch step followed by per-unit
steps. `drain-probe-item.formula.toml` in eb-city exists precisely because the v2 spec
documents the drain step's keys but not how per-member data reaches the item formula.

### `[steps.children]` and `[template]`

`steps.children.*` (corpus: 10) and a whole `[template]` block with `template.children.*`
(corpus: 85) mirror the step keys. Templates are how the `build-*` family shares a skeleton.
**Not established:** the precise semantics of template expansion.

## `metadata` — the real semantic surface

Step behavior is carried in metadata, not in typed fields. Counts are from the corpus:

| Key | Count | What it carries |
|---|---|---|
| `gc.run_target` | 358 | which role/runner executes the step |
| `gc.build.artifact_schema` | 74 | the schema the step's artifact must satisfy |
| `gc.build.artifact_path_keys` | 74 | which output keys are paths |
| `gc.continuation_group` | 35 | session continuity across steps |
| `gc.output_json_schema` | 23 | schema enforced on the step's JSON output |
| `gc.output_json_required` | 23 | whether that output is mandatory |
| `gc.provider` | 13 | which provider runs it |
| `gc.reviewer_model`, `opt_model` | — | model selection per step |
| `gc.scope_role`, `gc.scope_ref`, `gc.scope_name` | 10/8/2 | scoping |
| `gc.on_fail` | 6 | failure routing |
| `gc.session_affinity` | 6 | session reuse |
| `gc.kind`, `gc.publisher` | 8/9 | — |

A compiler emitting formulas is mostly a **metadata generator**. The typed surface is small;
the behavior is in these keys, and they are conventions rather than a schema.

## Two compilers

`[requires] formula_compiler = ">=2.0.0"` selects the v2 compiler, and the difference is
observable (**probed**): a v2 formula with one step compiles to **two** — the compiler appends
a terminal `workflow-finalize` step depending on the last one. The same formula without
`[requires]` compiles to one step, with no finalize.

Emit v2. Know that the finalize step exists, because it will appear in every diagram and every
step count your compiler reports.

## What gc enforces

Ten rules, all reproduced by `./probe.sh`:

| # | Rule |
|---|---|
| 1 | `steps[n]: id is required` |
| 2 | `title is required (unless using expand)` |
| 3 | duplicate step id, naming both indices |
| 4 | `needs` references an unknown step |
| 5 | a dependency cycle |
| 6 | `check.max_attempts` must be >= 1 |
| 7 | `check.check.mode` — only `exec` |
| 8 | `check.check.path` is required |
| 9 | `retry.on_exhausted` — `hard_fail` or `soft_fail` |
| 10 | `drain` — `formula` required; `context` separate/shared; `member_access` read/exclusive; `on_item_failure` skip_remaining/continue |

That is a **structural** validator. It checks that the graph is well formed.

## What gc does not enforce

Also probed, and this is the important half:

| Not checked | Consequence |
|---|---|
| A formula with no steps | Compiles. Reports `Root only: true` |
| A step with no description | Compiles. An empty instruction |
| `{{undeclared_var}}` in a description | Compiles. Ships the literal braces to the agent |
| An unknown top-level key | Accepted silently. A typo'd key is a no-op |
| A check script that does not exist | Compiles. **A gate that cannot run** |
| Whether any step has a check at all | Compiles. A formula with no gates is valid |
| Whether a human ever approves anything | Compiles |
| Whether the method is any good | Not its job |

**The missing check script is the one to dwell on.** It is the formula equivalent of the
scaffolder bug that dropped a gate: a control that is declared, reported, and absent. gc will
not catch it. The compiler must.

## Where the compiler's own rules go

The loop compiler's 22 rules are about *method quality* — they are not structural, which is
exactly why they do not overlap with the ten above. Carried across:

| Loop rule | Formula compiler equivalent |
|---|---|
| V3 approver is a named person | A human gate step exists, with a `notify` var bound to a person |
| V4 exit criterion contains a figure | `[catalog]` or metadata carries one — no native field, needs a convention |
| V7 a judgment names what checks it | Every step carrying `gc.provider` has a `[steps.check]` or a downstream one |
| V13 thinking is followed by a test or gate | Same, expressed over `needs` |
| V14 at least two gates | At least two `[steps.check]` blocks |
| V15 a condition contains a number or "never" | The check script exists **and is executable** — stronger than the loop's version |
| V16 a refusal names the next human action | The check's failure output names one |
| V17 proof is written by a mechanical step | The artifact is written by a step with no `gc.provider` |
| V19 three KPIs | No native field — needs a convention |
| V21 batch before unit | Parent formula and `[steps.drain]` item formula |

Plus rules only the formula target needs:

- Every `check.check.path` resolves to a file that exists and is executable.
- Every `{{var}}` used is declared in `[vars]`.
- Every `description_file` resolves.
- `formula`, `[catalog].name` and the filename agree.
- The graph has exactly one terminal step before `workflow-finalize`.
- No step both carries `gc.provider` and writes the artifact named in `gc.build.artifact_schema`.

## Reproducing this

```bash
./probe.sh
```

Builds a city in a temp dir, never registers it, so no controller and no patrol runs against
it. The output is the rule list. Re-run it against a new gc and diff, rather than trusting
this file.
