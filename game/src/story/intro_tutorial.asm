SECTION "Intro Setup", ROMX[$703a], BANK[$16]
IntroTutorialLoadTiles: ; 5b03a (16:703a)
  ld a, $02
  call JumpLoadFont
  ld a, $03
  call JumpLoadFont
  ld a, $09
  call JumpLoadFont
  ld a, $32
  call JumpLoadFont
  ld b, $00
  ld c, $00
  ld e, $0f
  call JumpLoadTilemap
  ld b, $05
  ld c, $08
  ld d, $00
  ld e, $00
  ld a, $0c
  call JumpTable_309
  ld a, $01
  call JumpTable_1e6
  ld a, $3c
  ld [$a03d], a
  ld [$a03f], a
  ld [$a041], a
  ld [$a043], a
  xor a
  ld [$c5c2], a
  ld [$c5c3], a
  ld a, $01
  ld [$c8b9], a
  call JumpTable_156
  ld de, $c140
  ld a, $01
  ld hl, $0
  add hl, de
  ld [hl], a
  xor a
  ld hl, $4
  add hl, de
  ld [hl], a
  ld a, $5a
  ld hl, $2
  add hl, de
  ld [hl], a
  ld a, $20
  ld hl, $3
  add hl, de
  ld [hl], a
  ld a, $5e
  call JumpTable_165
  ld a, $01
  ld [$c600], a
  jp JumpIncSubStateIndexWrapper