SECTION "Robattles Start Screen", ROM0[$2e58]
LoadRobattleStartScreenMedarotter:
  ld a, BANK(MedarottersPtr)
  rst $10
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
  rst $10
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
  nop
  nop
; 0x2eb0

SECTION "Robattles Start Screen - Name", ROM0[$2f2f]
LoadRobattleNames:
  ld hl, cNAME
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $9841, $be
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ld a, BANK(MedarottersPtr)
  rst $10
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
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $984b, $c6
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ret
.asm_2f95
  ld hl, $c778
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $984b, $c6
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ret
  nop
  nop
; 0x2faa

SECTION "Robattle Screen - Copy Player Medarot Info", ROMX[$4d8f], BANK[$4]
RobattleScreenCopyPlayerMedarotInfo:
  ld c, $a
  ld a, [de]
  ld b, a
  ld a, [$c64e]
  cp b
  jp nz, $4ddb
  ld hl, $a500 ; Probably where the original medarot structures actually live
  ld b, $0
  ld a, [$c654]
  ld c, a
  ld a, $5
  call JumpGetListTextOffset
  push de
  ld hl, RobattlePlayerMedarot1
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  pop de
  ld b, $20
  call HackCopyDEtoHL_4
  srl b
  ld a, $ee ; A hack to copy the name to $f0
  rst $28 ; hl += a
  call HackCopyDEtoHL_4
  ld a, [$c652]
  inc a
  ld [$c652], a
  ld d, h
  ld e, l
  ld hl, $0011
  add hl, de
  ld a, [$c650]
  ld [hl], a
  ld a, [$c650]
  inc a
  ld [$c650], a
  ret
; 0x10ddb

SECTION "(Hack) Copy 'b' bytes from [de] to [hl], preserve all registers except a", ROMX[$796a], BANK[$4]
HackCopyDEtoHL_4:
  push bc
  push de
  push hl
.loop
  ld a, [de]
  ld [hli], a
  inc de
  dec b
  jr nz, .loop
  pop hl
  pop de
  pop bc
  ret

SECTION "Robattle Screen - Initialize", ROMX[$520c], BANK[$4]
RobattleScreenSetup:
  ld a, [$c753]
  call $02bb
  ld a, [$c64e]
  ld [$c745], a
  xor a
  ld [$c65a], a
  ld hl, RobattleEnemyMedarot1
  ld b, $0
  ld a, [$c65a]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
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
  ld b, $10 ; Medarot name length, 15+1 term
  ld hl, $00f0
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

SECTION "Robattle - Medarot Select", ROMX[$7815], BANK[$2]
RobattleSetupMedarotSelect::
; This is a very long function, but there's no need to dump it yet


SECTION "Robattle - Part Screen", ROMX[$6c7e], BANK[$1b]
RobattlePartScreen:
  ld hl, RobattleMedarots
  ld a, [$c0d7]
  ld b, $0
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  push de
  ld hl, $00f0
  add hl, de
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $984b, $be
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
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
  ld hl, cBUF01 ; Medal
  psbc $98ac, $c6
  call VWFPutStringTo8
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
  psbc $9949, $d6
  call VWFPutStringTo8
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
  psbc $9989, $de
  call VWFPutStringTo8
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
  psbc $99c9, $e6
  call VWFPutStringTo8
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
  psbc $9a09, $5c
  call VWFPutStringTo8
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
  psbc $98ec, $ce
  push de
  ld d, BANK(RobattleMedarotInfoLoadSkill)
  ld e, BANK(SkillsPtr)  
  call PrintPtrText
  pop de
; 0x6f019
  ret ; Overwrites the first byte of the unused 1B copy

SECTION "Robattle - Load Text", ROMX[$54f1], BANK[$4]
RobattleLoadText:
.asm_114f1
  ld b, $6
  ld c, $d
  ld e, $86
  call $015c
  ret
; 0x114fb
  ld hl, $00d3
  add hl, de
  ld a, [hl]
  or a
  jr z, .asm_114f1 ; 0x11501 $ee
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b520
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $0
  call $0294
  ld hl, cBUF01
  call VWFPadTextTo8
  ld b, $0
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  psbc $99c6, $be
  call VWFPutStringTo8
  ret
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, $554b
  ld b, $b
  ld c, $f
  ld e, $86
  call $015c
  ret
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b5a0
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $1
  call $0294
  ld hl, cBUF01
  psbc $9a0b, $c6
  call VWFPutStringTo8
  ret
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, $5587
  ld b, $1
  ld c, $f
  ld e, $86
  call $015c
  ret
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b620
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $2
  call $0294
  ld hl, cBUF01
  call VWFLeftPadTextTo8
  ld b, $0
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  psbc $9a01, $ce
  call VWFPutStringTo8
  ret

SECTION "LeftPadTextTo8", ROMX[$546f], BANK[$4]
LeftPadTextTo8:
  push hl
  push bc
  ld b, $0
.asm_11473
  ld a, [hli]
  cp $50
  jr z, .asm_1147b ; 0x11476 $3
  inc b
  jr .asm_11473 ; 0x11479 $f8
