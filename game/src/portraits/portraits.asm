SECTION "Portraits 0-63", ROMX[$4000], BANK[$2E]
TilesetPortraits1::
  INCLUDE "game/src/portraits/include/portraits_1.asm"

SECTION "Portraits 64-113", ROMX[$4000], BANK[$2F]
TilesetPortraits2::
  INCLUDE "game/src/portraits/include/portraits_2.asm"

SECTION "Core portrait functions", ROM0[$1daa]
LoadPortraitTileset:
; a is the bank where the portraits are
; hl is the address of the portrait to pull
; bc is the size of the portraits (always 0100)
  rst $10
  call CopyVRAMData
  ld a, BANK(DrawPortrait)
  rst $10
  ret

SECTION "Portrait Functions", ROMX[$7F00], BANK[$24]
DrawPortrait::
  ld e, $f1 ; Portrait restore f1, Portrait f0
  ld b, $1 ; tilemap x position
  ld c, $1 ; tilemap y position
  inc a ; Portrait $ff is 'remove portrait', so ff + 1 will give us 0
  jr z, .removeportrait
  dec a
  dec e
  push bc
  push de
  cp $40
  ld e, a
  ld a, BANK(TilesetPortraits1)
  ld hl, TilesetPortraits1
  jr c, .normalbank
  ld a, e
  sub $40
  ld e, a
  ld a, BANK(TilesetPortraits2)
  ld hl, TilesetPortraits2
.normalbank
  ld b, e
  ld c, $0
  ld de, $8C00
  add hl, bc
  ld bc, $0100
  call LoadPortraitTileset
  pop de
  pop bc
  ld a, $4
.removeportrait
  ld [VWFPortraitDrawn], a
  ; Make sure to save 'temporary bank for rst $18 to function'
  ld a, [$c5c7]
  cp $1
  jr z, .windowUsed
  dec c ; adjust Y
.windowUsed
  ld a, [$c6e0]
  ld [TempBankStorage], a
  ld a, BANK(DrawPortrait)
  ld [$c6e0], a
  call LoadTilemapInWindowWrapper ; Draw in 9C00
  ld a, [TempBankStorage]
  ld [$c6e0], a
  ret