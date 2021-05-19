INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

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
  dw LoadLoadGameTextAndLoadTilemap ; 20
  dw LoadIntroTutorialTextAndLoadTilemap ; 21
  dw LoadNameScreenTextAndLoadTilemap ; 22
  dw LoadLinkMainMenuTextAndLoadTilemap ; 23
  dw LoadSaveDataCorruptedTextAndLoadTilemap ; 24
  dw ShopPartsMenuSellScrollUp ; 25
  dw ShopPartsMenuSellScrollDown ; 26
  dw PartTradeMenuScrollUp ; 27
  dw PartTradeMenuScrollDown ; 28
  dw LoadLuckLotteryTextAndJump2ca ; 29

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
  Load1BPPTileset $8980, PatchTilesetStartFWFY, PatchTilesetEndFWFY
  Load1BPPTileset $88D0, PatchTilesetStartFWFN, PatchTilesetEndFWFN
  Load1BPPTileset $89E0, PatchTilesetStartFWFe, PatchTilesetEndFWFe
  Load1BPPTileset $8AC0, PatchTilesetStartFWFs, PatchTilesetEndFWFs
  Load1BPPTileset $8A80, PatchTilesetStartFWFo, PatchTilesetEndFWFo
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
  call LoadTilesFrom2D
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
  Load1BPPTileset $8BA0, PatchTilesetStartDash, PatchTilesetEndDash
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
  Load1BPPTileset $8980, PatchTilesetStartFWFY, PatchTilesetEndFWFY
  Load1BPPTileset $88D0, PatchTilesetStartFWFN, PatchTilesetEndFWFN
  Load1BPPTileset $89E0, PatchTilesetStartFWFe, PatchTilesetEndFWFe
  Load1BPPTileset $8AC0, PatchTilesetStartFWFs, PatchTilesetEndFWFs
  Load1BPPTileset $8A80, PatchTilesetStartFWFo, PatchTilesetEndFWFo
  ld hl, $8F00
  ld de, PatchTilesetStartRobattleGraphics
  call LoadTilesFrom2D
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

LoadLoadGameTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartLoadGame, PatchTilesetEndLoadGame
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadIntroTutorialTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetIntroTutorial, PatchTilesetEndIntroTutorial
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadNameScreenTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $9010, PatchTilesetNameScreen, PatchTilesetEndNameScreen
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadLinkMainMenuTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $9010, PatchTilesetStartLinkMainMenuText, PatchTilesetEndLinkMainMenuText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadSaveDataCorruptedTextAndLoadTilemap:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartSaveDataCorruptedText, PatchTilesetEndSaveDataCorruptedText
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadLuckLotteryTextAndJump2ca:
  push hl
  push de
  push bc
  Load1BPPTileset $8800, PatchTilesetStartLuckLotteryText, PatchTilesetEndLuckLotteryText
  pop bc
  pop de
  pop hl
  jp JumpTable_2ca

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
  ld de, $982a
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
  
PartTradeMenuScrollUp::
  ld de, $990A
  ld hl, $994A
  call PartTradeMenuShiftLine
  ld de, $98CA
  ld hl, $990A
  call PartTradeMenuShiftLine
  ld de, $988A
  ld hl, $98CA
  call PartTradeMenuShiftLine
  ld a, [PartTradeScrollPosition]
  dec a
  ld [PartTradeScrollPosition], a
  call PartTradeCalculateLineDrawingPositionOnScroll
  psa $988A
  ld [ShopPartMapPseudoIndex], a
  ld a, $8A
  ld [ShopPartMapLocation], a
  ld a, $98
  ld [ShopPartMapLocation + 1], a
  ld a, [$C787]
  ld [PartTradeScrollNewLinePartIndex], a
  jp PartTradeMenuDrawSingle
  
PartTradeMenuScrollDown::
  ld de, $98CA
  ld hl, $988A
  call PartTradeMenuShiftLine
  ld de, $990A
  ld hl, $98CA
  call PartTradeMenuShiftLine
  ld de, $994A
  ld hl, $990A
  call PartTradeMenuShiftLine
  ld a, [PartTradeScrollPosition]
  inc a
  ld [PartTradeScrollPosition], a
  add 3
  call PartTradeCalculateLineDrawingPositionOnScroll
  psa $994A
  ld [ShopPartMapPseudoIndex], a
  ld a, $4A
  ld [ShopPartMapLocation], a
  ld a, $99
  ld [ShopPartMapLocation + 1], a
  ld a, [$C78A]
  ld [PartTradeScrollNewLinePartIndex], a
  jp PartTradeMenuDrawSingle

PartTradeCalculateLineDrawingPositionOnScroll::
  and 3
  add a
  add a
  add a
  add $A0
  ld [ShopPartDrawIndex], a
  ret

