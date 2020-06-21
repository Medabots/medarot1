SECTION "Robattle State Machine", ROMX[$4000], BANK[$4]
RobattleStateMachine::
  ld a, [CoreSubStateIndex]
  ld hl, .table
  ld d, 0
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl

.table
  dw RobattleStateInitialize ; 00
  dw RobattleSubStateDoSomething ; 01
  dw RobattleInitializeSubState ; 02
  dw RobattleStateLoadMedarotSelectTilemaps ; 03
  dw $4077 ; 04
  dw $4115 ; 05
  dw $4123 ; 06
  dw $41B6 ; 07
  dw $4226 ; 08
  dw $423D ; 09
  dw $430B ; 0A
  dw $43EC ; 0B
  dw $44BC ; 0C
  dw RobattleStateLoadMedarotSelectPartTilemap ; 0D
  dw $45C4 ; 0E
  dw $45E4 ; 0F
  dw $4604 ; 10
  dw $4614 ; 11
  dw RobattleStateDoNothing ; 12
  dw $4B45 ; 13
  dw RobattleStateDoNothing ; 14
  dw RobattleStateDoNothing ; 15
  dw RobattleStateDoNothing ; 16
  dw RobattleStateDoNothing ; 17
  dw RobattleStateDoNothing ; 18
  dw RobattleStateDoNothing ; 19
  dw $4624 ; 1A
  dw $4646 ; 1B
  dw $467A ; 1C
  dw $4077 ; 1D
  dw $4699 ; 1E
  dw $46A3 ; 1F
  dw $46EE ; 20
  dw $46F8 ; 21
  dw RobattleStatePrepareAttackScreen ; 22
  dw $4778 ; 23
  dw $483A ; 24
  dw $4852 ; 25
  dw $486E ; 26
  dw $48B8 ; 27
  dw $494A ; 28
  dw $4974 ; 29
  dw $49B4 ; 2A
  dw $4A02 ; 2B
  dw $4ADF ; 2C
  dw $4AFB ; 2D
  dw $4B1A ; 2E
  dw RobattleStateDoNothing ; 2F
  dw $4B58 ; 30
  dw $4B80 ; 31

RobattleStateDoNothing::
  ; This is a placeholder state.
  ret

SECTION "Robattle States (Partial 1)", ROMX[$408B], BANK[$4]
RobattleStateInitialize: ; 1008b (4:408b)
  ld a, $01
  call JumpTable_1e6
  xor a
  ld [$c750], a
  ld a, $02
  ld [$ffa0], a
  jp JumpIncSubStateIndexWrapper

RobattleSubStateDoSomething: ; 1009b (4:409b), not sure what this does exaclty
  call $722d
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

RobattleInitializeSubState: ; 100b5 (4:40b5)
  xor a
  ld [$c740], a
  jp JumpIncSubStateIndexWrapper

RobattleStateLoadMedarotSelectTilemaps: ; 100bc (4:40bc)
  ld a, [$c740]
  or a
  jr nz, .asm_100dd
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
.asm_100dd
  ld b, $0a
  ld c, $00
  ld e, $9b
  call JumpLoadTilemap
  ld b, $00
  ld c, $0c
  ld e, $30
  call JumpLoadTilemap
  call JumpTable_29d
  call $77e4
  ld a, [$c72d]
  ld b, $01
  call JumpTable_2a3
  call $77af
  ld a, $02
  call JumpTable_17d
  ld b, $08
  ld c, $09
  ld d, $0a
  ld e, $00
  ld a, $05
  call JumpTable_309
  jp JumpIncSubStateIndexWrapper

SECTION "Robattle States (Partial 2)", ROMX[$4564], BANK[$4]
RobattleStateLoadMedarotSelectPartTilemap: ; 10564 (4:4564)
  call $4c66
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
.asm_1058e
  xor a
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  dec b
  jr nz, .asm_1058e
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
; 0x105c4


SECTION "Robattle States (Partial 3)", ROMX[$4748], BANK[$4]
RobattleStatePrepareAttackScreen::
  ld a, [$A044]
  ld d, a
  ld a, [$A045]
  ld e, a
  call $54CB
  ld hl, $58
  add hl, de
  ld a, [hl]
  call $5481
  call $76AA
  ld hl, $58
  add hl, de
  ld a, [hl]
  ld hl, .table
  ld b, 0
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$C72D], a
  call $584A
  jp JumpIncSubStateIndexWrapper

.table
  db 3, 0, 1, 2
