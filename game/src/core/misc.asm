; Misc functions to be categorized, but needed to be dumped
INCLUDE "game/src/common/constants.asm"

SECTION "Draw Player Money in Menu", ROMX[$45B9], BANK[$2]
DrawPlayerMoneyInMenu: ; 85b9 (2:45b9)
  ld b, $04
  ld c, $00
  ld e, $51
  call JumpTable_2ca
  ld a, [$c93a]
  or a
  jr nz, .asm_85cd
  ld a, [$c93b]
  or a
  ret z
.asm_85cd
  ld b, $05
  ld c, $01
  call JumpTable_1dd
  push hl
  pop bc
  ld a, [$c93a]
  ld h, a
  ld a, [$c93b]
  ld l, a
  call JumpTable_1ec
  ret
; 0x85e2

SECTION "Draw Player Money (unknown area)", ROMX[$4289], BANK[$3]
DrawPlayerMoneyMisc: ; c289 (3:4289)
  call $429e
  ld b, $00
  ld c, $00
  ld e, $1f
  call JumpTable_2ca
  ld hl, $9825
  call $433a
  jp $659c
; 0xc29e

; Also used for wings of wind
SECTION "Town Map tilemap loading (partial)", ROMX[$77e9], BANK[$1]
LoadTownMapTilemapTextBox: ; 77e9 (1:77e9)
  ld b, $00
  ld c, $00
  ld e, $0d
  call JumpLoadTilemap
  jp JumpIncSubStateIndexWrapper

SECTION "Func_25e5", ROM0[$25e5]
Func_25e5: ; 25e5 (0:25e5)
  ld a, $12
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $70e6
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c932], a
  dec a
  ld [$c933], a
  call $398c
  ret

SECTION "Func_2bb2", ROM0[$2bb2]
Func_2bb2: ; 2bb2 (0:2bb2)
  ld [$c6d3], a
  ld a, $0b
  ld [$2000], a
  xor a
  ld [$c64e], a
  ld a, [$c6ce]
  or a
  jp nz, $2c38
  ld a, $01
  ld [$c6ce], a
  xor a
  ld [$c6d6], a
.asm_2bce
  push bc
  ld hl, $73e0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $00
  ld a, [$c6d6]
  ld c, a
  sla c
  rl b
  add hl, bc
  pop bc
  ld a, [hl]
  cp $ff
  jp z, $2c9c
  cp $fe
  jp nz, .asm_2c1e
  inc hl
  ld a, [hl]
  push bc
  ld hl, $8000
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  pop bc
  ld a, h
  ld [$c6cf], a
  ld a, l
  ld [$c6d0], a
  ld a, [$c6d6]
  inc a
  ld [$c6d6], a
  jp .asm_2bce
.asm_2c1e
; 0x2c1e

SECTION "Func_2dba", ROM0[$2dba]
Func_2dba: ; 2dba (0:2dba)
  ld a, $17
  ld [$2000], a
  ld hl, $c933
  ld a, [$c936]
  cp $ff
  jr z, .asm_2dcc
  ld hl, $c936
.asm_2dcc
  ld a, [hl]
  ld hl, $62a2
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  or a
  jp z, .asm_2dfb
  ld [$c64e], a
  ld a, [hli]
  ld [$c650], a
  ld a, $12
  ld [$2000], a
  ld hl, $7206
  ld b, $00
  ld a, [$c8f9]
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c64f], a
  ret
.asm_2dfb
; 0x2dfb

SECTION "Func_2eb0", ROM0[$2eb0]
Func_2eb0: ; 2eb0 (0:2eb0)
  ld a, $14
  ld [$2000], a
  ld a, [$c752]
  ld b, $00
  ld c, a
  sla c
  rl b
  ld hl, $2ef7
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $00
  ld a, [$c741]
  ld c, a
  ld a, $08
  call GetListTextOffset
  push hl
  ld hl, $9210
  ld b, $00
  ld a, [$c741]
  ld c, a
  ld a, $08
  call GetListTextOffset
  pop hl
  ld bc, $100
  call CopyVRAMData
  ld a, [$c741]
  inc a
  ld [$c741], a
  cp $03
  ret nz
  ld a, $ff
  ld [$c740], a
  ret
; 0x2ef7

