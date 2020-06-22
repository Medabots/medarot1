INCLUDE "game/src/common/constants.asm"

SECTION "User Functions (Hack)", ROMX[$4000], BANK[$24]
HackPredef::
  push af
  ld a, h
  ld [TempH], a
  ld a, l
  ld [TempL], a
  pop af
  ld hl, HackPredefTable
  rst $30
  push hl ; Change return pointer to Hack function
  ld a, [TempH]
  ld h, a
  ld a, [TempL]
  ld l, a
  ret

HackPredefTable:
  dw VWFPadTextInit ;0
  dw GetTextOffset ;1
  dw ZeroTextOffset ;2
  dw VWFCountCharForCentring ;3
  dw VWFPutStringInit ;4
  dw VWFWriteCharLimited ;5
  dw VWFMapRenderedString ; 6
  dw SetInitialName ; 7
  dw SetNextChar ; 8
  dw VWFCalculateCentredTextOffsets ; 9
  dw LeftShiftBC ; A
  dw LeftShiftBC5 ; B
  dw VWFCalculateRightAlignedTextOffsets ; C
  dw VWFCalculateAutoNarrow ; D
  dw AddHLShiftBC5 ; E
  dw LoadInventoryTilesetAndHelpTilemap ; F
  dw LoadNormalMenuTextAndLoadTilemap ; 10
  dw LoadShopTilesetAndBuySellTilemap ; 11
  dw VWFPutStringInitFullTileLocation ; 12
  dw LoadPatchText ; 13
  dw LoadPatchTextFixedTopRight ; 14
  dw LoadMainMenuTilesetAndLoadTilemap ; 15
  dw LoadMainMenuTileset ; 16
  dw LoadMainMenuTilesetWithGraphics ; 17
  dw LoadSaveScreenTextAndLoadTilemap ; 18
  dw LoadMedalScreenTextAndLoadTilemap ; 19
  dw LoadPartsScreenTextAndLoadTilemap ; 1A
  dw LoadMedarotScreenFontAndLoadTilemap ; 1B
  dw LoadPartsInfoTextAndLoadTilemap ; 1C
  dw LoadRobottleMedarotSelectTextAndLoadTilemap ; 1D
  dw LoadRobottleText ; 1E
  dw LoadMinimalPartScreenAndLoadTilemap ; 1f

; bc = [WTextOffsetHi][$c6c0]
GetTextOffset:
  ld a, [$c6c0]
  ld c, a
  ld a, [WTextOffsetHi]
  ld b, a
  ret

ZeroTextOffset:
  xor a
  ld [$c6c0], a
  ld [WTextOffsetHi], a
  ld [FlagClearText], a
  ld [FlagNewLine], a
  ret

hLineMax           EQU $11 ;Max offset from start of line
hLineOffset        EQU $20 ;Bytes between line tiles
hLineCount         EQU $04 ;Total number of lines
hLineVRAMStart     EQU $9C00 ;Initial Tile VRAM location

SetInitialName: ; TODO: In the future, we might be able to just set this as a loop and pull it from a build obj for different language support
  ld a, $87 ; H
  ld [hli], a
  ld a, $a2 ; i
  ld [hli], a
  ld a, $a4 ; k
  ld [hli], a
  ld a, $9a ; a
  ld [hli], a
  ld a, $ab ; r
  ld [hli], a
  ld a, $ae ; u
  ld [hli], a
  ld a, $50 ; EOL
  ld [hli], a
  xor a
  ld [hli], a
  ld [hli], a
  ld a, $6
  ld [$c5ce], a
  ret

SetNextChar: ; Override next character based on flags
  ld a, [FlagDo4C]
  cp $0
  jr z, .return
  ld a, [NextChar]
  cp $4c
  jr z, .is_4c
  ld a, $4c
  ld [TmpChar], a
  ld hl, TmpChar
.return
  ret
.is_4c
  xor a
  ld [FlagDo4C], a
  ret

; bc = bc << l
LeftShiftBC:
.loop
  sla c
  rl b
  dec l
  jr nz, .loop
.return
  ret

; bc = bc << 5
LeftShiftBC5:
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ret

AddHLShiftBC5:
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ret

; Tileset methods
INCLUDE "game/src/patch/include/tilesets.asm"

