include Makefile.config

.PHONY: all test unit_test unit_test_dev integ_test valgrind clean fmt
.DELETE_ON_ERROR:

UNIT_TARGET := unit_test
TARGET      := $(PROG)

SRCDIR      := src
INCDIR      := include
DEPSDIR     := deps
TESTDIR     := t

SRC         := $(shell find $(SRCDIR) -name "*.c")
TESTS       := $(shell find $(TESTDIR) -name "*.c")
SRC_NOMAIN  := $(filter-out $(SRCDIR)/main.c, $(SRC))
TEST_DEPS   := $(wildcard $(DEPSDIR)/libtap/*.c)
DEPS        := $(filter-out $(wildcard $(DEPSDIR)/libtap/*), $(wildcard $(DEPSDIR)/*/*.c))
UNIT_TESTS  := $(wildcard $(TESTDIR)/unit/*.c)

INCLUDES         := -I$(DEPSDIR) -I$(INCDIR)
STRICT           := -Wall -Wextra -Wno-missing-field-initializers \
 -Wno-unused-parameter -Wno-unused-function -Wno-unused-value
CFLAGS           := $(STRICT) $(INCLUDES)
PROGFLAGS        :=
UNITTEST_FLAGS   := $(CFLAGS)
LIBS             :=

all: $(SRC) $(DEPS)
	$(CC) $(CFLAGS) $(PROGFLAGS) $^ $(LIBS) -o $(TARGET)

install: all
	$(shell mkdir -p $(INSTALL_DIR)/bin)
	$(INSTALL) $(TARGET) $(INSTALL_DIR)/bin/$(TARGET)
	$(INSTALL) $(MANPAGE) $(MAN_DIR)/$(MANPAGE)

uninstall:
	$(shell rm $(INSTALL_DIR)/bin/$(TARGET))
	$(shell rm $(MAN_DIR)/$(MANPAGE))

test:
	@$(MAKE) unit_test
	@$(MAKE) integ_test

unit_test: $(UNIT_TESTS) $(DEPS) $(TEST_DEPS) $(SRC_NOMAIN)
	$(CC) $(UNITTEST_FLAGS) $^ $(LIBS) -o $(UNIT_TARGET)
	@./$(UNIT_TARGET)
	@$(MAKE) clean

unit_test_dev:
	ls $(INCDIR)/*.h $(SRCDIR)/*.{h,c} $(TESTDIR)/**/*.{h,c} | entr -s 'make -s unit_test'

integ_test: all
	@./$(TESTDIR)/integ/utils/run.bash
	@$(MAKE) clean

valgrind: CFLAGS += -g -O0 -DVALGRIND
valgrind: all
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes -s ./$(TARGET)
	@$(MAKE) clean

clean:
	@rm -f $(UNIT_TARGET) $(TARGET) .log*

fmt:
	$(FMT) -i $(SRC) $(TESTS)
