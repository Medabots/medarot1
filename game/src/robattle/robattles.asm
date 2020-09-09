INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

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
  xor a
  call HackCopyDEtoHL_4
  srl b
  ld a, $ee ; A hack to copy the name to $f0
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
  inc a
  ld [$c650], a
  ret
.end
REPT $4ddb - .end
  nop
ENDR
; 0x10ddb

SECTION "(Hack) Copy 'b' bytes from [de] to [hl+a], preserve all registers except a", ROMX[$796a], BANK[$4]
HackCopyDEtoHL_4:
  push bc
  push de
  push hl
  rst $28 ; hl += a
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
  call JumpTable_2bb
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
  call JumpTable_162
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
  call JumpTable_162
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
  call JumpTable_162
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
  call JumpTable_162
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
  call JumpLoadMedarotList
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

SECTION "Robattle - Restore font when exiting parts", ROMX[$6ac7], BANK[$1b]
RobattleReloadFont: ; 6eac7 (1b:6ac7)
  ld a, $1e ; LoadRobottleText
  rst $08
  ld a, [$c752]
  add $0d
  call JumpLoadFont
  ld a, $02
  call JumpTable_17d
  ld b, $08
  ld c, $0b
  ld d, $06
  ld e, $00
  ld a, $0a
  call JumpTable_309
  call $67de
  call RobattleLoadMedarotNamesCopy
  ret
.end
REPT $6af1 - .end
  nop
ENDR
; 0x6eaf1

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
  psbc $984b, $47
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
  call JumpTable_27c
  pop de
  ld a, $41
  ld hl, $988a
  call RobattlePartScreenLoadMedalIcon
  push de
  ld hl, $0081
  add hl, de
  ld a, [hl]
  call JumpLoadMedalList
  ld hl, cBUF01 ; Medal
  psbc $98ac, $c6
  call VWFPutStringAutoNarrowTo8Pad2
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
RobattlePartScreenLoadMedalIcon: ; 6ed0e (1b:6d0e)
  push hl
  push bc
  push de
  ld c, $03
.asm_6ed13
  push hl
  ld b, $02
.asm_6ed16
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  inc a
  dec b
  jr nz, .asm_6ed16
  pop hl
  ld de, $20
  add hl, de
  dec c
  jr nz, .asm_6ed13
  pop de
  pop bc
  pop hl
  ret

SECTION "Robattle - Load Parts", ROMX[$6d2c], BANK[$1b]
RobattleMedarotInfoLoadHead:
  ld a, [$a03d]
  sub $3c
  jp c, $6d3e
  ld b, $9
  ld c, $9
  ld e, $86
  call JumpLoadTilemap
  ret
  ld a, [$a03d]
  and $7f
  ld b, $0
  ld c, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9949, $d6
  call VWFPutStringAutoNarrowTo8
  ret
RobattleMedarotInfoLoadRArm:
  ld a, [$a03f]
  sub $3c
  jp c, $6d66
  ld b, $9
  ld c, $b
  ld e, $86
  call JumpLoadTilemap
  ret
  ld a, [$a03f]
  and $7f
  ld b, $0
  ld c, $1
  call JumpTable_294
  ld hl, cBUF01
  psbc $9989, $de
  call VWFPutStringAutoNarrowTo8
  ret
RobattleMedarotInfoLoadLArm:
  ld a, [$a041]
  sub $3c
  jp c, $6d8e
  ld b, $9
  ld c, $d
  ld e, $86
  call JumpLoadTilemap
  ret
  ld a, [$a041]
  and $7f
  ld b, $0
  ld c, $2
  call JumpTable_294
  ld hl, cBUF01
  psbc $99c9, $e6
  call VWFPutStringAutoNarrowTo8
  ret
RobattleMedarotInfoLoadLegs:
  ld a, [$a043]
  sub $3c
  jp c, $6db6
  ld b, $9
  ld c, $f
  ld e, $86
  call JumpLoadTilemap
  ret
  ld a, [$a043]
  and $7f
  ld b, $0
  ld c, $3
  call JumpTable_294
  ld hl, cBUF01
  psbc $9a09, $5c
  call VWFPutStringAutoNarrowTo8
  ret
; 0x6edcc

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
  jr nz, .asm_6fd6
  ld a, [$c65a]
  ld hl, SkillsPtr
  rla ; Realistically, there's not enough Skills for this to ever overflow
  rst $28
  psbc $98ec, $ce
  push de
  ld d, BANK(RobattleMedarotInfoLoadSkill)
  ld e, BANK(SkillsPtr)
  ld a, $02
  ld [VWFInitialPaddingOffset], a
  call PrintPtrTextAutoNarrow
  pop de
  ret
.end
REPT $7019 - .end
  nop
ENDR
; 0x6f019

SECTION "Robattle - Draw Part Names in Attack Selection Screen", ROMX[$54cb], BANK[$4]
RobattleLoadAttackSelectPartNames:: ; 114cb (4:54cb)
  ld hl, $99a1
  ld bc, $1204
  call JumpTable_270
  push de
  call RobattleLoadHeadPart
  pop de
  push de
  call RobattleLoadRightArm
  pop de
  push de
  call RobattleLoadLeftArm
  pop de
  ret
