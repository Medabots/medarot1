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
  dw $537e ; ret
  dw $537e ; ret
  dw $537e ; ret
  dw $537e ; ret
  dw $537e ; ret
  dw $5389 ; Clear screen
  dw SaveScreenExitAsyncRestoreTileset
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

SaveScreenSubStateIndex   EQU $c750
SECTION "Save Screen States Async Draw Save Screen Tilemap", ROMX[$51b0], BANK[$2]
SaveScreenInitAsyncDrawTilemap: ; It gets drawn in chunks
  ld a, [SaveScreenSubStateIndex]
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
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
.draw_bottom_half
  ld b, $00
  ld c, $05
  ld e, $2d
  call JumpLoadTilemap
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
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
  ld [SaveScreenSubStateIndex], a
  ret

SECTION "Save Screen States (partial disassembly)", ROMX[$575f], BANK[$2]
SaveScreenExitAsyncRestoreTileset: ; 975f (2:575f)
  call SaveScreenExitAsyncRestoreTilesetStateMachine ; Redraw tilesets
  ld a, [SaveScreenSubStateIndex]
  cp $ff
  ret nz
  call SaveScreenExitAsyncRestoreTilesetCleanup
  jp MenuIncrementStateSubIndex
SaveScreenExitSetState: ; 976e (2:576e)
  ld a, $05
  ld [$ffa0], a
  ld a, $01
  ld [$c600], a
  ld a, $01
  ld [MenuStateIndex], a
  ld a, $02
  ld [MenuStateSubIndex], a
  ret
SaveScreenExitAsyncRestoreTilesetCleanup: ; 9782 (2:5782)
  ld a, $02
  call JumpTable_17d
  ret
SaveScreenExitAsyncRestoreTilesetIncrementState: ; 9788 (2:5788)
  ld a, [SaveScreenSubStateIndex]
  inc a
  ld [SaveScreenSubStateIndex], a
  ret
; 0x9790

SECTION "SaveScreenExitAsyncRestoreTilesetStateMachine", ROMX[$5c15], BANK[$2]
SaveScreenExitAsyncRestoreTilesetStateMachine: ; 9c15 (2:5c15)
  ld a, [SaveScreenSubStateIndex]
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
  dw $5c35
  dw $5c3b
  dw SaveScreenExitAsyncRestoreTilesetMainSpecial ; TilesetMainSpecial
  dw SaveScreenExitAsyncRestoreTilesetMainDialog ; TilesetMainDialog
  dw $5c8f
  dw $5cb5
  dw $5cc5
  dw $56cd

SECTION "SaveScreenExitAsyncRestoreTilesetStateMachine - Tileset Restoration", ROMX[$5c53], BANK[$2]
SaveScreenExitAsyncRestoreTilesetMainSpecial: ; 9c53 (2:5c53)
  ld a, [$c6c8]
  cp $03
  jr z, .asm_9c62
  ld a, $02
  call JumpLoadFont
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
.asm_9c62
  ld a, $02
  ld b, $01
  call JumpDecompressAndLoadTiles
  ld a, [$c64e]
  or a
  ret nz
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
SaveScreenExitAsyncRestoreTilesetMainDialog: ; 9c71 (2:5c71)
  ld a, [$c6c8]
  cp $03
  jr z, .asm_9c80
  ld a, $03
  call JumpLoadFont
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
.asm_9c80
  ld a, $03
  ld b, $01
  call JumpDecompressAndLoadTiles
  ld a, [$c64e]
  or a
  ret nz
  jp SaveScreenExitAsyncRestoreTilesetIncrementState
; 0x9c8f
