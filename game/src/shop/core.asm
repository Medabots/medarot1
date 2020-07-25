INCLUDE "game/src/common/constants.asm"

SECTION "Shop Menu State Machine", ROMX[$702C], BANK[$3]
ShopMenuStateMachine::
  ld a, [$C7F2]
  ld hl, .table
  ld d, 0
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl

.table
  dw $7086
  dw $70AC
  dw $70B7
  dw $70BF
  dw $70CD
  dw $70DF
  dw $70E8
  dw $7104
  dw $710C
  dw $711D
  dw $7134
  dw $7142
  dw $7167
  dw $7189
  dw $71A2
  dw $71BC
  dw $71BF
  dw $71F0
  dw $724A
  dw $725B
  dw $7343
  dw $735A
  dw $7363
  dw $73AD
  dw $73E5
  dw $73E8
  dw $7414
  dw ShopSellPriceDisplayState
  dw $750C
  dw $7515
  dw $75AB
  dw $75BF
  dw $75D9
  dw $75E1
  dw $75F8
  dw $7608

SECTION "Shop Menu State Machine 2", ROMX[$7446], BANK[$3]
ShopSellPriceDisplayState::
  ld b, 0
  ld a, [$C890]
  ld c, a
  call $429E
  ld a, 1
  ld [$C89A], a
  ld b, $7
  ld c, $E
  call $412D
  call $433A
  call $5516
  ld hl, $4947
  ld a, [$C88A]
  ld e, a
  ld d, 0
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$C88C]
  ld e, a
  ld d, 0
  add hl, de
  ld a, [hli]
  srl a
  ld e, a
  ld d, 0
  ld a, [$C890]
  ld b, a
  call $457A
  ld a, d
  ld [$C89B], a
  ld a, e
  ld [$C89C], a
  ld b, d
  ld c, e
  call $429E
  ld a, 1
  ld [$C89A], a
  ld b, $C
  ld c, $E
  call $412D
  call $433A ; Displays the sell price.
  ldh a, [hJPInputChanged]
  and hJPInputUp
  jr z, .upNotPressed
  ld a, [$C886]
  ld b, a
  ld a, [$C890]
  cp b
  ret nc
  ld a, 3
  ldh [$FFA1], a
  ld a, [$C890]
  inc a
  ld [$C890], a
  ret

.upNotPressed
  ldh a, [hJPInputChanged]
  and hJPInputDown
  jr z, .downNotPressed
  ld a, [$C890]
  cp 1
  ret z
  ld a, 3
  ldh [$FFA1], a
  ld a, [$C890]
  dec a
  ld [$C890], a
  ret

.downNotPressed
  ldh a, [hJPInputChanged]
  and hJPInputB
  jr z, .bNotPressed
  ld a, 6
  ldh [$FFA1], a
  ld a, $C
  ld [$C7F2], a
  ld a, [$C88B]
  ld [$C890], a
  jp $451C

.bNotPressed
  ldh a, [hJPInputChanged]
  and hJPInputA
  ret z
  ld a, [$C890]
  ld [$C88D], a
  ld a, 4
  ldh [$FFA1], a
  ld b, $E
  ld c, $7
  ld e, $68
  call JumpTable_2ca
  xor a
  ld [$C890], a
  jp $659C
