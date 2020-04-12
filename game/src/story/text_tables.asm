SECTION "Pointers", ROMX[$4000], BANK[$25]
Snippet1:
  INCBIN "build/Snippet1.bin"
Snippet2:
  INCBIN "build/Snippet2.bin"
Snippet3:
  INCBIN "build/Snippet3.bin"
Snippet4:
  INCBIN "build/Snippet4.bin"
Snippet5:
  INCBIN "build/Snippet5.bin"
StoryText1:
  INCBIN "build/StoryText1.bin"
StoryText2:
  INCBIN "build/StoryText2.bin"
StoryText3:
  INCBIN "build/StoryText3.bin"
BattleText:
  INCBIN "build/BattleText.bin"

SECTION "FREE_TEXT0", ROMX[$4000], BANK[$26]
FREE_TEXT0:
  INCBIN "build/FREE_TEXT0.bin"

SECTION "FREE_TEXT1", ROMX[$4000], BANK[$27]
FREE_TEXT1:
  INCBIN "build/FREE_TEXT1.bin"

SECTION "FREE_TEXT2", ROMX[$4000], BANK[$28]
FREE_TEXT2:
  INCBIN "build/FREE_TEXT2.bin"

SECTION "FREE_TEXT3", ROMX[$4000], BANK[$29]
FREE_TEXT3:
  INCBIN "build/FREE_TEXT3.bin"

SECTION "FREE_TEXT4", ROMX[$4000], BANK[$2a]
FREE_TEXT4:
  INCBIN "build/FREE_TEXT4.bin"



SECTION "Dialog Text Tables", ROM0[$1d3b]
TextTableBanks: ; 0x1d3b
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

TextTableOffsets: ; 0x1d4b
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
