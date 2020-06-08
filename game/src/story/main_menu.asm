SECTION "Load Main Menu", ROMX[$4082], BANK[$2]
LoadMainMenuTilemap:: ; 8082 (2:4082)
  xor a
  call $42d3
  ld a, [$c5a2]
  srl a
  srl a
  srl a
  add $0d
  ld b, a
  ld a, [$c5a3]
  srl a
  srl a
  srl a
  ld c, a
  ld e, $60
  call JumpLoadTilemap
  jp $45b1
; 0x81f7

SECTION "Load Info Menu", ROMX[$41c3], BANK[$2]
LoadInfoMenuTilemap:: ; 81c3 (2:41c3)
  ld b, $01
  call $45a0
  ld a, $01
  call $42d3
  ld a, [$c5a2]
  srl a
  srl a
  srl a
  add $0c
  ld b, a
  ld a, [$c5a3]
  srl a
  srl a
  srl a
  add $03
  ld c, a
  ld e, $61
  call JumpLoadTilemap
  xor a
  ld [$c6f1], a
  ld [$c6f2], a
  ld [$c6f3], a
  jp $45b1
; 0x81f7