include Makefile.config

.PHONY: all test unit_test integ_test clean lint
.DELETE_ON_ERROR:

UNIT_TARGET := unit_test
TARGET      := $(PROGNAME).$(PROGVERS)

SRCDIR      := src
DEPSDIR     := deps
TESTDIR     := t

SRC         := $(wildcard $(SRCDIR)/*.c)
TESTS       := $(wildcard $(TESTDIR)/*.c)
UNIT_TESTS  := $(wildcard $(TESTDIR)/unit/*.c)
TEST_DEPS   := $(wildcard $(DEPSDIR)/tap.c/*.c)
DEPS        := $(filter-out $(wildcard $(DEPSDIR)/tap.c/*), $(wildcard $(DEPSDIR)/*/*.c))

CFLAGS      := -I$(DEPSDIR) -I$(SRCDIR) -Wall -Wextra -pedantic

$(TARGET):
	$(CC) $(CFLAGS) $(SRC) $(DEPS) -o $(TARGET)

all: $(TARGET)

test:
	$(MAKE) unit_test
	$(MAKE) integ_test

unit_test:
	$(CC) $(CFLAGS) $(UNIT_TESTS) $(TEST_DEPS) $(DEPS) $(filter-out $(SRCDIR)/main.c, $(SRC)) -o $(UNIT_TARGET)
	./$(UNIT_TARGET)
	$(MAKE) clean

integ_test: $(TARGET)
	./$(TESTDIR)/integ/utils/run.bash
	$(MAKE) clean

clean:
	rm -f $(UNIT_TARGET) $(TARGET)

lint:
	$(LINTER) -i $(SRC) $(TESTS)
