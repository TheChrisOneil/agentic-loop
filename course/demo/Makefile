# Everything you can do to this loop, in one place.
.PHONY: tick clean units findings report trust goals demo-tamper demo-badmath demo-cap demo-narrow help
help:
	@echo "make tick          run one night of the loop"
	@echo "make report        what happened, from the ledger"
	@echo "make trust         what each kind of call has earned"
	@echo "make goals         re-check every standing goal (the daily sweep)"
	@echo "make demo-tamper   edit a proof, watch delivery block"
	@echo "make demo-badmath  a judgment that asserts a wrong number, caught by arithmetic"
	@echo "make demo-cap      lower the approval cap, watch a gate fire that never fired before"
	@echo "make demo-narrow   a budget of 3 — see what gets deferred and why"
	@echo "make clean         forget everything and start the night over"

tick: ; @./loop.sh
units: ; @column -t -s'\t' memory/units.tsv
findings: ; @column -t -s'\t' memory/findings.tsv
trust: ; @./scripts/trust-log.sh --render
goals: ; @./scripts/verify-goals.sh
report:
	@echo "--- outcome by unit ---"
	@awk -F'\t' 'NR>1 && ($$3=="deliver" || $$3=="gate_pre" || $$3=="gate_post") {printf "  %-12s %-10s %-9s %s\n",$$2,$$3,$$4,$$5}' memory/ledger.tsv
	@echo "--- what it cost ---"
	@awk -F'\t' 'NR>1 {n++; s+=$$7} END{printf "  %d model calls, $$%.4f\n", n, s+0}' memory/usage.tsv
	@echo "--- how many units never reached a model ---"
	@awk -F'\t' 'NR>1 && $$4=="closed_by_rule" {n++} END{printf "  %d closed by arithmetic alone\n", n+0}' memory/ledger.tsv

demo-tamper: tick
	@echo; echo ">>> Somebody edits the proof after the fact, to make the number read better."
	@u=$$(ls outbox/*.md | grep -v REFUSED | head -1 | xargs basename | sed 's/.md//'); \
	 echo "      (editing proof/$$u.txt)"; \
	 echo "  reviewed and agreed - no adjustment needed" >> proof/$$u.txt; \
	 ./steps/9-deliver.sh $$u || true; \
	 echo; echo ">>> and the next daily sweep finds it:"; ./scripts/verify-goals.sh || true
demo-badmath:
	@$(MAKE) --no-print-directory clean >/dev/null; JUDGE_STUB=data/judgments.badmath.tsv ./loop.sh
demo-cap:
	@$(MAKE) --no-print-directory clean >/dev/null; APPROVAL_CAP=500 ./loop.sh
demo-narrow:
	@$(MAKE) --no-print-directory clean >/dev/null; BUDGET=3 ./loop.sh
clean: ; @rm -rf memory proof outbox judgments && echo "cleaned"
