INCLUDE "game/src/common/constants.asm"

SECTION "Main", ROM0[$0390]
Main::
; Disable LCD.
  call $0C80
  di

; Turn off all the interrupts.
  xor a
  ldh [hRegIF], a
  ldh [hRegIE], a
  ld sp, $FFFE

; Enable sram.
  ld a, $A
  ld [$0000], a

; Switch to bank 1.
  ld a, 1
  rst $10

; Switch to sram bank 0.
  ld a, 0
  ld [$4000], a

  call $0CA8
  call $0D6D
  call $0D78

; Clear OAM.
  ld hl, $FE00
  ld c, 0

.clearOAMLoop
  ld [hli], a
  dec c
  jr nz, .clearOAMLoop

; Clear HRAM.
  ld hl, $FF80
  ld c, $7F

.clearHRAMLoop
  ld [hli], a
  dec c
  jr nz, .clearHRAMLoop

  call $0C3B
  call $056B
  ld a, 1
  ld [$C600], a
  call $17D4
  ld a, $83
  ld [$C5A9], a
  ldh [hRegLCDC], a
  xor a
  ldh [hRegIF], a
  ld a, $D
  ldh [hRegIE], a
  ei
  call $3EB5
  ld a, $40
  ldh [hLCDStat], a
  xor a
  ldh [hRegIF], a
  ld a, $B
  ldh [hRegIE], a
  ld a, BANK(SGB_DetectICDPresence)
  ld [$C6E0], a
  rst $10
  ld a, 0
  ld [$C5FA], a
  call SGB_DetectICDPresence
  jp nc, .jpA
  ld a, 1
  ld [$C5FA], a
  call SGB_InstallBorderAndHotpatches

.jpA
  ld a, 1
  ld [CoreStateIndex], a
  ld a, 1
  rst $18

.gameLoop
  ld a, [$C5A0]
  inc a
  ld [$C5A0], a
  call $0482
  ld a, [$C5A1]
  or a
  jr nz, .waitForNextFrame
  call SerIO_RecvBufferPull
  call SerIO_SendBufferPush
  call $3EF8
  call $0C09
  call $3B23
  call LoadSpritesForDMAHack
  call $18DA
  ld a, 1
  ld [$C5A1], a

.waitForNextFrame
  ldh a, [$FF92]
  and a
  jr z, .waitForNextFrame

  xor a
  ldh [$FF92], a
  xor a
  ld [$C5A1], a
  jp .gameLoop
