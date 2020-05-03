; Fill this with the giant jump table and wrapper functions, eventually should only be 2 sections (JumpTable and Wrappers)
SECTION "Increment Substate Index Wrapper Wrapper", ROM0[$0168]
IncSubStateIndexWrapperWrapper:: jp IncSubStateIndexWrapper

SECTION "JumpTable_0", ROM0[$01E3]
JumpLoadItemList:: jp WrapLoadItemList

SECTION "JumpTable_1", ROM0[$0264]
JumpPutString:: jp WrapPutString

SECTION "JumpTable_2", ROM0[$028e]
JumpPadTextTo8:: jp WrapPadTextTo8

SECTION "JumpTable_3", ROM0[$02a6]
JumpRobattleSetupMedarotSelect:: jp WrapRobattleSetupMedarotSelect

SECTION "JumpTable_4", ROM0[$02b8]
JumpGetListTextOffset:: jp WrapGetListTextOffset

SECTION "Increment Substate Index Wrapper", ROM0[$05B4]
IncSubStateIndexWrapper:: jp IncSubStateIndex

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
  ld [$2000], a
  ld [$c6e0], a
  pop af
  call RobattleSetupMedarotSelect
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret

SECTION "Wrappers_4", ROM0[$086f]
WrapGetListTextOffset:
  call GetListTextOffset
  ret

SECTION "Wrappers_5", ROM0[$090a]
WrapLoadMedarotPartSelectSetupPartScreen:
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $2
  ld [$2000], a
  ld [$c6e0], a
  pop af
  call LoadMedarotPartSelectSetupPartScreen
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
; 0x925

SECTION "Wrappers_6", ROM0[$0b0d]
WrapRobattleSetupPrepScreenCopy: ; Calls the robattle name setup in the middle of a robattle (also copy in bank $4)
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  ld [$2000], a
  ld [$c6e0], a
  call $6b3f ; Calls RobattleLoadMedarotNamesCopy
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
; 0xb26