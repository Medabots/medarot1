INCLUDE "game/src/gfx/tileset_table.asm"
INCLUDE "game/src/gfx/tileset_files.asm"

SECTION "Load Dialogue Font", ROM0[$2d85]
LoadFont1:
  ld a, 3
  call LoadFont0
  ret

;a = 04 at init
;a = 05 on JP text before SPD2 screen
;a = 06, 07 before title screen
;a = 02 font for the special characters (A, B, 0, 1, 2, 3, 4... !, heart)
;a = 03 dialogue font
;a = 09 on kirara's intro
SECTION "Load Tileset", ROM0[$05a9]
LoadFont0: ;Gets called at the initial screens during setup
  call LoadFont_Sub
  rst $18

SECTION "Load Font sub", ROM0[$10d3]
LoadFont_Sub: ; 10d3 (0:10d3)
  ld hl, TilesetTable
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli] ;Follow pointer in table to struct
  ld h, [hl]
  ld l, a
  ld a, [hli] ;Retrieve bank
  rst $10 ;Bank swap
  ld a, [hli] ;Retrieve offset low bytes
  ld e, a
  ld a, [hli] ;Retrieve offset high bytes
  ld d, a
  ld a, [hli] ;For font type 2, this is 8800 (VRAM)
  ld h, [hl]
  ld l, a
  ld a, [de] ;Load first byte at bank:offset (01 is compressed, 00 is not)
  inc de
  jp $1214
; 0x10ef

SECTION "Load Menu Text (in Robattles)", ROMX[$6ac7], BANK[$1b]
  ld a, $a
  ld b, $1
  call LoadFont0
  ld a, [$c64e]
  or a
  ret nz
  ld a, [$c752]
  add $d
  call $015f
  ld a, $2
  call $017d
  ld b, $8
  ld c, $b
  ld d, $6
  ld e, $0
  ld a, $a
  call $0309
  call $67de
  ret
; 0x6eaf1

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
  ld hl, TilesetTable
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
  jp .asm_1342
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
.asm_1342
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
