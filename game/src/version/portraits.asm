SECTION "Core portrait functions", ROM0[$1daa]
LoadPortraitTileset:
IF DEF(FEATURE_PORTRAITS)
; a is the bank where the portraits are
; hl is the address of the portrait to pull
; bc is the size of the portraits (always 0100)
  rst $10
  call CopyVRAMData
  ld a, BANK(DrawPortrait)
  rst $10
ENDC
  ret

SECTION "Portrait Functions", ROMX[$7F00], BANK[$24]
DrawPortrait:
IF DEF(FEATURE_PORTRAITS)
  ld e, $f1 ; Portrait restore f1, Portrait f0
  inc a ; Portrait $ff is 'remove portrait', so ff + 1 will give us 0
  jr z, .removeportrait
  dec a
  dec e
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
  ld a, $4
  ld [VWFPortraitDrawn], a
  ld a, 3
  jr .dontremoveportrait

.removeportrait
  xor a
  ld [VWFPortraitDrawn], a

.dontremoveportrait
  call VWFPortraitSGBApplyAttrib
  ; Make sure to save 'temporary bank for rst $18 to function'
  ld a, [$c5c7]
  cp $1
  ld bc, $101 ; tilemap x and y position
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
ENDC
  ret

VWFPortraitClearSGBAttribAndWindowOnEndcode::
  ld a, [$c6e0]
  ld [TempBankStorage], a
  ld a, BANK(DrawPortrait)
  ld [$c6e0], a
  call Wrapper_630_Alt
  ld a, [TempBankStorage]
  ld [$c6e0], a
IF DEF(FEATURE_PORTRAITS)
  xor a
  ; Continues into VWFPortraitSGBApplyAttrib.
ELSE
  ret
ENDC

VWFPortraitSGBApplyAttrib::
IF DEF(FEATURE_PORTRAITS)
  push hl
  push de
  ld l, a
  add a
  add a
  add l
  ld [$C8D3], a
  ld hl, $C8D0
  ld a, $21 ;ATTR_BLK
  ld [hli], a
  ld a, 1
  ld [hli], a
  ld a, 3
  ld [hli], a
  inc hl
  ld a, 1
  ld [hli], a
  ld a, $D
  ld [hli], a
  ld a, 4
  ld [hli], a
  ld a, $10
  ld [hli], a
  ld a, [$c6e0]
  ld [TempBankStorage], a
  ld a, BANK(VWFPortraitSGBApplyAttrib)
  ld [$c6e0], a
  call Wrapper_aa3
  ld a, [TempBankStorage]
  ld [$c6e0], a
  pop de
  pop hl
ENDC
  ret

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
