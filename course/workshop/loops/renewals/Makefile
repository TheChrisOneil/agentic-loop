.PHONY: help tick todo trust cost ledger design clean
help:
	@echo "make tick     run one tick of this loop"
	@echo "make todo     what is still a placeholder"
	@echo "make ledger   every transition, in order"
	@echo "make trust    what each kind of call has earned"
	@echo "make cost     what it cost"
	@echo "make design   the design this was built from, re-validated"
	@echo "make clean    forget everything and start over"
tick:   ; @./loop.sh
todo:
	@echo "--- placeholders still to implement ---"
	@grep -n "TODO:" steps/*.sh | sed 's/:[[:space:]]*#/  /'
	@printf -- "--- %s remaining ---\n" "$$(grep -c 'TODO:' steps/*.sh | awk -F: '{s+=$$2} END{print s}')"
ledger: ; @column -t -s'	' memory/ledger.tsv 2>/dev/null || echo "no ledger yet — run make tick"
trust:  ; @./scripts/trust-log.sh --render
cost:   ; @column -t -s'	' memory/usage.tsv 2>/dev/null || echo "no usage yet"
design: ; @cat design/loop.design
clean:  ; @rm -rf memory outbox proof judgments && echo cleaned
