
RESULTS_NAME = graphviz

SHELL = /bin/bash
ALL_GV = $(wildcard *.gv)
ALL_HTML = $(patsubst %.gv,tmp/$(RESULTS_NAME)/%.html,$(ALL_GV))
ZIP = tmp/$(RESULTS_NAME).zip

.PHONY: default
default: first $(ZIP)
	@ printf 'begin========================\n'
	@ set
	@ printf 'end========================\n'

.PHONY: first
first:
	mkdir -p out tmp/$(RESULTS_NAME)

tmp/$(RESULTS_NAME)/%.html: tmp/%.map tmp/%.svg.base64 generic.html.m4
	m4 -P -DM_NAME=$* generic.html.m4 > $@

tmp/%.map: tmp/%.map.orig map.sed
	sed -f map.sed $< > $@

tmp/%.map.orig tmp/%.svg: %.gv
	dot -Tsvg -otmp/$*.svg -Tcmapx -otmp/$*.map.orig $<

tmp/%.svg.base64: tmp/%.svg
	base64 $< > $@

$(ZIP): $(ALL_HTML)
	cd tmp; zip -r -9 $(RESULTS_NAME).zip $(RESULTS_NAME)

.PHONY: clean
clean:
	$(RM) -r out tmp
	find . -type f -name '*~' -print0 | xargs -0 $(RM)

.SECONDARY:
