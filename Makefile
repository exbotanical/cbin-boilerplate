CC ?= gcc
AR ?= ar
LINTER ?= clang-format

PROG := <project>
UNIT_TARGET := unit_test

SRCDIR := src
DEPSDIR := deps
TESTDIR := t

SRC := $(wildcard $(SRCDIR)/*.c)
TEST_DEPS := $(wildcard $(DEPSDIR)/libtap/*.c)
DEPS := $(filter-out $(wildcard $(DEPSDIR)/libtap/*), $(wildcard $(DEPSDIR)/*/*.c))

CFLAGS := -I$(DEPSDIR) -Wall -Wextra -pedantic
LIBS :=

TESTS := $(wildcard $(TESTDIR)/*.c)

$(PROG):
	$(CC) $(CFLAGS) $(SRC) $(DEPS) $(LIBS) -Ideps -Isrc -o $(PROG)

test:
	$(MAKE) unit_test

unit_test:
	$(CC) $(wildcard $(TESTDIR)/unit/*.c) $(TEST_DEPS) $(DEPS) $(filter-out $(SRCDIR)/main.c, $(SRC)) -I$(SRCDIR) -I$(DEPSDIR) $(LIBS) -o $(UNIT_TARGET)
	./$(UNIT_TARGET)
	$(MAKE) clean

integ_test: $(PROG)
	./$(TESTDIR)/integ/utils/run.bash
	$(MAKE) clean

clean:
	rm -f $(UNIT_TARGET) $(PROG)

lint:
	$(LINTER) -i $(SRC) $(wildcard $(TESTDIR)/*/*.c)

.PHONY: test unit_test integ_test clean lint
