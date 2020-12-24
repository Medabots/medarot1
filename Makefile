export LC_CTYPE=C
export PYTHONIOENCODING=utf-8

VERSIONS := kabuto kuwagata kabuto_portraits kuwagata_portraits
OUTPUT_PREFIX := medarot_
ORIGINAL_PREFIX := baserom_
ROM_TYPE := gb
SOURCE_TYPE := asm
INT_TYPE := o
DIAG_TYPE := csv
BIN_TYPE := bin
TABLE_TYPE := tbl
TMAP_TYPE := tmap
SYM_TYPE := sym
MAP_TYPE := map
RAW_TSET_SRC_TYPE := png
TSET_SRC_TYPE := 2bpp
TSET_TYPE := malias
VWF_TSET_SRC_TYPE := 1bpp
VWF_TSET_TYPE := vwffont
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
DIALOG := $(TEXT)/dialog
CREDITS := $(TEXT)/credits

LISTS_TEXT := $(TEXT)/lists
LISTS_OUT := $(BUILD)/lists
PTRLISTS_TEXT := $(TEXT)/ptrlists
PTRLISTS_OUT := $(BUILD)/ptrlists
# For added patch-specific messages, unrelated to the game specifically
PATCH_TEXT := $(TEXT)/patch
PATCH_TEXT_OUT := $(BUILD)/patch

TILEMAP_BIN := $(GAME)/tilemaps
TILEMAP_TEXT := $(TEXT)/tilemaps
TILEMAP_OUT := $(BUILD)/tilemaps
TILESET_BIN := $(GAME)/tilesets
TILESET_TEXT := $(TEXT)/tilesets
TILESET_OUT := $(BUILD)/tilesets
TILESET_UNCOMPRESSED_TEXT := $(TILESET_TEXT)/nomalias
PATCH_TILESET_TEXT := $(TILESET_TEXT)/patch
PATCH_TILESET_OUT := $(TILESET_OUT)/patch
PATCH_PORTRAITS_TEXT := $(PATCH_TILESET_TEXT)/portraits
PATCH_PORTRAITS_OUT := $(PATCH_TILESET_OUT)/portraits

MODULES := core gfx story menu shop robattle titlescreen link patch
TEXT := BattleText Snippet1 Snippet2 Snippet3 Snippet4 Snippet5 StoryText1 StoryText2 StoryText3

# Toolchain
CC := rgbasm
CC_ARGS :=
LD := rgblink
LD_ARGS :=
FIX := rgbfix
FIX_ARGS :=
CCGFX := rgbgfx
CCGFX_ARGS :=

# Helper
TOUPPER = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

# Inputs
ORIGINALS := $(foreach VERSION,$(VERSIONS),$(BASE)/$(ORIGINAL_PREFIX)$(VERSION).$(ROM_TYPE))

# Outputs (used by clean)
TARGETS := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(ROM_TYPE))
SYM_OUT := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(SYM_TYPE))
MAP_OUT := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(MAP_TYPE))

