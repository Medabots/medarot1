SECTION "New/Load Game Screen", ROMX[$448c], BANK[$1]
LoadGameScreen:: ; 448c (1:448c)
  call JumpTable_1a7
  ld a, [$c624]
  or a
  jr nz, .new_game
  ld b, $00
  ld c, $00
  ld e, $28
  call JumpLoadTilemap
  ld a, $01
  call DrawCursor
  ld a, $08
  call JumpTable_17d
  call JumpIncSubStateIndexWrapper
  ret
.new_game
  ld b, $00
  ld c, $00
  ld e, $27
  call JumpLoadTilemap
  ld a, $01
  call DrawCursor
  ld a, $08
  call JumpTable_17d
  call JumpIncSubStateIndexWrapper
  ret
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