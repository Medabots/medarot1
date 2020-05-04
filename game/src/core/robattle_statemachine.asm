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
  dw $408B ; 00
  dw $409B ; 01
  dw $40B5 ; 02
  dw $40BC ; 03
  dw $4077 ; 04
  dw $4115 ; 05
  dw $4123 ; 06
  dw $41B6 ; 07
  dw $4226 ; 08
  dw $423D ; 09
  dw $430B ; 0A
  dw $43EC ; 0B
  dw $44BC ; 0C
  dw $4564 ; 0D
  dw $45C4 ; 0E
  dw $45E4 ; 0F
  dw $4604 ; 10
  dw $4614 ; 11
  dw RobattleStatePrepareAttackScreen ; 12
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
  dw RobattleStatePrepareAttackScreenOffload ; 22
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

SECTION "Robattle States (Partial)", ROMX[$4748], BANK[$4]
RobattleStatePrepareAttackScreen::
  ld a, [$A044]
  ld d, a
  ld a, [$A045]
  ld e, a
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
  ld a, $23
  ld [CoreSubStateIndex], a
  ret

.table
  db 3, 0, 1, 2

SECTION "Robattle States (Hack)", ROMX[$796a], BANK[$4]
RobattleStatePrepareAttackScreenOffload::
  ld a, [$A044]
  ld d, a
  ld a, [$A045]
  ld e, a
  ld a, [RobattleAttackNameDrawStagingIndex]

.checkStage0
  or a
  jr nz, .checkStage1
  ld hl,$99A1
  ld bc, $1204
  call $0270
  jr .nextStage

.checkStage1
  dec a
  jr nz, .checkStage2
  call $54E5
  jr .nextStage

.checkStage2
  dec a
  jr nz, .checkStage3
  call $5535
  jr .nextStage

.checkStage3
  dec a
  jr nz, .exit
  call $5571

.nextStage
  ld a, [RobattleAttackNameDrawStagingIndex]
  inc a
  ld [RobattleAttackNameDrawStagingIndex], a
  ret

.exit
  xor a
  ld [RobattleAttackNameDrawStagingIndex], a
  ld a, $12
  ld [CoreSubStateIndex], a
  ret
