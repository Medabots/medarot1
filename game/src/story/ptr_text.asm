; For text in tables with pointers (except Dialog Text and Tilemaps which are handled separately)
SECTION "Part Names", ROMX[$750b], BANK[$1]
PartTypesPtr::
INCLUDE "build/ptrlists/PartTypes.asm"

SECTION "Pointer Lists", ROMX[$4000], BANK[$2d]
PartDescriptionsPtr::
INCLUDE "build/ptrlists/PartDescriptions.asm"
AttributesPtr::
INCLUDE "build/ptrlists/Attributes.asm"
SkillsPtr::
INCLUDE "build/ptrlists/Skills.asm"
MedarottersPtr::
INCLUDE "build/ptrlists/Medarotters.asm"

SECTION "Attacks", ROMX[$76d2], BANK[$17]
AttacksPtr::
INCLUDE "build/ptrlists/Attacks.asm"

SECTION "Load Part Type", ROMX[$74eb], BANK[$1]
LoadPartType:
  push hl
  push de
  push bc
  ld hl, PartTypesPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld de, cBUF02
  ld b, $9 ; What's the point of the pointer table if you're going to use fixed lengths anyway?
.asm_7501
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_7501 ; 0x7505 $fa
  pop bc
  pop de
  pop hl
  ret
; 0x750b
