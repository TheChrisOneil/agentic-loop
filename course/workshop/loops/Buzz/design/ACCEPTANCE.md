# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — jobs/Buzz/proposed.design
  accepted by Buzz, The CTO at 2026-09-22T18:40:55
  content    9dbdf0ec515d8096
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `make -C ../.. verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
