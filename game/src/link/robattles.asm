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
  dw $45e7
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
  dw $46f8
  dw $4714
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
  dw $4c6f
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