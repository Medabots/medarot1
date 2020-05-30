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
  add hl, de
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  and $E0
  add 2
  ld [$c6c3], a
  ld e, a
  ld a, [hli]
  ld [$c6c2], a
  ld d, a
  push hl
  ld a, $10
  call VWFPadText
  pop hl
  ld a, [VWFCreditsRingBufferOffsetIndex]
  inc a
  ld [VWFCreditsRingBufferOffsetIndex], a
  dec a

.correctionLoop
  sub $F
  jr nc, .correctionLoop
  add $F
  inc a
  add a
  add a
  add a
  add a
  ld b, a
  ld a, $12
  rst $8 ; VWFPutStringInitFullTileLocation
  call VWFPutStringLoop

  ld a, [hli]
  ld [$c5c3], a
  ret
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop
  nop
  nop
  nop
  
  nop
  nop

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