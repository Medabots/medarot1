INCLUDE "game/src/common/constants.asm"

SECTION "Load Inventory Screen Help Text Tilemap", ROMX[$4673], BANK[$2]
LoadHelpTextTilemap: ; 8673 (2:4673)
  ld b, $00
  ld c, $0c
  ld e, $63
  call JumpLoadTilemap
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
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld a, $98
  ld [$c644], a
  ld a, $62
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
  call JumpPutString
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop bc
  pop hl
  ld a, [hl]
  and $80
  jp z, $4c70
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
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, $77
  di
  call JumpWaitLCDController
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
  call JumpWaitLCDController
  ld [hli], a
  ei
  ld a, [$c64f]
  and $f
  ld b, $6b
  add b
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  pop bc
  pop hl
  inc hl
  dec b
  jr nz, .asm_8bf8 ; 0x8c72 $84
  ret
; 0x8c75