; Fill this with the giant jump table and wrapper functions, eventually should only be 2 sections (JumpTable and Wrappers)
SECTION "JumpTable_0", ROM0[$01E3]
JumpLoadItemList:: jp WrapLoadItemList

SECTION "JumpTable_1", ROM0[$0264]
JumpPutString:: jp WrapPutString

SECTION "JumpTable_2", ROM0[$028e]
JumpPadTextTo8:: jp WrapPadTextTo8

SECTION "JumpTable_3", ROM0[$02a6]
JumpRobattleSetupMedarotSelect:: jp WrapRobattleSetupMedarotSelect

SECTION "Increment Substate Index Wrapper Wrapper", ROM0[$0168]
IncSubStateIndexWrapperWrapper::
  jp IncSubStateIndexWrapper

SECTION "Increment Substate Index Wrapper", ROM0[$05B4]
IncSubStateIndexWrapper::
  jp IncSubStateIndex

SECTION "Wrappers_0", ROM0[$0660]
WrapLoadItemList:
  call LoadItemList
  rst $18
  ret

SECTION "Wrappers_1", ROM0[$072c]
WrapPutString:
  call PutString
  ret

SECTION "Wrappers_2", ROM0[$0784]
WrapPadTextTo8:
  call PadTextTo8
  ret

SECTION "Wrappers_3", ROM0[$07eb]
WrapRobattleSetupMedarotSelect:
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $2
  rst $10
  ld [$c6e0], a
  pop af
  call RobattleSetupMedarotSelect
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop

SECTION "Wrappers_4", ROM0[$090a]
WrapLoadMedarotPartSelectSetupPartScreen:
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $2
  rst $10
  ld [$c6e0], a
  pop af
  call LoadMedarotPartSelectSetupPartScreen
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x925
