INCLUDE "game/src/common/constants.asm"

SECTION "Part Trade State Machine", ROMX[$46A2], BANK[$7]
PartTradeStateMachine::
  call $607F
  ld a, [$C64E]
  or a
  jr z, .stillConnected
  xor a
  ld [CoreStateIndex], a
  ld [CoreSubStateIndex], a
  ret

.stillConnected
  call $5310
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
  dw PartTradeDrawScreenState
  dw PartTradeMapScreenState
  dw PartTradeFadeInState
  dw $47FD
  dw $4819
  dw $4821
  dw $482F
  dw $483B
  dw $488C
  dw $48A5
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw $48B6
  dw $48BE
  dw $48CC
  dw $48E8
  dw $48F8
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw $49B5
  dw $49D1
  dw $49F0
  dw $49F7
  dw $477D
  dw $4797
  dw $47A8
  dw $4797
  dw $4A07
  dw $4A0E
  dw $4797
  dw $4A30
  dw $4A47
  dw $4A4F
  dw $4A64
  dw $4A80
  dw $4AAB
  dw $4AB3
  dw $4AC6
  dw $4AEA
  dw $4BEA
  dw PartTradePlaceholderState
  dw $4C26
  dw PartTradePlaceholderState
  dw $4C30
  dw $4C3D
  dw $4C64
  dw $4C79
  dw $4CA0
  dw $4CA6
  dw $4CC1
  dw PartTradePlaceholderState
  dw $4CD2
  dw $4CFE
  dw $477D
  dw $4D11
  dw PartTradeFadeOutState
  dw $4D1D
  dw $4D24
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState
  dw PartTradePlaceholderState

PartTradePlaceholderState::
  ret

PartTradeFadeInState::
  ld a, 0
  call JumpTable_180
  or a
  ret z
  jp JumpIncSubStateIndexWrapper

PartTradeFadeOutState::
  ld a, 1
  call JumpTable_180
  or a
  ret z
  jp JumpIncSubStateIndexWrapper

SECTION "Link Robattle State Machine - Part 2", ROMX[$47B9], BANK[$7]
PartTradeDrawScreenState::
  call JumpTable_1a7
  call JumpTable_1aa
  call JumpTable_213
  call JumpTable_156
  ld a, 3
  call JumpLoadFont
  ld a, $13
  call JumpLoadFont
  ld a, 1
  call JumpLoadFont
  ld b, 5
  ld c, 5
  ld d, 5
  ld e, 5
  ld a, 2
  call JumpTable_309
  jp JumpIncSubStateIndexWrapper

PartTradeMapScreenState::
  ld b, 0
  ld c, 0
  ld e, $E
  call JumpLoadTilemap
  ld a, 6
  ldh [$FFA0], a
  xor a
  ld [$C6F0], a
  ld a, 1
  call JumpTable_17d
  jp JumpIncSubStateIndexWrapper
