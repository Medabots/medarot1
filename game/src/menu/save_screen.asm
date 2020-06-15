; Save Screen state machine

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Save Screen State Machine", ROMX[$5037], BANK[$2]
SaveScreenStateMachine::
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
  dw $5393
  dw $5389
  dw $5071
  dw $5096
  dw $537f ; Calls async tilemap routines including blanking the screen for the fadeout
  dw SaveScreenLoadSaveDialogTilemap ; Draw Text Box and 'Do you want save?'
  dw SaveScreenLoadSaveYesNoTilemap ; Draw Yes/No
  dw $50d7 ; steady state
  dw $5155
  dw $516e
  dw $5182
  dw MenuStateMachineRet ; ret
  dw MenuStateMachineRet ; ret
  dw MenuStateMachineRet ; ret
  dw MenuStateMachineRet ; ret
  dw MenuStateMachineRet ; ret
  dw $5389 ; Clear screen
  dw MenuExitAsyncRestoreTileset
  dw $537f
  dw $51a0
  dw $50fa

SECTION "Save Screen Screen States Draw Tilemaps", ROMX[$50b2], BANK[$2]
SaveScreenLoadSaveDialogTilemap: ; 90b2 (2:50b2)
  ld b, $00
  ld c, $0c
  ld e, $30
  call JumpLoadTilemap
  ld b, $01
  ld c, $0d
  ld e, $25
  call JumpLoadTilemap
  jp MenuIncrementStateSubIndex

SaveScreenLoadSaveYesNoTilemap: ; 90c7 (2:50c7)
  ld b, $0e
  ld c, $0b
  ld e, $68
  call JumpLoadTilemap
  xor a
  ld [$c6f1], a
  jp MenuIncrementStateSubIndex

SECTION "Save Screen States Async Draw Save Screen Tilemap", ROMX[$51b0], BANK[$2]
SaveScreenInitAsyncDrawTilemap: ; It gets drawn in chunks
  ld a, [TempStateIndex]
  ld hl, .table
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
.table
  dw .draw_top_half
  dw .draw_bottom_half
  dw .draw_strings
.draw_top_half
  ld b, $00
  ld c, $00
  ld e, $24
  call JumpLoadTilemap
  jp TempStateIncrementStateIndex
.draw_bottom_half
  ld b, $00
  ld c, $05
  ld e, $2d
  call JumpLoadTilemap
  jp TempStateIncrementStateIndex
.draw_strings
  ld hl, cNAME
  ld bc, $9847
  call JumpPutString
  ld a, [$c8f0]
  ld h, a
  ld a, [$c8f1]
  ld l, a
  ld bc, $9884
  call JumpTable_1ec
  ld a, [$c8f2]
  ld h, a
  ld a, [$c8f3]
  ld l, a
  ld bc, $988e
  call JumpTable_1ec
  ld a, [$c8f4]
  ld hl, $994c
  call JumpTable_2fa
  ld a, [$c8f5]
  ld hl, $994f
  call JumpTable_2fa
  call $5223
  call $526f
  ld a, $ff
  ld [TempStateIndex], a
  ret