.asm_1147b
  ld a, $8
  sub b
  pop bc
  pop hl
  ret
; 0x11481

SECTION "Robattle - Load Battle Text", ROMX[$58b5], BANK[$5]
RobattleLoadBattleText:
  push de
  ld hl, $00f0
  add hl, de
  ld de, cBUF01
  ld b, $10
.asm_158bf
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_158bf ; 0x158c3 $fa
  pop de
  ret
; 0x158c7

SECTION "Robattle - Load Attack Text", ROM0[$3adc]
RobattleLoadAttackText:
  push hl
  push de
  push bc
  ld hl, $00ca
  add hl, de
  ld a, [hl]
  ld [$c652], a
  ld hl, $000d
  ld b, $0
  ld c, a
  add hl, bc
  add hl, de
  ld a, [hl]
  and $7f
  ld c, a
  ld a, [$c652]
  ld b, a
  ld a, $f
  push de
  call $3117
  pop de
  ld a, BANK(AttacksPtr)
  rst $10
  ld hl, AttacksPtr
  ld b, $0
  ld a, [$c64e]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld de, cBUF04
  ld b, $9
.asm_3b19
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_3b19 ; 0x3b1d $fa
  pop bc
  pop de
  pop hl
  ret
  nop
; 0x3b23

SECTION "Robattle - Ending Screen", ROMX[$72c4], BANK[$1]
RobattleEndScreenEXP:
  ld a, $1
  call $01d7
  ld a, [$a08e]
  ld b, a
  ld a, [$a08f]
  ld c, a
  ld hl, cBUF01
  ld a, [$c64e]
  push af
  call $0336
  pop af
  ld [$c64e], a
  ld a, $d1
  ld [$a0c2], a
  ld a, $aa
  ld [$a0c3], a
  jp $73ce
  ld a, [$a0c1]
  ld hl, $a090
  ld b, $0
  ld c, a
  ld a, $4
  call JumpGetListTextOffset
  ld a, d
  ld [$a044], a
  ld a, e
  ld [$a045], a
  ld a, [hl]
  or a
  jr z, .asm_730c ; 0x7304 $6
  call $73ce
  jp $7294
.asm_730c
  ld a, $1
  ld [$c64e], a
  ret
  ld a, $19
  ld [$ffa0], a
  ld a, [$a044]
  ld h, a
  ld a, [$a045]
  ld l, a
  ld bc, $0001
  add hl, bc
  ld a, [hli]
  call $0282
  ld a, $d0
  ld [$a0c2], a
.asm_732b
  ld a, $50
.asm_732d
  ld [$a0c3], a
  ld a, $1
  call $01d7
  jp $73ce
; 0x7338

SECTION "Robattle - Load Medarot Names", ROMX[$76cc], BANK[$4]
RobattleLoadMedarotNames:
  xor a
  ld [$c652], a
.loop_medarot
  ld hl, RobattlePlayerMedarot1
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  ld a, [de]
  or a
  jp z, .next_medarot
  ld hl, $00f0
  add hl, de
  call VWFLeftPadTextTo8
  ld [$c650], a
  push de
  pshl $98e0, $01 ; write to free space, to avoid redrawing 
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $3
  call JumpGetListTextOffset
  pop de
  ld a, [$c650]
  ld b, $0
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringTo8
.next_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_medarot
  xor a
  ld [$c652], a
.loop_enemy_medarot
  ld hl, RobattleEnemyMedarot1
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  ld a, [de]
  or a
  jp z, .next_enemy_medarot
  push de
  pshl $98ec, $d6
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $3
  call JumpGetListTextOffset
  pop de
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringTo8
.next_enemy_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_enemy_medarot
  ret
; 0x13756

SECTION "Robattle - Load Medarot Names (1B copy)", ROMX[$6e26], BANK[$1B]
RobattleLoadMedarotNamesCopy::
  xor a
  ld [$c652], a
.loop_medarot
  ld hl, RobattlePlayerMedarot1
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  ld a, [de]
  or a
  jp z, .next_medarot
  ld hl, $00f0
  add hl, de
  call VWFLeftPadTextTo8
  ld [$c650], a
  push de
  pshl $98e0, $01
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $3
  call JumpGetListTextOffset
  pop de
  ld a, [$c650]
  ld b, $0
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringTo8
.next_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_medarot
  xor a
  ld [$c652], a
.loop_enemy_medarot
  ld hl, RobattleEnemyMedarot1
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $8
  call JumpGetListTextOffset
  ld a, [de]
  or a
  jp z, .next_enemy_medarot
  push de
  pshl $98ec, $d6
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $3
  call JumpGetListTextOffset
  pop de
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringTo8
.next_enemy_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_enemy_medarot
  ret

SECTION "LeftPadTextTo8 (1B Copy)", ROMX[$6ebc], BANK[$1B]
LeftPadTextTo8Copy:
  push hl
  push bc
  ld b, $0
.asm_11473
  ld a, [hli]
  cp $50
  jr z, .asm_1147b ; 0x11476 $3
  inc b
  jr .asm_11473 ; 0x11479 $f8
.asm_1147b
  ld a, $8
  sub b
  pop bc
  pop hl
  ret