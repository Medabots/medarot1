SECTION "List Data", ROMX[$5af0], BANK[$17]
ItemList::
  INCBIN "build/lists/Items_{GAMEVERSION}.bin"
MedalList::
  INCBIN "build/lists/Medals_{GAMEVERSION}.bin"

SECTION "Medarot List Data", ROMX[$6c36], BANK[$17]
MedarotList::
  INCBIN "build/lists/Medarots_{GAMEVERSION}.bin"

SECTION "Part List Data", ROMX[$65cc], BANK[$1c]
PartList::
HeadPartList::
  INCBIN "build/lists/HeadParts_{GAMEVERSION}.bin"
RightPartList::
  INCBIN "build/lists/RightParts_{GAMEVERSION}.bin"
LeftPartList::
  INCBIN "build/lists/LeftParts_{GAMEVERSION}.bin"
LegPartList::
  INCBIN "build/lists/LegParts_{GAMEVERSION}.bin"

SECTION "Part Names", ROMX[$750b], BANK[$1]
PartTypesPtr::
INCLUDE "build/ptrlists/PartTypes_{GAMEVERSION}.asm"

SECTION "Attributes", ROMX[$7f03], BANK[$2]
AttributesPtr::
INCLUDE "build/ptrlists/Attributes_{GAMEVERSION}.asm"

SECTION "Part Descriptions", ROMX[$7234], BANK[$1f]
PartDescriptionsPtr::
INCLUDE "build/ptrlists/PartDescriptions_{GAMEVERSION}.asm"

SECTION "Skill", ROMX[$7fc0], BANK[$2]
SkillsPtr::
INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"

SECTION "Attacks", ROMX[$76d2], BANK[$17]
AttacksPtr::
INCLUDE "build/ptrlists/Attacks_{GAMEVERSION}.asm"

SECTION "Medarotters", ROMX[$64e6], BANK[$17]
MedarottersPtr::
INCLUDE "build/ptrlists/Medarotters_{GAMEVERSION}.asm"

; They actually maintain a separate copy of all the skills in 1B
SECTION "Skills_1B", ROMX[$7019], BANK[$1b]
SkillsPtr_1B::
INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"