SECTION "SetupDialog", ROM0[$1c87]
SetupDialog::
  ld [$c5c7], a
  xor a
  ld [$c5c8], a
  call $1ab0
  xor a
  ld [$c6c0], a
  ld [$c6c5], a
  ld [$c6c6], a
  ld hl, $1cc6
  ld b, $0
  ld a, [$c765]
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c6c1], a
  ld [$c6c4], a
  ld hl, $9c00
  ld bc, $0041
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1cbc ; 0x1cb7 $3
  ld bc, $0021
.asm_1cbc
  add hl, bc
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ret
; 0x1cc6

SECTION "PutChar", ROM0[$1cc9]
PutChar:
  ld a, [$c6c6]
  or a
  ret nz
  ld a, [$c6c0]
  sub $2
  jr nc, .asm_1cda ; 0x1cd3 $5
  ld a, $1
  ld [$c600], a
.asm_1cda
  ld a, [$c6c1]
  or a
  jr z, .asm_1ce5 ; 0x1cde $5
  dec a
  ld [$c6c1], a
  ret
.asm_1ce5
  push bc
  ld a, b
  and $f0
  swap a
  push af
  ld hl, TextTableBanks
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  rst $10 ;Swap to the correct bank
  pop af
  ld hl, TextTableOffsets ;Go to the start of the dialog in this bank
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  pop bc
  ld a, b
  and $f
  ld b, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld a, [$c6c0]
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  cp $4f
  jp z, Char4F
  cp $4e
  jp z, Char4E
  cp $4d
  jp z, Char4D
  cp $4c
  jp z, Char4C
  cp $4b
  jp z, Char4B
  cp $4a
  jp z, Char4A
  jp WriteChar

SECTION "WriteChar", ROM0[$1f96]
WriteChar: ; 1f96
  ld a, [hl]
  ld d, a
  ld a, $40
  sub d
  jp c, .asm_1fc2
  ld hl, $1ff2
  ld c, d
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  push hl
  push af
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  pop af
  di
  call WaitLCDController
  ld [hl], a ; "/°
  ei
  pop hl
  ld a, [hl]
  ld d, a
.asm_1fc2
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld a, d
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  ld a, [$c6c4]
  ld [$c6c1], a
  pop hl
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  jp $1d11
  ; 0x1ff2

hPSTextAddrHi          EQU $c640
hPSTextAddrLo          EQU $c641
hPSVRAMAddrHi          EQU $c642
hPSVRAMAddrLo          EQU $c643
hPSCurrChar            EQU $c64e
hPSCurrCharTile        EQU $c64f
SECTION "PutString", ROM0[$2fcf]
PutString:: ; 2fcf
  ld a, h
  ld [hPSTextAddrHi], a
  ld a, l
  ld [hPSTextAddrLo], a
  ld a, b
  ld [hPSVRAMAddrHi], a
  ld a, c
  ld [hPSVRAMAddrLo], a
.char
  ld a, [hPSTextAddrHi]
  ld h, a
  ld a, [hPSTextAddrLo]
  ld l, a
  ld a, [hl]
  cp $50
  ret z
  ld [hPSCurrChar], a
  call $2068
  ld a, [hPSCurrCharTile]
  or a
  jp z, .write_vram
  ld a, [hPSVRAMAddrHi]
  ld h, a
  ld a, [hPSVRAMAddrLo]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  ld a, [hPSCurrCharTile]
  di
  call WaitLCDController
  ld [hl], a
  ei
.write_vram
  ld a, [hPSVRAMAddrHi]
  ld h, a
  ld a, [hPSVRAMAddrLo]
  ld l, a
  ld a, [hPSCurrChar]
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [hPSVRAMAddrHi], a
  ld a, l
  ld [hPSVRAMAddrLo], a
  ld a, [hPSTextAddrHi]
  ld h, a
  ld a, [hPSTextAddrLo]
  ld l, a
  inc hl
  ld a, h
  ld [hPSTextAddrHi], a
  ld a, l
  ld [hPSTextAddrLo], a
  jp .char

SECTION "PadTextTo8", ROM0[$34c4]
; Centers text given 8 tiles
; [hl] = text
PadTextTo8:: ; 34c4
  push hl
  push bc
  ld b, $0
.asm_34c8
  ld a, [hli]
  cp $50
  jr z, .asm_34d0 ; 0x34cb $3
  inc b
  jr .asm_34c8 ; 0x34ce $f8
.asm_34d0
  ld a, $8
  sub b
  srl a
  pop bc
  pop hl
  ret
; 0x34d8
