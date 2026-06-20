# Top-level Makefile for bookmark-x.
#
# Targets:
#   make test          - run the test suite (ERT, batch mode)
#   make compile       - byte-compile the source files
#   make clean         - remove .elc files
#   make -C doc        - build the user manual (info / html / pdf)

EMACS ?= emacs

CORE_FILES = bookmark-x-mac.el bookmark-x-lit.el bookmark-x-bmu.el \
             bookmark-x-1.el bookmark-x-key.el bookmark-x-preview.el \
             bookmark-x.el

.PHONY: test compile clean

test:
	$(EMACS) -Q --batch -L . -L test \
	    -l bookmark-x-mac.el \
	    -l ert \
	    -l test/run-tests.el \
	    -f ert-run-tests-batch-and-exit

compile:
	$(EMACS) -Q --batch -L . -l bookmark-x-mac.el \
	    -f batch-byte-compile $(CORE_FILES)

clean:
	rm -f *.elc
