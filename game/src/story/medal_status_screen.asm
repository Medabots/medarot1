SECTION "Load Medal Stat Screen", ROMX[$5cd6], BANK[$2]
LoadMedalStatScreen:
  ld a, [$c750]
  ld hl, $5ce8
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
  ld a, [$ff00+c]
  ld e, h
  ld a, [de]
  ld e, l
  cpl
  ld e, l
  ld e, l
  ld e, l
  ld a, e
  ld e, l
  ld de, $c0c0
  call JumpTable_159
  ld b, $0
  ld c, $0
  ld e, $93
  call JumpTable_15c
  ld a, [$c725]
  ld b, a
  ld a, [$c6f4]
  ld c, a
  call $5942
  ld de, $0001
  add hl, de
  ld a, [hl]
  ld [$c5fd], a
  call JumpTable_34b
  jp $5788
  ld b, $2
  ld c, $6
  ld e, $6f
  call JumpTable_15c
  ld b, $2
  ld c, $6
  ld e, $70
  call JumpTable_15c
  jp $5788
  ld a, [$c725]
  ld b, a
  ld a, [$c6f4]
  ld c, a
  call $5942
  ld hl, $0001
  add hl, de
  ld a, [hl]
  call JumpTable_282
  ld bc, $9841
  ld hl, cBUF01
  call JumpPadTextTo8
  ld h, $0
  ld l, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call JumpPutString
  call $5e27
  jp $5788
  ld a, [$c6f5]
  or a
  jr nz, .asm_9d6f ; 0x9d61 $c
  ld b, $a
  ld c, $0
  ld e, $94
  call JumpTable_15c
  jp $5788
.asm_9d6f
  ld b, $a
  ld c, $0
  ld e, $95
  call JumpTable_15c
  jp $5788
; 0x9d7b

SECTION "Load Medal Stat Screen - Load Attributes", ROMX[$5e27], BANK[$2]
LoadMedalStatScreenAttribute:
  ld a, [$c725]
  ld b, a
  ld a, [$c6f4]
  ld c, a
  call $5942
  ld hl, $0001
  add hl, de
  ld a, [hl]
  ld hl, AttributesPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  psbc $9881, $be
  ld d, BANK(LoadMedalStatScreenAttribute)
  ld e, BANK(AttributesPtr)
  ; Checks string length for padding
  push hl
  call PadPtrTextTo8
  ld h, $0
  ld l, a
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  jp PrintPtrText
; 0x9e57