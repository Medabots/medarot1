SECTION "Draw Player Money in Menu", ROMX[$45B9], BANK[$2]
DrawPlayerMoneyInMenu:: ; 85b9 (2:45b9)
  ld b, $04
  ld c, $00
  ld e, $51
  call JumpTable_2ca
  ld a, [$c93a]
  or a
  jr nz, .asm_85cd
  ld a, [$c93b]
  or a
  ret z
.asm_85cd
  ld b, $06
  ld c, $01
  call JumpTable_1dd
  push hl
  pop bc
  ld a, [$c93a]
  ld h, a
  ld a, [$c93b]
  ld l, a
  call MapMoneyWithYenSymbol
  ret
; 0x85e2