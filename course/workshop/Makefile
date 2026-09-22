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
check:   ; @./validate.sh $(DESIGN)
example: ; @./validate.sh examples/invoices.design
broken:  ; @./validate.sh examples/broken.design || true
rules:   ; @./validate.sh --rules
format:  ; @cat schema/DESIGN-FORMAT.md
start:   ; @./start.sh
jobs:    ; @./start.sh --list
generate:; @./generate.sh --name $(NAME) --use-case $(UC)
test:    ; @./tests/flow.sh && echo && ./tests/repair-path.sh && echo && ./tests/repair-budget.sh
accept:  ; @./accept.sh $(DESIGN) --by "$(BY)"
status:  ; @./accept.sh --status $(DESIGN)
register:; @./accept.sh --list
verify:  ; @./accept.sh --verify
scaffold:; @mkdir -p loops && ./scaffold.sh $(DESIGN) loops/$(NAME)
diagram: ; @./render.sh $(DESIGN)
flow:    ; @./render.sh --flow $(DESIGN)
svg:
	@command -v mmdc >/dev/null || { echo "mmdc not installed — the .mmd output is still valid Mermaid."; exit 1; }
	@mkdir -p build
	@./render.sh $(DESIGN) > build/sequence.mmd && mmdc -i build/sequence.mmd -o build/sequence.svg >/dev/null
	@./render.sh --flow $(DESIGN) > build/flow.mmd && mmdc -i build/flow.mmd -o build/flow.svg >/dev/null
	@echo "build/sequence.svg  build/flow.svg"
clean:   ; @rm -rf build && echo cleaned
