IF DEF(FEATURE_PORTRAITS)
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
ENDC

SECTION "Portrait Functions", ROMX[$7F00], BANK[$24]
IF DEF(FEATURE_PORTRAITS)
DrawPortrait:
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
ENDC

VWFChar48::
  ; Draw character portrait if called
  ; csv2bin will forcibly add 4C before this, if it isn't the first character in dialog
IF DEF(FEATURE_PORTRAITS)
  inc hl
  ld a, [hl]
  call DrawPortrait ; Sets VWFPortraitDrawn
  pop hl
  call VWFIncTextOffset
  call VWFIncTextOffset
  call VWFResetMessageBox ; Need to set start offsets
ELSE
  pop hl
  call VWFIncTextOffset
  call VWFIncTextOffset
ENDC
  jp PutCharLoopWithBankSwitch