SECTION "Func_2faa", ROM0[$2faa]
Func_2faa: ; 2faa (0:2faa)
  ld a, $17
  ld [$2000], a
  ld a, [$c753]
  ld hl, $64e6
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc hl
  inc hl
  inc hl
  ld de, cBUF01
  ld b, $09
.asm_2fc8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_2fc8
  ret
; 0x2fcf

SECTION "Func_3155", ROM0[$3155]
Func_3155: ; 3155 (0:3155)
  ld [$c64e], a
  ld a, $17
  ld [$2000], a
  ld hl, $318f
  ld d, $00
  ld e, b
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld d, $00
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
  add hl, de
  ld a, [$c64e]
  ld d, $00
  ld e, a
  add hl, de
  ld a, [hl]
  ld [$c64e], a
  ret
; 0x318f

SECTION "Func_3195", ROM0[$3195]
Func_3195: ; 3195 (0:3195)
  ld b, $0a
  ld c, $00
  ld e, $3c
  call LoadTilemap
  ld a, $17
  ld [$2000], a
  ld hl, $325c
  ld b, $00
  ld a, [$a00e]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a00f]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $986b
  call PutString
  ld hl, $325c
  ld b, $00
  ld a, [$a010]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a011]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $98ab
  call PutString
  ld hl, $325c
  ld b, $00
  ld a, [$a012]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a013]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $98eb
  call PutString
  ld hl, $325c
  ld b, $00
  ld a, [$a014]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a015]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $992b
  call PutString
  ret

SECTION "Func_3262", ROM0[$3262]
Func_3262: ; 3262 (0:3262)
  push af
  ld a, $08
  ld [$2000], a
  pop af
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4e4e
  add hl, bc
  ld bc, $40
  call CopyVRAMData
  ret
; 0x328f

SECTION "Func_32ed", ROM0[$32ed]
Func_32ed: ; 32ed (0:32ed)
  push hl
  push de
  push bc
  ld d, $01
  ld e, $03
.asm_32f4
  ld a, d
  call $32df
  ld hl, $a000
  ld bc, $2000
.asm_32fe
  xor a
  ld [hli], a
  dec bc
  ld a, c
  or b
  jr nz, .asm_32fe
  inc d
  dec e
  jp nz, .asm_32f4
  pop bc
  pop de
  pop hl
  ret
; 0x330e

SECTION "Func_3480", ROM0[$3480]
Func_3480: ; 3480 (0:3480)
  push af
  ld a, $0a
  ld [$2000], a
  pop af
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4000
  add hl, bc
  ld bc, $100
  call CopyVRAMData
  ret
; 0x34b5

SECTION "34b5", ROM0[$34b5]
Func_34b5: ; 34b5 (0:34b5)
  ld a, $0a
  ld [$2000], a
  ld hl, $7900
  ld bc, $1a0
  call CopyVRAMData
  ret
; 0x34c4

SECTION "Func_356a", ROM0[$356a]
Func_356a: ; 356a (0:356a)
  push af
  ld b, $0c
  add b
  ld [$2000], a
  ld b, $00
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4000
  add hl, bc
  ld bc, $100
  pop af
  cp $03
  jr nz, .asm_35a2
  ld bc, $c0
.asm_35a2
  call CopyVRAMData
  ret
; 0x35a6

SECTION "Func_35a6", ROM0[$35a6]
Func_35a6: ; 35a6 (0:35a6)
  push hl
  push de
  push bc
  ld a, $0b
  ld [$2000], a
  ld hl, $4000
  ld bc, $90
  call CopyVRAMData
  pop bc
  pop de
  pop hl
  ret
; 0x35bb

SECTION "Func_35bb", ROM0[$35bb]
Func_35bb: ; 35bb (0:35bb)
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $6879
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $09
  ld de, $c64e
.asm_35d5
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_35d5
  ret
; 0x35dc

SECTION "Func_37cd", ROM0[$37cd]
Func_37cd: ; 37cd (0:37cd)
  push hl
  push de
  push bc
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $70d6
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $1f
  call CopyVRAMData
  pop bc
  pop de
  pop hl
  ret
; 0x37fc

SECTION "Func_37fc", ROM0[$37fc]
Func_37fc: ; 37fc (0:37fc)
  push hl
  push de
  push bc
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $6ff6
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  push hl
  ld hl, $c
  add hl, de
  ld d, h
  ld e, l
  pop hl
  ld b, $08
.asm_3823
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_3823
  pop bc
  pop de
  pop hl
  ret
