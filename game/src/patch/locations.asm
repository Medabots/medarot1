INCLUDE "game/src/common/macros.asm"

SECTION "Location names", ROMX[$7c25], BANK[$1]
LocationsPtr::
INCLUDE "build/ptrlists/Locations.asm"

; Expect 'hl' to be correct
DrawLocationsVWF::
  ld a, $10
  push hl
  call VWFPadText
  pop hl
  ld a, [VWFCurrentFont]
  cp 1
  jr nz, .notNarrow
  ld a, $10
  push hl
  call VWFPadText
  pop hl
.notNarrow
  ld a, $10
  psbc $9842, $be
  call VWFPutString
  ret