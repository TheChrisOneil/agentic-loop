# The front door for the session. Everything else lives in demo/ and workshop/.
.PHONY: help ready ready-live demo workshop
help:
	@echo "make ready        check this machine — 37 checks, no key needed"
	@echo "make ready-live   the same, plus one real generation (spends tokens)"
	@echo "make demo         one night of the invoice loop"
	@echo "make workshop     what the workshop can do"
ready:      ; @./check.sh
ready-live: ; @./check.sh --live
demo:       ; @$(MAKE) --no-print-directory -C demo clean tick
workshop:   ; @$(MAKE) --no-print-directory -C workshop help
