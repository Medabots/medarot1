; Functions that needed to go within the core game space 

; Takes space from control_codes.asm, precedes VWF core functions
; (will need to modify both if these are modified)
SECTION "GetNextChar", ROM0[$1d6b]
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
  ; de is preserved
  push de
  ld a, e
  or a
  jr z, .start
  rst $10 ; bank swap
.start
  rst $38 ; hl = [hl], deref ptr
  call VWFPutStringTo8
  pop af ; take stored de -> af, a = d, f = e
  or a
  jr z, .return
  rst $10
.return
  ret

PrintPtrTextAutoNarrow:: ; Same as PrintPtrText but calling AutoNarrow, can't be used with PadPtrTextTo8
  push de
  ld a, e
  or a
  jr z, .start
  rst $10 ; bank swap
.start
  rst $38 ; hl = [hl], deref ptr
  call VWFPutStringAutoNarrowTo8
  pop af ; take stored de -> af, a = d, f = e
  or a
  jr z, .return
  rst $10
.return
  ret

PadPtrTextTo8::
  ; Usually called with PrintPtrText, same arguments, but will restore hl, bc, and de
  ; Calls PadTextTo8 while optionally swapping banks if necessary
  push hl
  push bc
  push de
  ld a, e
  or a
  jr z, .start
  rst $10 ; bank swap
.start
  rst $38 ; hl = [hl], deref ptr
  call VWFPadTextTo8
  pop de
  ld a, d
  or a
  jr z, .return
  rst $10
.return
  pop bc
  pop hl
  ret 
  ; 1DA7