name: every-proposal-carries-a-proof
predicate: for f in outbox/*.md; do case "$f" in *REFUSED*) continue;; esac; u=$(basename "$f" .md); test -f "proof/$u.txt" || exit 1; test "$(shasum -a 256 "proof/$u.txt" | awk '{print $1}')" = "$(cat "proof/$u.sha")" || exit 1; done
born: 2026-09-21
source: the tamper demonstration
status: satisfied
on-violation: page whoever owns this loop. A proposal without an intact proof is not a proposal.
retire-when: never, while this loop runs.
