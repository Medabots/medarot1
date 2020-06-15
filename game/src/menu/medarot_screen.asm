; Medarot Screen state machine

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Medarot Screen State Machine", ROMX[$683b], BANK[$2]
MedarotScreenStateMachine::
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
  dw $68a6
  dw $689c
  dw $68bf ; 
  dw MedarotScreenSetupLoadTilesets ; Load tilesets
  dw MedarotScreenSetupLoadTilemaps ; Load tilemaps
  dw $6892 
  dw MedarotScreenSetupSetupSquares ; Draw empty squares
  dw MedarotScreenSetupSetupMedarots ; Draw medarots
  dw $6973 ; main screen idle state
  dw $689c
  dw $6a9f
  dw $6aca
  dw $6aef
  dw $6892
  dw $6b16
  dw $6bb5
  dw $6beb
  dw $6bee
  dw $6c05
  dw $6c3c
  dw $6c4a
  dw $5389
  dw MenuExitAsyncRestoreTileset
  dw $537f
  dw MenuExitSetState
  dw $6891 ; ret
  dw $6891 ; ret
  dw $6891 ; ret
  dw $6cdd
  dw $537f
  dw $6cec
  dw $6d3c
  dw $6d4d
  dw $6d57

SECTION "Medarot Screen State Machine (partial disassembly)", ROMX[$690b], BANK[$2]
MedarotScreenSetupLoadTilesets: ; a90b (2:690b)
  ld a, $0a
  call JumpLoadFont
  ld a, $0b
  call JumpLoadFont
  ld a, $0c
  call JumpLoadFont
  ld de, $8600
  call JumpTable_29a
  ld a, $00
  ld [$c72d], a
  ld [$c740], a
  ld a, $20
  ld [MenuStateSubIndex], a
  ret

MedarotScreenSetupLoadTilemaps: ; a92e (2:692e)
  ld b, $00
  ld c, $00
  ld e, $03 ; MedarotSelect
  call JumpLoadTilemap
  ld b, $00
  ld c, $0c
  ld e, $22 ; MedarotSelectHelpText
  call JumpLoadTilemap
  ld a, $02
  call JumpTable_17d
  ld b, $08
  ld c, $09
  ld d, $0a
  ld e, $00
  ld a, $05
  call JumpTable_309
  jp MenuIncrementStateSubIndex

MedarotScreenSetupSetupSquares: ; a955 (2:6955)
  call JumpTable_29d
  ld a, [$c72d]
  ld b, $01
  call JumpTable_2a3
  ld a, $00
  ld [$c740], a
  jp MenuIncrementStateSubIndex
; 0xa968

MedarotScreenSetupSetupMedarots: ; a968 (2:6968)
  call JumpMedarotScreenSetupMedarotSelect
  ld a, [$c6c6]
  or a
  ret z
  jp MenuIncrementStateSubIndex

MedarotSelectStateIndex   EQU $c740
SECTION "Medarot Screen State Machine - Setup Medarot Select", ROMX[$7815], BANK[$2]
MedarotScreenSetupMedarotSelect::
  xor a
  ld [$c6c6], a
  ld a, [$c72d]
  call MedarotScreenSetupMedarotSelectLoadData
  ld hl, .table
  ld b, $00
  ld a, [MedarotSelectStateIndex]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
.table
  dw $7841 ; Draw medarot sprites in squares
  dw $784e
  dw $788a
  dw $78c6 ; Starts drawing large medarot portrait tileset
  dw $7902
  dw $794a
  dw $7963 ; Load portrait into frame
  dw MedarotScreenSetupWriteName ; Write medarot name

SECTION "Medarot Screen State Machine - Setup Medarot Select - Write Medarot Name", ROMX[$798a], BANK[$2]
MedarotScreenSetupWriteName: ; b98a (2:798a)
  ld hl, $0
  add hl, de
  ld a, [hl]
  or a
  jr z, .asm_b9a7
  ld hl, $2
  add hl, de
  push hl
  call JumpPadTextTo8
  ld h, $00
  ld l, a
  ld bc, $994b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call JumpPutString
.asm_b9a7
  xor a
  ld [MedarotSelectStateIndex], a
  ld [$c741], a
  ld a, $01
  ld [$c6c6], a
  ret
; 0xb9b4

SECTION "Medarot Screen State Machine - Setup Medarot Select - Utility", ROMX[$7b81], BANK[$2]
MedarotScreenSetupIncrementState: ; bb81 (2:7b81)
  ld a, [MedarotSelectStateIndex]
  inc a
  ld [MedarotSelectStateIndex], a
  ret
MedarotScreenSetupMedarotSelectLoadData: ; bb89 (2:7b89)
  ld [$c650], a
  ld hl, $a500
  ld b, $00
  ld a, [$c650]
  ld c, a
  ld a, $05
  call JumpGetListTextOffset
  ret