; Main Menu state machine

INCLUDE "game/src/menu/include/variables.asm"

SECTION "Main Menu State Machine", ROMX[$4066], BANK[$2]
MainMenuStateMachine:: ; 8066 (2:4066)
  ld a, [MenuStateSubIndex]
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
  dw InitializeMainMenu
  dw AdditionalSetupMainMenu ; Additional Setup
  dw $40C9 ; Main Menu steady state
  dw $4157 ; Clean up this menu
  dw $4186 ; Exiting this menu

InitializeMainMenu: ; 8082 (2:4082)
  xor a
  call $42d3
  ld a, [$c5a2]
  srl a
  srl a
  srl a
  add $0d
  ld b, a
  ld a, [$c5a3]
  srl a
  srl a
  srl a
  ld c, a
  ld e, $60
  call JumpLoadTilemap
  jp MenuIncrementStateSubIndex

AdditionalSetupMainMenu: ; 80a4 (2:40a4)
  ld b, $01
  call MenuIncrementStateCounter
  ld b, $10
  ld c, $68
  ld d, $68
  ld e, $a8
  call JumpTable_204
  ld b, $10
  ld c, $30
  ld d, $20
  ld e, $68
  call JumpTable_204
  call DrawPlayerMoneyInMenu
  ld a, $05
  ld [$ffa0], a
  jp MenuIncrementStateSubIndex