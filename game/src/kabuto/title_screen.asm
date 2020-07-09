SECTION "Titlescreen State Initialize", ROMX[$423D], BANK[$1]
TitlescreenStateInitialize::
  ld b, 0
  ld c, 0
  ld e, 7
  call JumpLoadTilemap
  ld a, 6
  call JumpLoadFont
  ld a, 7
  call JumpLoadFont
  ld a, $B8
  ld [$C5C2], a
  ld a, $A
  ld [$C5C3], a
  xor a
  ld [$C7FB], a
  ld [$C5C4], a
  ld [$C5C5], a
  ld a, 4
  call JumpTable_17d
  ld de, $C140
  ld hl, 4
  add hl, de
  ld a, $EF
  ld [hl], a
  ld a, 1
  ld hl, 0
  add hl, de
  ld [hl], a
  ld a, $B8
  ld hl, 2
  add hl, de
  ld [hl], a
  ld a, $60
  ld hl, 3
  add hl, de
  ld [hl], a
  ld a, 1
  ld [$C600], a
  ld a, $4F
  ld [$C5AA], a
  ld a, 1
  ld [$C6BF], a
  ld hl, $C6B0
  ld a, $7F
  ld [hli], a
  ld a, $70
  ld [hli], a
  xor a
  ld [hli], a
  ld b, 3
  ld c, 4
  ld d, $39
  ld e, $3A
  ld a, $E
  call JumpTable_309
  ld a, 3
  ldh [$FFA0], a
  jp JumpIncSubStateIndexWrapper