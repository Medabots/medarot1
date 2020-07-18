; Core state machine for the link robattles

INCLUDE "game/src/common/constants.asm"

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
  call JumpTable_1e6
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
  call JumpLoadTilemap
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
  call JumpLoadTilemap
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
  ld a, $0a
  call JumpLoadFont
  call $65f5
  jp JumpIncSubStateIndexWrapper

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
  cp $01
  jr nz, .asm_54c88
  xor a
  ld [de], a
  jr .asm_54c8e
.asm_54c88
  ld a, $04
  add l
  ld l, a
  ld a, [hl]
  ld [de], a
.asm_54c8e
  inc de
  ld a, $04
  add l
  ld l, a
  dec b
  jr nz, .asm_54c7f
  ld a, [$c740]
  inc a
  ld [$c740], a
  cp $03
  jp z, .asm_4ca8
  ld a, $33
  ld [CoreSubStateIndex], a
  ret
.asm_4ca8
  xor a
  ld [$c740], a
  ld [$c741], a
  ld [$c742], a
  jp JumpIncSubStateIndexWrapper
; 0x54cb5

SECTION "Link Robattle - Copy Player Medarot Info", ROMX[$5111], BANK[$15]
LinkRobattleScreenCopyPlayerMedarotInfo: ; 55111 (15:5111)
  ld c, $0a
.asm_5113
  ld a, [de]
  ld b, a
  ld a, [$c64e]
  cp b
  jp nz, .asm_515d
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
  push hl
.asm_5513d
  ld a, [de]
  ld [hli], a
  inc de
  dec b
  jr nz, .asm_5513d
  ld a, [$c652]
  inc a
  ld [$c652], a
  pop hl
  ld d, h
  ld e, l
  ld hl, $11
  add hl, de
  ld a, [$c650]
  ld [hl], a
  ld a, [$c650]
  inc a
  ld [$c650], a
  ret
.asm_515d
  ld a, [$c654]
  inc a
  ld [$c654], a
  inc de
  dec c
  jp nz, .asm_5113
  ret
; 0x5516a

SECTION "Link Robattle States - Load Part Data", ROMX[$5867], BANK[$15]
LinkRobattleLoadPartHead:
  ld hl, $000d
  add hl, de
  ld a, [hl]
  and a, $7f
  sub a, $3c
  jp c, .valid_part
.broken_or_missing_part
  ld b, $06
  ld c, $0d
  ld e, $86 ; -------
  call JumpLoadTilemap
  ret
.valid_part ; 5587d (15:587d)
  ld hl, $d3
  add hl, de
  ld a, [hl]
  or a
  jr z, .broken_or_missing_part
  ld hl, $d
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b520
  ld c, a
  ld b, $00
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $00
  call JumpTable_294
  ld hl, cBUF01
  call JumpPadTextTo8
  ld hl, $99c6
  ld b, $00
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call JumpPutString
  ret

LinkRobattleLoadPartRightArm:
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and a, $7f
  sub a, $3c
  jp c, .valid_part
.broken_or_missing_part
  ld b, $0b
  ld c, $0f
  ld e, $86 ; -------
  call JumpLoadTilemap
  ret
.valid_part
  ld hl, $000e
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b5a0
  ld c, a
  ld b, $00
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $01
  call JumpTable_294
  ld hl, cBUF01
  ld bc, $9a0b
  call JumpPutString
  ret

LinkRobattleLoadPartLeftArm:
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and a, $7f
  sub a, $3c
  jp c, .valid_part
.broken_or_missing_part
  ld b, $01
  ld c, $0f
  ld e, $86 ; -------
  call JumpLoadTilemap
  ret
.valid_part
  ld hl, $000f
  add hl, de
  ld a, [hl]
  and $7f
  ld hl, $b620
  ld c, a
  ld b, $00
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $00
  ld c, $02
  call JumpTable_294
  ld hl, cBUF01
  call LeftPadTextTo8
  ld hl, $9a01
  ld b, $00
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call JumpPutString
  ret

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
  ld hl, $0002
  add hl, de
  call LeftPadTextTo8
  ld [$c650], a
  push de
  ld hl, $98e0
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $6
  call JumpGetListTextOffset
  pop de
  ld a, [$c650]
  ld b, $0
  ld c, a
  add hl, bc
  ld b, h
  ld c, l
  ld hl, $0002
  add hl, de
  call JumpPutString
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
  ld hl, $98ec
  ld b, $0
  ld a, [$c652]
  ld c, a
  ld a, $6
  call JumpGetListTextOffset
  pop de
  ld b, h
  ld c, l
  ld hl, $0002
  add hl, de
  call JumpPutString
.next_enemy_medarot
  ld a, [$c652]
  inc a
  ld [$c652], a
  cp $3
  jp nz, .loop_enemy_medarot
  ret
