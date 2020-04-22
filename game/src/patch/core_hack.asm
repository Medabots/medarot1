; Functions that needed to go within the core game space 

SECTION "GetNextChar", ROM0[$7B]
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