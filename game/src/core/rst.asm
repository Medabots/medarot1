SECTION "rst0", ROM0[$0]
  pop hl
  add a ;a = a+a
  rst $28
  ld a, [hli] ; a = *hl++
  ld h, [hl] ; h = *hl
  ld l, a ;l = a
  jp hl

SECTION "rst8",ROM0[$8] ; HackPredef
  ld [TempA], a ; 3
  jp Rst8Cont

SECTION "rst8Cont",ROM0[$62] ;Replaces a bunch of empty space
Rst8Cont:
  ld a, [hBank]
  push af
  ld a, BANK(HackPredef)
  rst $10
  ld a, [TempA]
  call HackPredef
  ld [TempA], a
  pop af
  rst $10
  ld a, [TempA]
  ret
  nop
  nop
  nop
  nop

SECTION "rst10, bank swap",ROM0[$10]
  ld [hBank], a
  ld [$2000], a
  ret

SECTION "rst18",ROM0[$18] ;Bank swap from memory
  ld a, [$c6e0]
  rst $10
  ret

SECTION "rst20",ROM0[$20]
  add l
  ld l, a ; l += a
  ret c ; Return if 'c'
  dec h ; h--
  ret

SECTION "rst28",ROM0[$28] ; hl += a
  add l
  ld l, a ;l += a
  ret nc ;Return if not 'c'
  inc h ;h++
  ret

SECTION "rst30",ROM0[$30] ; a += a; hl = [hl + a], useful for pointer tables
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
