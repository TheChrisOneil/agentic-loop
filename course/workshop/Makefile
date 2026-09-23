.PHONY: help job method history show start jobs revise rules check example broken format brief diagram flow generate estimate accept status register cost verify scaffold test clean
MODEL  ?= browser-assistant
help:
	@echo "make job NAME=slug        start a job: a folder, an empty use case, your editor"
	@echo "make method               the written procedure the wrapper sends"
	@echo "make history NAME=slug    what happened on that job, in order"
	@echo "make show NAME=slug       open that job's flowchart"
	@echo "make start                the workshop — resume a job, or begin one"
	@echo "make jobs                 every job and where it stopped"
	@echo "make check DESIGN=path    validate one design"
	@echo "make diagram DESIGN=path  a Mermaid sequence diagram (validates first)"
	@echo "make flow DESIGN=path     a Mermaid flowchart, colored by step type"
	@echo "make brief DESIGN=path    write BRIEF.md and diagrams/ beside a design (svg if mmdc)"
	@echo "make generate NAME=slug UC=path   a use case becomes a design and a brief"
	@echo "make revise NAME=slug ASK=\"...\"   ask for a change; the old version is kept"
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
check:
	@[ -n "$(DESIGN)" ] || { echo "make check DESIGN=path"; exit 64; }
	@tooling/validate.sh $(DESIGN)
example: ; @tooling/validate.sh examples/invoices.design
broken:  ; @tooling/validate.sh examples/broken.design || true
rules:   ; @tooling/validate.sh --rules
format:  ; @cat tooling/schema/DESIGN-FORMAT.md
job:
	@[ -n "$(NAME)" ] || { echo "make job NAME=<slug>   e.g. make job NAME=team-7"; exit 64; }
	@mkdir -p jobs/$(NAME)
	@[ -e jobs/$(NAME)/use-case.txt ] || printf '%s\n' \
	  "# Describe the process in your own words. Delete these lines as you go." \
	  "#" \
	  "#   what the work is, and roughly how much of it there is" \
	  "#   who does it today, and what the exceptions look like" \
	  "#   what goes wrong, and what it costs when it does" \
	  "#   anything a person has to judge rather than look up" \
	  "" > jobs/$(NAME)/use-case.txt
	@echo "  jobs/$(NAME)/use-case.txt"
	@if [ -t 1 ]; then \
	   if [ -n "$$EDITOR" ]; then $$EDITOR jobs/$(NAME)/use-case.txt; \
	   elif command -v open >/dev/null; then open -t jobs/$(NAME)/use-case.txt; \
	   elif command -v nano >/dev/null; then nano jobs/$(NAME)/use-case.txt; \
	   else echo "  no editor found — open that file however you like"; fi; \
	 else echo "  (not a terminal: opened no editor)"; fi
method:  ; @cat tooling/method/GENERATE.md
history:
	@[ -n "$(NAME)" ] || { echo "make history NAME=<slug>"; exit 64; }
	@if [ -s jobs/$(NAME)/job.tsv ]; then column -t -s"$$(printf '\t')" jobs/$(NAME)/job.tsv 2>/dev/null || cat jobs/$(NAME)/job.tsv; \
	 else echo "no job called $(NAME) yet — make job NAME=$(NAME)"; fi
show:
	@[ -n "$(NAME)" ] || { echo "make show NAME=<slug>"; exit 64; }
	@if [ -f jobs/$(NAME)/diagrams/flow.svg ]; then \
	   if command -v open >/dev/null; then open jobs/$(NAME)/diagrams/flow.svg; \
	   elif command -v xdg-open >/dev/null; then xdg-open jobs/$(NAME)/diagrams/flow.svg; \
	   else echo "  jobs/$(NAME)/diagrams/flow.svg"; fi; \
	 else echo "no diagram yet — make brief DESIGN=jobs/$(NAME)/proposed.design"; fi
start:   ; @tooling/start.sh
jobs:    ; @tooling/start.sh --list
generate:
	@[ -n "$(NAME)" ] || { echo "make generate NAME=<slug> UC=<use case file>"; exit 64; }
	@[ -n "$(UC)" ]   || { echo "make generate NAME=$(NAME) UC=<use case file>"; exit 64; }
	@tooling/generate.sh --name $(NAME) --use-case $(UC)
test:    ; @tooling/tests/flow.sh && echo && tooling/tests/repair-path.sh && echo && tooling/tests/repair-budget.sh
accept:
	@[ -n "$(DESIGN)" ] && [ -n "$(BY)" ] || { echo "make accept DESIGN=<design> BY=\"Name, Role\""; exit 64; }
	@tooling/accept.sh $(DESIGN) --by "$(BY)"
status:
	@[ -n "$(DESIGN)" ] || { echo "make status DESIGN=path"; exit 64; }
	@tooling/accept.sh --status $(DESIGN)
register:; @tooling/accept.sh --list
revise:
	@[ -n "$(NAME)" ] || { echo "make revise NAME=<slug> ASK=\"what should change\""; exit 64; }
	@tooling/revise.sh $(NAME) $(ASK)
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
	@[ -n "$(DESIGN)" ] && [ -n "$(NAME)" ] || { echo "make scaffold DESIGN=<design> NAME=<folder under loops/>"; exit 64; }
	@mkdir -p loops && tooling/scaffold.sh $(DESIGN) loops/$(NAME)
brief:
	@[ -n "$(DESIGN)" ] || { echo "make brief DESIGN=path"; exit 64; }
	@tooling/brief.sh $(DESIGN)
diagram:
	@[ -n "$(DESIGN)" ] || { echo "make diagram DESIGN=path"; exit 64; }
	@tooling/render.sh $(DESIGN)
flow:
	@[ -n "$(DESIGN)" ] || { echo "make flow DESIGN=path"; exit 64; }
	@tooling/render.sh --flow $(DESIGN)
clean:   ; @rm -rf examples/diagrams examples/BRIEF.md && echo "cleaned — jobs/, loops/ and memory/ are records and are left alone"
