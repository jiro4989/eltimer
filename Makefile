CMD := emacs -Q --batch -L src -L test
SRC := src/eltimer.el
UNIT_SRC := test/eltimer-test.el

.PHONY: test
test: $(SRC) $(UNIT_SRC)
	$(CMD) -l test/eltimer-test.el -f ert-run-tests-batch-and-exit
