; For text in tables with pointers (except Dialog Text and Tilemaps which are handled separately)
SECTION "Part Names", ROMX[$750b], BANK[$1]
PartTypesPtr:
INCLUDE "build/ptrlists/PartTypes.asm"

SECTION "Attributes", ROMX[$7f03], BANK[$2]
AttributesPtr:
INCLUDE "build/ptrlists/Attributes.asm"

SECTION "Part Descriptions", ROMX[$7234], BANK[$1f]
PartDescriptionsPtr:
INCLUDE "build/ptrlists/PartDescriptions.asm"

SECTION "Skill", ROMX[$7fc0], BANK[$2]
SkillsPtr:
INCLUDE "build/ptrlists/Skills.asm"

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
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $9941
  call $0264
  ret
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
  ld bc, $9a01
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
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $99c1
  call $0264
  ret
; 0xa7d1