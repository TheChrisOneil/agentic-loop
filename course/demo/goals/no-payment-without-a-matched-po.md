name: no-payment-without-a-matched-po
predicate: awk -F'\t' 'NR>1 && $2=="no_po" {print $1}' memory/findings.tsv | while read u; do test -f "outbox/$u.REFUSED.md" || exit 1; test ! -f "outbox/$u.md" || exit 1; done
born: 2026-09-21
source: the first night this loop ran — INV-7009, Meridian Consulting, $3,500 with no purchase order
status: satisfied
on-violation: page the accounts payable owner. Do not auto-repair.
retire-when: this supplier onboarding process is replaced. Retirement is a human decision, and it is logged.
