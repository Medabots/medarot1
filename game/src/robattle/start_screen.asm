INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "Robattle Portraits", ROMX[$4000], BANK[$14]
RobattleImages::
RobattlePortraits::
  INCLUDE "game/src/story/include/robattle_portraits.asm"
RobattleBackgrounds::
  INCLUDE "game/src/story/include/robattle_backgrounds.asm"

SECTION "Load Player Portrait", ROM0[$2e3f]
LoadPlayerPortrait: ; 2e3f (0:2e3f)
  ld a, BANK(RobattleImages)
  rst $10
  ld hl, RobattleImages
  ld de, $9010
  ld bc, $100
  call CopyVRAMData
  ld a, [$c740]
  inc a
  ld [$c740], a
  ret
; 0x2e58

SECTION "Robattles Start Screen", ROM0[$2e58]
LoadRobattleStartScreenMedarotter:
  ld a, BANK(MedarottersPtr)
  rst $10
  ld a, [$c753]
  ld hl, MedarottersPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hl]
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
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld a, BANK(RobattleImages)
  rst $10
  ld hl, RobattleImages
  add hl, bc
  ld de, $9110
  ld bc, $0100
  call CopyVRAMData
  ld a, [$c740]
  inc a
  ld [$c740], a
  xor a
  ld [$c741], a
  ret
  nop
  nop
; 0x2eb0

SECTION "Robattles Start Screen - Name", ROM0[$2f2f]
LoadRobattleNames:
  ld hl, cNAME
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $9841, $be
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ld a, BANK(MedarottersPtr)
  rst $10
  ld a, [$c753]
  ld hl, MedarottersPtr
  ld b, $0
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc hl
  ld a, [hli]
  push hl
  push af
  ld a, [$c74e]
  ld hl, $d0c0
  ld b, $0
  ld c, a
  ld a, $6
  call GetListTextOffset
  ld b, $0
  pop af
  ld c, a
  add hl, bc
  ld a, h
  ld [$c754], a
  ld a, l
  ld [$c755], a
  pop hl
  ld a, [hli]
  ld [$c76b], a
  ld a, [$c776]
  or a
  jr nz, .asm_2f95 ; 0x2f81 $12
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $984b, $c6
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ret
.asm_2f95
  ld hl, $c778
  push hl
  call VWFPadTextTo8
  ld h, $0
  ld l, a
  psbc $984b, $c6
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call VWFPutStringTo8
  ret
  nop
  nop
; 0x2faa