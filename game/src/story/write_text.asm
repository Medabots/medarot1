SECTION "SetupDialog", ROM0[$1c87]
SetupDialog:
  ld [$c5c7], a
  xor a
  ld [$c5c8], a
  call $1ab0
  xor a
	ld a, $2
	rst $8 ; ZeroTextOffset
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
  rst $28
  ld a, [hl]
  rst $10 ;Swap to the correct bank
  pop af
  ld hl, TextTableOffsets ;Go to the start of the dialog in this bank
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  rst $38
  pop bc
  ld a, b
  and $f
  ld b, a
  add hl, bc ;Pointers to text in each of the banks now also have the bank offset, so instead of logical shifts just add it 3 times 
  add hl, bc
  add hl, bc
  ld a,[hli] ;To have more room for text, change the pointer table to include banks ({Bank:1, Address:2 (LE)})
  push af
  rst $38
  pop af
  rst $10
  
PutCharLoop:: ;1d11, things jump to here after the control code
  push hl
  ld a, $1 ; GetTextOffset
  rst $8
  add hl, bc
  call GetNextChar
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
  jp SkipSpace

SECTION "WriteChar", ROM0[$1f96]
WriteChar:: ; 1f96
  ld a, [hl]
  ld d, a
  cp $0
  jr nz, .skip_length_check
  call GetWordLength
.skip_length_check
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
  ld a, $3 ; IncrementTileOffset
  rst $8
  ld a, $0 ; IncTextOffset
  rst $8
  ld a, [$c6c4]
  ld [$c6c1], a
  pop hl
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  jp PutCharLoop
  nop
  nop
  nop
  ; 0x1ff2

hPSCounter             EQU $c640
hPSTextAddrLo          EQU $c641
hPSVRAMAddrHi          EQU $c642
hPSVRAMAddrLo          EQU $c643
hPSCurrChar            EQU $c64e
hPSCurrCharTile        EQU $c64f
SECTION "PutString", ROM0[$2fcf]
PutString:: ; 2fcf
  ; hl is ptr to string to print, terminated by 0x50
  ; bc is VRAM address to write to
  xor a
  ld [hPSCounter], a
.loop
  ld a, [hli]
  cp $50
  ret z
  ld [hPSCurrChar], a
  push hl
  push bc
  call $2068
  pop bc
  pop hl
  ld a, [hPSCurrCharTile]
  or a
  jr z, .write_vram
  push hl ; Save current text addr
  push bc ; Save current VRAM addr
  push bc ; hl = bc
  pop hl 
  ld bc, $ffe0
  add hl, bc
  di
  call WaitLCDController
  ld [hl], a
  ei
  pop bc
  pop hl
.write_vram
  push hl
  push bc ; hl = bc
  pop hl
  ld a, [hPSCurrChar]
  di
  call WaitLCDController
  ld [hl], a
  ei
  pop hl
  inc bc
  ld a, [hPSCounter]
  inc a
  cp $12
  jr nz, .continue
  push hl
  push bc
  pop hl
  ld c, $20 - $12
  ld b, $0
  add hl, bc
  push hl
  pop bc
  pop hl
  xor a
.continue
  ld [hPSCounter], a
  jr .loop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
; 303b