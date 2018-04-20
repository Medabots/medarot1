export LC_CTYPE=C
export PYTHONIOENCODING=utf-8

#User defined
TARGET := medarot
ORIGINAL := baserom.gbc
TARGET_TYPE := gbc
SOURCE_TYPE := asm
TEXT_TYPE := csv
BIN_TYPE := bin
PYTHON := python3

BASE := .
BUILD := $(BASE)/build
GAME := $(BASE)/game
SRC := $(GAME)/src
COMMON := $(SRC)/common
DIALOG := $(BASE)/text/dialog

MODULES := core gfx story patch
TEXT := BattleText Snippet1 Snippet2 Snippet3 Snippet4 Snippet5 StoryText1 StoryText2 StoryText3

#TODO: This should actually be configurable 

#Compiler/Linker
CC := rgbasm
CC_ARGS :=
LD := rgblink
LD_ARGS :=
FIX := rgbfix
FIX_ARGS := -v -k 9C -l 0x33 -m 0x13 -p 0 -r 3 -t "MEDAROT KABUTO"
#End User Defined

#You shouldn't need to touch anything past this line!
TARGET_OUT := $(TARGET).$(TARGET_TYPE)
TARGET_SRC := $(GAME)/$(TARGET).$(SOURCE_TYPE)

INT_TYPE := o
MODULES_OBJ := $(foreach FILE,$(MODULES),$(BUILD)/$(FILE).$(INT_TYPE))
TEXT_FILES := $(foreach FILE,$(TEXT),$(DIALOG)/$(FILE).$(TEXT_TYPE))
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE))
BIN_FILE := $(BUILD)/$(word 1, $(TEXT)).$(BIN_TYPE)

all: $(TARGET_OUT)

$(TARGET_OUT): $(MODULES_OBJ)
	$(LD) -O $(ORIGINAL) -o $@ $^
	$(FIX) $(FIX_ARGS) $@

#Make is a stupid spec, this is absurd
$(BIN_FILE): $(TEXT_FILES)
	$(PYTHON) scripts/csv2bin.py
	
.SECONDEXPANSION:
$(BUILD)/%.$(INT_TYPE): $(SRC)/%.$(SOURCE_TYPE) $$(wildcard $(SRC)/%/*.$(SOURCE_TYPE)) $(BUILD) $(COMMON_SRC) $(BIN_FILE)
	$(CC) -o $@ $<
	
clean:
	rm -rf $(BUILD) $(TARGET_OUT)

#Make directories if necessary
$(BUILD): 
	mkdir $(BUILD)

