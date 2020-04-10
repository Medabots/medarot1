SECTION "Load Parts Screen, Part Name", ROMX[$62f7], BANK[$2]
LoadPartsScreenPartName:
  ld a, $98
  ld [$c644], a
  ld a, $a8
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $6316
  cp $1
  jp z, $631c
  cp $2
  jp z, $6322
  jp $6328
; 0xa316
  ld hl, $b520
  jp $632b
; 0xa31c
  ld hl, $b5a0
  jp $632b
; 0xa322
  ld hl, $b620
  jp $632b
; 0xa328
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
.asm_a33c  
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6354
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $8
  ld e, $73
  call $015c
  jp $637d
; 0xa354
  push hl
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $8
  ld e, $7a
  call $015c
  pop hl
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $0
  call $0294
  ld hl, cBUF01
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  call $0264
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jr nz, .asm_a33c ; 0xa39a $a0
  ret
  ld a, [$c750]
  ld hl, $63af
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl
  cp a
  ld h, e
  bit 4, e
  rst $10
  ld h, e
  or $63
  dec b
  ld h, h
  ld b, b
  ld h, h
  ld d, e
  ld h, h
  ld e, a
  ld h, h
  ld b, $0
  ld c, $0
  ld e, $7b
  call $015c
  jp $5788
; 0xa3cb

SECTION "Load Parts Screen, Part Model", ROMX[$65a3], BANK[$2]
LoadPartsScreenPartModel:
  ld a, $98
  ld [$c644], a
  ld a, $a1
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $65c2
  cp $1
  jp z, $65c8
  cp $2
  jp z, $65ce
  jp $65d4
; 0xa5c2
  ld hl, $b520
  jp $65d7
; 0xa5c8
  ld hl, $b5a0
  jp $65d7
; 0xa5ce
  ld hl, $b620
  jp $65d7
; 0xa5d4
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
.asm_a5e8  
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6600
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $1
  ld e, $78
  call $015c
  jp $661a
; 0xa600
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $1
  call $0294
  ld hl, cBUF01
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  call $0264
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jr nz, .asm_a5e8 ; 0xa637 $af
  ret
  ld a, $98
  ld [$c644], a
  ld a, $b0
  ld [$c645], a
  ld a, [$c727]
  cp $0
  jp z, $6659
  cp $1
  jp z, $665f
  cp $2
  jp z, $6665
  jp $666b
; 0xa659
  ld hl, $b520
  jp $666e
; 0xa65f
  ld hl, $b5a0
  jp $666e
; 0xa665
  ld hl, $b620
  jp $666e
; 0xa66b
  ld hl, $b6a0
  ld a, [$c725]
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, $0
  push hl
  push bc
  push de
  ld a, [hl]
  or a
  jp nz, $6697
  ld a, b
  sla a
  add $4
  ld c, a
  ld b, $11
  ld e, $79
  call $015c
  jp $66ed
; 0xa697
  push hl
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  xor a
  di
  call $016e
  ld [hli], a
  ei
  di
  call $016e
  ld [hli], a
  ei
  di
  call $016e
  ld [hli], a
  ei
  di
  call $016e
  ld [hli], a
  ei
  pop hl
  push hl
  inc hl
  ld a, [hl]
  push af
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  pop af
  call $02fa
  pop hl
  ld a, [hl]
  and $7f
  ld hl, $759e
  ld b, $0
  ld c, a
  add hl, bc
  ld a, [hl]
  or a
  jp nz, $66ed
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  inc hl
  inc hl
  inc hl
  ld a, $50
  di
  call $016e
  ld [hli], a
  ei
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0040
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  inc hl
  inc hl
  inc b
  ld a, b
  cp $4
  jp nz, $667f
  ret
; 0xa70e

SECTION "Load Part Info", ROMX[$6753], BANK[$2]
LoadPartInfo:
  call $670e
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $0
  call $0294
  ld hl, cBUF01
  call $028e
  ld h, $0
  ld l, a
  ld bc, $9901
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call $0264
  ret
; 0xa778

SECTION "Load Attribute", ROMX[$6789], BANK[$2]
LoadAttribute:
  ld a, $0
  call $6778
  ld hl, AttributesPtr
  ld b, $0
  ld a, [$c64e]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld bc, $9941
  ld d, BANK(LoadAttribute)
  ld e, BANK(AttributesPtr)
  jp PrintPtrText
; 0xa7a6

SECTION "Load Part Description", ROM0[$3926]
LoadPartDescription:
  push af
  ld a, BANK(PartDescriptionsPtr)
  ld [$2000], a
  pop af
  ld hl, PartDescriptionsPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $99e1 ; original 9a01
  call PutString
  ret
; 0x3942

SECTION "Load Skill", ROMX[$67a6], BANK[$2]
LoadSkill:
  ld a, [$c727]
  cp $3
  ret z
  ld a, $3
  call $6778
  ld hl, $67d1
  ld b, $0
  ld a, [$c64e]
  ld c, a
  add hl, bc
  ld a, [hl]
  ld hl, SkillsPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld bc, $99a1 ; original 99c1
  ld d, BANK(LoadSkill)
  ld e, BANK(SkillsPtr)  
  jp PrintPtrText
; 0xa7d1