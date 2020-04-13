export LC_CTYPE=C
export PYTHONIOENCODING=utf-8

#User defined
TARGET := medarot
ORIGINAL := baserom.gbc
TARGET_TYPE := gbc
SOURCE_TYPE := asm
DIAG_TYPE := csv
BIN_TYPE := bin
TABLE_TYPE := tbl
TMAP_TYPE := tmap
SYM_TYPE := sym
MAP_TYPE := map
TSET_SRC_TYPE := 2bpp
TSET_TYPE := malias
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
DIALOG := $(BASE)/text/dialog

LISTS_TEXT := $(TEXT)/lists
LISTS_OUT := $(BUILD)/lists
PTRLISTS_TEXT := $(TEXT)/ptrlists
PTRLISTS_OUT := $(BUILD)/ptrlists

TILEMAP_BIN := $(GAME)/tilemaps
TILEMAP_TEXT := $(TEXT)/tilemaps
TILEMAP_OUT := $(BUILD)/tilemaps
TILESET_BIN := $(GAME)/tilesets
TILESET_TEXT := $(TEXT)/tilesets
TILESET_OUT := $(BUILD)/tilesets

MODULES := core gfx story
TEXT := BattleText Snippet1 Snippet2 Snippet3 Snippet4 Snippet5 StoryText1 StoryText2 StoryText3
TILEMAPS := $(notdir $(basename $(wildcard $(TILEMAP_TEXT)/*.$(TEXT_TYPE))))
LISTS := $(notdir $(basename $(wildcard $(LISTS_TEXT)/*.$(TEXT_TYPE))))
PTRLISTS := $(notdir $(basename $(wildcard $(PTRLISTS_TEXT)/*.$(TEXT_TYPE))))
TILESETS := $(notdir $(basename $(wildcard $(TILESET_TEXT)/*.$(TSET_SRC_TYPE))))

#Compiler/Linker
CC := rgbasm
CC_ARGS :=
LD := rgblink
LD_ARGS :=
FIX := rgbfix
FIX_ARGS := -v -k 9C -l 0x33 -m 0x03 -p 0 -r 3 -t "MEDAROT KABUTO"
#End User Defined

#You shouldn't need to touch anything past this line!
TARGET_OUT := $(TARGET).$(TARGET_TYPE)
SYM_OUT := $(TARGET).$(SYM_TYPE)
MAP_OUT := $(TARGET).$(MAP_TYPE)
TARGET_SRC := $(GAME)/$(TARGET).$(SOURCE_TYPE)

INT_TYPE := o
MODULES_OBJ := $(foreach FILE,$(MODULES),$(BUILD)/$(FILE).$(INT_TYPE))
DIAG_FILES := $(foreach FILE,$(TEXT),$(DIALOG)/$(FILE).$(DIAG_TYPE))
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE)) $(BUILD)/buffer_constants.$(SOURCE_TYPE)
BIN_FILE := $(BUILD)/$(word 1, $(TEXT)).$(BIN_TYPE)
TILEMAP_FILES := $(foreach FILE,$(TILEMAPS),$(TILEMAP_OUT)/$(FILE).$(TMAP_TYPE))
TILESET_FILES := $(foreach FILE,$(TILESETS),$(TILESET_OUT)/$(FILE).$(TSET_TYPE))
LISTS_FILES := $(foreach FILE,$(LISTS),$(LISTS_OUT)/$(FILE).$(LIST_TYPE))
PTRLISTS_FILES := $(foreach FILE,$(PTRLISTS),$(PTRLISTS_OUT)/$(FILE).$(SOURCE_TYPE))

gfx_ADDITIONAL := $(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE) $(TILESET_FILES)
story_ADDITIONAL := $(LISTS_FILES) $(PTRLISTS_FILES)

all: $(TARGET_OUT)

$(TARGET_OUT): $(MODULES_OBJ)
	$(LD) -n $(SYM_OUT) -m $(MAP_OUT) -O $(ORIGINAL) -o $@ $^
	$(FIX) $(FIX_ARGS) $@
	cmp -l $(ORIGINAL) $@

#Make is a stupid spec, this is absurd
$(BIN_FILE): $(DIAG_FILES)
	$(PYTHON) scripts/csv2bin.py
	
.SECONDEXPANSION:
$(BUILD)/%.$(INT_TYPE): $(SRC)/%.$(SOURCE_TYPE) $(COMMON_SRC) $$(%_ADDITIONAL) $$(wildcard $(SRC)/%/*.$(SOURCE_TYPE)) $(BIN_FILE) | $(BUILD)
	$(CC) -o $@ $<

$(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE): $(SCRIPT)/res/tilemap_files.$(TABLE_TYPE) $(TILEMAP_FILES)
	$(PYTHON) $(SCRIPT)/update_tilemap_files.py $@

$(TILEMAP_OUT)/%.$(TMAP_TYPE): $(TILEMAP_TEXT)/%.$(TEXT_TYPE) $(SCRIPT)/res/tilemap_tilesets.$(TABLE_TYPE) | $(TILEMAP_OUT)
	$(PYTHON) $(SCRIPT)/txt2tmap.py $< $@

$(TILESET_OUT)/%.$(TSET_TYPE): $(TILESET_TEXT)/%.$(TSET_SRC_TYPE) | $(TILESET_OUT)
	$(PYTHON) $(SCRIPT)/tileset2malias.py $< $@

$(BUILD)/buffer_constants.$(SOURCE_TYPE): $(SCRIPT)/res/ptrs.tbl | $(BUILD)
	$(PYTHON) $(SCRIPT)/ptrs2asm.py $^ $@

$(LISTS_OUT)/%.$(LIST_TYPE): $(LISTS_TEXT)/%.$(TEXT_TYPE) | $(LISTS_OUT)
	$(PYTHON) $(SCRIPT)/list2bin.py $< $@

$(PTRLISTS_OUT)/%.$(SOURCE_TYPE): $(PTRLISTS_TEXT)/%.$(TEXT_TYPE) | $(PTRLISTS_OUT)
	$(PYTHON) $(SCRIPT)/ptrlist2bin.py $< $@

dump: dump_text dump_tilemaps dump_lists dump_ptrlists dump_tilesets

dump_text:
	$(PYTHON) $(SCRIPT)/dump_text.py

dump_tilemaps: | $(TILEMAP_TEXT) $(TILEMAP_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilemaps.py

dump_lists: | $(LISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_lists.py

dump_ptrlists: | $(PTRLISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_ptrlists.py

dump_tilesets: | $(TILESETS_TEXT) $(TILESET_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilesets.py

clean:
	rm -r $(BUILD) $(TARGET_OUT) $(SYM_OUT) $(MAP_OUT)	

# Rules to stop Make from deleting outputs...
list_files:  $(LISTS_FILES)
ptrlist_files: $(PTRLISTS_FILES)
tileset_files: $(TILESET_FILES)

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

$(LISTS_OUT):
	mkdir -p $(LISTS_OUT)

$(PTRLISTS_TEXT):
	mkdir -p $(PTRLISTS_TEXT)

$(PTRLISTS_OUT):
	mkdir -p $(PTRLISTS_OUT)

$(TILESET_BIN):
	mkdir -p $(TILESET_BIN)

$(TILESET_TEXT):
	mkdir -p $(TILESET_TEXT)

$(TILESET_OUT):
	mkdir -p $(TILESET_OUT)