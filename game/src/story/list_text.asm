; Includes logic for dealing with "list" text (Medals, Items)

SECTION "List Data", ROMX[$5af0], BANK[$17]
ItemsList:
  INCBIN "build/lists/Items.bin"
MedalList:
  INCBIN "build/lists/Medals.bin"

SECTION "Load Lists", ROM0[$328f]
LoadItemsList:
  push af
  ld a, BANK(ItemsList)
  ld [$2000], a
  pop af
  ld hl, ItemsList - $10
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
  rst $8 ; SetInitialName
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