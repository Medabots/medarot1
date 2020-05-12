SECTION "Tilemaps", ROMX[$4000], BANK[$1e]
Tilemaps:
; The tilemap pointer table can reference the same data multiple times
; so even though there's 0xEF tilemaps, we actually have even fewer than that
INCLUDE "build/tilemaps/tilemap_files.asm"

SECTION "Load Tilemaps", ROM0[$e2c]
LoadTilemap::
  ld a, BANK(Tilemaps)
  rst $10
  push de
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  ld d, $0
  ld e, c
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  ld hl, $9800
  ld c, b
  ld b, $0
  add hl, bc
  add hl, de
  pop de
  push hl
  ld hl, Tilemaps
  ld d, $0
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld d, [hl]
  ld e, a
  pop hl
  ld b, h
  ld c, l
  ld a, [de]
  cp $ff
  jp z, $0f83
  and $3
  jr z, .asm_e7d ; 0xe71 $a
  dec a
  jr z, .asm_eac ; 0xe74 $36
  dec a
  jp z, $0f20
  jp $0f51
.asm_e7d
  inc de
  ld a, [de]
  cp $ff
  jp z, $0f83
  cp $fe
  jr z, .asm_e97 ; 0xe86 $f
  cp $fd
  jr z, .asm_ea6 ; 0xe8a $1a
  di
  call WaitLCDController
  ld [hli], a
  ei
  call $2a2a
  jr .asm_e7d ; 0xe95 $e6
.asm_e97
  push de
  ld de, $0020
  ld h, b
  ld l, c
  add hl, de
  call $2a94
  ld b, h
  ld c, l
  pop de
  jr .asm_e7d ; 0xea4 $d7
.asm_ea6
  inc hl
  call $2a2a
  jr .asm_e7d ; 0xeaa $d1
.asm_eac
  inc de
  ld a, [de]
  cp $ff
  jp z, $0f83
  ld a, [de]
  and $c0
  cp $c0
  jp z, $0f08
  cp $80
  jp z, $0ef0
  cp $40
  jp z, $0ed9
  push bc
  ld a, [de]
  inc a
  ld b, a
  inc de
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  dec b
  jp nz, $0ec9
  pop bc
  jp $0eac
; 0xed9

SECTION "Load Tilemap in Window", ROM0[$f84]
LoadTilemapInWindow::
  ld a, BANK(Tilemaps)
  rst $10
  push de
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  ld d, $0
  ld e, c
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  ld hl, $9c00
  ld c, b
  ld b, $0
  add hl, bc
  add hl, de
  pop de
  push hl
  ld hl, Tilemaps
  ld d, $0
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld d, [hl]
  ld e, a
  pop hl
  ld b, h
  ld c, l
  ld a, [de]
  cp $ff
  jp z, $10d2
  and $3
  jr z, .asm_fd5 ; 0xfc9 $a
  dec a
  jr z, .asm_ffb ; 0xfcc $2d
  dec a
  jp z, $106f
  jp $10a0
.asm_fd5
  inc de
  ld a, [de]
  cp $ff
  jp z, $10d2
  cp $fe
  jr z, .asm_fec ; 0xfde $c
  cp $fd
  jr z, .asm_ff8 ; 0xfe2 $14
  di
  call WaitLCDController
  ld [hli], a
  ei
  jr .asm_fd5 ; 0xfea $e9
.asm_fec
  push de
  ld de, $0020
  ld h, b
  ld l, c
  add hl, de
  ld b, h
  ld c, l
  pop de
  jr .asm_fd5 ; 0xff6 $dd
.asm_ff8
  inc hl
  jr .asm_fd5 ; 0xff9 $da
.asm_ffb
  inc de
  ld a, [de]
  cp $ff
  jp z, $10d2
  ld a, [de]
  and $c0
  cp $c0
  jp z, $1057
  cp $80
  jp z, $103f
  cp $40
  jp z, $1028
  push bc
  ld a, [de]
  inc a
  ld b, a
  inc de
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  dec b
  jp nz, $1018
  pop bc
  jp $0ffb
; 0x1028