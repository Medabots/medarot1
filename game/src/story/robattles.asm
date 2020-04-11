SECTION "Robattles Start Screen", ROM0[$2e58]
LoadRobattleStartScreenMedarotter:
  ld a, BANK(MedarottersPtr)
  ld [$2000], a
  ld a, [$c753]
  ld hl, MedarottersPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hl]
  ld b, $0
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld a, $14
  ld [$2000], a
  ld hl, $4000
  add hl, bc
  ld de, $9110
  ld bc, $0100
  call $0cb7
  ld a, [$c740]
  inc a
  ld [$c740], a
  xor a
  ld [$c741], a
  ret
; 0x2eb0

SECTION "Robattles Start Screen - Name", ROM0[$2f2f]
LoadRobattleNames:
  ld hl, cNAME
  push hl
  call $34c4
  ld h, $0
  ld l, a
  ld bc, $9841
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call PutString
  ld a, BANK(MedarottersPtr)
  ld [$2000], a
  ld a, [$c753]
  ld hl, MedarottersPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc hl
  ld a, [hli]
  push hl
  push af
  ld a, [$c74e]
  ld hl, $d0c0
  ld b, $0
  ld c, a
  ld a, $6
  call $3981
  ld b, $0
  pop af
  ld c, a
  add hl, bc
  ld a, h
  ld [$c754], a
  ld a, l
  ld [$c755], a
  pop hl
  ld a, [hli]
  ld [$c76b], a
  ld a, [$c776]
  or a
  jr nz, .asm_2f95 ; 0x2f81 $12
  push hl
  call $34c4
  ld h, $0
  ld l, a
  ld bc, $984b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call PutString
  ret
.asm_2f95
  ld hl, $c778
  push hl
  call $34c4
  ld h, $0
  ld l, a
  ld bc, $984b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call PutString
  ret
; 0x2faa

SECTION "Robattle Screen - Initialize", ROMX[$520c], BANK[$4]
RobattleScreenSetup:
  ld a, [$c753]
  call $02bb
  ld a, [$c64e]
  ld [$c745], a
  xor a
  ld [$c65a], a
  ld hl, $af00
  ld b, $0
  ld a, [$c65a]
  ld c, a
  ld a, $8
  call $02b8
  ld a, $3
  ld [de], a
  ld a, $1
  ld hl, $0000
  add hl, de
  ld [hl], a
  ld a, [$c650]
  ld hl, $5326
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $0001
  add hl, de
  ld [hl], a
  ld a, [$c656]
  ld hl, $000b
  add hl, de
  ld [hl], a
  call $0162
  ld a, [$c5f0]
  and $3
  ld hl, $c650
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $000d
  add hl, de
  ld [hl], a
  call $0162
  ld a, [$c5f0]
  and $3
  ld hl, $c650
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $000e
  add hl, de
  ld [hl], a
  call $0162
  ld a, [$c5f0]
  and $3
  ld hl, $c650
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $000f
  add hl, de
  ld [hl], a
  call $0162
  ld a, [$c5f0]
  and $3
  ld hl, $c650
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $0010
  add hl, de
  ld [hl], a
  ld a, [$c65a]
  inc a
  ld hl, $0011
  add hl, de
  ld [hl], a
  ld a, [$c64e]
  push af
  call $539b
  pop af
  ld [$c64e], a
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and $7f
  ld c, a
  call $02be
  push de
  ld b, $9
  ld hl, $0002
  add hl, de
  ld d, h
  ld e, l
  ld hl, cBUF01
.asm_112cb
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_112cb ; 0x112cf $fa
  pop de
  ld a, $1
  ld hl, $00c8
  add hl, de
  ld [hl], a
  ld hl, $0080
  add hl, de
  ld a, $1
  ld [hl], a
  ld hl, $000b
  add hl, de
  ld a, [hl]
  ld hl, $0081
  add hl, de
  ld [hl], a
  ld a, [$c654]
  ld b, a
  ld a, [$c934]
  add b
  ld c, a
  sub $b
  jr c, .asm_112f9 ; 0x112f5 $2
  ld c, $a
.asm_112f9
  ld a, c
  ld hl, $0083
  add hl, de
  ld [hl], a
  ld a, [$c655]
  ld b, a
  ld a, [$c935]
  add b
  ld c, a
  sub $7
  jr c, .asm_1130e ; 0x1130a $2
  ld c, $6
.asm_1130e
  ld a, c
  ld hl, $0084
  add hl, de
  ld [hl], a
  ld a, [$c65a]
  inc a
  ld [$c65a], a
  ld a, [$c64e]
  dec a
  ld [$c64e], a
  jp nz, $521c
  ret
; 0x11326