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
  dw LoadNormalMenuText ; 10

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
INCLUDE "game/src/patch/tilesets.asm"

LoadInventoryTilesetAndHelpTilemap:
  push hl
  push de
  push bc
  ld hl, $8800
  ld de, PatchTilesetStartInventoryText
  ld a, [de]
  inc de
  call LoadTiles
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap

LoadNormalMenuText:
  push hl
  push de
  push bc
  ld hl, $8800
  ld de, PatchTilesetStartMapText
  ld a, [de]
  inc de
  call LoadTiles
  pop bc
  pop de
  pop hl
  jp WrapLoadTilemap