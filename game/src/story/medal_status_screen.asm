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
  call $0159
  ld b, $0
  ld c, $0
  ld e, $93
  call $015c
  ld a, [$c725]
  ld b, a
  ld a, [$c6f4]
  ld c, a
  call $5942
  ld de, $0001
  add hl, de
  ld a, [hl]
  ld [$c5fd], a
  call $034b
  jp $5788
  ld b, $2
  ld c, $6
  ld e, $6f
  call $015c
  ld b, $2
  ld c, $6
  ld e, $70
  call $015c
  jp $5788
  ld a, [$c725]
  ld b, a
  ld a, [$c6f4]
  ld c, a
  call $5942
  ld hl, $0001
  add hl, de
  ld a, [hl]
  call $0282
  ld bc, $9841
  ld hl, cBUF01
  call $028e
  ld h, $0
  ld l, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call $0264
  call $5e27
  jp $5788
  ld a, [$c6f5]
  or a
  jr nz, .asm_9d6f ; 0x9d61 $c
  ld b, $a
  ld c, $0
  ld e, $94
  call $015c
  jp $5788
.asm_9d6f
  ld b, $a
  ld c, $0
  ld e, $95
  call $015c
  jp $5788
; 0x9d7b