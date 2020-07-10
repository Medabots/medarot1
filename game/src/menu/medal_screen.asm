; Medals Screen state machine

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Medal Screen State Machine", ROMX[$5344], BANK[$2]
MedalScreenStateMachine::
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
  dw MedalScreenSetupMedalTilesetStateMachine
  dw MedalScreenSetupTilemap
  dw $537f
  dw $54ba
  dw $5634
  dw $5389
  dw $5645
  dw $537f
  dw $5672
  dw $56fe
  dw $5389
  dw $570f
  dw $573b
  dw MenuStateMachineRet ; ret
  dw $5389
  dw MenuExitAsyncRestoreTileset
  dw $537f
  dw $576e

SECTION "Medal Screen - Draw Medal Tilesets Asynchronously", ROMX[$53b6], BANK[$2]
MedalScreenSetupMedalTilesetStateMachine::
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
  dw MedalScreenSetupMedalTilesetStateMachineInit
  dw MedalScreenSetupMedalTilesetStateMachinePullFromSRAM
  dw MedalScreenSetupMedalTilesetStateMachineClearVRAM1
  dw MedalScreenSetupMedalTilesetStateMachineClearVRAM2
  dw MedalScreenSetupMedalTilesetStateMachinePrep
  dw MedalScreenSetupMedalTilesetStateMachineLoadMedarotSprite ; Loads tilesets 0A
  dw MedalScreenSetupMedalTilesetStateMachineLoadUnkTileset ; Loads tilesets 0C
  dw MedalScreenSetupMedalTilesetStateMachineLoadTextTileset ; Loads tilesets 0B
  dw MedalScreenSetupMedalTilesetStateMachineLoadMedalTileset ; Loads the actual medal tileset

MedalScreenSetupMedalTilesetStateMachineInit:
  call $5af6
  ld a, [$c751]
  cp $ff
  ret nz
  ld a, [$c5a2]
  ld [$c5ab], a
  ld a, [$c5a3]
  ld [$c5ac], a
  xor a
  ld [$c5a2], a
  ld [$c5a3], a
  ld [$c6f4], a
  ld [$c6f5], a
  ld [$c6f6], a
  ld [$c6f7], a
  call $4dcc
  ld a, $01
  ld [$c725], a
  xor a
  ld [$c740], a
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachinePullFromSRAM: ; 9411 (2:5411)
  ld hl, $c0a0
  ld b, $00
  ld a, [$c740]
  ld c, a
  ld a, $05
  call JumpGetListTextOffset
  ld hl, $b200
  ld b, $00
  ld a, [$c740]
  ld c, a
  ld a, $05
  push de
  call JumpGetListTextOffset
  pop de
  ld bc, $20
  call JumpTable_22e
  ld a, [$c740]
  inc a
  ld [$c740], a
  cp $19
  ret nz
  xor a
  ld [$c740], a
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineClearVRAM1: ; 9446 (2:5446)
  ld a, [$c740]
  or a
  jr nz, .asm_945e
  ld hl, $9800
  ld b, $14
  ld c, $09
  call $7b9b ; Clear VRAM
  ld a, [$c740]
  inc a
  ld [$c740], a
  ret
.asm_945e
  ld hl, $9920
  ld b, $14
  ld c, $09
  call $7b9b
  xor a
  ld [$c740], a
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineClearVRAM2: ; 946f (2:546f)
  ld hl, $9c00
  ld b, $14
  ld c, $06
  call $7b9b
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachinePrep: ; 947c (2:547c)
  call JumpTable_156
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineLoadMedarotSprite: ; 9482 (2:5482)
  ld a, $0a
  call JumpLoadFont
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineLoadUnkTileset:
  ld a, $0c ; Don't know what this tileset is (1197)
  call JumpLoadFont
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineLoadTextTileset:
  ld a, $0b ; Letters + border
  call JumpLoadFont
  jp TempStateIncrementStateIndex

MedalScreenSetupMedalTilesetStateMachineLoadMedalTileset: ; 949a (2:549a)
  ld de, $9300
  call JumpTable_28b
  xor a
  ld [TempStateIndex], a
  ld a, $06
  ld [$ffa0], a
  jp MenuIncrementStateSubIndex

SECTION "Medal Screen State Machine (partial disassembly)", ROMX[$54ab], BANK[$2]
MedalScreenSetupTilemap: ; 94ab (2:54ab)
  call MedalScreenSetupTilemapStateMachine
  ld a, [TempStateIndex]
  cp $ff
  ret nz
  call MenuExitAsyncRestoreTilesetCleanup
  jp MenuIncrementStateSubIndex

SECTION "Medal Screen - Draw Tilemaps Asynchronously", ROMX[$5b5e], BANK[$2]
MedalScreenSetupTilemapStateMachine:: ; 9b5e (2:5b5e)
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
  dw MedalScreenSetupDrawInfoTilemaps
  dw MedalScreenSetupDrawPageNumber
  dw MedalScreenSetupWriteText ; Calls MedalScreenSetupLoadMedalText
  dw $5bbb
  dw $5bc9
  dw $5bf1

MedalScreenSetupDrawInfoTilemaps: ; 9b7c (2:5b7c)
  ld b, $01
  ld c, $00
  ld e, $6b
  ld a, $19 ; LoadMedalScreenTextAndLoadTilemap
  rst $08
  ld b, $0a
  ld c, $01
  ld e, $23
  call JumpLoadTilemap
  jp TempStateIncrementStateIndex

MedalScreenSetupDrawPageNumber:
  call $5790
  ld hl, $980e
  call $4cff ; Draw the page number
  jp TempStateIncrementStateIndex

