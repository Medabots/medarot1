SECTION "List Data", ROMX[$4000], BANK[$2c]
ItemList:
  INCBIN "build/lists/Items_{GAMEVERSION}.bin"
MedalList:
  INCBIN "build/lists/Medals_{GAMEVERSION}.bin"
MedarotList:
  INCBIN "build/lists/Medarots_{GAMEVERSION}.bin"
PartList:
HeadPartList:
  INCBIN "build/lists/HeadParts_{GAMEVERSION}.bin"
RightPartList:
  INCBIN "build/lists/RightParts_{GAMEVERSION}.bin"
LeftPartList:
  INCBIN "build/lists/LeftParts_{GAMEVERSION}.bin"
LegPartList:
  INCBIN "build/lists/LegParts_{GAMEVERSION}.bin"