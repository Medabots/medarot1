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