; Core state machine for the link robattles

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "Link Robattle State Machine", ROMX[$4000], BANK[$15]
LinkRobattleStateMachine:: ; 54000 (15:4000)
  call $7ebb
  ld a, [$c64e]
  or a
  jr z, .no_exit
  xor a
  ld [CoreStateIndex], a
  ld [CoreSubStateIndex], a
  ret
.no_exit
  call $7d96
  ld a, [CoreSubStateIndex]
  ld hl, .table
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
.table
  dw LinkRobattleStateInitialize
  dw LinkRobattleSubStateDoSomething
  dw LinkRobattleSubStateInitialize
  dw LinkRobattleLoadMedarotSelectTilemaps
  dw $40e7
  dw $4188
  dw $4196
  dw $422d
  dw $429d
  dw $42b4
  dw $4382
  dw $4467
  dw $453b
  dw LinkRobattleStateLoadMedarotSelectPartTilemap
  dw $4647
  dw $4667
  dw $4683
  dw $4693
  dw LinkRobattleStateMachineRet
  dw $46a0
  dw $46a8
  dw $46b6
  dw $46c4
  dw $46cc
  dw $46e2
  dw $4bba
  dw LinkRobattleStateSetupRobattleScreenLoadFonts
  dw LinkRobattleStateSetupRobattleScreenLoadInitialTilemaps
  dw $473f
  dw $40e7
  dw $475e
  dw $4765
  dw $4771
  dw $477b
  dw $47bc
  dw $47ec
  dw $48ae
  dw $48ce
  dw $48ea
  dw $4934
  dw $49c6
  dw $49f0
  dw $4a33
  dw $4a81
  dw $4b4a
  dw $4b70
  dw $4b8f
  dw LinkRobattleStateMachineRet
  dw $4bc9
  dw $4bf1
  dw $4c5e
  dw $4c0b
  dw $4c5e
  dw $4c1c
  dw $4c36
  dw $4c5e
  dw LinkRobattleScreenSetEnemyMedarotInfo
  dw $4c0b
  dw $4c5e
  dw $4cb5
  dw $4ccf
  dw $4c5e
  dw $4cf7
  dw LinkRobattleStateMachineRet
  dw $46a0
  dw $46a8
  dw $46cc
  dw $4c5e
  dw $4c0b
  dw $4c5e
  dw $4d55
  dw $4d97
  dw $4c5e
  dw $4dde
  dw $4e54
  dw $4e72
  dw $4e9b
  dw LinkRobattleStateMachineRet
  dw LinkRobattleStateMachineRet
  dw LinkRobattleStateMachineRet
  dw $46a0
  dw $46a8
  dw $46cc
  dw $4c5e
  dw $4c0b
  dw $4c5e
  dw $4ea1
  dw $4d55
  dw $4d97
  dw $4c5e
  dw $4eab
  dw $4c5e
  dw $4e54
  dw $4e72
  dw $46d7
  dw $4f16
LinkRobattleStateMachineRet::
  ret

SECTION "Link Robattle States Partial 1", ROMX[$40fb], BANK[$15]
LinkRobattleStateInitialize:
  ld a, $01
  call JumpEnableSRAM
  xor a
  ld [$c750], a
  ld [$da42], a
  ld a, $02
  ld [$ffa0], a
  jp JumpIncSubStateIndexWrapper

LinkRobattleSubStateDoSomething: ; not sure what this does exaclty
  call $75ac
  ld a, [$c750]
  cp $ff
  ret nz
  ld a, $00
  ld [$c740], a
  ld a, $08
  ld [$c72d], a
  ld a, $21
  ld [$ffa0], a
  jp JumpIncSubStateIndexWrapper

LinkRobattleSubStateInitialize:
  xor a
  ld [$c740], a
  jp JumpIncSubStateIndexWrapper

