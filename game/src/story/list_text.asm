; Includes logic for dealing with "list" text (Medals, Items)

SECTION "List Data", ROMX[$4000], BANK[$2E]
ItemList:
  INCBIN "build/lists/Items.bin"
MedalList:
  INCBIN "build/lists/Medals.bin"
MedarotList:
  INCBIN "build/lists/Medarots.bin"

SECTION "Load Lists", ROM0[$328f]
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

LoadMedalList: ;4a9f
  ld b, $0
  ld c, a
  ld l, $4 ; Shift 4 times, list element size is 16
  ld a, $a ; LeftShiftBC
  rst $8
  push af
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

SECTION "Load Medarots", ROM0[$35dc]
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
