export LC_CTYPE=C

# User defined
TARGET := medarot
ORIGINAL := baserom.gbc
TARGET_TYPE := gbc
SOURCE_TYPE := asm
TABLE_TYPE := tbl
TMAP_TYPE := tmap
LIST_TYPE := bin
TEXT_TYPE := txt
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
TILEMAP_OUT := $(BUILD)/tilemaps
LISTS_TEXT := $(TEXT)/lists
LISTS_OUT := $(BUILD)/lists
PTRLISTS_TEXT := $(TEXT)/ptrlists
PTRLISTS_OUT := $(BUILD)/ptrlists

MODULES := core gfx story
TILEMAPS := $(notdir $(basename $(wildcard $(TILEMAP_TEXT)/*.$(TEXT_TYPE))))
LISTS := $(notdir $(basename $(wildcard $(LISTS_TEXT)/*.$(TEXT_TYPE))))

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
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE)) $(BUILD)/buffer_constants.$(SOURCE_TYPE)
TILEMAP_FILES := $(foreach FILE,$(TILEMAPS),$(TILEMAP_OUT)/$(FILE).$(TMAP_TYPE))
LISTS_FILES := $(foreach FILE,$(LISTS),$(LISTS_OUT)/$(FILE).$(LIST_TYPE))

gfx_ADDITIONAL := $(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE)
story_ADDITIONAL := $(LISTS_FILES)

all: $(TARGET_OUT)

$(TARGET_OUT): $(MODULES_OBJ)
	$(LD) -O $(ORIGINAL) -o $@ $^
	$(FIX) $(FIX_ARGS) $@
	cmp -l $(ORIGINAL) $@

.SECONDEXPANSION:
$(BUILD)/%.$(INT_TYPE): $(SRC)/%.$(SOURCE_TYPE) $(COMMON_SRC) $$(%_ADDITIONAL) $$(wildcard $(SRC)/%/*.$(SOURCE_TYPE)) | $(BUILD)
	$(CC) -o $@ $<

$(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE): $(SCRIPT)/res/tilemap_files.$(TABLE_TYPE) $(TILEMAP_FILES)
	$(PYTHON) $(SCRIPT)/update_tilemap_files.py $@

$(TILEMAP_OUT)/%.$(TMAP_TYPE): $(TILEMAP_TEXT)/%.$(TEXT_TYPE) $(SCRIPT)/res/tilesets.$(TABLE_TYPE) | $(TILEMAP_OUT)
	$(PYTHON) $(SCRIPT)/txt2tmap.py $< $@

$(BUILD)/buffer_constants.$(SOURCE_TYPE): $(SCRIPT)/res/ptrs.tbl | $(BUILD)
	$(PYTHON) $(SCRIPT)/ptrs2asm.py $^ $@

$(LISTS_OUT)/%.$(LIST_TYPE): $(LISTS_TEXT)/%.$(TEXT_TYPE) | $(LISTS_OUT)
	$(PYTHON) $(SCRIPT)/list2bin.py $< $@

list_files:  $(LISTS_FILES)

dump: dump_text dump_tilemaps dump_lists dump_ptrlists

dump_text:
	$(PYTHON) $(SCRIPT)/dump_text.py

dump_tilemaps: | $(TILEMAP_TEXT) $(TILEMAP_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilemaps.py

dump_lists: | $(LISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_lists.py

dump_ptrlists: | $(PTRLISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_ptrlists.py

clean:
	rm -r $(BUILD) $(TARGET_OUT)	

#Make directories if necessary
$(BUILD):
	mkdir -p $(BUILD)

$(TILEMAP_BIN):
	mkdir -p $(TILEMAP_BIN)

$(TILEMAP_TEXT):
	mkdir -p $(TILEMAP_TEXT)

$(TILEMAP_OUT):
	mkdir -p $(TILEMAP_OUT)

$(LISTS_TEXT):
	mkdir -p $(LISTS_TEXT)

$(PTRLISTS_TEXT):
	mkdir -p $(PTRLISTS_TEXT)

$(LISTS_OUT):
	mkdir -p $(LISTS_OUT)