LinkRobattleLoadMedarotSelectTilemaps:
  ld a, [$c740]
  or a
  jr nz, .asm_54150
  ld b, $01
  ld c, $00
  ld e, $9c
  ld a, $1d ; LoadRobottleMedarotSelectTextAndLoadTilemap
  rst $08
  ld hl, $9840
  ld b, $0a
  ld c, $0a
  call JumpTable_270
  ld a, [$c740]
  inc a
  ld [$c740], a
  ret
.asm_54150
  ld b, $0a
  ld c, $00
  ld e, $9b
  call JumpLoadTilemap
  ld b, $00
  ld c, $0c
  ld e, $30
  call JumpLoadTilemap
  call JumpTable_29d
  call $7c4c
  ld a, [$c72d]
  ld b, $01
  call JumpTable_2a3
  call $7c17
  ld a, $02
  call JumpTable_17d
  ld b, $08
  ld c, $09
  ld d, $0a
  ld e, $00
  ld a, $05
  call JumpTable_309
  jp JumpIncSubStateIndexWrapper

SECTION "Link Robattle States Partial 2", ROMX[$45e7], BANK[$15]
LinkRobattleStateLoadMedarotSelectPartTilemap: ; 545e7 (15:45e7)
  call $4fe8
  ld a, $01
  call JumpTable_180
  or a
  ret z
  ld hl, $9800
  ld d, $00
  ld a, [$c740]
  ld e, a
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  add hl, de
  ld b, $14
.asm_54611
  xor a
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  dec b
  jr nz, .asm_54611
  ld a, [$c740]
  inc a
  ld [$c740], a
  cp $12
  ret nz
  xor a
  ld [$c740], a
  ld b, $0a
  ld c, $00
  ld e, $97
  ld a, $1f ; LoadMinimalPartScreenAndLoadTilemap
  rst $08
  ld b, $00
  ld c, $08
  ld e, $84
  call JumpLoadTilemap
  call JumpTable_2dc
  call JumpTable_2df
  call JumpTable_366
  jp JumpIncSubStateIndexWrapper
; 0x54647

SECTION "Link Robattle States Partial 3", ROMX[$46f8], BANK[$15]
LinkRobattleStateSetupRobattleScreenLoadFonts: ; 546f8 (15:46f8)
  call JumpTable_1a7
  call JumpTable_1aa
  call JumpTable_156
  call JumpTable_213
  ld a, $0b
  call JumpLoadFont
  ld a, $1e ; LoadRobottleText
  rst $08
  call $65f5
  jp JumpIncSubStateIndexWrapper
.end
REPT $4714 - .end
  nop
ENDR

LinkRobattleStateSetupRobattleScreenLoadInitialTilemaps: ; 54714 (15:4714)
  call $51d7
  call $5289
  call $52ac
  call $67cf
  call $54da
  call $555b
  call $556d
  ld b, $00
  ld c, $0c
  ld e, $50
  call JumpLoadTilemap
  ld hl, $98c0
  ld b, $14
  ld c, $06
  call JumpTable_270
  jp JumpIncSubStateIndexWrapper
; 0x5473f

SECTION "Link Robattle States Partial 4", ROMX[$4c6f], BANK[$15]
LinkRobattleScreenSetEnemyMedarotInfo: ; 54c6f (15:4c6f)
  ld hl, RobattleEnemyMedarot1
  call $7da2
  ld d, h
  ld e, l
  call $7e56
  call $7e5d

  ld b, $20
.asm_54c7f
  ld a, [hl]
  dec a
  jr nz, .asm_54c88
  ld [de], a
  jr .asm_54c8e
.asm_54c88
  call HackIncrementLBy4_15
  ld a, [hl]
  ld [de], a
.asm_54c8e
  inc de
  call HackIncrementLBy4_15
  dec b
  jr nz, .asm_54c7f

  ; Copy the medarot name to $f0 from $02
  call HackCallCopyNameHack_15

  ld a, [$c740]
  inc a
  cp $03
  jp z, .asm_4ca8
  ld [$c740], a

  ld a, $33
  ld [CoreSubStateIndex], a
  ret
