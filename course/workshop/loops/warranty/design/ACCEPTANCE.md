# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — jobs/warranty/proposed.design
  accepted by R. Nakamura, Warranty Operations Lead at 2026-09-22T07:48:28
  content    0f8cd20c15287351
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `make -C ../.. verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
