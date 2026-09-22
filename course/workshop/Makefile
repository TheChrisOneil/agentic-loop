.PHONY: help start jobs rules check example broken format brief diagram flow generate estimate accept status register cost verify scaffold test clean
DESIGN ?= examples/invoices.design
MODEL  ?= browser-assistant
help:
	@echo "make start                the workshop — resume a job, or begin one"
	@echo "make jobs                 every job and where it stopped"
	@echo "make check DESIGN=path    validate one design"
	@echo "make diagram DESIGN=path  a Mermaid sequence diagram (validates first)"
	@echo "make flow DESIGN=path     a Mermaid flowchart, colored by step type"
	@echo "make brief DESIGN=path    write BRIEF.md and diagrams/ beside a design (svg if mmdc)"
	@echo "make generate NAME=slug UC=path   a use case becomes a design and a brief"
	@echo "make accept DESIGN=path BY=\"Name, Role\"  accept a design, by name"
	@echo "make status DESIGN=path    is this exact design accepted?"
	@echo "make cost                 what every model call cost, in tokens and dollars"
	@echo "make estimate NAME=slug PROMPT=f REPLY=f   record a pasted call, estimated"
	@echo "make register             the acceptance register"
	@echo "make verify               recompute the register hash chain"
	@echo "make scaffold DESIGN=path NAME=x    build a running loop into loops/x"
	@echo "make example              validate the worked example"
	@echo "make broken               a design that fails, for the session"
	@echo "make rules                the rule list, in plain language"
	@echo "make format               the design format specification"
	@echo "make test                 the whole pipeline, with a stub model — no key needed"
	@echo "make clean                remove anything make brief left beside a design"
check:   ; @tooling/validate.sh $(DESIGN)
example: ; @tooling/validate.sh examples/invoices.design
broken:  ; @tooling/validate.sh examples/broken.design || true
rules:   ; @tooling/validate.sh --rules
format:  ; @cat tooling/schema/DESIGN-FORMAT.md
start:   ; @tooling/start.sh
jobs:    ; @tooling/start.sh --list
generate:
	@[ -n "$(NAME)" ] || { echo "make generate NAME=<slug> UC=<use case file>"; exit 64; }
	@[ -n "$(UC)" ]   || { echo "make generate NAME=$(NAME) UC=<use case file>"; exit 64; }
	@tooling/generate.sh --name $(NAME) --use-case $(UC)
test:    ; @tooling/tests/flow.sh && echo && tooling/tests/repair-path.sh && echo && tooling/tests/repair-budget.sh
accept:
	@[ -n "$(BY)" ] || { echo "make accept DESIGN=<design> BY=\"Name, Role\""; exit 64; }
	@tooling/accept.sh $(DESIGN) --by "$(BY)"
status:  ; @tooling/accept.sh --status $(DESIGN)
register:; @tooling/accept.sh --list
estimate:
	@[ -n "$(NAME)" ] && [ -n "$(PROMPT)" ] && [ -n "$(REPLY)" ] || \
	  { echo "make estimate NAME=<slug> PROMPT=<prompt file> REPLY=<design file>"; exit 64; }
	@tooling/cost-estimate.sh $(NAME) $(PROMPT) $(REPLY) "$(MODEL)"
cost:
	@if [ ! -s memory/usage.tsv ]; then echo "no model calls recorded yet"; else \
	   column -t -s"$$(printf '\t')" memory/usage.tsv 2>/dev/null || cat memory/usage.tsv; \
	   awk -F'\t' 'NR>1 && $$11 ~ /^[0-9.]+$$/ { n[$$3]++; s[$$3]+=$$11 } \
	     END{ printf "\n  %-4s %2d call(s)  $$%.4f   designing the loop, paid once\n", "NRE", n["nre"]+0, s["nre"]+0; \
	          printf "  %-4s %2d call(s)  $$%.4f   running it, per unit of work\n", "RUN", n["run"]+0, s["run"]+0; \
	          if (n["run"]) printf "  cost per unit of work: $$%.4f\n", s["run"]/n["run"]; \
	          else print "  cost per unit of work: not yet measured — no run-time calls recorded" }' memory/usage.tsv; \
	 fi
verify:  ; @tooling/accept.sh --verify
scaffold:
	@[ -n "$(NAME)" ] || { echo "make scaffold DESIGN=<design> NAME=<folder under loops/>"; exit 64; }
	@mkdir -p loops && tooling/scaffold.sh $(DESIGN) loops/$(NAME)
brief:   ; @tooling/brief.sh $(DESIGN)
diagram: ; @tooling/render.sh $(DESIGN)
flow:    ; @tooling/render.sh --flow $(DESIGN)
clean:   ; @rm -rf examples/diagrams examples/BRIEF.md && echo "cleaned — jobs/, loops/ and memory/ are records and are left alone"
