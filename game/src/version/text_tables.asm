SECTION "Snippet1", ROMX[$7e00], BANK[$0c]
Snippet1:
  INCBIN "build/Snippet1_{GAMEVERSION}.bin"

SECTION "Snippet2", ROMX[$7e00], BANK[$0d]
Snippet2:
  INCBIN "build/Snippet2_{GAMEVERSION}.bin"

SECTION "Snippet3", ROMX[$7e00], BANK[$0e]
Snippet3:
  INCBIN "build/Snippet3_{GAMEVERSION}.bin"

SECTION "Snippet4", ROMX[$7e00], BANK[$0f]
Snippet4:
  INCBIN "build/Snippet4_{GAMEVERSION}.bin"

SECTION "Snippet5", ROMX[$7800], BANK[$13]
Snippet5:
  INCBIN "build/Snippet5_{GAMEVERSION}.bin"

SECTION "StoryText1", ROMX[$6000], BANK[$16]
StoryText1:
  INCBIN "build/StoryText1_{GAMEVERSION}.bin"

SECTION "StoryText2", ROMX[$4000], BANK[$18]
StoryText2:
  INCBIN "build/StoryText2_{GAMEVERSION}.bin"

SECTION "StoryText3", ROMX[$4000], BANK[$1a]
StoryText3: ; FIXME: StoryText3 has some data between text that causes trouble when rebuilding... (between 0x682b6 and 0x682b8)
  ;INCBIN "build/StoryText3_{GAMEVERSION}.bin"

SECTION "BattleText", ROMX[$4000], BANK[$1d]
BattleText:
  INCBIN "build/BattleText_{GAMEVERSION}.bin"


SECTION "Dialog Text Tables", ROM0[$1d3b]
TextTableBanks:: ; 0x1d3b
  db BANK(Snippet1) ;Snippet 1
  db BANK(Snippet2) ;Snippet 2
  db BANK(Snippet3) ;Snippet 3
  db BANK(Snippet4) ;Snippet 4
  db BANK(StoryText1) ;StoryText 1
  db BANK(Snippet5) ;Snippet 5
  db $00
  db $00
  db BANK(StoryText2) ;Story Text 2
  db $00
  db BANK(StoryText3) ;Story Text 3
  db $00
  db $00
  db BANK(BattleText) ;Battle Text
  db $00
  db $00

TextTableOffsets:: ; 0x1d4b
  dw Snippet1 ;Snippet 1
  dw Snippet2 ;Snippet 2
  dw Snippet3 ;Snippet 3
  dw Snippet4 ;Snippet 4
  dw StoryText1 ;Story Text 1
  dw Snippet5 ;Snippet 5
  dw $4000
  dw $4000
  dw StoryText2 ;Story Text 2
  dw $4000
  dw StoryText3 ;Story Text 3
  dw $4000
  dw $4000
  dw BattleText ;Battle Text
  dw $4000
  dw $4000
