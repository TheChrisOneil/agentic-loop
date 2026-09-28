# The formula compiler. Every command a person runs is here.
SHELL := /bin/bash
OUT   ?= build
WORKSHOP ?= ../course/workshop

help:
	@echo "make compile DESIGN=<path> NAME=<formula-name>   design -> formula + checks"
	@echo "make conformance NAME=<formula-name>             ask the installed gc"
	@echo "make rules                                       the compiler's own rules"
	@echo "make probe                                       what gc enforces, derived"
	@echo "make demo                                        compile the worked example"
	@echo "make test                                        compile every example, end to end"
	@echo "make clean                                       remove $(OUT)/"

compile:
	@[ -n "$(DESIGN)" ] && [ -n "$(NAME)" ] || { echo "make compile DESIGN=<path> NAME=<formula-name>"; exit 64; }
	@tooling/compile.sh "$(DESIGN)" --name "$(NAME)" --out "$(OUT)"

rules: ; @tooling/validate-formula.sh --rules 2>/dev/null || sed -n 's/^  *fail("\(F[0-9]*\)", *"\(.*\)".*/\1  \2/p' tooling/lib/validate-formula.awk

probe: ; @./probe.sh

conformance:
	@[ -n "$(NAME)" ] || { echo "make conformance NAME=<formula-name>"; exit 64; }
	@command -v gc >/dev/null || { echo "REFUSED: gc is not installed, so nothing can confirm this compiles."; exit 1; }
	@tooling/conformance.sh "$(OUT)" "$(NAME)"

demo:
	@$(MAKE) --no-print-directory compile DESIGN=$(WORKSHOP)/examples/invoices.design NAME=invoice-reconciliation
	@$(MAKE) --no-print-directory conformance NAME=invoice-reconciliation

test: ; @./test.sh

clean: ; @rm -rf $(OUT) && echo "cleaned $(OUT)/"

.PHONY: help compile rules probe conformance demo test clean
