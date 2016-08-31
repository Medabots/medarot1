SECTION "rst0", ROM0[$0]
	pop hl
	add a ;a = a+a
	rst $28
	ld a, [hli] ; a = *hl++
	ld h, [hl] ; h = *hl
	ld l, a ;l = a
	jp [hl]

SECTION "rst8",ROM0[$8] ; HackPredef
	ld [TempA], a ; 3
	jp Rst8Cont

SECTION "rst8Cont",ROM0[$62] ;Replaces a bunch of empty space
Rst8Cont:
	ld a, [hBank]
	ld [BankOld],a
	ld a, BANK(HackPredef)
	ld [$2000], a
	call HackPredef
	ld [TempA], a
	ld a, [BankOld]
	cp a, $17
	jr z, .bs
	cp a, $1f
	jr nc, .bs ; bank swap
	ld a, [$c6e0]
.bs
	ld [$2000], a
	ld a, [TempA]
	ret

SECTION "rst10, bank swap",ROM0[$10]
	ld [$2000], a
  ret

SECTION "rst18",ROM0[$18] ;Bank swap from memory
  ld a, [$c6e0]
	rst $10
	nop
	nop
  ret

SECTION "rst20",ROM0[$20]
  add l ;a = l+a
  ld l, a ;l = a
  ret c ;Return if 'c'
  dec h ;h--
  ret

SECTION "rst28",ROM0[$28]
	add l ;a = l+a
	ld l, a ;l = a
	ret nc ;Return if not 'c'
	inc h ;h++
	ret

SECTION "rst30",ROM0[$30] ;
  add a
  rst $28
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ret

SECTION "rst38",ROM0[$38]
	ld a, [hli]
	ld h, [hl]
	ld l, a
  ret
