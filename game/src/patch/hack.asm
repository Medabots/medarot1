SECTION "User Functions (Hack)", ROMX[$4000], BANK[$24]
HackPredef::
  ; save hl
  ld a, h
  ld [TempH], a
  ld a, l
  ld [TempL], a
  push bc
  ld hl, HackPredefTable
  ld b, 0
  ld a, [TempA] ; old a
  ld c, a
  add hl, bc
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a
  push bc
  pop hl
  pop bc
  push hl
  ld a, [TempH]
  ld h, a
  ld a, [TempL]
  ld l, a
  ret ; jumps to hl

HackPredefTable:
  dw IncTextOffset ;0
  dw GetTextOffset ;1
  dw ZeroTextOffset ;2
  dw IncrementTileOffset ;3

; [[WTextOffsetHi][$c6c0]]++
IncTextOffset:
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  ret nz
  ld a, [WTextOffsetHi]
  inc a
  ld [WTextOffsetHi], a
  ret

; bc = [WTextOffsetHi][$c6c0]
GetTextOffset:
  ld a, [$c6c0]
  ld c, a
  ld a, [WTextOffsetHi]
  ld b, a
  ret

ZeroTextOffset:
  xor a
  ld [$c6c0], a
  ld [WTextOffsetHi], a
  ret

hLineMax           EQU $10 ;Max offset from start of line
hLineOffset        EQU $20 ;Bytes between line tiles
IncrementTileOffset:
  push bc ; save original bc
  push hl ; save original hl
  ld a, hLineMax 
  ld b, $0
  ld c, hLineOffset
.loop
  add c ; a becomes upper limit
  inc b ; b is the line number (first line is 1)
  cp l
  jr c, .loop
  ld a, b
  pop hl ; restore original hl
  pop bc ; restore original bc
  jr nz, .normal_increment
.reset_offset
  cp $3
  jr c, .new_line
.new_textbox
  push bc
  ld hl, $9c00
  ld bc, $0041
  ld a, [$c5c7]
  cp $1
  jr z, .new_textbox_normal_type
  ld bc, $0021
.new_textbox_normal_type
  add hl, bc
  pop bc
  jr .save_tile_offset
.new_line
  push bc
  ld hl, $9c00
  ld bc, $0080
  ld a, [$c5c7]
  cp $1
  jr z, .new_line_normal_type
  ld bc, $0060
.new_line_normal_type
  add hl, bc
  pop bc
.normal_increment
  inc hl
.save_tile_offset
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ret