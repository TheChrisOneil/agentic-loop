# The Gas City formula surface

What a formula can contain, for the purpose of writing a compiler that emits them.

**Primary source:** <https://docs.gascity.com/reference/specs/formula-spec-v2> — the formulas v2
contract. Read it. This file is a working digest organized as a compile target, not a
replacement for it.

**Verification:** every rule marked **[v]** below was reproduced against the installed `gc` by
`./probe.sh`, which builds a throwaway, never-registered city and feeds it one malformed
formula at a time. Counts marked **[c]** are from 96 unique `*.formula.toml` files on this
machine. Where the spec and this machine disagree, the spec wins and the difference is noted.

## What a formula is

`gc formula --help`, verbatim:

> A formula is a reusable TOML method for how multi-step work should be done (a bead is the
> work itself).

That is why it is a good compile target. A design describes a method. A formula *is* a method.
The unit of work arrives separately, as a bead.

## Start here — six things that bite a compiler author

1. **Canonical filename is `formulas/<name>.toml`.** `<name>.formula.toml` is accepted but
   **deprecated**, and the infix is not part of the name. Every file in the local corpus uses
   the deprecated form. Emit `<name>.toml`. **[v]**
2. **Opt in with `[requires] formula_compiler = ">=2.0.0"`.** `contract = "graph.v2"` is the
   deprecated opt-in and warns in `gc doctor`. 78 of 96 local files still use it. **[c]**
3. **Graph-only constructs force that opt-in.** `check`, `retry`, `drain`, `on_complete` and
   authored reserved `gc.*` metadata all fail without it.
4. **`check`, `retry` and `drain` are mutually exclusive on one step.** The full matrix is
   below. This is the single most likely thing to get wrong when generating steps. **[v]**
5. **A v2 graph grows a step.** The compiler appends `workflow-finalize`, depending on every
   sink. One authored step compiles to two. **[v]**
6. **`gc converge` accepts only v1 formulas and rejects v2.** If your compiler emits v2 — and
   it must, to use gates — convergence loops are not available to its output.

## Top-level keys

| Key | Type | Req | Notes |
|---|---|---|---|
| `formula` | string | **yes** | unique name |
| `description` | string | no | prose; `{{var}}` substituted |
| `type` | string | no | `workflow` (default), `expansion`, `aspect` |
| `extends` | []string | no | parent formulas; circular chains fail |
| `contract` | string | no | only `graph.v2`; **deprecated** |
| `phase` | string | no | `liquid` or `vapor`; v1 compat, avoid |
| `pour` | bool | no | monotonic through `extends` — an ancestor's `true` sticks |
| `[requires]` | table | no | `formula_compiler` semver; **unknown keys fail** |
| `[catalog]` | table | no | `name`, `description` — opts into catalog discovery |
| `[vars]` | table | no | declarations |
| `[[steps]]` | array | no | the work |
| `[template]` | array | no | `type = "expansion"` only |
| `[compose]` | table | no | `bond_points`, `hooks`, `expand`, `map`, `branch`, `gate`, `aspects` |
| `[[advice]]` | array | no | before/after/around transformations |
| `[[pointcuts]]` | array | no | `type = "aspect"` only |

Unknown top-level keys are silently ignored — except unknown keys inside `[requires]`, which
fail. **[v]** A typo'd top-level key is a no-op your compiler must not produce.

## `[vars]`

Two forms: `name = "default"` shorthand, or a table.

| Key | Notes |
|---|---|
| `description` | shown by `gc formula show` |
| `default` | empty string is valid |
| `required` | **cannot be combined with `default`** — `vars.x: cannot have both required:true and default` **[v]** |
| `enum` | []string, enforced at instantiation |
| `pattern` | regex, enforced at instantiation |
| `type` | `string`/`int`/`bool` — **parsed but never enforced** |

**Reserved names: `convoy_id` and `bead_id` cannot be declared** — `vars.convoy_id: formulas v2
reserved variable cannot be declared` **[v]**, and callers cannot supply them either.
`{{bead_id}}` is gone in v2; use `{{convoy_id}}`. `{{issue}}` is a deprecated alias that warns
at cook and sling.

`{{key}}` substitutes into `description`, `title`, `notes`, `assignee` and metadata *values*.

## `[[steps]]`