MedalScreenSetupWriteText: ; 9b9d (2:5b9d)
  ld a, [$c725]
  call MedalScreenSetupMedalIcons
  ld a, [$c725]
  call MedalScreenDrawAllMedalIconTilemaps
  ld a, [$c725]
  call MedalScreenSetupLoadMedalText
  ld a, [$c725]
  call $58cd
  ld [$c728], a
  jp TempStateIncrementStateIndex

SECTION "Load Medal Screen", ROMX[$5878], BANK[$2]
MedalScreenSetupLoadMedalText:
  ld hl, $a640
  dec a
  ld b, $0
  ld c, a
  call $58e9
  ld a, $be
  ld [$c644], a
  psa $9883
  ld [$c645], a
  ld b, $5
.asm_9890
  ld a, [hl]
  or a
  ret z
  push bc
  push hl
  inc hl
  ld a, [hl]
  call JumpLoadMedalList
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  push bc
  ld hl, cBUF01
  ld a, $02
  ld [VWFInitialPaddingOffset], a
  ld a, $07 ; Max tile length of $7
  call VWFPutStringAutoNarrow
  pop bc
  ld hl, $0730 ; Max tile length of $7, each line is $30 apart
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop hl
  pop bc
  ld de, $0020
  add hl, de
  dec b
  jr nz, .asm_9890 ; 0x98ca $c4
  ret
.LoadMedalScreenEnd
REPT $58cd - .LoadMedalScreenEnd
  nop
ENDR
; 0x98cd

SECTION "Medal Screen - Load Medarot Name", ROMX[$5a4a], BANK[$2]
MedalScreenLoadMedarotName: ; 9a4a (2:5a4a)
  ld a, $01
  ld [$c600], a
  ld a, $11
  ld [$c0c0], a
  ld a, $78
  ld [$c0c2], a
  ld a, $78
  ld [$c0c3], a
  ld hl, $13
  add hl, de
  ld a, [hl]
  dec a
  ld hl, $77d9
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  sla a
  add $d0
  ld [$c0c4], a
  ld hl, $99eb
  ld b, $08
  ld c, $02
  call $7b9b ; OAM, probably
  ld hl, $2
  add hl, de
  push hl
  call VWFPadTextTo8
  pop hl
  psbc $9a0b, $e0
  call VWFPutStringTo8
  ret
.end
REPT $5a93 - .end
  nop
ENDR
; 0x9a93

SECTION "Medal Screen - Medal Icons", ROMX[$67a0], BANK[$7]
MedalIcons::
  INCLUDE "game/src/menu/include/medal_icons.asm"

SECTION "Medal Screen - Load Medal Icons", ROM0[$3262]
MedalScreenLoadMedalIcons:: ; 3262 (0:3262)
  ld h, $0
  ld l, a
  ld a, BANK(MedalIcons)
  rst $10
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl
  ld b, h
  ld c, l
  add hl, hl
  add hl, bc
  ld bc, MedalIcons
  add hl, bc
  ld bc, $60
  call CopyVRAMData
  ret
.end
REPT $328d - .end
  nop
ENDR

SECTION "Medal Screen - Setup Load Medal Icons", ROMX[$57b7], BANK[$2]
MedalScreenSetupMedalIcons: ; 97b7 (2:57b7)
  ld hl, $a640
  dec a
  ld b, $00
  ld c, a
  call $58e9
  ld a, $90
  ld [$c644], a
  ld a, $10
  ld [$c645], a
  ld b, $05
  ld d, h
  ld e, l
.asm_97cf
  ld a, [de]
  or a
  ret z
  push hl
  push bc
  push de
  ld hl, $1
  add hl, de
  ld a, [hl]
  push af
  ld a, [$c644]
  ld d, a
  ld a, [$c645]
  ld e, a
  pop af
  call JumpTable_27c
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld de, $60
  add hl, de
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  ld hl, $20
  add hl, de
  ld d, h
  ld e, l
  dec b
  jr nz, .asm_97cf
  ret
; 0x9808

SECTION "Medal Screen - Draw Medal Icon functions", ROMX[$5808], BANK[$2]
MedalScreenDrawAllMedalIconTilemaps: ; 9808 (2:5808)
  ld hl, $a640
  dec a
  ld b, $00
  ld c, a
  call $58e9
  ld a, $98
  ld [$c644], a
  ld a, $61
  ld [$c645], a
  ld a, $01
  ld [$c64e], a
  ld b, $05
  ld d, h
  ld e, l
.asm_9825
  ld a, [de]
  or a
  ret z
  push hl
  push bc
  push de
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld a, [$c64e]
  call MedalScreenDrawMedalIconTilemap
  ld bc, $60
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  ld a, [$c64e]
  add $06
  ld [$c64e], a
  pop de
  pop bc
  pop hl
  ld hl, $20
  add hl, de
  ld d, h
  ld e, l
  dec b
  jr nz, .asm_9825
  ret
MedalScreenDrawMedalIconTilemap: ; 985a (2:585a)
  push hl
  push bc
  push de
  ld c, $03
.asm_985f
  push hl
  ld b, $02
.asm_9862
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  inc a
  dec b
  jr nz, .asm_9862
  pop hl
  ld de, $20
  add hl, de
  dec c
  jr nz, .asm_985f
  pop de
  pop bc
  pop hl
  ret
; 0x9878

SECTION "Medal Screen - Clear Screen (page swap)", ROMX[$5ad7], BANK[$2]
MedalScreenClearMedalList: ; 9ad7 (2:5ad7)
  ld hl, $9860
  ld b, $0a
  ld c, $0f
  call $7b9b
  ld hl, $984b
  ld b, $08
  ld c, $0a
  call $7b9b
  ld hl, $99eb
  ld b, $08
  ld c, $02
  call $7b9b
  ret
; 0x9af6