Load1BPPTiles:
; hl is the vram address to write to.
; de is the address to copy from.
; b is the number of tiles to copy.
  ld c, 8
.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, [de]
  ld [hli], a
  ld [hli], a

  ei

  inc de
  dec c
  jr nz, .loop
  dec b
  jr nz, Load1BPPTiles

  ret

Load1BPPTileset: MACRO
  ld hl, \1
  ld de, \2
  ld b, (\3 - \2) / $8
  call Load1BPPTiles
  ENDM

LoadInventoryTilesetAndHelpTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartInventoryText, PatchTilesetEndInventoryText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadNormalMenuTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMapText, PatchTilesetEndMapText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadShopTilesetAndBuySellTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartShopText, PatchTilesetEndShopText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadMainMenuTilesetAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMainMenuText, PatchTilesetEndMainMenuText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadMainMenuTileset:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMainMenuText, PatchTilesetEndMainMenuText
  pop bc
  pop de
  pop hl
  ret

LoadMainMenuTilesetWithGraphics: ; A little lazy here, but it'll work
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMainMenuText, PatchTilesetEndMainMenuText
  ld hl, $8F00
  ld de, PatchTilesetStartMainMenuGraphics
  ld a, [de]
  inc de
  call LoadTiles
  pop bc
  pop de
  pop hl
  ret

LoadSaveScreenTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartSaveScreenText, PatchTilesetEndSaveScreenText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadMedalScreenTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMedalScreenText, PatchTilesetEndMedalScreenText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadPartsScreenTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartPartsListText, PatchTilesetEndPartsListText
  Load1BPPTileset $9110, PatchTilesetStartPartsInfoText, PatchTilesetEndPartsInfoText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadMedarotScreenFontAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMedarotScreenText, PatchTilesetEndMedarotScreenText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadPartsInfoTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $9110, PatchTilesetStartPartsInfoText, PatchTilesetEndPartsInfoText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadRobottleMedarotSelectTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartRobottlesMedarotSelectText, PatchTilesetEndRobottlesMedarotSelectText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadRobottleText:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartRobottlesText, PatchTilesetEndRobottlesText
  Load1BPPTileset $8BA0, PatchTilesetStartDash, PatchTilesetEndDash
  ld hl, $8F00
  ld de, PatchTilesetStartRobattleGraphics
  ld a, [de]
  inc de
  call LoadTiles
  pop bc
  pop de
  pop hl
  ret

LoadMinimalPartScreenAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartMinimalEquipScreenText, PatchTilesetEndMinimalEquipScreenText
  Load1BPPTileset $8BA0, PatchTilesetStartDash, PatchTilesetEndDash
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

INCLUDE "game/src/patch/include/patch_text.asm"

GetPatchTextLength:
  push de
  push bc
  xor a
  ld [VWFNextWordLength], a
  push hl
.measure_text_loop
  ld a, [hl]
  cp $50
  jr z, .return
  cp $49
  jr z, .return
  call VWFMeasureCharacter
  jr .measure_text_loop
.return
  pop hl
  pop bc
  pop de
  ld a, [VWFNextWordLength]
  rra
  rra
  rra
  and $1f
  inc a
  ret

LoadPatchText:
; hl = Text Pointer in this bank
; bc = bc for VWFPutString (set with psbc)
.loop
  call GetPatchTextLength
  push af
  push bc
  call VWFPutString
  pop bc
  pop af
  push hl
  ld h, a ; Tiles used
  ld l, $10 ; Next line
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  ld a, [hl]
  cp $50 ; [hl] will only be $50 once we're done
  jr nz, .loop

  ret

LoadPatchTextFixedTopRight:
; hl = Text Pointer in this bank
; b = tile drawing index
  ld de, $980b
.loop
  call GetPatchTextLength
  ld [VWFTileLength], a
  push bc
  call VWFPutStringInitFullTileLocation
  pop bc
  push bc
  push de
  call VWFPutStringLoop
  pop de
  pop bc
  ld a, [VWFTileLength] ; increment tile drawing index
  add b
  ld b, a
  push hl
  ld hl, $0020 ; next line
  add hl, de
  ld d, h
  ld e, l
  pop hl
  ld a, [hl]
  cp $50 ; [hl] will only be $50 once we're done
  jr nz, .loop
  ret
