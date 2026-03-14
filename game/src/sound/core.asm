INCLUDE "game/src/common/constants.asm"

SECTION "Sound Loop", ROMX[$4000], BANK[$06]
PlaySound:: ; 18000 (6:4000)
  push af
  push bc
  push de
  push hl
  ldh a, [$ffa0] ; Swap music if not 0
  cp $01
  jp z, $44b8
  or a
  jr z, .continue_same_music
  call SwapMusic
  xor a
  ldh [$ffa0], a
  jr .asm_18021
.continue_same_music
  ldh a, [$ffa1] ; Sound effect
  or a
  jr z, .asm_18021
  call $4ae7
  xor a
  ldh [$ffa1], a
.asm_18021
  ld a, [$ce90]
  or a
  jr z, .asm_18047
  ld a, [$ce91]
  or a
  jp nz, .asm_18168
  ld a, $ff
  ld [$ce91], a
  ld a, $08
  ldh [hRegNR22], a
  ldh [hRegNR42], a
  xor a
  ldh [hRegNR32], a
  ld a, $80
  ldh [hRegNR24], a
  ldh [hRegNR44], a
  ldh [hRegNR34], a
  jp .asm_18168
.asm_18047
  ld a, [$ce91]
  or a
  jr z, .asm_18064
  xor a
  ld [$ce91], a
  ld a, $8f
  ldh [hRegNR52], a
  ld [$ce94], a
  ld a, $08
  ldh [hRegNR12], a
  ld a, $80
  ldh [hRegNR14], a
  xor a
  ld [$cda0], a
.asm_18064
  ld a, [$ce96]
  or a
  jr z, .asm_180cc
  ld a, [$ce97]
  or a
  jr z, .asm_18076
  dec a
  ld [$ce97], a
  jr .asm_180cc
.asm_18076
  ld a, [$ce98]
  sub $22
  jr c, .asm_1808a
  ld [$ce98], a
  ldh [hRegNR50], a
  ld a, [$ce96]
  ld [$ce97], a
  jr .asm_180cc
.asm_1808a
  xor a
  ldh [hRegNR50], a
  ld [$ce96], a
  ld [$ce97], a
  ldh [hRegNR51], a
  ld [$cd00], a
  ld [$cd28], a
  ld [$cd50], a
  ld [$cd78], a
  ld [$cda0], a
  ld [$cdc8], a
  ldh [hRegNR11], a
  ldh [hRegNR21], a
  ldh [hRegNR32], a
  ldh [hRegNR42], a
  ldh [hRegNR13], a
  ldh [hRegNR23], a
  ldh [hRegNR33], a
  ldh [hRegNR43], a
  ldh [hRegNR30], a
  ld a, $08
  ldh [hRegNR10], a
  ld a, $c0
  ldh [hRegNR14], a
  ldh [hRegNR24], a
  ldh [hRegNR34], a
  ldh [hRegNR44], a
  pop hl
  pop de
  pop bc
  pop af
  ret
.asm_180cc
  ld de, $cd00
  ld a, [de]
  or a
  jr z, .asm_1811d
  xor a
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_180e1
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_1811d
.asm_180e1
  ld a, [$ce94]
  or a
  jr z, .asm_1811a
  xor a
  ld [$ce94], a
  ld hl, $5
  add hl, de
  ld a, [hli]
  ldh [hRegNR10], a
  ld a, [hli]
  ldh [hRegNR11], a
  inc hl
  ld a, [hli]
  or $08
  ldh [hRegNR12], a
  inc hl
  ld a, [hli]
  ldh [hRegNR13], a
  ld a, [hl]
  or $80
  ldh [hRegNR14], a
  ld hl, $25
  add hl, de
  ld a, [hl]
  add a
  ld c, a
  ld b, $00
  ld hl, $41ad
  add hl, bc
  ld c, [hl]
  inc hl
  ld b, [hl]
  ld hl, .asm_1811a
  push hl
  push bc
  ret
.asm_1811a
  call $41b3
.asm_1811d
  ld de, $cd28
  ld a, [de]
  or a
  jr z, .asm_18136
  ld a, $01
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_18133
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_18136
.asm_18133
  call $41b3
.asm_18136
  ld de, $cd50
  ld a, [de]
  or a
  jr z, .asm_1814f
  ld a, $02
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_1814c
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_1814f
.asm_1814c
  call $41b3
