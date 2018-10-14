export LC_CTYPE=C

# User defined
TARGET := medarot
ORIGINAL := baserom.gbc
TARGET_TYPE := gbc
SOURCE_TYPE := asm
PYTHON := python #Python3

BASE := .
BUILD := $(BASE)/build
SCRIPT := $(BASE)/scripts
GAME := $(BASE)/game
SRC := $(GAME)/src
COMMON := $(SRC)/common

MODULES := core gfx story

#Compiler/Linker
CC := rgbasm
CC_ARGS :=
LD := rgblink
LD_ARGS :=
FIX := rgbfix
FIX_ARGS := -v -k 9C -l 0x33 -m 0x03 -p 0 -r 3 -t "MEDAROT KABUTO"
# End User Defined

#You shouldn't need to touch anything past this line!
TARGET_OUT := $(TARGET).$(TARGET_TYPE)
TARGET_SRC := $(GAME)/$(TARGET).$(SOURCE_TYPE)

INT_TYPE := o
MODULES_OBJ := $(foreach FILE,$(MODULES),$(BUILD)/$(FILE).$(INT_TYPE))
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE))

all: $(TARGET_OUT)

$(TARGET_OUT): $(MODULES_OBJ)
	$(LD) -O $(ORIGINAL) -o $@ $^
	$(FIX) $(FIX_ARGS) $@
	cmp -l $(ORIGINAL) $@

.SECONDEXPANSION:
$(BUILD)/%.$(INT_TYPE): $(SRC)/%.$(SOURCE_TYPE) $$(wildcard $(SRC)/%/*.$(SOURCE_TYPE)) $(BUILD) $(COMMON_SRC)
	$(CC) -o $@ $<

clean:
	rm -rf $(BUILD) $(TARGET_OUT)

dump:
	$(PYTHON) $(SCRIPT)/dump_text.py
	$(PYTHON) $(SCRIPT)/dump_tilemaps.py

#Make directories if necessary
$(BUILD):
	mkdir $(BUILD)