.asm_4ca8
  xor a
  ld [$c740], a
  ld [$c741], a
  ld [$c742], a
  jp JumpIncSubStateIndexWrapper
.end
REPT $4cb5 - .end
  nop
ENDR
; 0x54cb5

SECTION "Link Robattle - Copy Player Medarot Info", ROMX[$5111], BANK[$15]
LinkRobattleScreenCopyPlayerMedarotInfo: ; 55111 (15:5111)
  ld c, $0a
.asm_5113
  ld a, [de]
  ld b, a
  ld a, [$c64e]
  cp b
  jr nz, .asm_515d
  ld hl, $a500
  ld b, $00
  ld a, [$c654]
  ld c, a
  ld a, $05
  call JumpGetListTextOffset
  push de
  ld hl, RobattlePlayerMedarot1
  ld b, $00
  ld a, [$c652]
  ld c, a
  ld a, $08
  call JumpGetListTextOffset
  pop de
  ld b, $20
  xor a
  call HackCopyDEtoHL_15
  srl b
  ld a, $ee ; A hack to copy the name to $f0
  call HackCopyDEtoHL_15
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
.asm_515d
  ld a, [$c654]
  inc a
  ld [$c654], a
  inc de
  dec c
  jr nz, .asm_5113
  ret
.end
REPT $516a - .end
  nop
ENDR
; 0x5516a

SECTION "(Hack)", ROMX[$7f19], BANK[$15]
HackIncrementLBy4_15:
  ld a, $04
  add l
  ld l, a
  ret
HackCallCopyNameHack_15:
  xor a
  ld e, $02
  ld h, d
  ld l, $f0
  ld b, $09 ; 8 characters per name + 1 for terminator
HackCopyDEtoHL_15: ;  Copy 'b' bytes from [de] to [hl+a], preserve all registers except a 
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

SECTION "Link Robattle States - Load Part Data", ROMX[$584d], BANK[$15]
LinkRobattleSetupParts: ; 5584d (15:584d)
  ld hl, $99a1
  ld b, $12
  ld c, $04
  call JumpTable_270
  push de
  call LinkRobattleLoadPartHead
  pop de
  push de
  call LinkRobattleLoadPartRightArm
  pop de
  push de
  call LinkRobattleLoadPartLeftArm
  pop de
  ret
LinkRobattlePartBrokenLoadTilemap:
  ld e, $86
  jp JumpLoadTilemap
LinkRobattleLoadPartHead:
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and a, $7f
  sub a, $3c
  jr nc, LinkRobattlePartBrokenLoadTilemap
.not_broken:
  ld hl, $00d3
  add hl, de
  ld a, [hl]
  or a
  ld bc, $060d
  jr z, LinkRobattlePartBrokenLoadTilemap
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
LinkRobattleLoadPartRightArm:
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, .not_broken
  ld bc, $0b0f
  jr z, LinkRobattlePartBrokenLoadTilemap
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
LinkRobattleLoadPartLeftArm:
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  sub $3c
  jp c, .not_broken
  ld bc, $010f
  jp z, LinkRobattlePartBrokenLoadTilemap
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
REPT $593b - .end
  nop
ENDR

SECTION "Link Robattle LeftPadTextTo8", ROMX[$57f1], BANK[$15]
LeftPadTextTo8:
  push hl
  push bc
  ld b, $0
.loop
  ld a, [hli]
  cp $50
  jr z, .endloop ; 0x11476 $3
  inc b
  jr .loop ; 0x11479 $f8
.endloop
  ld a, $8
  sub b
  pop bc
  pop hl
  ret

SECTION "Link Robattle - Load Medarot Names", ROMX[$7b34], BANK[$15]
LinkRobattleLoadMedarotNames: ; 15:7b34
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
REPT $7bbe - .end
  nop
ENDR

SECTION "Link Robattle - Partial Disassembly 5", ROMX[$558e], BANK[$15]
LinkRobattleInitialize: ; 5558e (15:558e)
  ld a, [$c753]
  call JumpTable_2bb
  ld a, [$c64e]
  ld [$c745], a
  xor a
  ld [$c65a], a
