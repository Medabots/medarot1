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



SECTION "Robattle - Part Screen", ROMX[$6c7e], BANK[$1b]
RobattlePartScreen:
  ld hl, $ac00
  ld a, [$c0d7]
  ld b, $0
  ld c, a
  ld a, $8
  call $02b8
  push de
  ld hl, $0002
  add hl, de
  push hl
  call $028e
  ld h, $0
  ld l, a
  ld bc, $984b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call $0264
  pop de
  push de
  ld hl, $0081
  add hl, de
  ld a, [hl]
  ld de, $9410
  call $027c
  pop de
  ld a, $41
  ld hl, $988a
  call $6d0e
  push de
  ld hl, $0081
  add hl, de
  ld a, [hl]
  call $0282
  ld hl, cBUF01
  ld bc, $98ac
  call $0264
  pop de
  call $6fc4
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and $7f
  ld [$a03d], a
  push de
  call $6d2c
  pop de
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  ld [$a03f], a
  push de
  call $6d54
  pop de
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  ld [$a041], a
  push de
  call $6d7c
  pop de
  ld hl, $0010
  add hl, de
  ld a, [hl]
  and $7f
  ld [$a043], a
  push de
  call $6da4
  pop de
  call $6ece
  ret
; 0x6ed0e

SECTION "Robattle - Load Parts", ROMX[$6d2c], BANK[$1b]
RobattleMedarotInfoLoadHead:
  ld a, [$a03d]
  sub $3c
  jp c, $6d3e
  ld b, $9
  ld c, $9
  ld e, $86
  call $015c
  ret
  ld a, [$a03d]
  and $7f
  ld b, $0
  ld c, $0
  call $0294
  ld hl, cBUF01
  ld bc, $9949
  call $0264
  ret
RobattleMedarotInfoLoadRArm:
  ld a, [$a03f]
  sub $3c
  jp c, $6d66
  ld b, $9
  ld c, $b
  ld e, $86
  call $015c
  ret
  ld a, [$a03f]
  and $7f
  ld b, $0
  ld c, $1
  call $0294
  ld hl, cBUF01
  ld bc, $9989
  call $0264
  ret
RobattleMedarotInfoLoadLArm:
  ld a, [$a041]
  sub $3c
  jp c, $6d8e
  ld b, $9
  ld c, $d
  ld e, $86
  call $015c
  ret
  ld a, [$a041]
  and $7f
  ld b, $0
  ld c, $2
  call $0294
  ld hl, cBUF01
  ld bc, $99c9
  call $0264
  ret
RobattleMedarotInfoLoadLegs:
  ld a, [$a043]
  sub $3c
  jp c, $6db6
  ld b, $9
  ld c, $f
  ld e, $86
  call $015c
  ret
  ld a, [$a043]
  and $7f
  ld b, $0
  ld c, $3
  call $0294
  ld hl, cBUF01
  ld bc, $9a09
  call $0264
  ret
; 0x6edcc

; They actually maintain a separate copy of all the skills in 1B
; SECTION "Skills_1B", ROMX[$7019], BANK[$1b]
; Skills_1B:
; INCLUDE "build/ptrlists/Skills.asm"

SECTION "Robattle - Load Parts - Skills", ROMX[$6fc4], BANK[$1b]
RobattleMedarotInfoLoadSkill:
  xor a
  ld [$c658], a
  ld [$c65a], a
  ld [$c65b], a
  ld hl, $008c
  add hl, de
  ld a, [hl]
  ld [$c65b], a
.asm_6fd6:
  ld hl, $008c
  ld b, $0
  ld a, [$c658]
  ld c, a
  add hl, bc
  add hl, de
  ld a, [hl]
  ld b, a
  ld a, [$c65b]
  sub b
  jr nc, .asm_6eff3 ; 0x6efe7 $a
  ld a, [$c658]
  ld [$c65a], a
  ld a, b
  ld [$c65b], a
.asm_6eff3
  ld a, [$c658]
  inc a
  ld [$c658], a
  cp $8
  jp nz, .asm_6fd6
  ld a, [$c65a]
  ld hl, SkillsPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld bc, $98ec
  push de
  ld d, BANK(RobattleMedarotInfoLoadSkill)
  ld e, BANK(SkillsPtr)  
  call PrintPtrText
  pop de
; 0x6f019
  ret ; Overwrites the first byte of the unused 1B copy