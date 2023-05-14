CC ?= gcc
LINTER ?= clang-format

SRCDIR := src
DEPSDIR := deps
TESTDIR := t

TARGET := <project>
TEST_TARGET := test

SRC := $(wildcard $(SRCDIR)/*.c)
TEST_DEPS := $(wildcard $(DEPSDIR)/tap.c/*.c)
DEPS := $(filter-out $(wildcard $(DEPSDIR)/tap.c/*), $(wildcard $(DEPSDIR)/*/*.c))

CFLAGS := -Wall -Wextra -pedantic -std=c17
LIBS :=

$(TARGET):
	$(CC) $(CFLAGS) $(SRC) $(DEPS) $(LIBS) -o $(TARGET)

clean:
	rm -f $(OBJ) $(STATIC_TARGET) $(DYNAMIC_TARGET) $(EXAMPLE_TARGET) $(TEST_TARGET)

lint:
	$(LINTER) -i $(wildcard $(SRCDIR)/*) $(wildcard $(TESTDIR)/*)

.PHONY: clean lint
