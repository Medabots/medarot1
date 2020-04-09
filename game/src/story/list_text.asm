; Includes logic for dealing with "list" text (Medals, Items, Medarots)
; Data is fixed size, so no need for a pointer table

SECTION "List Data", ROMX[$4000], BANK[$2E]
ItemList:
  INCBIN "build/lists/Items.bin"
MedalList:
  INCBIN "build/lists/Medals.bin"
MedarotList:
  INCBIN "build/lists/Medarots.bin"
PartList:
HeadPartList:
  INCBIN "build/lists/HeadParts.bin"
RightPartList:
  INCBIN "build/lists/RightParts.bin"
LeftPartList:
  INCBIN "build/lists/LeftParts.bin"
LegPartList:
  INCBIN "build/lists/LegParts.bin"

SECTION "Load from Item List", ROM0[$328f]
LoadItemList:
  push af
  ld a, BANK(ItemList)
  rst $10
  pop af
  ld hl, ItemList - $20
  ld b, $0
  ld c, a
  ld a, $b ; LeftShiftBC5
  rst $8
  add hl, bc
  ld de, cBUF01
  ld b, $20
.asm_32b2
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_32b2 ; 0x32b6 $fa
  ret
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
; 0x32b9

LoadMedalList: ;32b9
  ld b, $0
  ld c, a
  push af
  ld l, $4 ; Shift 4 times, list element size is 16
  ld a, $a ; LeftShiftBC
  rst $8
  ld a, BANK(MedalList)
  ld [$2000], a
  pop af
  ld hl, MedalList
  add hl, bc
  ld de, cBUF01
  ld b, $7
.asm_32d8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_32d8 ; 0x32dc $fa
  ret
  nop
  nop
  nop
  nop
  nop
  nop
  nop
; 0x32df

SECTION "Load from Medarot List", ROM0[$35dc]
LoadMedarotList:
  push hl
  push de
  ld a, BANK(MedarotList)
  ld [$2000], a
  ld hl, MedarotList
  ld b, $0
  ld a, $4
  call $3981
  ld de, cBUF01
  ld a, [hli]
  cp $50 ; Unlike the other lists, medarot names literally just don't even bother checking for length, and just look for the terminator...
  jr z, .asm_35fa ; 0x35f3 $5
  ld [de], a
  inc de
  jp $35f0
.asm_35fa
  ld a, $50
  ld [de], a
  pop de
  pop hl
  ret
; 0x3600

; Pointer to the start of each part list (Head, Right, Left, Leg)
SECTION "Part List Pointers", ROM0[$3562] ; Actually quite surprising it's in ROM0, since there's no need for flexibility with banks (all part lists are in 1c)
PartListPointers:
  dw HeadPartList
  dw RightPartList
  dw LeftPartList
  dw LegPartList

SECTION "Load from Part List", ROM0[$34f0]
LoadPartList:
  ld [$c64e], a
  ld a, BANK(PartList)
  rst $10 ; Swap and preserve bank
  ld a, b
  or a
  jp nz, .load_model_no
  ld hl, PartListPointers
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c64e]
  ld b, $0
  ld c, a
  ld a, $b ; LeftShiftBC5
  rst $8
  add hl, bc
  ld de, cBUF01
  ld b, $25
.asm_3526
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_3526 ; 0x352a $fa
  ret
.load_model_no
  ld hl, PartListPointers
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c64e]
  ld b, $0
  ld c, a
  ld a, $b ; LeftShiftBC5
  rst $8
  add hl, bc
  ld b, $0
  ld c, $25
  add hl, bc
  ld de, cBUF01
  ld b, $7
.asm_355b
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_355b ; 0x355f $fa
  ret
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
; 0x3562

SECTION "Load Inventory Screen", ROMX[$4bdc], BANK[$2]
LoadInventoryScreen:
  ld hl, $aa00
  dec a
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld a, $98
  ld [$c644], a
  ld a, $62
  ld [$c645], a
  ld b, $5
.asm_8bf8
  ld a, [hli]
  or a
  ret z
  push hl
  push bc
  call $01e3
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
  pop bc
  pop hl
  ld a, [hl]
  and $80
  jp z, $4c70
  ld a, [hl]
  and $7f
  ld [$c64e], a
  push hl
  push bc
  ld d, $0
  ld e, b
  sla e
  rl d
  ld hl, $4c75
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, $77
  di
  call $016e
  ld [hli], a
  ei
  ld a, [$c64e]
  push hl
  call $025b
  pop hl
  ld a, [$c64f]
  and $f0
  swap a
  ld b, $6b
  add b
  di
  call $016e
  ld [hli], a
  ei
  ld a, [$c64f]
  and $f
  ld b, $6b
  add b
  di
  call $016e
  ld [hli], a
  ei
  pop bc
  pop hl
  inc hl
  dec b
  jr nz, .asm_8bf8 ; 0x8c72 $84
  ret
; 0x8c75

SECTION "Load Medal Screen", ROMX[$5878], BANK[$2]
LoadMedalScreen:
  ld hl, $a640
  dec a
  ld b, $0
  ld c, a
  call $58e9
  ld a, $98
  ld [$c644], a
  ld a, $83
  ld [$c645], a
  ld b, $5
  ld d, h
  ld e, l
.asm_9890
  ld a, [de]
  or a
  ret z
  push hl
  push bc
  push de
  ld hl, $0001
  add hl, de
  ld a, [hl]
  call $0282
  ld a, [$c644]
  ld b, a
  ld a, [$c645]
  ld c, a
  ld hl, cBUF01
  call $0264
  ld a, [$c644]
  ld h, a
  ld a, [$c645]
  ld l, a
  ld bc, $0060
  add hl, bc
  ld a, h
  ld [$c644], a
  ld a, l
  ld [$c645], a
  pop de
  pop bc
  pop hl
  ld hl, $0020
  add hl, de
  ld d, h
  ld e, l
  dec b
  jr nz, .asm_9890 ; 0x98ca $c4
  ret
; 0x98cd

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