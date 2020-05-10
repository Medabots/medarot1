SECTION "LCDC VBlank_IRQ", ROM0[$049B]
VBlankingIRQ::
  push af
  push bc
  push de
  push hl
  ldh a, [$FF92]
  or a
  jr z, .jpA
  ld a, [CoreStateIndex]
  ld [$C6D8], a
  ld a, [CoreSubStateIndex]
  ld [$C6D9], a

.jpA
  call $044E
  ldh a, [$FF92]
  or a
  jr nz, .setCompletedFlag
  ld a, [$C600]
  or a
  call nz,  $FF80 ; In-memory code: OAM DMA
  ei
  xor a
  ld [$C600], a

.setCompletedFlag
  ld a, 1
  ldh [$FF92], a
  call $3DF9
  pop hl
  pop de
  pop bc
  pop af
  reti