; 0x114e5
RobattlePartBrokenLoadTilemap:
  ld e, $86
  jp JumpLoadTilemap
RobattleLoadHeadPart:
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and a, $7f
  sub a, $3c
  jr nc, RobattlePartBrokenLoadTilemap
.not_broken:
  ld hl, $00d3
  add hl, de
  ld a, [hl]
  or a
  ld bc, $060d
  jr z, RobattlePartBrokenLoadTilemap
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b520
  ld c, a
  ld b, $0
  add hl, bc
  add hl, bc
  ld a, [hl]
  and $7f
  ld bc, $0000
  call JumpTable_294
  ld hl, cBUF01
  call VWFPadTextTo8
  ld a, [VWFCurrentFont]
  or a
  jr z, .not_narrow
  call VWFPadTextTo8
.not_narrow
  psbc $99c6, $9f
  call VWFPutStringTo8
  ret
RobattleLoadRightArm:
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, .not_broken
  ld bc, $0b0f
  jr z, RobattlePartBrokenLoadTilemap
.not_broken
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b5a0
  ld c, a
  ld b, $0
  add hl, bc
  add hl, bc
  ld a, [hl]
  and $7f
  ld bc, $0001
  call JumpTable_294
  ld hl, cBUF01
  psbc $9a0b, $ad
  call VWFPutStringAutoNarrowTo8
  ret
RobattleLoadLeftArm:
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, .not_broken
  ld bc, $010f
  jp z, RobattlePartBrokenLoadTilemap
.not_broken
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b620
  ld c, a
  ld b, $0
  add hl, bc
  add hl, bc
  ld a, [hl]
  and $7f
  ld bc, $0002
  call JumpTable_294
  ld hl, cBUF01
  call VWFLeftPadTextTo8
  ld a, [VWFCurrentFont]
  or a
  jr z, .not_narrow
  call VWFLeftPadTextTo8
.not_narrow
  psbc $9a01, $be
  call VWFPutStringTo8
  ret
.end
REPT $55b9 - .end
  nop
ENDR
; 0x55b9

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
  call Func_3117
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
.end
REPT $3b23 - .end
  nop
ENDR
; 0x3b23

SECTION "Robattle - Ending Screen", ROMX[$72c4], BANK[$1]
RobattleEndScreenEXP:
  ld a, $1
  call JumpSetupDialog
  ld a, [$a08e]
  ld b, a
  ld a, [$a08f]
  ld c, a
  ld hl, cBUF01
  ld a, [$c64e]
  push af
  call JumpTable_336
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
  call JumpLoadMedalList
  ld a, $d0
  ld [$a0c2], a
.asm_732b
  ld a, $50
.asm_732d
  ld [$a0c3], a
  ld a, $1
  call JumpSetupDialog
  jp $73ce
; 0x7338

SECTION "Robattle - Load Medarot Names", ROMX[$76cc], BANK[$4]
RobattleLoadMedarotNames::
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
  pshl $98e0, $01
  ld a, [$c652]
  ld bc, $0820
.loop_player_getoffset
  or a
  jr z, .end_loop_player_getoffset
  add hl, bc
  dec a
  jr .loop_player_getoffset
.end_loop_player_getoffset
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
  pshl $98ec, $19
  ld a, [$c652]
  ld bc, $0820
.loop_enemy_getoffset
  or a
  jr z, .end_loop_enemy_getoffset
  add hl, bc
  dec a
  jr .loop_enemy_getoffset
.end_loop_enemy_getoffset
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringAutoNarrowTo8
.next_enemy_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_enemy_medarot
  ret
.end
REPT $7756 - .end
  nop
ENDR
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
  pshl $98e0, $01
  ld a, [$c652]
  ld bc, $0820
.loop_player_getoffset
  or a
  jr z, .end_loop_player_getoffset
  add hl, bc
  dec a
  jr .loop_player_getoffset
.end_loop_player_getoffset
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
  pshl $98ec, $19
  ld a, [$c652]
  ld bc, $0820
.loop_enemy_getoffset
  or a
  jr z, .end_loop_enemy_getoffset
  add hl, bc
  dec a
  jr .loop_enemy_getoffset
.end_loop_enemy_getoffset
  ld b, h
  ld c, l
  ld hl, $00f0
  add hl, de
  call VWFPutStringAutoNarrowTo8
.next_enemy_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_enemy_medarot
  ret
.end
REPT $6eb0 - .end
  nop
ENDR

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

