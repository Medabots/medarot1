INCLUDE "game/src/common/constants.asm"

SECTION "LCDC VBlank_IRQ", ROM0[$049B]
VBlankingIRQ::
  push af
  push bc
  push de
  push hl
  ldh a, [$FF92]
  or a
  jr z, .jpA
  ld a, [CoreStateIndex]
  ld [$C6D8], a
  ld a, [CoreSubStateIndex]
  ld [$C6D9], a

.jpA
  call $044E
  ldh a, [$FF92]
  or a
  jr nz, .setCompletedFlag
  ld a, [$C600]
  or a
  call nz,  $FF80 ; In-memory code: OAM DMA
  ei
  xor a
  ld [$C600], a

.setCompletedFlag
  ld a, 1
  ldh [$FF92], a
  call $3DF9
  pop hl
  pop de
  pop bc
  pop af
  reti

; LCDC Status Interrupt (INT 48)
LCDC_Status_IRQ: ; 4d0 (0:4d0)
  push af
  push bc
  push de
  push hl
  ld a, [$c7f9]
  or a
  jp nz, .asm_51f
  ld a, [$c6bf]
  or a
  jp nz, .asm_4e8
  call .asm_54e
  jp .asm_549
.asm_4e8: ; 4e8 (0:4e8)
  ld de, $c6b0
.asm_4eb
  di
  call WaitLCDController
  ld a, [de]
  ei
  or a
  jp z, .asm_517
  ld hl, $1
  add hl, de
  ld a, [hl]
  ld [hRegSCX], a
  ld hl, $2
  add hl, de
  ld a, [hl]
  ld [hRegSCY], a
  ld hl, $0
  add hl, de
  ld a, [hl]
  ld b, a
.asm_509
  ld a, [hRegLY]
  sub b
  jr c, .asm_509
  ld hl, $3
  add hl, de
  ld d, h
  ld e, l
  jp .asm_4eb
; 0x517
.asm_517: ; 517 (0:517)
  xor a
  ld [hRegSCX], a
  ld [hRegSCY], a
  jp .asm_549
.asm_51f: ; 51f (0:51f)
  xor a
  ld [$c7fc], a
  ld de, $90
  ld hl, $c800
.asm_529
  ld a, [hli]
  ld [hRegSCX], a
  ld a, $00
  ld [hRegSCY], a
  ld a, [$c7fc]
  ld b, a
.asm_534
  call WaitLCDController
  ld a, [hRegLY]
  sub b
  jr c, .asm_534
  ld a, [$c7fc]
  inc a
  ld [$c7fc], a
  dec de
  ld a, d
  or e
  jp nz, .asm_529
.asm_549
  pop hl
  pop de
  pop bc
  pop af
  reti
.asm_54e: ; 54e (0:54e)
  ld hl, $c6b0
  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ret
; 0x562