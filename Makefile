export LC_CTYPE=C

# User defined
TARGET := medarot
ORIGINAL := baserom.gbc
TARGET_TYPE := gbc
SOURCE_TYPE := asm
PYTHON := python3

BASE := .
BUILD := $(BASE)/build
SCRIPT := $(BASE)/scripts
GAME := $(BASE)/game
SRC := $(GAME)/src
TEXT := $(BASE)/text
COMMON := $(SRC)/common
TILEMAP_BIN := $(GAME)/tilemaps
TILEMAP_TEXT := $(TEXT)/tilemaps

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

# TODO: The dependency chain here is "wrong"...
.SECONDEXPANSION:
$(BUILD)/%.$(INT_TYPE): $(SRC)/%.$(SOURCE_TYPE) $$(wildcard $(SRC)/%/*.$(SOURCE_TYPE)) $(BUILD) $(COMMON_SRC) $(TILEMAP_BIN)/tilemap_files.asm
	$(CC) -o $@ $<

$(TILEMAP_BIN)/tilemap_files.asm: $(SCRIPT)/res/tilemaps.tbl $(wildcard $(TILEMAP_BIN)/*.tmap)
	$(PYTHON) $(SCRIPT)/update_tilemap_files.py

dump: dump_text dump_tilemaps

dump_text:
	$(PYTHON) $(SCRIPT)/dump_text.py

dump_tilemaps: $(TILEMAP_BIN) $(TILEMAP_TEXT)
	$(PYTHON) $(SCRIPT)/dump_tilemaps.py

clean:
	rm -rf $(BUILD) $(TARGET_OUT)	

#Make directories if necessary
$(BUILD):
	mkdir -p $(BUILD)

$(TILEMAP_BIN):
	mkdir -p $(TILEMAP_BIN)

$(TILEMAP_TEXT):
	mkdir -p $(TILEMAP_TEXT)