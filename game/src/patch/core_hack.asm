; Functions that needed to go within the core game space 

SECTION "GetWordLength", ROM0[$7B]
; input current character addr in hl
; output length from next character to end of word in [CurrentWordLen]
GetWordLength::
  ;$50, $00, $4X are word terminators, except 4B which requires some tuning
  push hl
  push bc
  push af
  inc hl
  ld c, $0
.loop
  ld a, [hli]
  cp $00
  jr z, .end_loop
  cp $50
  jr z, .end_loop
  cp $4f
  jr z, .end_loop
  cp $4e
  jr z, .end_loop
  cp $4d
  jr z, .end_loop
  cp $4c
  jr z, .end_loop
  cp $4b
  jr z, .change_ptr
  cp $4a
  jr z, .end_loop
  inc c
  ld a, c
  cp $ff
  jr nz, .loop
.end_loop
  ld a, c
  ld [CurrentWordLen], a
  pop af
  pop bc
  pop hl
  ret
.change_ptr
  rst $38 ; hl = [hl]
  jr .loop

SkipSpace::
  push af
  cp $0
  jr nz, .return
  ld a, [FlagNewLine]
  cp $0
  jr z, .return
  ld a, $0 ; IncTextOffset
  rst $8
  pop af
  pop hl
  jp PutCharLoop
.return
  pop af
  jp WriteChar

GetNextChar::
  push hl
  ld a, [hl]
  ld [NextChar], a
  pop hl
  ld a, $8 ; SetNextChar
  rst $8
  ret

PrintPtrText::
  ; hl is pointer to string (must deref)
  ; d = bank to return to
  ; e = bank to swap to, if 0 don't do anything
  ; bc = VRAM Address
  push de
  ld a, e
  cp $0
  jr z, .start
  rst $10 ; bank swap
.start
  rst $38 ; hl = [hl], deref ptr
  call PutString
  pop af ; take stored de -> af, a = d, f = e
  cp $0
  jr z, .return
  rst $10
.return
  ret