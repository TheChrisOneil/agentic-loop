.PHONY: help start jobs rules check example broken format diagram flow svg generate accept status register verify scaffold test clean
DESIGN ?= examples/invoices.design
help:
	@echo "make start                the workshop — resume a job, or begin one"
	@echo "make jobs                 every job and where it stopped"
	@echo "make check DESIGN=path    validate one design"
	@echo "make diagram DESIGN=path  a Mermaid sequence diagram (validates first)"
	@echo "make flow DESIGN=path     a Mermaid flowchart, colored by step type"
	@echo "make svg DESIGN=path      render both to build/ as SVG (needs mmdc)"
	@echo "make generate NAME=slug UC=path   a use case becomes a design and a brief"
	@echo "make accept DESIGN=path BY=\"Name, Role\"  accept a design, by name"
	@echo "make status DESIGN=path    is this exact design accepted?"
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
verify:  ; @tooling/accept.sh --verify
scaffold:; @mkdir -p loops && tooling/scaffold.sh $(DESIGN) loops/$(NAME)
diagram: ; @tooling/render.sh $(DESIGN)
flow:    ; @tooling/render.sh --flow $(DESIGN)
svg:
	@command -v mmdc >/dev/null || { echo "mmdc not installed — the .mmd output is still valid Mermaid."; exit 1; }
	@mkdir -p build
	@tooling/render.sh $(DESIGN) > build/sequence.mmd && mmdc -i build/sequence.mmd -o build/sequence.svg >/dev/null
	@tooling/render.sh --flow $(DESIGN) > build/flow.mmd && mmdc -i build/flow.mmd -o build/flow.svg >/dev/null
	@echo "build/sequence.svg  build/flow.svg"
clean:   ; @rm -rf build && echo cleaned
