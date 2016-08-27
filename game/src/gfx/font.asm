SECTION "Load Font", ROM0[$2d85]
LoadFont:: ;Dialogue
	ld a, 3
	call DecompressAndLoadTiles ; Decompress
	ret

SECTION "Decompress Tiles", ROM0[$12e8]
DecompressAndLoadTiles: ; 12e8 (0:12e8)
	ld [$c650], a ;Store font type
	ld a, b
	ld [$c6d3], a
	xor a
	ld [$c64e], a
	ld a, [$c6ce]
	or a
	jp nz, .asm_132e
	ld a, $01
	ld [$c6ce], a
	ld a, [$c650]
	ld hl, $10f0
	ld d, $00
	ld e, a
	sla e
	rl d
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [$c6d4], a
	rst $10
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc de
	ld a, h
	ld [$c5f6], a
	ld a, l
	ld [$c5f7], a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	jp $1342
; 0x132e
.asm_132e
	ld a, [$c6d4]
	rst $10
	ld a, [$c6cf]
	ld b, a
	ld a,[$c6d0]
	ld c, a
	ld a,[$c6d1]
	ld d, a
	ld a,[$c6d2]
	ld e, a
	ld a, [$c6d3]
	or a
	jr nz, .asm_135e
	ld a, b
	ld [$c6cf], a
	ld a, c
	ld [$c6d0], a
	ld a, d
	ld [$c6d1], a
	ld a, e
	ld [$c6d2], a
	ld a, $01
	ld [$c64e], a
	ret
.asm_135e
