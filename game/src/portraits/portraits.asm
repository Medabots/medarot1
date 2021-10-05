SECTION "Portraits 0-63", ROMX[$4000], BANK[$2E]
TilesetPortraits1::
  INCLUDE "game/src/portraits/include/portraits_1.asm"

SECTION "Portraits 64-113", ROMX[$4000], BANK[$2F]
TilesetPortraits2::
  INCLUDE "game/src/portraits/include/portraits_2.asm"

; Actual portrait functionality is in version/portraits.asm, which allows for the use of IF DEF(FEATURE_PORTRAITS)