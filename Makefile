include Makefile.config

.PHONY: all test unit_test integ_test clean fmt
.DELETE_ON_ERROR:

UNIT_TARGET := unit_test
TARGET      := $(PROGNAME).$(PROGVERS)

SRCDIR      := src
DEPSDIR     := deps
TESTDIR     := t

SRC         := $(wildcard $(SRCDIR)/*.c)
SRC_NOMAIN  := $(filter-out $(SRCDIR)/main.c, $(SRC))
TESTS       := $(wildcard $(TESTDIR)/*.c)
UNIT_TESTS  := $(wildcard $(TESTDIR)/unit/*.c)
TEST_DEPS   := $(wildcard $(DEPSDIR)/tap.c/*.c)
DEPS        := $(filter-out $(wildcard $(DEPSDIR)/tap.c/*), $(wildcard $(DEPSDIR)/*/*.c))

INCLUDES    := -I$(DEPSDIR) -I$(SRCDIR)
LIBS        :=
CFLAGS      := -Wall -Wextra -pedantic $(INCLUDES)

all: $(SRC) $(DEPS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

test:
	@$(MAKE) unit_test
	@$(MAKE) integ_test

unit_test: $(UNIT_TESTS) $(TEST_DEPS) $(DEPS) $(SRC_NOMAIN)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $(UNIT_TARGET)
	@./$(UNIT_TARGET)
	@$(MAKE) clean

integ_test: all
	@./$(TESTDIR)/integ/utils/run.bash
	@$(MAKE) clean

clean:
	@rm -f $(UNIT_TARGET) $(TARGET)

fmt:
	@$(FMT) -i $(SRC) $(TESTS)
