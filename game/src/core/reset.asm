INCLUDE "game/src/common/constants.asm"

SECTION "Game Reset State Machine",  ROMX[$5B0F],  BANK[$1]
ResetGameStateMachine::
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
  ret

.table
  dw ResetGameSubStateInitA
  dw ResetGameSubStateInitB
  dw ResetGameSubStateBeginGame

ResetGameSubStateInitA::
  ld a, 1
  ld [$CE96], a
  ld a, 2
  ld [$C5B1], a
  xor a
  ld [$C5B0], a
  ld a, [$C5A6]
  sub $E4
  jr c, .exit
  xor a
  ld [$C5B2], a

.exit
  jp JumpIncSubStateIndexWrapper

ResetGameSubStateInitB::
  ld a, 1
  call JumpTable_180
  or a
  ret z
  call JumpTable_192
  ld a, [$C5FA]
  push af
  call JumpTable_18f
  call JumpTable_153
  call JumpTable_240
  ld a, 1
  ld [$C600], a
  call JumpTable_174
  ld a, $C3
  ld [$C5A9], a
  ldh [hRegLCDC], a
  xor a
  ldh [$FF0F], a
  ld a, 9
  ldh [$FFFF], a
  ei
  call JumpTable_243
  ld a, $40
  ldh [hLCDStat], a
  xor a
  ldh [$FF0F], a
  ld a, $B
  ldh [$FFFF], a
  pop af
  ld [$C5FA], a
  ld a, 2
  ld [CoreSubStateIndex], a
  ret

ResetGameSubStateBeginGame::
  ld a, 1
  ld [CoreStateIndex], a
  xor a
  ld [CoreSubStateIndex], a
  ret