# Sources
DIALOG_FILES := $(foreach FILE,$(TEXT),$(DIALOG)/$(FILE).$(DIAG_TYPE))
CREDIT_FILES := $(wildcard $(CREDITS)/*.$(DIAG_TYPE))
TILEMAPS := $(notdir $(basename $(wildcard $(TILEMAP_TEXT)/*.$(TEXT_TYPE))))
LISTS := $(notdir $(basename $(wildcard $(LISTS_TEXT)/*.$(TEXT_TYPE))))
PTRLISTS := $(notdir $(basename $(wildcard $(PTRLISTS_TEXT)/*.$(TEXT_TYPE))))
TILESETS := $(notdir $(basename $(wildcard $(TILESET_TEXT)/*.$(RAW_TSET_SRC_TYPE))))
UNCOMPRESSED_TILESETS := $(notdir $(basename $(wildcard $(TILESET_UNCOMPRESSED_TEXT)/*.$(RAW_TSET_SRC_TYPE))))
OBJNAMES := $(foreach MODULE,$(MODULES),$(addprefix $(MODULE)., $(addsuffix .$(INT_TYPE), $(notdir $(basename $(wildcard $(SRC)/$(MODULE)/*.$(SOURCE_TYPE)))))))
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE)) $(BUILD)/buffer_constants.$(SOURCE_TYPE)
PATCH_TEXT_TILESETS := $(notdir $(basename $(wildcard $(PATCH_TILESET_TEXT)/*.$(VWF_TSET_SRC_TYPE).$(RAW_TSET_SRC_TYPE)))) # text-only -> 1bpp to save space
PATCH_TILESETS := $(filter-out $(PATCH_TEXT_TILESETS), $(notdir $(basename $(wildcard $(PATCH_TILESET_TEXT)/*.$(RAW_TSET_SRC_TYPE)))))
PATCH_PORTRAIT_TILESETS := $(notdir $(basename $(wildcard $(PATCH_PORTRAITS_TEXT)/*.$(RAW_TSET_SRC_TYPE))))
PATCH_TEXT_FILES := $(notdir $(basename $(wildcard $(PATCH_TEXT)/*.$(TEXT_TYPE))))

# Intermediates
OBJECTS := $(foreach OBJECT,$(OBJNAMES), $(addprefix $(BUILD)/,$(OBJECT)))
BASE_BIN_FILE := $(BUILD)/$(word 1, $(TEXT))
CREDITS_BIN_FILE := $(BUILD)/$(basename $(word 1, $(notdir $(CREDIT_FILES)))).$(BIN_TYPE)
BIN_FILES := $(foreach VERSION,$(VERSIONS),$(BASE_BIN_FILE)_$(VERSION).$(BIN_TYPE)) # One script call generates all bin files, so we just look at the first one
TILEMAP_FILES := $(foreach FILE,$(TILEMAPS),$(TILEMAP_OUT)/$(FILE).$(TMAP_TYPE))
TILESET_FILES := $(foreach FILE,$(TILESETS),$(TILESET_OUT)/$(FILE).$(TSET_TYPE))
UNCOMPRESSED_TILESET_FILES := $(foreach FILE,$(UNCOMPRESSED_TILESETS),$(TILESET_OUT)/$(FILE).$(TSET_SRC_TYPE))
LISTS_FILES := $(foreach VERSION,$(VERSIONS),$(foreach FILE,$(LISTS),$(LISTS_OUT)/$(FILE)_$(VERSION).$(LIST_TYPE)))
PTRLISTS_FILES := $(foreach VERSION,$(VERSIONS),$(foreach FILE,$(PTRLISTS),$(PTRLISTS_OUT)/$(FILE)_$(VERSION).$(SOURCE_TYPE)))
PATCH_TEXT_TILESET_FILES := $(foreach FILE,$(PATCH_TEXT_TILESETS),$(PATCH_TILESET_OUT)/$(FILE))
PATCH_TILESET_FILES := $(foreach FILE,$(PATCH_TILESETS),$(PATCH_TILESET_OUT)/$(FILE).$(TSET_TYPE))
PATCH_PORTRAIT_TILESET_FILES := $(foreach FILE,$(PATCH_PORTRAIT_TILESETS),$(PATCH_PORTRAITS_OUT)/$(FILE).$(TSET_SRC_TYPE))
PATCH_BIN_FILES := $(foreach FILE,$(PATCH_TEXT_FILES),$(PATCH_TEXT_OUT)/$(FILE).$(BIN_TYPE))

# Additional dependencies, per module granularity (i.e. story, gfx, core) or per file granularity (e.g. story_text_tables_ADDITIONAL)
shared_ADDITIONAL := $(LISTS_FILES) $(BIN_FILES) $(PTRLISTS_FILES) $(wildcard $(SRC)/version/*.$(SOURCE_TYPE))
gfx_ADDITIONAL := $(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE) $(TILESET_FILES)
story_ADDITIONAL := $(PTRLISTS_FILES) $(LISTS_FILES) $(UNCOMPRESSED_TILESET_FILES) $(CREDITS_BIN_FILE)
menu_medal_screen_ADDITIONAL := $(UNCOMPRESSED_TILESET_FILES)

# Manually add MainDialog as a special case for map text reloading
patch_ADDITIONAL :=
patch_hack_ADDITIONAL := $(PATCH_TILESET_FILES) $(TILESET_OUT)/MainDialog.malias $(PATCH_BIN_FILES) $(PATCH_TEXT_TILESET_FILES)
patch_vwf_ADDITIONAL := $(PATCH_TEXT_TILESET_FILES) 
patch_locations_ADDITIONAL := $(PTRLISTS_OUT)/Locations.$(SOURCE_TYPE)

portraits_ADDITIONAL := $(PATCH_PORTRAIT_TILESET_FILES)

.PHONY: all clean default $(VERSIONS)
default: kabuto
all: $(VERSIONS)

# Support building specific versions
# Unfortunately make has no real good way to do this dynamically from VERSIONS so we just manually set CURVERSION here to propagate to the rgbasm call
kabuto: CURVERSION:=kabuto
kuwagata: CURVERSION:=kuwagata
# Use underscores to rely on the same dependencies as a base, but rely on new changes
# Must be in the format 'version_specialty'
kabuto_%: CURVERSION:=kabuto
kuwagata_%: CURVERSION:=kuwagata
kabuto_portraits: FEATURE:=PORTRAITS
kuwagata_portraits: FEATURE:=PORTRAITS

$(VERSIONS): %: $(OUTPUT_PREFIX)%.$(ROM_TYPE)

# $| is a hack, we cannot have any other order-only prerequisites
.SECONDEXPANSION:
$(BASE)/$(OUTPUT_PREFIX)%.$(ROM_TYPE): $(OBJECTS) \
	$$(addprefix $(BUILD)/$$*., $$(addsuffix .$(INT_TYPE), $$(notdir $$(basename $$(wildcard $(SRC)/$$*/*.$(SOURCE_TYPE)))))) \
	$$(addprefix $(BUILD)/$$*., $$(addsuffix .$(INT_TYPE), $$(notdir $$(basename $$(wildcard $(SRC)/$$(firstword $$(subst _, ,$$*))/*.$(SOURCE_TYPE)))))) \
	$$(addprefix $(BUILD)/$$(lastword $$(subst _, ,$$*))., $$(addsuffix .$(INT_TYPE), $$(notdir $$(basename $$(wildcard $(SRC)/$$(lastword $$(subst _, ,$$*))/*.$(SOURCE_TYPE)))))) \
	| $(BASE)/$(ORIGINAL_PREFIX)$$(firstword $$(subst _, ,$$*)).$(ROM_TYPE)
	
	$(LD) $(LD_ARGS) -n $(OUTPUT_PREFIX)$*.$(SYM_TYPE) -m $(OUTPUT_PREFIX)$*.$(MAP_TYPE) -O $| -o $@ $^
	$(FIX) $(FIX_ARGS) -v -k 9C -l 0x33 -m 0x13 -p 0 -r 3 $@ -t "MEDAROT $(call TOUPPER,$(CURVERSION))"

# Treat version.bin specially
# SHORT_HASH is set in CI
$(PATCH_TEXT_OUT)/version.$(BIN_TYPE): $(PATCH_TEXT)/version.$(TEXT_TYPE) $(PATCH_TEXT)/text_version.$(TEXT_TYPE) | $(PATCH_TEXT_OUT)
	cat $^ | tr -d "\n" > $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
	echo "" >> $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
ifdef SHORT_HASH
	echo "${SHORT_HASH}" >> $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
endif
	date +%Y-%m-%d >> $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
ifndef PIPELINE_NUMBER
	echo 'Build CUSTOM' >> $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
else
	echo 'Build ${PIPELINE_NUMBER}' >> $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE)
endif
	$(PYTHON) $(SCRIPT)/patchtext2bin.py $(PATCH_TEXT_OUT)/version.$(TEXT_TYPE) $@

# Don't delete intermediate files
.SECONDEXPANSION:
.SECONDARY:
$(BUILD)/%.$(INT_TYPE): $(SRC)/$$(firstword $$(subst _, ,$$(firstword $$(subst ., ,$$*))))/$$(lastword $$(subst ., ,$$*)).$(SOURCE_TYPE) $(COMMON_SRC) $(shared_ADDITIONAL) $$(wildcard $(SRC)/$$(firstword $$(subst ., ,$$*))/include/*.$(SOURCE_TYPE)) $$($$(firstword $$(subst ., ,$$*))_ADDITIONAL) $$($$(firstword $$(subst ., ,$$*))_$$(lastword $$(subst ., ,$$*))_ADDITIONAL) | $(BUILD)
	$(CC) $(CC_ARGS) -DGAMEVERSION=$(CURVERSION) -DFEATURE_$(FEATURE) -o $@ $<

$(BUILD)/buffer_constants.$(SOURCE_TYPE): $(SCRIPT)/res/ptrs.tbl | $(BUILD)
	$(PYTHON) $(SCRIPT)/ptrs2asm.py $^ $@

$(TILEMAP_OUT)/tilemap_files.$(SOURCE_TYPE): $(SCRIPT)/res/tilemap_files.$(TABLE_TYPE) $(TILEMAP_FILES) | $(TILEMAP_OUT)
	$(PYTHON) $(SCRIPT)/update_tilemap_files.py $@

$(TILEMAP_OUT)/%.$(TMAP_TYPE): $(TILEMAP_TEXT)/%.$(TEXT_TYPE) $(SCRIPT)/res/tilemap_tilesets.$(TABLE_TYPE) | $(TILEMAP_OUT)
	$(PYTHON) $(SCRIPT)/txt2tmap.py $< $@

$(TILESET_OUT)/%.$(TSET_SRC_TYPE): $(TILESET_UNCOMPRESSED_TEXT)/%.$(RAW_TSET_SRC_TYPE) | $(TILESET_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 2 -o $@ $<

$(TILESET_OUT)/%.$(TSET_SRC_TYPE): $(TILESET_TEXT)/%.$(RAW_TSET_SRC_TYPE) | $(TILESET_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 2 -o $@ $<

$(TILESET_OUT)/%.$(TSET_TYPE): $(TILESET_OUT)/%.$(TSET_SRC_TYPE) | $(TILESET_OUT)
	$(PYTHON) $(SCRIPT)/tileset2malias.py $< $@

$(PATCH_TILESET_OUT)/%.$(VWF_TSET_TYPE): $(PATCH_TILESET_TEXT)/%.$(VWF_TSET_SRC_TYPE) | $(PATCH_TILESET_OUT)
	cp $< $@

$(PATCH_TILESET_OUT)/%.$(TSET_TYPE): $(PATCH_TILESET_OUT)/%.$(TSET_SRC_TYPE) | $(PATCH_TILESET_OUT)
	$(PYTHON) $(SCRIPT)/tileset2malias.py $< $@

$(PATCH_TILESET_OUT)/%.$(VWF_TSET_SRC_TYPE): $(PATCH_TILESET_TEXT)/%.$(VWF_TSET_SRC_TYPE).$(RAW_TSET_SRC_TYPE) | $(PATCH_TILESET_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 1 -o $@ $<

$(PATCH_TILESET_OUT)/%.$(TSET_SRC_TYPE): $(PATCH_TILESET_TEXT)/%.$(RAW_TSET_SRC_TYPE) | $(PATCH_TILESET_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 2 -o $@ $<

$(PATCH_PORTRAITS_OUT)/%.$(TSET_SRC_TYPE): $(PATCH_PORTRAITS_TEXT)/%.$(RAW_TSET_SRC_TYPE) | $(PATCH_PORTRAITS_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 2 -o $@ $<

$(PATCH_TEXT_OUT)/%.$(BIN_TYPE): $(PATCH_TEXT)/%.$(TEXT_TYPE) | $(PATCH_TEXT_OUT)
	$(PYTHON) $(SCRIPT)/patchtext2bin.py $< $@

.SECONDEXPANSION:
$(LISTS_OUT)/%.$(LIST_TYPE): $(LISTS_TEXT)/$$(word 1, $$(subst _, ,$$*)).$(TEXT_TYPE) | $(LISTS_OUT)
	$(PYTHON) $(SCRIPT)/list2bin.py $< $@ $(word 2, $(subst _, ,$*))

$(PTRLISTS_OUT)/%.$(SOURCE_TYPE): $(PTRLISTS_TEXT)/$$(word 1, $$(subst _, ,$$*)).$(TEXT_TYPE) | $(PTRLISTS_OUT)
	$(PYTHON) $(SCRIPT)/ptrlist2bin.py $< $@ $(word 2, $(subst _, ,$*))

$(BASE_BIN_FILE)_%.$(BIN_TYPE): $(DIALOG_FILES) $(BUILD)/buffer_constants.$(SOURCE_TYPE)
	$(PYTHON) scripts/csv2bin.py $*

$(CREDITS_BIN_FILE): $(CREDIT_FILES) $(SRC)/story/credits.asm
	$(PYTHON) scripts/credits2bin.py

dump: dump_text dump_tilemaps dump_lists dump_ptrlists dump_credits

dump_text:
	$(PYTHON) $(SCRIPT)/dump_text.py

dump_credits:
	$(PYTHON) $(SCRIPT)/dump_credits.py

dump_tilemaps: | $(TILEMAP_TEXT) $(TILEMAP_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilemaps.py

dump_lists: | $(LISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_lists.py

dump_ptrlists: | $(PTRLISTS_TEXT)
	$(PYTHON) $(SCRIPT)/dump_ptrlists.py

dump_tilesets: | $(TILESETS_TEXT) $(TILESET_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilesets.py

clean:
	rm -r $(BUILD) $(TARGETS) $(SYM_OUT) $(MAP_OUT) || exit 0

# Rules to stop Make from deleting outputs...
list_files:  $(LISTS_FILES)
ptrlist_files: $(PTRLISTS_FILES)
tileset_files: $(TILESET_FILES)
vwf_tileset_files: $(VWF_TILESET_FILES)
patch_tileset_files: $(PATCH_TILESET_FILES)
patch_portrait_files: $(PATCH_PORTRAIT_TILESET_FILES)

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

$(PATCH_TILESET_OUT):
	mkdir -p $(PATCH_TILESET_OUT)

$(PATCH_PORTRAITS_OUT):
	mkdir -p $(PATCH_PORTRAITS_OUT)

$(PATCH_TEXT_OUT):
	mkdir -p $(PATCH_TEXT_OUT)