.asm_1814f
  ld de, $cd78
  ld a, [de]
  or a
  jr z, .asm_18168
  ld a, $03
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_18165
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_18168
.asm_18165
  call $41b3
.asm_18168
  ld de, $cda0
  ld a, [de]
  or a
  jr z, .asm_18181
  ld a, $04
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_1817e
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_18181
.asm_1817e
  call $41b3
.asm_18181
  ld a, [$ce90]
  or a
  jr nz, .asm_181a0
  ld de, $cdc8
  ld a, [de]
  or a
  jr z, .asm_181a0
  ld a, $05
  ldh [hJoypadReleased], a
  call $41a5
  jr z, .asm_1819d
  ld a, [hl]
  and $7f
  ld [hl], a
  jr .asm_181a0
.asm_1819d
  call $41b3
.asm_181a0
  pop hl
  pop de
  pop bc
  pop af
  ret
; 0x181a5

SECTION "Swap Music", ROMX[$4aca], BANK[$06]
SwapMusic: ; 18aca (6:4aca)
  xor a
  ld [$ce96], a
  ld [$ce97], a
  ld [$ce9b], a
  ld [$ceb0], a
  ld [$ceb1], a
  ld [$ceb4], a
  ld [$ceb5], a
  ld hl, $4c22
  ldh a, [$ffa0]
  jr .asm_18b0d
  ld hl, $70e5
  ldh a, [$ffa1]
  jr .asm_18b0d
.asm_18aee
  inc bc
  inc bc
.loop
  ldh a, [$ffa2]
  inc a
  ldh [$ffa2], a
  cp $06
  jr nz, .asm_18b05
  ld a, $77
  ld [$ce98], a
  ldh [$ff24], a
  ld a, $ff
  ldh [$ff25], a
  ret
.asm_18b05
  ld hl, $28
  add hl, de
  ld e, l
  ld d, h
  jr .asm_18b26
.asm_18b0d
  dec a
  add a
  ld e, a
  ld d, $00
  add hl, de
  ld c, [hl]
  inc hl
  ld b, [hl]
  ld a, [bc]
  ld [$ce92], a
  inc bc
  ld a, [bc]
  ld [$ce93], a
  inc bc
  ld de, $cd00
  xor a
  ldh [$ffa2], a
.asm_18b26
  ld a, [$ce92]
  add a
  ld [$ce92], a
  jr nc, .loop
  ld hl, $0
  add hl, de
  ld a, [$ce93]
  cp [hl]
  jr c, .asm_18aee
  push de
  ld l, $28
  xor a
.asm_18b3d
  ld [de], a
  inc de
  dec l
  jr nz, .asm_18b3d
  pop de
  ld hl, $4
  add hl, de
  ld [hl], $01
  ld hl, $b
  add hl, de
  ld [hl], $ff
  call $471e
  ldh a, [$ffa2]
  cp $05
  jr nz, .asm_18b6d
  ld a, [$cd78]
  or a
  jp nz, $4baa
  xor a
  ldh [$ff20], a
  ldh [$ff21], a
  ldh [$ff22], a
  ld a, $80
  ldh [$ff23], a
  jp $4baa
.asm_18b6d
  push bc
  ld hl, $4bc2
  ldh a, [$ffa2]
  or a
  jr z, .asm_18b93
  ld b, $00
  cp $01
  jr nz, .asm_18b80
  ld c, $05
  jr .asm_18b92
.asm_18b80
  cp $02
  jr nz, .asm_18b88
  ld c, $0a
  jr .asm_18b92
.asm_18b88
  cp $03
  jr nz, .asm_18b90
  ld c, $0f
  jr .asm_18b92
.asm_18b90
  ld c, $14
.asm_18b92
  add hl, bc
.asm_18b93
  pop bc
  ld a, [hli]
  cp $ee
  call nz, $4a07
  ld a, [hli]
  call $4a11
  ld a, [hli]
  call $4a1b
  ld a, [hli]
  call $4a49
  ld a, [hl]
  call $4a53
  ld hl, $0
  add hl, de
  ld a, [$ce93]
  ld [hli], a
  ld a, [bc]
  inc bc
  ld [hli], a
  ld a, [bc]
  inc bc
  ld [hl], a
  ld hl, $22
  add hl, de
  ld a, $80
  ld [hl], a
  jp .loop
; 0x18bc2