INCLUDE "game/src/common/constants.asm"

SECTION "Load Parts Trade Menu", ROMX[$5A0E], BANK[$7]
LoadPartsTradeMenuScrollUp::
  ld a, [$C6F1]
  or a
  ret nz
  call $5953
  or a
  ret nz
  call $5994
  call LoadPartsTradeMenu
  ret

LoadPartsTradeMenuScrollDown::
  ld a, [$C6F1]
  cp 3
  ret nz
  call $59AA
  or a
  ret nz
  call $59EF
  call LoadPartsTradeMenu
  ret

LoadPartsTradeMenu::
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
