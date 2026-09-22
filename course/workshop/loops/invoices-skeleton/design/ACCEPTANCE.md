# Acceptance

This loop was built from a design that a named person accepted.

```
ACCEPTED — jobs/invoices/proposed.design
  accepted by C. ONeil, EverBetter at 2026-09-22T18:02:08
  content    84ef0d4097162b0c
```

The acceptance is of the design's **content**, not its filename. The register that
holds it is append-only and chained — `make -C ../.. verify` recomputes it.

Change `design/loop.design` and this acceptance stops covering it. Scaffolding again
will refuse until somebody accepts the new version, by name.
