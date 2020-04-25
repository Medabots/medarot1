; Includes logic for dealing with "list" text (Medals, Items, Medarots)
; Data is fixed size, so no need for a pointer table

SECTION "List Data", ROMX[$5af0], BANK[$17]
ItemList:
  INCBIN "build/lists/Items.bin"
MedalList:
  INCBIN "build/lists/Medals.bin"

SECTION "Medarot List Data", ROMX[$6c36], BANK[$17]
MedarotList:
  INCBIN "build/lists/Medarots.bin"

SECTION "Part List Data", ROMX[$65cc], BANK[$1c]
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
  ld [$2000], a
  pop af
  ld hl, ItemList - $10
  ld b, $0
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld de, cBUF01
  ld b, $9 ; Despite having 16 bytes per item, it only looks at 10
.asm_32b2
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_32b2 ; 0x32b6 $fa
  ret
; 0x32b9

SECTION "Load from Medal List", ROM0[$32b9]
LoadMedalList:
  push af
  ld a, BANK(MedalList)
  ld [$2000], a
  pop af
  ld hl, MedalList
  ld b, $0
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
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
  cp $50
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
  ld [$2000], a
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
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld de, cBUF01
  ld b, $9
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
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld b, $0
  ld c, $9
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
  call JumpPutString
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
  call JumpPutString
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