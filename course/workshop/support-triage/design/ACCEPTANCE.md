# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — examples/support-triage.design
  accepted by D. Aluko, Support Duty Manager at 2026-09-22T05:48:53
  content    7e0572b8db0e7753
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `../accept.sh --verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
