.PHONY: help start jobs rules check example broken format brief diagram flow svg generate accept status register cost verify scaffold test clean
DESIGN ?= examples/invoices.design
help:
	@echo "make start                the workshop — resume a job, or begin one"
	@echo "make jobs                 every job and where it stopped"
	@echo "make check DESIGN=path    validate one design"
	@echo "make diagram DESIGN=path  a Mermaid sequence diagram (validates first)"
	@echo "make flow DESIGN=path     a Mermaid flowchart, colored by step type"
	@echo "make brief DESIGN=path    write BRIEF.md and diagrams/ beside a design"
	@echo "make svg DESIGN=path      render both beside the design in diagrams/ (needs mmdc)"
	@echo "make generate NAME=slug UC=path   a use case becomes a design and a brief"
	@echo "make accept DESIGN=path BY=\"Name, Role\"  accept a design, by name"
	@echo "make status DESIGN=path    is this exact design accepted?"
	@echo "make cost                 what every model call cost, in tokens and dollars"
	@echo "make register             the acceptance register"
	@echo "make verify               recompute the register hash chain"
	@echo "make scaffold DESIGN=path NAME=x    build a running loop into loops/x"
	@echo "make example              validate the worked example"
	@echo "make broken               a design that fails, for the session"
	@echo "make rules                the rule list, in plain language"
	@echo "make format               the design format specification"
check:   ; @tooling/validate.sh $(DESIGN)
example: ; @tooling/validate.sh examples/invoices.design
broken:  ; @tooling/validate.sh examples/broken.design || true
rules:   ; @tooling/validate.sh --rules
format:  ; @cat schema/DESIGN-FORMAT.md
start:   ; @tooling/start.sh
jobs:    ; @tooling/start.sh --list
generate:; @tooling/generate.sh --name $(NAME) --use-case $(UC)
test:    ; @tooling/tests/flow.sh && echo && tooling/tests/repair-path.sh && echo && tooling/tests/repair-budget.sh
accept:  ; @tooling/accept.sh $(DESIGN) --by "$(BY)"
status:  ; @tooling/accept.sh --status $(DESIGN)
register:; @tooling/accept.sh --list
cost:
	@[ -s memory/usage.tsv ] || { echo "no model calls recorded yet"; exit 0; }
	@column -t -s"$$(printf '\t')" memory/usage.tsv 2>/dev/null || cat memory/usage.tsv
	@awk -F'\t' 'NR>1 && $$10 ~ /^[0-9.]+$$/ {n++; s+=$$10; t+=$$6; c+=$$8} \
	  END{ if(n) printf "\n  %d priced call(s)  $$%.4f  %d output tokens  %d cache reads\n", n, s, t, c; \
	       else print "\n  no priced calls yet" }' memory/usage.tsv
verify:  ; @tooling/accept.sh --verify
scaffold:; @mkdir -p loops && tooling/scaffold.sh $(DESIGN) loops/$(NAME)
brief:   ; @tooling/brief.sh $(DESIGN)
diagram: ; @tooling/render.sh $(DESIGN)
flow:    ; @tooling/render.sh --flow $(DESIGN)
svg:
	@command -v mmdc >/dev/null || { echo "mmdc not installed — the .mmd output is still valid Mermaid."; exit 1; }
	@mkdir -p $(dir $(DESIGN))diagrams
	@tooling/render.sh $(DESIGN) > $(dir $(DESIGN))diagrams/sequence.mmd \
	  && mmdc -i $(dir $(DESIGN))diagrams/sequence.mmd -o $(dir $(DESIGN))diagrams/sequence.svg >/dev/null
	@tooling/render.sh --flow $(DESIGN) > $(dir $(DESIGN))diagrams/flow.mmd \
	  && mmdc -i $(dir $(DESIGN))diagrams/flow.mmd -o $(dir $(DESIGN))diagrams/flow.svg >/dev/null
	@echo "$(dir $(DESIGN))diagrams/sequence.svg  $(dir $(DESIGN))diagrams/flow.svg"
clean:   ; @rm -rf examples/diagrams && echo cleaned
