INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

; Used to draw shop items, only thing I've seen that uses this so far (might need to move it elsewhere if it's used elsewhere)
; hl = text
; bc = index, added to $9800
SECTION "PutShopString", ROM0[$303c]
PutShopString:: ; 303c (0:303c)
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  call $37b6
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  push bc
  ld c, b
  ld b, $00
  ld hl, $9800
  add hl, bc
  pop bc
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
  add hl, bc
  ld a, h
  ld [$c642], a
  ld a, l
  ld [$c643], a
.asm_3077
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld a, [hl]
  cp $50
  ret z
  ld [$c64e], a
  call $2068
  ld a, [$c64f]
  or a
  jp z, $30a8
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  call $2a94
  ld a, [$c64f]
  di
  call WaitLCDController
  ld [hl], a
  ei
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld a, [$c64e]
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  call $2a2a
  ld a, h
  ld [$c642], a
  ld a, l
  ld [$c643], a
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  inc hl
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  jp .asm_3077
; 0x30d9

SECTION "Load Shop Menu - Parts", ROMX[$45af], BANK[$3]
LoadShopPartsMenu:
  call LoadShopInfo
  ld [$c883], a
  ld a, [$c88a]
  ld c, a
  ld a, [hli]
  cp $ff
  jp z, .asm_c69f
  push hl
  push af
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9884, $b0
  call VWFPutStringAutoNarrowTo8
  pop af
  call $4593
  ld b, $d
  ld c, $4
  call JumpTable_1dd
  push hl
  pop bc
  ld h, $0
  ld a, [$c884]
  ld l, a
  call MapMoneyWithYenSymbol
  ld b, $11
  ld c, $4
  ld e, $19
  call JumpTable_2ca
  pop hl
  ld a, [$c88a]
  ld c, a
  ld a, [hli]
  cp $ff
  jp z, .asm_c69f
  push hl
  push af
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $98c4, $b8
  call VWFPutStringAutoNarrowTo8
  pop af
  call $4593
  ld b, $d
  ld c, $6
  call JumpTable_1dd
  push hl
  pop bc
  ld h, $0
  ld a, [$c884]
  ld l, a
  call MapMoneyWithYenSymbol
  ld b, $11
  ld c, $6
  ld e, $19
  call JumpTable_2ca
  pop hl
  ld a, [$c88a]
  ld c, a
  ld a, [hli]
  cp $ff
  jp z, .asm_c69f
  push hl
  push af
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9904, $c0
  call VWFPutStringAutoNarrowTo8
  pop af
  call $4593
  ld b, $d
  ld c, $8
  call JumpTable_1dd
  push hl
  pop bc
  ld h, $0
  ld a, [$c884]
  ld l, a
  call MapMoneyWithYenSymbol
  ld b, $11
  ld c, $8
  ld e, $19
  call JumpTable_2ca
  pop hl
  ld a, [$c88a]
  ld c, a
  ld a, [hli]
  cp $ff
  jp z, .asm_c69f
  push af
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9944, $c8
  call VWFPutStringAutoNarrowTo8
  pop af
  call $4593
  ld b, $d
  ld c, $a
  call JumpTable_1dd
  push hl
  pop bc
  ld h, $0
  ld a, [$c884]
  ld l, a
  call MapMoneyWithYenSymbol
  ld b, $11
  ld c, $a
  ld e, $19
  call JumpTable_2ca
.asm_c69f
  ret
  nop
  nop
  nop
  nop
; 0xc6a0
LoadShopPartsMenuSell:
  ld a, [$c88a]
  ld c, a
  call JumpTable_16b
  ld [$c883], a
  call $4815
  cp $ff
  jp z, .asm_c79f
  push af
  ld a, [$c88a]
  ld c, a
  ld a, [$c886]
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9884, $b0
  call VWFPutStringAutoNarrowTo8
  ld b, $d
  ld c, $4
  call JumpTable_1dd
  push hl
  pop bc
  pop af
  ld h, $0
  ld l, a
  call JumpDrawNumber
  ld b, $11
  ld c, $4
  ld e, $18
  call JumpTable_2ca
  ld a, [$c886]
  inc a
  ld [$c886], a
  call $4815
  cp $ff
  jp z, .asm_c79f
  push af
  ld a, [$c88a]
  ld c, a
  ld a, [$c886]
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $98c4, $b8
  call VWFPutStringAutoNarrowTo8
  ld b, $d
  ld c, $6
  call JumpTable_1dd
  push hl
  pop bc
  pop af
  ld h, $0
  ld l, a
  call JumpDrawNumber
  ld b, $11
  ld c, $6
  ld e, $18
  call JumpTable_2ca
  ld a, [$c886]
  inc a
  ld [$c886], a
  call $4815
  cp $ff
  jp z, .asm_c79f
  push af
  ld a, [$c88a]
  ld c, a
  ld a, [$c886]
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9904, $c0
  call VWFPutStringAutoNarrowTo8
  ld b, $d
  ld c, $8
  call JumpTable_1dd
  push hl
  pop bc
  pop af
  ld h, $0
  ld l, a
  call JumpDrawNumber
  ld b, $11
  ld c, $8
  ld e, $18
  call JumpTable_2ca
  ld a, [$c886]
  inc a
  ld [$c886], a
  call $4815
  cp $ff
  jp z, .asm_c79f
  push af
  ld a, [$c88a]
  ld c, a
  ld a, [$c886]
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  psbc $9944, $c8
  call VWFPutStringAutoNarrowTo8
  ld b, $d
  ld c, $a
  call JumpTable_1dd
  push hl
  pop bc
  pop af
  ld h, $0
  ld l, a
  call JumpDrawNumber
  ld b, $11
  ld c, $a
  ld e, $18
  call JumpTable_2ca
.asm_c79f
  ret
  nop
  nop
  nop
  nop
; 0xc7a0
LoadShopInfo: ; c7a0 (3:47a0)
  ld hl, $484d
  ld a, [$c881]
  ld e, a
  ld d, $00
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c88a]
  ld e, a
  ld d, $00
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  ret
; 0xc7c1

SECTION "Load Buy/Sell Menu (in shops)", ROMX[$70d3], BANK[$3]
LoadBuySellTilemap: ; f0d3 (3:70d3)
  ld b, $00
  ld c, $00
  ld e, $1e
  ld a, $11 ; LoadShopTilesetAndBuySellTilemap
  rst $8
  jp $659c
; 0xf0df

SECTION "Load Money Overlay (in shops)", ROMX[$571c], BANK[$3]
LoadMoneyTilemapOverlayInShops: ; d71c (3:571c)
  ld b, $0C
  ld c, $00
  ld e, $1f
  call JumpTable_2ca
  ld b, $0e
  ld c, $01
  call JumpTable_1dd
  push hl
  pop bc
  ld a, [$c93a]
  ld h, a
  ld a, [$c93b]
  ld l, a
  ld a, h
  or a
  jr nz, .asm_d73d
  ld a, l
  or a
  ret z
.asm_d73d
  call MapMoneyWithYenSymbol
  ret
; 0xd741