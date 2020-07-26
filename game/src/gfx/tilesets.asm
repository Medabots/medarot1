INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "Load Dialogue Font", ROM0[$2d85]
LoadMainDialogTileset::
  ld a, 3
  call DecompressAndLoadTiles
  ret

;a = 04 at init
;a = 05 on JP text before SPD2 screen
;a = 06, 07 before title screen
;a = 02 font for the special characters (A, B, 0, 1, 2, 3, 4... !, heart)
;a = 03 dialogue font
;a = 09 on kirara's intro
SECTION "Load Font sub", ROM0[$10d3]
LoadFont0:: ; 10d3 (0:10d3)
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
  jp LoadTiles
; 0x10ef

SECTION "Load Tiles", ROM0[$1214]
LoadTiles:: ; 1214 (0:1214)
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
  ret z
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
  ret z
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

Load1BPPTiles::
; hl is the vram address to write to.
; de is the address to copy from.
; b is the number of tiles to copy.
  ld c, 8
.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, [de]
  ld [hli], a
  ld [hli], a

  ei

  inc de
  dec c
  jr nz, .loop
  dec b
  jr nz, Load1BPPTiles
  
  ret

  nop
  nop
  nop
  nop
  nop
  nop
  nop

DecompressAndLoadTiles:: ; 12e8 (0:12e8)
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
  jp NoDecompressLoadTiles

Load1BPPTilesFrom2D::
  ld a, $2D
  rst $10
  call Load1BPPTiles
  ld a, $24
  rst $10
  ret

LoadTilesFrom2D::
  ld a, $2D
  rst $10
  ld a, [de]
  inc de
  call LoadTiles
  ld a, $24
  rst $10
  ret

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  nop
  nop
.asm_135e

SECTION "Load Uncompressed Tiles", ROM0[$1fb9] ; Address is at the end of the old control codes
NoDecompressLoadTiles:
  ld a, [de]
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  inc de

  ld a, c
  and 1
  jr z, .loop

  di
  call WaitLCDController
  ld a, [de]
  ld [hli], a
  ei
  inc de
  dec c

.loop
  ld a, b
  or c
  ret z
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, [de]
  ld [hli], a
  inc de
  ld a, [de]
  ld [hli], a
  ei
  inc de
  dec bc
  dec c
  jr .loop
