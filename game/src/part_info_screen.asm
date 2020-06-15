INCLUDE "game/src/common/constants.asm"

SECTION "Load Part Info", ROMX[$6753], BANK[$2]
LoadPartInfo:
  call $670e
  ld a, [$c727]
  ld c, a
  ld a, [hl]
  and $7f
  ld b, $0
  call JumpTable_294
  ld hl, cBUF01
  call JumpPadTextTo8
  ld h, $0
  ld l, a
  ld bc, $9901
  add hl, bc
  ld b, h
  ld c, l
  ld hl, cBUF01
  call JumpPutString
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
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $9941
  call JumpPutString
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
  call JumpPutString
  ret
; 0xa7d1