INCLUDE "game/src/common/macros.asm"

SECTION "New/Load Game Screen", ROMX[$448c], BANK[$1]
LoadGameScreen:: ; 448c (1:448c)
  call JumpTable_1a7
  ld e, $28 
  ld a, [$c624] ; New Game flag (1 if yes)
  or a
  psc $9921 ; Draw Disclaimer text below box
  jr z, .draw_tilemap
  psc $9901 ; Draw a row up if new game
  ld e, $27
.draw_tilemap
  ld b, $01
  ld hl, PatchTextDisclaimerNotice
  ld a, $13 ; LoadPatchText
  rst $8
  psbc $986b, $b4
  ld hl, PatchTextVersion
  ld a, $13
  rst $8
  ld bc, $0000
  call WrapLoadTilemap
  ld a, $01
  call DrawCursor
  ld a, $08
  call JumpTable_17d
  call JumpIncSubStateIndexWrapper
  ret
.LoadGameScreenEnd
REPT $44c3 - .LoadGameScreenEnd
  nop
ENDR
; 0x44c3
SECTION "Draw Cursor", ROMX[$46cf], BANK[$1]
DrawCursor: ; 46cf (1:46cf)
  ld [$c64e], a
  ld a, [$c5cd]
  inc a
  ld hl, $9801
.asm_46d9
  ld bc, $40
  add hl, bc
  dec a
  jr nz, .asm_46d9
  di
  call JumpWaitLCDController
  ld [hl], $fb
  ei
  ld a, [$c64e]
  or a
  ret z
  cp $01
  jr nz, .asm_46f8
  di
  call JumpWaitLCDController
  ld [hl], $f8
  ei
  ret
.asm_46f8
  di
  call JumpWaitLCDController
  ld [hl], $f9
  ei
  ret
; 0x4700