.asm_5559e
  ld hl, RobattleEnemyMedarot1
  ld b, $00
  ld a, [$c65a]
  ld c, a
  ld a, $08
  call JumpGetListTextOffset
  ld a, $03
  ld [de], a
  ld a, $01
  ld hl, $0
  add hl, de
  ld [hl], a
  ld a, [$c650]
  ld hl, .data_556a8
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $1
  add hl, de
  ld [hl], a
  ld a, [$c656]
  ld hl, $b
  add hl, de
  ld [hl], a
  call JumpTable_162
  ld a, [$c5f0]
  and $03
  ld hl, $c650
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $d
  add hl, de
  ld [hl], a
  call JumpTable_162
  ld a, [$c5f0]
  and $03
  ld hl, $c650
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $e
  add hl, de
  ld [hl], a
  call JumpTable_162
  ld a, [$c5f0]
  and $03
  ld hl, $c650
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $f
  add hl, de
  ld [hl], a
  call JumpTable_162
  ld a, [$c5f0]
  and $03
  ld hl, $c650
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, $10
  add hl, de
  ld [hl], a
  ld a, [$c65a]
  inc a
  ld hl, $11
  add hl, de
  ld [hl], a
  ld a, [$c64e]
  push af
  call $571d
  pop af
  ld [$c64e], a
  ld hl, $d
  add hl, de
  ld a, [hl]
  and $7f
  ld c, a
  call JumpLoadMedarotList
  push de
  ld b, $09
  ld hl, $2
  add hl, de
  ld d, h
  ld e, l
  ld hl, cBUF01
.asm_5564d
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_5564d
  pop de
  ld a, $01
  ld hl, $c8
  add hl, de
  ld [hl], a
  ld hl, $80
  add hl, de
  ld a, $01
  ld [hl], a
  ld hl, $b
  add hl, de
  ld a, [hl]
  ld hl, $81
  add hl, de
  ld [hl], a
  ld a, [$c654]
  ld b, a
  ld a, [$c934]
  add b
  ld c, a
  sub $0b
  jr c, .asm_5567b
  ld c, $0a
.asm_5567b
  ld a, c
  ld hl, $83
  add hl, de
  ld [hl], a
  ld a, [$c655]
  ld b, a
  ld a, [$c935]
  add b
  ld c, a
  sub $07
  jr c, .asm_55690
  ld c, $06
.asm_55690
  ld a, c
  ld hl, $84
  add hl, de
  ld [hl], a
  ld a, [$c65a]
  inc a
  ld [$c65a], a
  ld a, [$c64e]
  dec a
  ld [$c64e], a
  jp nz, .asm_5559e
  ret
.data_556a8
  db $00
; 0x556a9

SECTION "Link Robattle - Partial Disassembly 6", ROMX[$4bc9], BANK[$15]
LinkRobattleWriteText: ; 54bc9 (15:4bc9)
  call JumpTable_26d
  ld a, $01
  call JumpSetupDialog
  call $7977
  ld hl, $3c
  add hl, de
  ld a, [hl]
  ld [$c740], a
  call $7a36
  ld hl, $2
  add hl, de
  ld de, cBUF01
  ld b, $19
.asm_54be8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_54be8
  jp JumpIncSubStateIndexWrapper
; 0x54bf1


SECTION "Post-Robattle Screen - Partial Disassembly 1", ROMX[$5078], BANK[$7]
LinkPostRobattleSetupPartLostText: ; 1d078 (7:5078)
  ld a, $01
  call JumpSetupDialog
  ld a, $01
  call $57fc
  ld hl, cBUF01
  ld de, cBUF04
  ld a, $19
  call JumpTable_1ef
  ld a, $20
  ld [CoreSubStateIndex], a
  ret
; 0x1d093

