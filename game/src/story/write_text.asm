SECTION "SetupDialog", ROM0[$1c87]
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
  nop
  nop
  nop
  nop
  nop
PutCharLoop: ;1d11, things jump to here after the control code
  push hl
  ld a, $1
  rst $8
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
  jp c, $1fc2
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
  ld a, $0
  rst $8
  nop
  nop
  nop
  nop
  ld a, [$c6c4]
  ld [$c6c1], a
  pop hl
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  jp PutCharLoop
  ; 0x1ff2

SECTION "PutString", ROM0[$2fcf]
PutString: ; 2fcf
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  ld a, b
  ld [$c642], a
  ld a, c
  ld [$c643], a
.char
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld a, [hl]
  cp $50
  ret z
  ld [$c64e], a
  call $2068
  ld a, [$c64f]
  or a
  jp z, $300d
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  ld a, [$c64f]
  di
  call WaitLCDController
  ld [hl], a
  ei
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld a, [$c64e]
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [$c642], a
  ld a, l
  ld [$c643], a
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  inc hl
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  jp .char
