INCLUDE "game/src/gfx/tileset_table.asm"
INCLUDE "game/src/gfx/tileset_files.asm"

SECTION "Load Dialogue Font", ROM0[$2d85]
LoadFont1:
  ld a, 3
  call DecompressAndLoadTiles
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

SECTION "Load Tiles", ROM0[$1214]
LoadTiles: ; 1214 (0:1214)
  cp $0
  jp z, NoDecompressLoadTiles
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
.read_next
  ld a, b
  or c
  jp z, NoDecompressLoadTiles.return
  ld a, [de]
  ld [$c5f5], a
  inc de
  ld a, [de]
  ld [$c5f4], a
  inc de
  ld a, $11
  ld [$c5f3], a
.loop
  ld a, b
  or c
  jp z, NoDecompressLoadTiles.return
  ld a, [$c5f3]
  dec a
  jp z, .read_next
  ld [$c5f3], a
  push de
  ld a, [$c5f4]
  ld d, a
  ld a, [$c5f5]
  ld e, a
  srl d
  ld a, d
  ld [$c5f4], a
  rr e
  ld a, e
  ld [$c5f5], a
  jp c, .break_loop
  pop de
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  dec bc
  inc de
  jp .loop
.break_loop
; 0x127f
  pop de
  push de
  ld a, [de]
  ld l, a
  inc de
  ld a, [de]
  and $7
  ld h, a
  ld a, [de]
  srl a
  srl a
  srl a
  and $1f
  add $3
  ld [$c5f2], a
  ld a, h
  cpl
  ld d, a
  ld a, l
  cpl
  ld e, a
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
  add hl, de
  push hl
  pop de
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
.write_to_vram
  di
  call WaitLCDController
  ld a, [de]
  ei
  ld [hli], a
  dec bc
  inc de
  ld a, [$c5f2]
  dec a
  ld [$c5f2], a
  jp nz, .write_to_vram
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  pop de
  inc de
  inc de
  jp .loop
NoDecompressLoadTiles:
  ld a, [de]
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  inc de
.loop
  ld a, b
  or c
  jp z, .return
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  inc de
  dec bc
  jp .loop
.return:
  ret
DecompressAndLoadTiles: ; 12e8 (0:12e8)
  ld [$c650], a ;Store font type
  ld a, b
  ld [$c6d3], a
  xor a
  ld [$c64e], a ; "In Progress" flag
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
  jr NoDecompressLoadTiles
  nop
  ld a, [$c6ce]
  or a
  jp nz, .asm_132e
  ld a, $01
  ld [$c6ce], a
  ld a, h
  ;ld [$c5f6], a
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

SECTION "Load Menu Text (in Robattles)", ROMX[$6ac7], BANK[$1b]
  ld a, $a
  ld b, $1
  call $0246
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