SECTION "Post-Robattle Screen - Partial Disassembly 2", ROMX[$5828], BANK[$7]
LinkPostRobattleLoadTextWonMedal: ; 1d828 (7:5828)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $81
  add hl, de
  ld a, [hl]
  call JumpLoadMedalList ; Actually loads part name into cBUF01
  ld hl, cBUF01
  call LinkPostRobattleLoadPartNameForRoulette ; Loads it into cBUF04
  ret
LinkPostRobattleLoadTextWonHead: ; 1d83f (7:583f)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $39
  add hl, de
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $00
  call JumpTable_294
  ld hl, cBUF01
  call LinkPostRobattleLoadPartNameForRoulette
  ret
LinkPostRobattleLoadTextWonRArm: ; 1d85c (7:585c)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $3f
  add hl, de
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $01
  call JumpTable_294
  ld hl, cBUF01
  call LinkPostRobattleLoadPartNameForRoulette
  ret
LinkPostRobattleLoadTextWonLArm: ; 1d879 (7:5879)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $45
  add hl, de
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $02
  call JumpTable_294
  ld hl, cBUF01
  call LinkPostRobattleLoadPartNameForRoulette
  ret
LinkPostRobattleLoadTextWonLegs: ; 1d896 (7:5896)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $4b
  add hl, de
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $03
  call JumpTable_294
  ld hl, cBUF01
  call LinkPostRobattleLoadPartNameForRoulette
  ret
LinkPostRobattleLoadPartNameForRoulette: ; 1d8b3 (7:58b3)
  ld de, cBUF04
  ld b, $19
.asm_1d8b8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_1d8b8
  ret
; 0x1d8bf

SECTION "Post-Robattle Screen - Partial Disassembly 3", ROMX[$4cd2], BANK[$7]
Func_1ccd2: ; 1ccd2 (7:4cd2)
  ld a, $19
  ld [$ffa0], a
  ld a, [$c78c]
  call JumpTable_38d
  ld a, [$c78c]
  ld c, a
  ld b, $00
  ld a, [$c78d]
  call JumpTable_294
  ld hl, cBUF01
  ld de, cBUF04
  ld b, $19
.asm_1ccf0
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_1ccf0
  ld a, $01
  call JumpSetupDialog
  jp JumpIncSubStateIndexWrapper

SECTION "Post-Robattle Screen - Partial Disassembly 4", ROMX[$5175], BANK[$7]
Func_1d175: ; 1d175 (7:5175)
  ld hl, cBUF01
  ld de, cBUF04
  ld a, $19
  call JumpTable_1ef
  ld a, $01
  call JumpSetupDialog
  jp JumpIncSubStateIndexWrapper

SECTION "Post-Robattle Screen - Partial Disassembly 5", ROMX[$57dd], BANK[$7]
Func_1d7dd: ; 1d7dd (7:57dd)
  ld a, [$c782]
  ld d, a
  ld a, [$c783]
  ld e, a
  ld hl, $1
  add hl, de
  ld a, [hli]
  ld [$c756], a
  ld de, cBUF01
  ld b, $19
.asm_1d7f2
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_1d7f2
  call JumpTable_33f
  ret

SECTION "Post-Robattle Screen - Partial Disassembly 6", ROMX[$5b76], BANK[$7]
Func_1db76: ; 1db76 (7:5b76)
  ld hl, cBUF01
  ld de, cBUF04
  ld b, $19
.asm_1db7e
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_1db7e
  ld a, [$c78e]
  ld c, a
  ld b, $00
  ld a, [$c78f]
  call JumpTable_294
  ret
; 0x1db91

SECTION "Post-Robattle Screen - Partial Disassembly 7", ROMX[$5d11], BANK[$7]
Func_1dd11: ; 1dd11 (7:5d11)
  ld hl, cBUF01
  ld de, cBUF04
  ld b, $19
.asm_1dd19
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_1dd19
  ld a, [$c78c]
  ld c, a
  ld b, $00
  ld a, [$c78d]
  call JumpTable_294
  ret
; 0x1dd2c
