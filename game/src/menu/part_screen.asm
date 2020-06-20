; Medals Screen state machine

INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"
INCLUDE "game/src/menu/include/variables.asm"

SECTION "Part Screen State Machine", ROMX[$5fc3], BANK[$2]
PartScreenStateMachine::
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
  dw $6007
  dw $5389
  dw $602a
  dw PartScreenTilemapTextSetup ; Load part names and tilemaps
  dw $537f
  dw $6090
  dw $61e7
  dw $5389
  dw $61f8
  dw $6213
  dw $6225
  dw $6225
  dw $6237
  dw $537f
  dw $6249
  dw $5389
  dw $625c
  dw MenuStateMachineRet
  dw MenuStateMachineRet
  dw MenuStateMachineRet
  dw MenuStateMachineRet
  dw $5389
  dw MenuExitAsyncRestoreTileset
  dw $537f
  dw $576e
; 2:6007

SECTION "Part Screen State Machine (partial disassembly)", ROMX[$6070], BANK[$2]
PartScreenTilemapTextSetup:
  call PartScreenSetupTilemapTextStateMachine
  ld a, [TempStateIndex]
  cp $ff
  ret nz
  xor a
  ld [$c735], a
  ld b, $08
  ld c, $0b
  ld d, $00
  ld e, $00
  ld a, $0d
  call JumpTable_309
  call MenuExitAsyncRestoreTilesetCleanup
  jp MenuIncrementStateSubIndex

SECTION "Part Screen Setup Tilemaps State Machine", ROMX[$629d], BANK[$2]
PartScreenSetupTilemapTextStateMachine:
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
  dw PartScreenSetupTilemaps
  dw PartScreenSetupText

PartScreenSetupTilemaps: ; a2b3 (2:62b3)
  ld b, $00
  ld c, $0c
  ld e, $72 ; Help Text at bottom
  ld a, $1a ; LoadPartsScreenTextAndLoadTilemap
  rst $08
  ld b, $01 ; x position, originally 3
  ld c, $00
  ld a, [$c727]
  add $74
  ld e, a ; Part Type
  call JumpLoadTilemap
  ld b, $00
  ld c, $02
  ld e, $cb
  call JumpLoadTilemap
  jp TempStateIncrementStateIndex

PartScreenSetupText: ; a2d5 (2:62d5)
  ld hl, $982d 
  call $4cff ; Set page number
  call PartScreenSetupLoadPartName
  call PartScreenSetupLoadPartModel
  call $663a
  ld a, [$c6f4]
  ld d, a
  ld a, $02
  ld b, $00
  ld c, $06
  call $4c81
  ld a, $ff
  ld [TempStateIndex], a
  ret
; 0xa2f7

PartScreenSetupLoadPartName:
  ld a, $be
  ld [$c644], a
  psa $98a8
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $6316
  cp $1
  jp z, $631c
  cp $2
  jp z, $6322
  jp $6328
  ld hl, $b520
  jp $632b
  ld hl, $b5a0
  jp $632b
  ld hl, $b620
  jp $632b
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
.asm_a33c  
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6354
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $8
  ld e, $73
  call JumpLoadTilemap
  jp $637d
  push hl
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $8
  ld e, $7a
  call JumpLoadTilemap
  pop hl
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  call VWFPutStringTo8
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0820
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jr nz, .asm_a33c ; 0xa39a $a0
  ret

PartInfoScreenStateMachine:
  ld a, [TempStateIndex]
  ld hl, .table
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
.table
  dw PartInfoScreenTilemapLoadSmallBox
  dw $63cb
  dw $63d7
  dw $63f6
  dw $6405
  dw $6440
  dw $6453
  dw $645f
PartInfoScreenTilemapLoadSmallBox:
  ld b, $0
  ld c, $0
  ld e, $7b
  call JumpLoadTilemap
  jp TempStateIncrementStateIndex
PartInfoScreenTilemapLoadStatBox:
  ld b, $0a
  ld c, $0
  ld e, $7c
  ld a, $1c ; LoadPartsInfoTextAndLoadTilemap
  rst $08
  jp TempStateIncrementStateIndex
; 0xa3cb

SECTION "Load Part Screen Setup - Load Model", ROMX[$65a3], BANK[$2]
PartScreenSetupLoadPartModel:
  ld a, $98
  ld [$c644], a
  ld a, $a1
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $65c2
  cp $1
  jp z, $65c8
  cp $2
  jp z, $65ce
  jp $65d4
  ld hl, $b520
  jp $65d7
  ld hl, $b5a0
  jp $65d7
  ld hl, $b620
  jp $65d7
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
.asm_a5e8  
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6600
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $1
  ld e, $78
  call JumpLoadTilemap
  jp $661a
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $1
  call JumpTable_294
  ld hl, cBUF01
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  call JumpPutString
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jr nz, .asm_a5e8 ; 0xa637 $af
  ret
  ld a, $98
  ld [$c644], a
  ld a, $b0
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $6659
  cp $1
  jp z, $665f
  cp $2
  jp z, $6665
  jp $666b
  ld hl, $b520
  jp $666e
  ld hl, $b5a0
  jp $666e
  ld hl, $b620
  jp $666e
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6697
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $11
  ld e, $79
  call JumpLoadTilemap
  jp $66ed
; 0xa697
  push hl
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  xor a
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  pop hl
  push hl
  inc hl
  ld a, [hl]
  push af
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  pop af
  call JumpTable_2fa
  pop hl
  ld a, [hl]
  and $7f
  ld hl, $759e
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  or a
  jp nz, $66ed
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  inc hl
  inc hl
  inc hl
  ld a, $50
  di
  call JumpWaitLCDController
  ld [hli], a
  ei
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jp nz, $667f
  ret
; 0xa70e
