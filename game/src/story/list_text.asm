; Includes logic for dealing with "list" text (Medals, Items)
SECTION "Medals Data", ROMX[$4000], BANK[$2E]
MedalList:
  INCBIN "build/lists/Medals.bin"

SECTION "Load Medals", ROM0[$32b9]
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
  ld b, cBUF01Size-$1
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