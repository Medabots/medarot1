; Info Menu state machine

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Info Menu State Machine", ROMX[$41a7], BANK[$2]
InfoMenuStateMachine::
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
  dw InitializeInfoMenu
  dw InitialSetupInfoMenu ; Additional Setup
  dw SteadyStateInfoMenu ; Info Menu steady state
  dw CleanupInfoMenu ; Clean up this menu
  dw ExitInfoMenu ; Exiting this menu

InitializeInfoMenu: ; 81c3 (2:41c3)
  ld b, $01
  call MenuIncrementStateCounter
  ld a, $01
  call $42d3
  ld a, [$c5a2]
  srl a
  srl a
  srl a
  add $0c
  ld b, a
  ld a, [$c5a3]
  srl a
  srl a
  srl a
  add $03
  ld c, a
  ld e, $61
  call JumpLoadTilemap
  xor a
  ld [InfoMenuPosition], a
  ld [$c6f2], a
  ld [$c6f3], a
  jp MenuIncrementStateSubIndex
; 0x81f7

InitialSetupInfoMenu: ; 81f7 (2:41f7)
  ld b, $30
  ld c, $80
  ld d, $60
  ld e, $a8
  call JumpTable_204
  jp MenuIncrementStateSubIndex

SteadyStateInfoMenu: ; 8205 (2:4205)
  ld a, [InfoMenuPosition]
  ld d, a
  ld a, $01
  ld b, $0d
  ld c, $05
  call MenuSwapCursor
  ld a, [hJPInputChanged]
  and hJPInputB
  jr z, .check_inputs
  ld a, $06
  ld [$ffa1], a
  call MenuIncrementStateSubIndex
  jp MenuIncrementStateSubIndex
.check_inputs
  ld a, [hJPInputChanged]
  and hJPInputA | hJPInputStart
  jp z, .no_input
  ld a, $04
  ld [$ffa1], a
  ld a, [InfoMenuPosition]
  cp $00
  jr nz, .check_medals
  ld a, [InfoMenuPosition]
  ld d, a
  ld a, $02
  ld b, $0d
  ld c, $05
  call MenuSwapCursor
  ld a, $02
  ld [$ffa0], a
  ld a, $04
  ld [MenuStateIndex], a
  ld a, $00
  ld [MenuStateSubIndex], a
  ret
.check_medals
  cp $01
  jr nz, .check_parts
  ld a, [InfoMenuPosition]
  ld d, a
  ld a, $02
  ld b, $0d
  ld c, $05
  call MenuSwapCursor
  ld a, $02
  ld [$ffa0], a
  ld a, $05
  ld [MenuStateIndex], a
  ld a, $00
  ld [MenuStateSubIndex], a
  ret
.check_parts
  cp $02
  jr nz, .exit
  ld a, [InfoMenuPosition]
  ld d, a
  ld a, $02
  ld b, $0d
  ld c, $05
  call MenuSwapCursor
  ld a, $02
  ld [$ffa0], a
  ld a, $06
  ld [MenuStateIndex], a
  ld a, $00
  ld [MenuStateSubIndex], a
  ret
.exit
  call MenuIncrementStateSubIndex
  jp MenuIncrementStateSubIndex
.no_input: ; 8296 (2:4296)
  ld a, $03
  ld hl, InfoMenuPosition
  ld b, $0d
  ld c, $05
  call $455a
  ret

CleanupInfoMenu: ; 82a3 (2:42a3)
  ld a, $01
  call JumpTable_180
  or a
  ret z
  ld a, $04
  ld [$c6c8], a
  xor a
  ld [$c6c9], a
  ret

ExitInfoMenu: ; 82b4 (2:42b4)
  ld a, $01
  ld b, $01
  call $445f
  ld a, [$c64e]
  or a
  ret nz
  call JumpTable_207
  ld b, $ff
  call MenuIncrementStateCounter
  ld a, $00
  ld [$c6c8], a
  ld a, $02
  ld [$c6c9], a
  ret
; 0x82d3