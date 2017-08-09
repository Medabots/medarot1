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