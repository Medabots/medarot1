SECTION "List Data", ROMX[$4000], BANK[$2c]
ItemList::
  INCBIN "build/lists/Items_{GAMEVERSION}.bin"
MedalList::
  INCBIN "build/lists/Medals_{GAMEVERSION}.bin"
MedarotList::
  INCBIN "build/lists/Medarots_{GAMEVERSION}.bin"
PartList::
HeadPartList::
  INCBIN "build/lists/HeadParts_{GAMEVERSION}.bin"
RightPartList::
  INCBIN "build/lists/RightParts_{GAMEVERSION}.bin"
LeftPartList::
  INCBIN "build/lists/LeftParts_{GAMEVERSION}.bin"
LegPartList::
  INCBIN "build/lists/LegParts_{GAMEVERSION}.bin"

; Pointer lists
AttributesPtr::
INCLUDE "build/ptrlists/Attributes_{GAMEVERSION}.asm"
PartDescriptionsPtr::
INCLUDE "build/ptrlists/PartDescriptions_{GAMEVERSION}.asm"
SkillsPtr::
INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"
AttacksPtr::
INCLUDE "build/ptrlists/Attacks_{GAMEVERSION}.asm"
MedarottersPtr::
INCLUDE "build/ptrlists/Medarotters_{GAMEVERSION}.asm"

SECTION "Part Names", ROMX[$750b], BANK[$1]
PartTypesPtr::
INCLUDE "build/ptrlists/PartTypes_{GAMEVERSION}.asm"

; They actually maintain a separate copy of all the skills in 1B
;SECTION "Skills_1B", ROMX[$7019], BANK[$1b]
;SkillsPtr_1B::
;INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"
