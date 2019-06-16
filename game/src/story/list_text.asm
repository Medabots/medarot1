; Includes logic for dealing with "list" text (Medals, Items)
SECTION "Medals Data", ROMX[$5d50], BANK[$17]
MedalList:
  INCBIN "build/lists/Medals.bin"

SECTION "Load Medals", ROM0[$32b9]
LoadMedalList: ;4a9f
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $5d50
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

