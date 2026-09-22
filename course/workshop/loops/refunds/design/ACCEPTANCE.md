# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — examples/refunds.design
  accepted by M. Okafor, Refunds Team Lead at 2026-09-22T05:48:09
  content    643dc5df6c09829e
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `../../tooling/accept.sh --verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
