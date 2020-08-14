INCLUDE "game/src/common/macros.asm"

SECTION "Check save data", ROMX[$4430], BANK[$1]
CheckSaveData: ; 4430 (1:4430)
  call JumpSaveDataVerification
  ld [$c624], a
  cp $00
  jr z, .load_game
  cp $01
  jr z, .new_game
  ld b, $02 ; If we reached here, something is wrong (a not in (0, 1))
  ld c, $05
  ld e, $26
  ld a, $24 ; LoadSaveDataCorruptedTextAndLoadTilemap
  rst $08
  ld a, $04
  call JumpTable_17d
  jp JumpIncSubStateIndexWrapper
.load_game
  ld a, [$bffd]
  or a
  jr nz, .asm_445a
  ld a, $01
  ld [$c624], a
.asm_445a
  ld a, $04
  ld [CoreSubStateIndex], a
  ret
.new_game
  call JumpInitiateNewSave
  ld a, $04
  ld [CoreSubStateIndex], a
  ret
; 0x4469

SECTION "New/Load Game Screen", ROMX[$448c], BANK[$1]
LoadGameScreen:: ; 448c (1:448c)
  call JumpTable_1a7
  ld e, $28 
  ld a, [$c624] ; New Game flag (1 if yes)
  or a
  psc $9921 ; Draw Disclaimer text below box
  jr z, .draw_tilemap
  psc $98e1 ; Draw a row up if new game
  ld e, $27
.draw_tilemap
  push de
  ld b, $01
  ld hl, PatchTextDisclaimerNotice
  ld a, $13 ; LoadPatchText
  rst $8
  ld b, $b6
  ld hl, PatchTextVersion
  ld a, $14 ; LoadPatchTextFixed
  rst $8
  ld bc, $0000
  pop de
  ;call WrapLoadTilemap
  ld a, $20 ; LoadLoadGameTextAndLoadTilemap
  rst $8
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