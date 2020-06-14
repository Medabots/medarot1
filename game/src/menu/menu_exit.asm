; Menu Exit functions (including a state machine for tileset restoration)

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Menu Exit States (partial disassembly)", ROMX[$575f], BANK[$2]
MenuExitExitAsyncRestoreTileset:: ; 975f (2:575f)
  call MenuExitExitAsyncRestoreTilesetStateMachine ; Redraw tilesets
  ld a, [TempStateIndex]
  cp $ff
  ret nz
  call MenuExitExitAsyncRestoreTilesetCleanup
  jp MenuIncrementStateSubIndex
MenuExitExitSetState:: ; 976e (2:576e)
  ld a, $05
  ld [$ffa0], a
  ld a, $01
  ld [$c600], a
  ld a, $01
  ld [MenuStateIndex], a
  ld a, $02
  ld [MenuStateSubIndex], a
  ret
MenuExitExitAsyncRestoreTilesetCleanup: ; 9782 (2:5782)
  ld a, $02
  call JumpTable_17d
  ret

SECTION "MenuExitExitAsyncRestoreTilesetStateMachine", ROMX[$5c15], BANK[$2]
MenuExitExitAsyncRestoreTilesetStateMachine: ; 9c15 (2:5c15)
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
  dw $5c35
  dw $5c3b
  dw MenuExitExitAsyncRestoreTilesetMainSpecial ; TilesetMainSpecial
  dw MenuExitExitAsyncRestoreTilesetMainDialog ; TilesetMainDialog
  dw $5c8f
  dw $5cb5
  dw $5cc5
  dw $56cd

SECTION "MenuExitExitAsyncRestoreTilesetStateMachine - Tileset Restoration", ROMX[$5c53], BANK[$2]
MenuExitExitAsyncRestoreTilesetMainSpecial: ; 9c53 (2:5c53)
  ld a, [$c6c8]
  cp $03
  jr z, .asm_9c62
  ld a, $02
  call JumpLoadFont
  jp TempStateIncrementStateIndex
.asm_9c62
  ld a, $02
  ld b, $01
  call JumpDecompressAndLoadTiles
  ld a, [$c64e]
  or a
  ret nz
  jp TempStateIncrementStateIndex
MenuExitExitAsyncRestoreTilesetMainDialog: ; 9c71 (2:5c71)
  ld a, [$c6c8]
  cp $03
  jr z, .asm_9c80
  ld a, $03
  call JumpLoadFont
  jp TempStateIncrementStateIndex
.asm_9c80
  ld a, $03
  ld b, $01
  call JumpDecompressAndLoadTiles
  ld a, [$c64e]
  or a
  ret nz
  jp TempStateIncrementStateIndex
; 0x9c8f