SECTION "Robattle - Display Health",  ROMX[$5cf8],  BANK[$5]
RobattleDisplayHealth::
  push de
  ld [$C64E], a
  ld a, b
  ld [$C640], a
  ld a, c
  ld [$C641], a
  push bc

  ; Map health bar left border.

  ld a, [$C640]
  ld h, a
  ld a, [$C641]
  ld l, a
  ld a, $FB
  di
  call JumpWaitLCDController
  ld [hli], a
  ei

  ; Map health in bar.

  ld a, h
  ld [$C640], a
  ld a, l
  ld [$C641], a
  call $5D7D

  ; Map health bar right border.

  ld a, [$C640]
  ld h, a
  ld a, [$C641]
  ld l, a
  ld a, $FC
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  ld a, h
  ld [$C640], a
  ld a, l
  ld [$C641], a
  pop bc
  ld hl, $FFE0
  add hl, bc
  ld b, h
  ld c, l

  ; Map current health numbers.

  push bc
  call $5821
  pop bc
  ld hl, $59
  add hl, de
  ld a, [hli]
  ld l, [hl]
  ld h, a
  call RobattleHealthDisplayFix

  ; Map "/".

  push bc
  ld hl, 4
  add hl, bc
  ld a, $68
  di
  call JumpWaitLCDController
  ld [hl], a
  ei
  pop bc
  ld hl, 4
  add hl, bc

  ; Map max health numbers.

  ld b, h
  ld c, l
  ld hl, $5B
  add hl, de
  ld a, [hli]
  ld l, [hl]
  ld h, a
  call RobattleHealthDisplayFix
  pop de
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

SECTION "Robattle - Display Health Fix (Hack)", ROMX[$7f64], BANK[$5]
RobattleHealthDisplayFix::
  push bc
  inc bc ; Skip first tile.
  ld a, l
  cp 100 ; Note: decimal value.
  call c, .clearTile
  ld a, l
  cp 10
  call c, .clearTile
  pop bc
  jp JumpDrawNumber

.clearTile
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  xor a
  ld [bc], a
  ei
  inc bc
  ret

SECTION "Robattle - Load Part Screen",  ROMX[$6a13],  BANK[$1b]
RobattleStateLoadPartScreenTilemaps: ; 6ea13 (1b:6a13)
  ld hl, $9800
  ld b, $00
  ld a, [$c740]
  ld c, a
  ld a, $06
  call JumpGetListTextOffset
  ld b, $14
  ld c, $02
  call JumpTable_270
  ld a, [$c740]
  inc a
  ld [$c740], a
  cp $09
  ret nz
  ld b, $0a
  ld c, $00
  ld e, $97
  ld a, $1f ; LoadMinimalPartScreenAndLoadTilemap
  rst $08
  ld b, $00
  ld c, $08
  ld e, $84
  call JumpLoadTilemap
  call $6c7e
  xor a
  ld [$c740], a
  call $67de
  ret
; 0x6ea4f

SECTION "Robattle - Time Limit Reached",  ROMX[$7629],  BANK[$1b]
RobattleTimeLimitReachedDecideWinner: ; 6f629 (1b:7629)
  call $7695
  ld a, [SerIO_ConnectionTestResult]
  or a
  jr nz, .asm_6f635
  call $7700
.asm_6f635
  ld a, [$a404]
  cp $01
  jr z, .load_own_name
  cp $ff
  jr z, .asm_6f677
  ld a, [$c776]
  or a
  jr nz, .asm_6f652
  call JumpTable_162
  ld a, [$c5f0]
  and $01
  jr z, .load_own_name
  jr .asm_6f677
.asm_6f652
  call JumpTable_162
  ld a, [$c5f0]
  and $01
  ld b, a
  ld a, [SerIO_Connected]
  cp b
  jr z, .load_own_name
  jr .asm_6f677
.load_own_name
  ld a, $01
  ld [$c74e], a
  ld hl, cNAME
  ld de, cBUF01
  ld b, $09
.asm_6f670
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_6f670
  ret
.asm_6f677
  ld a, $02
  ld [$c74e], a
  ld a, [$c776]
  or a
  jr nz, .load_opponent_name
  call JumpTable_333
  ret
.load_opponent_name
  ld hl, $c778
  ld de, cBUF01
  ld b, $09
.asm_6f68e
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_6f68e
  ret
; 0x6f695

SECTION "Robattle - Load text for transformation message",  ROMX[$58c7],  BANK[$05]
RobattleLoadTextFromBUF01ToBUF04:
  push de
  ld [$c650], a
  ld hl, $000d
  add hl, de
  ld b, $0
  ld a, [$c650]
  ld c, a
  add hl, bc
  ld a, [hl]
  and $7f
  push af
  ld b, $0
  ld a, [$c650]
  ld c, a
  pop af
  call JumpTable_294
  ld hl, cBUF01
  ld de, cBUF04
  ld b, $0f
.asm_158ec
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_158ec ; 0x158f0 $fa
  pop de
  ret
RobattleLoadTextFromBUF01ToBUF02:
  push de
  ld [$c650], a
  ld hl, $002f
  add hl, de
  ld a, [hl]
  and $7f
  push af
  ld b, $0
  ld a, [$c650]
  ld c, a
  pop af
  call JumpTable_294
  ld hl, cBUF01
  ld de, cBUF02
  ld b, $0f
.asm_15912
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_15912 ; 0x15916 $fa
  pop de
  ret
; 0x1591a