| Key | Req | Notes |
|---|---|---|
| `id` | **yes** | unique across the formula **including `children`** **[v]** |
| `title` | **yes** | unless `expand` is set **[v]** |
| `description` | no | the instruction body |
| `description_file` | no | path to Markdown; must resolve or v2 **fails fast** **[v]**; over 4096B it becomes a pointer |
| `notes` | no | |
| `type` | no | `task`/`bug`/`feature`/`epic`/`chore` — not validated |
| `priority` | no | int 0–4; out of range rejected |
| `tags` | no | []string. The TOML key is `tags`; `labels` is the deprecated JSON form |
| `assignee` | no | |
| `needs` / `depends_on` | no | aliases; both become blocking edges; must resolve **[v]** |
| `condition` | no | compile-time filter: `{{v}}`, `!{{v}}`, `{{v}} == x`, `{{v}} != x` |
| `children` | no | nested steps, same schema, shared id namespace |
| `expand` / `expand_vars` | no | inline expansion; the step is replaced |
| `waits_for` | no | `all-children`, `any-children`, `children-of(id)` — **inert in v0** |
| `metadata` | no | string map; `gc.*` reserved |
| `[steps.check]` | no | graph-only |
| `[steps.retry]` | no | graph-only |
| `[steps.drain]` | no | graph-only |
| `[steps.on_complete]` | no | graph-only |
| `[steps.gate]` | no | `{type, id, timeout}` — **inert in v0** |
| `[steps.loop]` | no | see below; until-loops are **inert** |
| `timeout` | no | positive Go duration; **requires `check`** |
| `[steps.tally]` | — | **removed** — `steps.tally was removed from the SDK` |

Unknown step keys are silently ignored.

### `[steps.check]` — the gate

```toml
[steps.check]
max_attempts = 1                  # required, >= 1                     [v]
[steps.check.check]
mode = "exec"                     # required, only exec supported      [v]
path = ".gc/scripts/checks/x.sh"  # required, non-empty                [v]
timeout = "2m"                    # positive duration; beats step timeout
```

**Script exit codes are the contract:**

| Exit | Meaning |
|---|---|
| `0` | pass — the step closes |
| `75` | infrastructure unreachable — re-run, **attempt not consumed** |
| other | "not yet" — consumes an attempt |

Materializes as a spec sidecar, an iteration bead, and a control bead of kind `ralph`.

### `[steps.retry]`

```toml
max_attempts = 2                  # >= 1                                [v]
on_exhausted = "hard_fail"        # hard_fail (default) | soft_fail     [v]
```

`soft_fail` closes the control as passed with `gc.final_disposition = soft_fail`.

### `[steps.drain]` — fan-out

```toml
formula = "item-formula"          # required; no {{templated}} names    [v]
context = "separate"              # separate (default) | shared         [v]
member_access = "read"            # read (default) | exclusive          [v]
max_units = 100                   # [1,100], default 100 — a hard cap
on_item_failure = "continue"      # skip_remaining | continue           [v]
continuation_group = "..."        # only with context = "shared"
[steps.drain.item]
single_lane = true                # must be true for shared drains
```

`on_item_failure` defaults differ by context: `continue` for separate, `skip_remaining` for
shared. **The item formula must itself declare the v2 contract.** Drain forces targeted
invocation.

### `[steps.on_complete]` — fan-out over structured output

`for_each` (must start with `output.`) and `bond` are required together; `parallel` (default
true) and `sequential` are mutually exclusive. Placeholders `{item}`, `{item.field}`, `{index}`.

### `[steps.loop]`

Exactly one of `count`, `until`, `range`; `body` non-empty; `max` required with `until`.
**Until-loop re-execution is inert** — the label is written, nothing reads it, exactly one
iteration runs. Use `check` for orchestrator-driven re-execution.

## The incompatibility matrix

A step may carry at most one of these, with these exclusions:

| Construct | Cannot combine with |
|---|---|
| `check` | `loop`, `on_complete`, `gate`, `expand`, `assignee`, `retry` **[v]** |
| `retry` | `check` **[v]**, `loop`, `on_complete`, `gate`, `expand`, `children` |
| `drain` | `assignee`, `expand`, `gate`, `loop`, `on_complete`, `check`, `retry`, `children`, `timeout`, authored `gc.kind` |

This is the constraint a generator will violate first. A step that both runs a model and
carries its own gate is not expressible — the gate is a separate step, or the check is the
step. That is the same conclusion the loop's V17 reaches from the other direction.

## Reserved `gc.*` metadata