; 0x382d

SECTION "Func_382d", ROM0[$382d]
Func_382d: ; 382d (0:382d)
  push de
  ld de, $a410
  or a
  jr z, .asm_3837
  ld de, $a420
.asm_3837
  ld a, $17
  ld [$2000], a
  ld hl, $4
  add hl, de
  ld a, [hl]
  cp $03
  jr nz, .asm_387f
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $7456
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $7
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $8
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp .asm_38c3
.asm_387f
  ld hl, $4
  add hl, de
  ld a, [hl]
  cp $02
  jr nz, .asm_38b0
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $74f4
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $7
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp .asm_38c3
.asm_38b0
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $753c
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
.asm_38c3
  ld de, $a084
  ld b, $08
.asm_38c8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_38c8
  pop de
  ret
; 0x38d0

SECTION "Func_38d0", ROM0[$38d0]
Func_38d0: ; 38d0 (0:38d0)
  push de
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $755a
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld de, $a084
  ld b, $08
.asm_38f0
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_38f0
  pop de
  ret
; 0x38f8

SECTION "Func_38f8", ROM0[$38f8]
Func_38f8: ; 38f8 (0:38f8)
  push hl
  push de
  ld a, $17
  ld [$2000], a
  ld hl, $7622
  ld d, $00
  ld e, b
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  add hl, de
  ld d, $00
  ld e, c
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  pop bc
  pop de
  pop hl
  ret
; 0x3926

SECTION "Func_3942", ROM0[$3942]
Func_3942: ; 3942 (0:3942)
  push af
  push bc
  ld b, $01
  ld c, $01
  ld e, $2f
  call LoadTilemapInWindow
  pop bc
  pop af
  ld c, a
  ld a, $01
  call $3117
  ld a, $02
  ld [$2000], a
  ld hl, $67f7
  ld b, $00
  ld a, [$c64e]
  ld c, a
  add hl, bc
  ld a, [hl]
  push af
  ld a, $1f
  ld [$2000], a
  pop af
  ld hl, $7234
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $9c41
  call PutString
  ret
; 0x3981

SECTION "Func_398c", ROM0[$398c]
Func_398c: ; 398c (0:398c)
  ld a, $12
  ld [$2000], a
  ld hl, $7176
  ld b, $00
  ld a, [$c8f9]
  ld c, a
  add hl, bc
  ld a, [hl]
  push af
  and $f0
  swap a
  ld b, a
  ld a, [$c939]
  ld hl, $39c0
  ld d, $00
  ld e, a
  add hl, de
  ld a, [hl]
  add b
  ld c, a
  sub $0b
  jr c, .asm_39b5
  ld c, $0a
.asm_39b5
  ld a, c
  ld [$c934], a
  pop af
  and $0f
  ld [$c935], a
  ret
; 0x39c0

SECTION "Func_3ac8", ROM0[$3ac8]
Func_3ac8: ; 3ac8 (0:3ac8)
  ld a, $12
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $7296
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c64e], a
  ret
; 0x3adc

SECTION "Func_3ca6", ROM0[$3ca6]
Func_3ca6: ; 3ca6 (0:3ca6)
  call $2a9e
  ld a, $1d
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $6000
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c939]
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld a, $1d
  ld [$2000], a
  ld a, [hl]
  cp $ff
  jp z, $3d66
  call $3d68
  cp $00
  jp nz, $3d66
  pop hl
  ld a, [hli]
  push hl
  ld hl, $14
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $15
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $17
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $18
  add hl, de
  ld [hl], a
  ld [$c8b0], a
  pop hl
  call $3d8c
  cp $00
  jp nz, $3d5f
  ld a, [hli]
  cp $ff
  jp z, $3d53
  push hl
  ld hl, $4
  add hl, de
  ld [hl], a
  push af
  ld hl, $1b
  add hl, de
  and $f0
  ld [hl], a
  pop af
  ld hl, $1c
  add hl, de
  and $0f
  ld [hl], a
  pop hl
  ld a, $09
  push hl
  ld hl, $0
  add hl, de
  ld [hl], a
  pop hl
  push hl
  ld hl, $14
  add hl, de
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld c, a
  ld a, $01
  ld [$2000], a
  ld a, [$c8b0]
  and $80
  jp z, .asm_3d4d
  pop hl
  jp $3d53
.asm_3d4d
; 0x3d4d