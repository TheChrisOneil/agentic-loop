# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — examples/renewals.design
  accepted by J. Lindqvist, Commercial Counsel at 2026-09-22T05:49:22
  content    d286a5bfff21c719
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `make -C ../.. verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
