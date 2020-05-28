SECTION "Credits", ROMX[$52ed], BANK[$16]
Credits:
  INCBIN "build/Credits.bin"
CreditsBinEnd: ; Unused space
REPT $6000 - CreditsBinEnd
  db 0
ENDR

SECTION "Load Credit Text", ROMX[$51d2], BANK[$16]
LoadCreditText:
  ld d, $0
  ld hl, Credits
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  ld [$c6c3], a
  ld a, [hli]
  ld [$c6c2], a
.asm_51e8
  ld a, [hli]
  cp $4f
  jp z, .asm_5236
  push hl
  ld d, a
  ld a, $40
  sub d
  jp c, .asm_521a
  ld hl, $5277
  ld c, d
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  push hl
  push af
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  pop af
  di
  call JumpTable_16e
  ld [hl], a
  ei
  pop hl
  ld a, [hl]
  ld d, a
.asm_521a
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld a, d
  di
  call JumpTable_16e
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  pop hl
  jp .asm_51e8
.asm_5236
  ld a, [hli]
  ld [$c5c3], a
  ret
DrawUnknown: ; Draws something, not sure what
  ld a, [$c5a3]
  sub $20
  and $f0
  ld e, a
  ld d, $0
  sla e
  rl d
  sla e
  rl d
  ld hl, $9800
  add hl, de
  push hl
  ld bc, $0014
.asm_59255
  xor a
  di
  call JumpTable_16e
  ld [hli], a
  ei
  dec bc
  ld a, c
  or b
  jr nz, .asm_59255 ; 0x5925f $f4
  pop hl
  ld de, $0020
  add hl, de
  ld bc, $0014
.asm_5269
  xor a
  di
  call JumpTable_16e
  ld [hli], a
  ei
  dec bc
  ld a, c
  or b
  jp nz, .asm_5269
  ret
; 0x59277
; It's all data beyond here