INCLUDE "game/src/common/constants.asm"

SECTION "Skill Increase Setup", ROMX[$7353], BANK[$1]
Func_7353: ; 7353 (1:7353)
  ld hl, cBUF01
  ld b, $00
  ld c, a
  ld a, [$c64e]
  push af
  call JumpTable_336
  pop af
  ld [$c64e], a
  ld a, $d0
  ld [$a0c2], a
  ld a, [$a0c0]
  sub $03
  add $51
  ld [$a0c3], a
  ld a, $01
  call JumpSetupDialog
  jp $73ce