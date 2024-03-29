ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    detected_OS := Windows
else
    detected_OS := $(shell uname)  # same as "uname -s"
endif
# Thank you https://stackoverflow.com/questions/714100/os-detecting-makefile

TOP := ../..

BUILD = $(TOP)/build
BIN = $(TOP)/bin

TESTERS = arraylist bignums

UNITS = testfuns vmheap vmrun vmstate vmrun vmstring value iformat vtable \
        printbuf print check-expect testfuns vmerror argparse sxread linestream
MAINS = svm-test


# LDLIBS = -lcii40

LDFLAGS = -L/usr/sup/cii40/lib64

# Module 2 adds the ability to load virtual object code, plus the svm binary

UNITS += loader iparsers tokens name itable instructions svmdebug disasm
MAINS += svm svm-loader-instructions


MAINS += svm-dis

MAINS += test-arraylist test-bignums

TESTOBJ := $(TESTERS:%=$(BUILD)/%.o)

UNITS += gcdebug vstack


OBJ := $(UNITS:%=$(BUILD)/%.o)
MOBJ := $(MAINS:%=$(BUILD)/%.o)

EXE := $(MAINS:%=$(BIN)/%)

DEPS := $(OBJ:.o=.d)

CPPFLAGS += -MMD -MP
# -Werror
CFLAGS = -std=c11 -pedantic -Wall -Wextra -g0 -I/usr/include
ifeq ($(detected_OS), Darwin  ) # yeah, you __need__ the two spaces here.
	CFLAGS += -DNOVALGRIND
endif

all: CFLAGS += -O2
all: executable

# Build executable with debug symbols and CANDEBUG flag
debug: CFLAGS += -g3 -DCANDUMP
debug: executable

debug-optimized: CFLAGS += -O2 -g3 -DCANDUMP
debug-optimized: executable

.PHONY: all obj clean
executable: $(EXE)
	@: do nothing, and say nothing about doing nothing

obj: $(OBJ) $(MOBJ)

clean:
	rm -f $(OBJ) $(MOBJ) $(DEPS) $(EXE) $(TESTOBJ)


.PHONY: show
show: 
	echo $(OBJ) $(MOBJ)

.PHONY: svm-test

svm-test: $(BIN)/svm-test

$(BIN)/svm-test: $(OBJ) $(BUILD)/svm-test.o
	gcc $(CFLAGS) -o $@ $^ -lm

.PHONY: test-arraylist
test-arraylist: $(BIN)/test-arraylist

$(BIN)/test-arraylist: $(TESTOBJ) $(BUILD)/test-arraylist.o
	gcc $(CFLAGS) -o $@ $^ -lm

.PHONY: test-bignums
test-bignums: $(BIN)/test-bignums 

$(BIN)/test-bignums: $(TESTOBJ) $(BUILD)/test-bignums.o
	gcc $(CFLAGS) -o $@ $^ -lm

.PHONY: svm

svm: $(BIN)/svm

$(BIN)/svm: $(OBJ) $(BUILD)/svm.o
	gcc $(CFLAGS) -o $@ $^ -lm

$(BIN)/svm-loader-instructions: $(OBJ) $(BUILD)/svm-loader-instructions.o
	gcc $(CFLAGS) -o $@ $^ -lm

# all: $(BUILD)/model-state.o
# all: $(BUILD)/model-run.o

# $(BUILD)/model-state.o: model/vmstate.c model/vmstate.h
# 	gcc -c -DMODEL $(CFLAGS) -Imodel -I. -o $@ model/vmstate.c
# $(BUILD)/model-run.o: model/vmrun.c model/vmstate.h
# 	gcc -c -DMODEL $(CFLAGS) -Imodel -I. -o $@ model/vmrun.c


$(BIN)/svm-dis: $(OBJ) $(BUILD)/svm-dis.o
	gcc $(CFLAGS) -o $@ $^ -lm




$(BUILD)/%.o: %.c
	gcc $(CFLAGS) -MMD -MF $(BUILD)/$*.d -o $@ -c $<

$(BUILD)/vmrun.o: vmrun.c
	gcc $(CFLAGS) -MMD -MF $(BUILD)/vmrun.d -o $@ -c $<


-include $(DEPS)