PartTradeMenuDrawSingle::
  ld a, [$C6F0]
  ld c, a
  ld a, [PartTradeScrollNewLinePartIndex]
  or a
  jr nz, .notEmpty
  ld b, 2

.clearloop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ei
  dec b
  jr nz, .clearloop

.notEmpty
  push af
  ld a, [$c6e0]
  ld [TempReturnBank], a
  ld a, $24
  ld [$c6e0], a
  pop af
  and $7F
  ld b, 0
  call JumpTable_294
  ld hl, cBUF01
  ld a, [ShopPartDrawIndex]
  ld b, a
  ld a, [ShopPartMapPseudoIndex]
  ld c, a
  ld a, [TempReturnBank]
  ld [$c6e0], a
  jp VWFPutStringAutoNarrowTo8

ShopPartsMenuSellScrollUp::
  ld de, $9904
  ld hl, $9944
  call ShopPartsMenuShiftLine
  ld de, $98C4
  ld hl, $9904
  call ShopPartsMenuShiftLine
  ld de, $9884
  ld hl, $98C4
  call ShopPartsMenuShiftLine
  call ShopPartsCalculateLineDrawingPositionOnScroll
  ld a, 4
  ld [ShopPartMapLineIndex], a
  psa $9884
  ld [ShopPartMapPseudoIndex], a
  ld a, $84
  ld [ShopPartMapLocation], a
  ld a, $98
  ld [ShopPartMapLocation + 1], a
  jp ShopPartsSellMenuDrawSingle

ShopPartsMenuSellScrollDown::
  ld de, $98C4
  ld hl, $9884
  call ShopPartsMenuShiftLine
  ld de, $9904
  ld hl, $98C4
  call ShopPartsMenuShiftLine
  ld de, $9944
  ld hl, $9904
  call ShopPartsMenuShiftLine
  call ShopPartsCalculateLineDrawingPositionOnScroll
  ld a, $A
  ld [ShopPartMapLineIndex], a
  psa $9944
  ld [ShopPartMapPseudoIndex], a
  ld a, $44
  ld [ShopPartMapLocation], a
  ld a, $99
  ld [ShopPartMapLocation + 1], a
  jp ShopPartsSellMenuDrawSingle

ShopPartsCalculateLineDrawingPositionOnScroll::
  ld a, [$C891]
  and 3
  add a
  add a
  add a
  add $B0
  ld [ShopPartDrawIndex], a
  ret

ShopPartsSellMenuDrawSingle::
  ld a, [$C886]
  ld b, a
  ld a, 3
  call ShopPartsMenuCrossBank4815
  cp $FF
  jr nz, .notEmpty

  ld a, [ShopPartMapLocation]
  ld l, a
  ld a, [ShopPartMapLocation + 1]
  ld h, a
  ld b, 7

.clearloop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  xor a
  ld [hli], a
  ld [hli], a
  ei
  dec b
  jr nz, .clearloop
  ret

.notEmpty
  push af
  ld a, [$c6e0]
  ld [TempReturnBank], a
  ld a, BANK(ShopPartsSellMenuDrawSingle)
  ld [$c6e0], a
  ld a, [$c88a]
  ld c, a
  ld a, [$c886]
  ld b, 0
  call Wrapper_78d
  ld hl, cBUF01
  ld a, [ShopPartDrawIndex]
  ld b, a
  ld a, [ShopPartMapPseudoIndex]
  ld c, a
  call VWFPutStringAutoNarrowTo8
  ld a, [ShopPartMapLocation]
  add 8
  ld l, a
  ld c, a
  ld a, [ShopPartMapLocation + 1]
  ld h, a
  ld b, a
  inc c
  push bc
  ld b, 3
  call .clearloop
  pop bc
  pop af
  ld h, 0
  ld l, a
  call WrapDrawNumber
  ld a, [ShopPartMapLineIndex]
  ld b, $11
  ld c, a
  ld e, $18
  call Wrapper_891
  ld a, [TempReturnBank]
  ld [$c6e0], a
  ret

PartTradeMenuShiftLine::
  ld b, 4
  jr ShopPartsMenuShiftLine.loop

ShopPartsMenuShiftLine::
  ld b, 7

.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, [de]
  ld [hli], a
  inc de
  ld a, [de]
  ld [hli], a
  ei
  inc de
  dec b
  jr nz, .loop
  ret

SECTION "1bpp Tilesets", ROMX[$4000], BANK[$2D]
; Tileset methods
INCLUDE "game/src/patch/include/tilesets.asm"

SECTION "Load 1BPP Tiles", ROM0[$1F6E]
ShopPartsMenuCrossBank4815::
  rst $10
  ld a, b
  call $4815 ; I have no idea what this actually does.
  push af
  ld a, $24
  rst $10
  pop af
  ret