| Key | Author may set | Purpose |
|---|---|---|
| `gc.run_target` | yes | routing intent; resolved to `gc.routed_to` at dispatch. 358 uses **[c]** |
| `gc.scope_name`, `gc.scope_role`, `gc.scope_ref` | yes | scoping; `scope_role` ∈ setup/member/teardown/body/control |
| `gc.on_fail` | yes | only `abort_scope` |
| `gc.continuation_group` | yes | shared execution group |
| `gc.kind` | **only `scope`, `cleanup`** | everything else is compiler-owned |
| `gc.output_json_required` | compiler | |
| `gc.output_json` | **deprecated** | `gc lint` warns; use `drain` |
| `gc.model` | **deprecated** | use `opt_model`; `gc doctor` migrates |
| `opt_*` | yes | provider options, validated at spawn |

Authoring any reserved `gc.*` key forces the v2 declaration.

`gc.kind` vocabulary — control kinds `retry`, `ralph`, `check`, `retry-eval`, `fanout`,
`drain`, `scope-check`, `workflow-finalize` are dispatched; `scope`, `cleanup`, `run`,
`retry-run` are structural and never dispatched; `workflow`, `wisp` are roots; `spec` is a
sidecar.

## What the compiled graph looks like

Flat, topologically ordered, blocking edges only. `workflow-finalize` is appended and depends
on every sink, **excluding** teardown steps (`gc.scope_role = "teardown"`), which outlive
settlement. Non-root nodes get non-blocking `tracks` edges to the root for cascade deletion.
The root is stamped `gc.kind = "workflow"` plus `gc.formula_hash` (SHA-256) and
`gc.formula_source`.

That hash is worth noting: **Gas City already content-hashes the formula.** Your acceptance
register can sign that hash rather than inventing its own.

## File resolution

`formulas/<name>.toml` (canonical) beats `<name>.formula.toml` (deprecated) beats
`<name>.formula.json` (loader-only), within a layer. Layers, lowest to highest: city packs,
city's own `formulas/`, rig packs, rig `formulas_dir`. Last wins. `[formulas].dir` in
`city.toml` is a hard error.

## What gc enforces — reproduced locally

`./probe.sh` reproduces: step `id` required; `title` required unless `expand`; duplicate id;
`needs` unresolved; dependency cycle; `check.max_attempts >= 1`; `check.check.mode` exec only;
`check.check.path` required; `on_exhausted` enum; all four drain enums; `required`+`default`
conflict; reserved variable declaration; check/retry incompatibility.

## What gc does not enforce — where your rules live

| Not checked | Consequence |
|---|---|
| A formula with no steps | compiles; `Root only: true` **[v]** |
| A step with no description | compiles; an empty instruction **[v]** |
| `{{undeclared_var}}` | compiles; ships literal braces to the agent **[v]** |
| An unknown top-level or step key | silently ignored **[v]** |
| **A check script that does not exist** | **compiles — a gate that cannot run** **[v]** |
| Whether any step has a check at all | compiles; a formula with no gates is valid |
| Whether a human approves anything | compiles |
| `vars.<name>.type` | parsed, never enforced |
| Whether the method is any good | not its job |

The missing check script is the formula equivalent of the scaffolder bug that dropped a gate:
declared, reported, absent. gc will not catch it. The compiler must.

## The compiler's own rules

Carried from the loop compiler's 22, which are about method quality and therefore do not
overlap with gc's structural set:

| Loop rule | Formula equivalent |
|---|---|
| V3 named approver | a human gate step exists with `notify` bound to a person |
| V4 exit criterion has a figure | no native field — `[catalog]` or metadata, by convention |
| V7 a judgment names its check | every step with `gc.provider`/`opt_model` has a downstream `check` step |
| V13 thinking is followed by a test | same, over `needs` |
| V14 at least two gates | at least two `[steps.check]` blocks |
| V15 a condition has a number | the check script **exists and is executable** — stronger than prose |
| V16 a refusal names the next action | the check's non-zero output names one |
| V17 proof written mechanically | the artifact step carries no provider — and the matrix enforces half of this already |
| V19 three KPIs | no native field — by convention |
| V21 batch before unit | parent formula plus `[steps.drain]` item formula |

New rules the formula target demands:

- Every `check.check.path` resolves to an existing, executable file.
- Every `{{var}}` used is declared, and is not `convoy_id` or `bead_id`.
- Every `description_file` resolves.
- `formula`, `[catalog].name` and the filename agree.
- No step carries two of `check`, `retry`, `drain`.
- Emit `[requires] formula_compiler`, never bare `contract`.
- Emit `<name>.toml`, never `<name>.formula.toml`.
- Any drain's item formula also declares v2.
- Exit 75 is reserved — a generated check script must not return it for a business failure.

## Reproducing

```bash
./probe.sh
```

Builds a city in a temp dir and never registers it, so no controller and no patrol runs
against it. Diff its output against a new `gc` rather than trusting this file.
