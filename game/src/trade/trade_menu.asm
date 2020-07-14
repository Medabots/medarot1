INCLUDE "game/src/common/constants.asm"

SECTION "Load Parts Trade Menu", ROMX[$5a31], BANK[$7]
LoadPartsTradeMenu:
  ld b, 8
  ld c, 2
  ld e, $BA
  call JumpLoadTilemap
  ld a, [$C6F0]
  ld c, a
  ld a, [$C787]
  or a
  ret z

.partA
  and $7F
  ld b, 0
  call JumpTable_294
  ld hl, cBUF01
  ld bc, $988A
  call JumpPutString
  ld a, [$C6F0]
  ld c, a
  ld a, [$C788]
  or a
  ret z

.partB
  and $7F
  ld b, 0
  call JumpTable_294
  ld hl, cBUF01
  ld bc, $98CA
  call JumpPutString
  ld a, [$C6F0]
  ld c, a
  ld a, [$C789]
  or a
  ret z

.partC
  and $7F
  ld b, 0
  call JumpTable_294
  ld hl, cBUF01
  ld bc, $990A
  call JumpPutString
  ld a, [$C6F0]
  ld c, a
  ld a, [$C78A]
  or a
  ret z

.partD
  and $7F
  ld b, 0
  call JumpTable_294
  ld hl, cBUF01
  ld bc, $994A
  call JumpPutString
  ret
; 0x5a9f
