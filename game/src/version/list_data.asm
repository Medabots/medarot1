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