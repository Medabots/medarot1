INCLUDE "game/src/common/macros.asm"

SECTION "Location names", ROMX[$7c25], BANK[$1]
LocationsPtr::
INCLUDE "build/ptrlists/Locations.asm"

; Expect 'hl' to be correct
DrawLocationsVWF::
  ld a, $10 ; 16 characters
  push hl
  call VWFPadText
  pop hl
  ld a, $10
  psbc $9842, $be
  call VWFPutString
  ret