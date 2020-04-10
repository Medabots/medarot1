SECTION "Medarot Equip Screen - Load Part Names", ROMX[$6ee6], BANK[$2]
LoadMedarotPartSelectMedal:
  ld a, [$a03b]
  ld b, a
  ld a, [$a03a]
  cp b
  jp nz, $6efb
  ld b, $a
  ld c, $4
  ld e, $85
  call $015c
  ret
  ld hl, $a640
  ld c, b
  ld b, $0
  ld a, $5
  call $02b8
  ld a, $40
  ld hl, $988a
  call $585a
  ld hl, $0001
  add hl, de
  ld a, [hl]
  call $0282
  ld hl, cBUF01
  ld bc, $98ac
  call $0264
  ret
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

SECTION "Medarot Equip Screen, Load Skill", ROMX[$761e], BANK[$2]
LoadMedarotPartSelectSkills:
  ld a, [$a03a]
  ld b, a
  ld a, [$a03b]
  cp b
  ret z
  ld hl, $a640
  ld b, $0
  ld c, a
  ld a, $5
  call $02b8
  xor a
  ld [$c658], a
  ld [$c65a], a
  ld [$c65b], a
.asm_b644
  ld hl, $000c
  add hl, de
  ld a, [hl]
  ld [$c65b], a
  ld hl, $000c
  ld b, $0
  ld a, [$c658]
  ld c, a
  add hl, bc
  add hl, de
  ld a, [hl]
  ld b, a
  ld a, [$c65b]
  sub b
  jr nc, .asm_b661 ; 0xb655 $a
  ld a, [$c658]
  ld [$c65a], a
  ld a, b
  ld [$c65b], a
.asm_b661
  ld a, [$c658]
  inc a
  ld [$c658], a
  cp $8
  jp nz, $7644 ; asm_b644
  ld a, [$c65a]
  ld hl, SkillsPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $98ec
  call $0264
  ret
; 0xb685