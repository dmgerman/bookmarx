# Build the Bookmark-X Info manual.
#
# Targets:
#   make           - build bookmark-x.info
#   make html      - also build bookmark-x.html
#   make pdf       - also build bookmark-x.pdf (requires texi2pdf)
#   make clean     - remove generated files

MAKEINFO ?= makeinfo
TEXI2PDF ?= texi2pdf

INFO  = bookmark-x.info
HTML  = bookmark-x.html
PDF   = bookmark-x.pdf
TEXI  = bookmark-x.texi

.PHONY: all html pdf clean

all: $(INFO)

$(INFO): $(TEXI)
	$(MAKEINFO) $(TEXI) -o $@

html: $(HTML)

$(HTML): $(TEXI)
	$(MAKEINFO) --html --no-split $(TEXI) -o $@

pdf: $(PDF)

$(PDF): $(TEXI)
	$(TEXI2PDF) --clean $(TEXI) -o $@

clean:
	rm -f $(INFO) $(HTML) $(PDF) *.aux *.cp *.fn *.fns *.ky *.log \
	      *.pg *.toc *.tp *.vr *.vrs
