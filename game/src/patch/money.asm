SECTION "Map Price With Yen Symbol", ROM0[$79]
MapMoneyWithYenSymbol::
  dec c
  di
  call WaitLCDController
  xor a
  ld [bc], a
  ei
  inc c
  call JumpTable_1ec
  push bc
  inc c
  inc c

.loop
  di
  call WaitLCDController
  ld a, [bc]
  ei
  dec c
  jr z, .exit
  or a
  jr nz, .loop
  inc c
  di
  call WaitLCDController
  ld a, $7C
  ld [bc], a
  ei

.exit
  pop bc
  ret
