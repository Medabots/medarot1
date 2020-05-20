INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "Load Inventory Screen Help Text Tilemap", ROMX[$4673], BANK[$2]
LoadHelpTextTilemap: ; 8673 (2:4673)
  ld b, $00
  ld c, $0c
  ld e, $63
  ld a, $f ; LoadInventoryTilesetAndHelpTilemap
  rst $8
  ld a, $02
  call JumpTable_17d
  ld b, $05
  ld c, $05
  ld d, $05
  ld e, $05
  ld a, $02
  call JumpTable_309
  jp $45b1
; 0x8691

SECTION "Load Inventory Screen", ROMX[$4bdc], BANK[$2]
LoadInventoryScreen:
  ld hl, $aa00
  dec a
  ld b, $0
  ld c, a
  ld a, $e ; AddHLShiftBC5
  rst $8
  ld a, $ad
  ld [$c644], a
  psa $9862
  ld [$c645], a
  ld b, $5
.asm_8bf8
  ld a, [hli]
  or a
  ret z
  push hl
  push bc
  call JumpLoadItemList
  ld hl, cBUF01
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  call VWFPutStringAutoNarrowTo8
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0820 ; increment drawing area (b) and position (c)
  add hl, bc
  ld a, h
  cp $d0 - $8
  jr c, .no_backtrack
  ld a, $a0
.no_backtrack
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop bc
  pop hl
  ld a, [hl]
  and $80
  jp z, .asm_8c70
  ld a, [hl]
  and $7f
  ld [$c64e], a
  push hl
  push bc
  ld d, $0
  ld e, b
  sla e
  rl d
  ld hl, $4c75
  add hl, de
  rst $38
  ld a, $77
  di
  call JumpTable_16e
  ld [hli], a
  ei
  ld a, [$c64e]
  push hl
  call JumpTable_25b
  pop hl
  ld a, [$c64f]
  and $f0
  swap a
  ld b, $6b
  add b
  di
  call JumpTable_16e
  ld [hli], a
  ei
  ld a, [$c64f]
  and $f
  ld b, $6b
  add b
  di
  call JumpTable_16e
  ld [hli], a
  ei
  pop bc
  pop hl
.asm_8c70
  inc hl
  dec b
  jr nz, .asm_8bf8 ; 0x8c72 $84
  ret
  nop
  nop
; 0x8c75