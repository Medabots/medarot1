; Functions that needed to go within the core game space 

SECTION "GetWordLength", ROM0[$7B]
; input current character addr in hl
; output length from next character to end of word in [CurrentWordLenHi][CurrentWordLenLo]
GetWordLength::
  ;$50, $00, $4X are word terminators
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
  jr z, .end_loop
  cp $4a
  jr z, .end_loop
  inc c
  cp $ff
  jr nz, .loop
.end_loop
  ld a, c
  ld [CurrentWordLen], a
  pop af
  pop bc
  pop hl
  ret