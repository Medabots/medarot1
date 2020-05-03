SECTION "State Machine Indexes", WRAM0[$C5C0]
CoreStateIndex:: ds 1
CoreSubStateIndex:: ds 1

SECTION "Increment Substate Index", ROM0[$17C3]
IncSubStateIndex::
  ld a, [CoreSubStateIndex]
  inc a
  ld [CoreSubStateIndex], a
  ret