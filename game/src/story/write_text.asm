SECTION "SetupDialog", ROM0[$1c87]
SetupDialog:
  ld [$c5c7], a
  xor a
  ld [$c5c8], a
  inc a
  ld [VWFIsInit], a
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
  ld h, $9c
  ld l, $41
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1cbc ; 0x1cb7 $3
  ld l, $21
.asm_1cbc
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
  ld a, [VWFTilesDrawn]
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
  add hl, bc
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
  ld [VWFTrackBank], a
  rst $10
  
PutCharLoop: ;1d11, things jump to here after the control code
  push hl
  ld a, $1 ; GetTextOffset
  rst $8
  add hl, bc
  call GetNextChar

  ; Store the current character index as well as potential arguments for control codes in WRAM. Point hl to WRAM location.
  ld b, h
  ld c, l
  call VWFWordLengthTest
  ld hl, VWFCurrentLetter
  ld a, [bc]
  ld [hli], a
  inc bc
  ld a, [bc]
  ld [hli], a
  inc bc
  ld a, [bc]
  ld [hld], a
  dec l

  ; Switch to the bank where the vwf font is located.
  ld a, BANK(VWFFont)
  rst $10
  
  ; From here on out there is no reason for us to operate in bank 0 until the next character is required.
  jp VWFDrawCharLoop

PutCharLoopWithBankSwitch::
  ; Swap to the bank with the text before jumping back
  ld a, [VWFTrackBank]
  rst $10
  jr PutCharLoop
  nop
  nop
  nop
  nop
  nop

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
