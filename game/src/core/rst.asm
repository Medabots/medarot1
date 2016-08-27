SECTION "rst0", ROM0[$0]
	pop hl
	add a
	rst $28
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

SECTION "rst8",ROM0[$8]
  reti

SECTION "rst10, bank swap",ROM0[$10]
	ld [$2000], a
  ret

SECTION "rst18",ROM0[$18]
  ld a, [$c6e0]
  ld [$2000], a
  ret

SECTION "rst20",ROM0[$20]
  add l
  ld l, a
  ret c
  dec h
  ret

SECTION "rst28",ROM0[$28]
	add l
	ld l, a
	ret nc
	inc h
	ret

SECTION "rst30",ROM0[$30]
  add a
  rst $28
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ret

SECTION "rst38",ROM0[$38] ; Unused
	ld a, [hli]
	ld l, [hl]
	ld h, a
  ret
