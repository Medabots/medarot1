; Core state machine for the menu screens

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Menu State Machine", ROMX[$4000], BANK[$2]
MenuStateMachine::
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
  dw InitializeMenu ; Initialization, called on main menu load
  dw MenuSubStateMachine ; Menus initialized, stays in this state

InitializeMenu: ; 8016 (2:4016)
  xor a
  ld [MenuStateIndex], a ; What menu we're in
  ld [MenuStateSubIndex], a ; What state the current menu is in
  ld [MenuStateCounter], a
  ld [MainMenuPosition], a
  ld [InfoMenuPosition], a
  ld [$c6f2], a
  ld [$c6f3], a
  ld [$c6f4], a
  ld [$c6f5], a
  ld [$c6f6], a
  ld [$c6f7], a
  ld a, $03
  call JumpLoadFont
  ld a, $01
  call JumpEnableSRAM
  call JumpIncSubStateIndexWrapper
  ret

MenuSubStateMachine: ; 8046 (2:4046)
  ld a, [MenuStateIndex]
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
  dw MainMenuStateMachine ; Main Menu State Machine
  dw InfoMenuStateMachine ; Info Menu State Machine
  dw InventoryScreenStateMachine ; Inventory Screen State Machine
  dw SaveScreenStateMachine ; Save Screen State Machine
  dw MedarotScreenStateMachine ; Medarot Screen State Machine
  dw MedalScreenStateMachine ; Medal Screen State Machine
  dw PartScreenStateMachine ; Part Screen State Machine


SECTION "Menu State Machine Utility functions", ROMX[$44f7], BANK[$2]
MenuSwapCursor:: ; 84f7 (2:44f7)
  push af ;; Highlights the cursor
  push bc
  push de
  ld a, [$c902]
  ld h, a
  ld a, [$c903]
  ld l, a
  ld de, $1
.asm_8505
  add hl, de
  call JumpTable_20a
  dec b
  jr nz, .asm_8505
  pop de
  ld e, d
  ld d, $00
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
  sla e
  rl d
  add hl, de
  pop bc
  ld e, c
  ld d, $00
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
  call JumpTable_210
  pop af
  or a
  jr z, .asm_8553
  cp $02
  jr z, .asm_8551
  ld a, $f8
  jr .asm_8553
.asm_8551
  ld a, $f9
.asm_8553
  di
  call JumpWaitLCDController
  ld [hl], a
  ei
  ret
; 0x855a

SECTION "Menu State Machine Utility functions 2", ROMX[$45a0], BANK[$2]
MenuIncrementStateCounter::
  ld a, [MenuStateCounter]
  add b
  ld [MenuStateCounter], a
  ret
MenuWaitLCD:: ; 85a8 (2:45a8)
  push af
.loop
  ld a, [hLCDStat]
  and $02
  jr nz, .loop
  pop af
  ret
MenuIncrementStateSubIndex::
  ld a, [MenuStateSubIndex]
  inc a
  ld [MenuStateSubIndex], a
  ret

SECTION "Menu State Machine Return", ROMX[$537e], BANK[$2]
MenuStateMachineRet::
  ret

SECTION "Menu State Machine Utility functions 3", ROMX[$5788], BANK[$2]
TempStateIncrementStateIndex:: ; 9788 (2:5788)
  ld a, [TempStateIndex]
  inc a
  ld [TempStateIndex], a
  ret
; 0x9790
