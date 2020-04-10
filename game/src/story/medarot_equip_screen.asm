SECTION "Load Medarot Part Select", ROMX[$6f20], BANK[$2]
LoadMedarotPartSelectHead:
  ld a, [$a03d]
  sub $3c
  jp c, $6f32
  ld b, $9
  ld c, $9
  ld e, $86
  call $015c
  ret
  ld a, [$a03d]
  ld hl, $b520
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $0
  call $0294
  ld hl, cBUF01
  ld bc, $9949
  call $0264
  ret
LoadMedarotPartSelectRArm:
  ld a, [$a03f]
  sub $3c
  jp c, $6f66
  ld b, $9
  ld c, $b
  ld e, $86
  call $015c
  ret
  ld a, [$a03f]
  ld hl, $b5a0
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $1
  call $0294
  ld hl, cBUF01
  ld bc, $9989
  call $0264
  ret
LoadMedarotPartSelectLArm:
  ld a, [$a041]
  sub $3c
  jp c, $6f9a
  ld b, $9
  ld c, $d
  ld e, $86
  call $015c
  ret
  ld a, [$a041]
  ld hl, $b620
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $2
  call $0294
  ld hl, cBUF01
  ld bc, $99c9
  call $0264
  ret
; 0xafbc
LoadMedarotPartSelectLegs:
  ld a, [$a043]
  sub $3c
  jp c, $6fce
  ld b, $9
  ld c, $f
  ld e, $86
  call $015c
  ret
; 0xafce
  ld a, [$a043]
  ld hl, $b6a0
  ld c, a
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hl]
  and $7f
  ld b, $0
  ld c, $3
  call $0294
  ld hl, cBUF01
  ld bc, $9a09
  call $0264
  ret
; 0xaff0