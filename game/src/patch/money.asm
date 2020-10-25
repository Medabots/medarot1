SECTION "Map Price With Yen Symbol", ROM0[$79]
MapMoneyWithYenSymbol::
; Warning: Be careful about making changes to the money window tilemap.
; MapMoneyWithYenSymbol can descend into an infinite loop if it can't find a place to insert the yen symbol.

  call JumpDrawNumber
  ld a, c
  inc a
  inc a
  jr .decccommon

.loop
  di
  call WaitLCDController
  ld a, [bc]
  ei
  or a
  jr z, .exit

.decc
  ld a, c
  dec a

.decccommon
  and $1F
  ld d, a
  ld a, c
  and $E0
  add d
  ld c, a
  jr .loop

.exit
  di
  call WaitLCDController
  ld a, $7C
  ld [bc], a
  ei
  ret

SECTION "Map Price With Yen Symbol 2", ROMX[$7F6C], BANK[$3]
MapSellMoneyWithYenSymbol::
  push hl
  ld de, $C89D
  ld bc, $37C

.loop
  ld a, [de]
  or a
  jr nz, .yenFound
  xor a
  di
  call WaitLCDController
  ld [hli], a
  ei
  inc de
  dec b
  jr nz, .loop

.yenFound
  di
  call WaitLCDController
  ld [hl], c
  ei

  pop hl
  inc hl
  xor a
  ld [$C89A], a
  jp $433A

ShopSellPriceSpriteFixHack::
  call $456F

  ld hl, $C0A0
  ld de, $20
  ld b, $19

.loop
  ld a, [hl]
  or a
  jr z, .dontHide

  and 1
  jr z, .dontHide

  ld c, l
  ld a, l
  add $13
  ld l, a
  ld a, [hl]
  ld l, c
  or a
  jr nz, .dontHide

  ld a, [hl]
  and $FE
  or 2
  ld [hl], a

.dontHide
  add hl, de
  dec b
  jr nz, .loop
  ld a, 1
  ld [$C600], a
  ret
