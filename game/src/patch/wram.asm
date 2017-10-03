SECTION "User Globals (hack)", WRAMX[$DEA0], BANK[$1] ; for DMG doesn't really matter, but rgbds needs it for overlay
TempA::
  ds 1
BankOld::
  ds 1
TempH::
  ds 1
TempL::
  ds 1
WTextOffsetHi::
  ds 1
FlagClearText::
  ds 1
CurrentWordLen::
  ds 1
FlagNewLine::
  ds 1
NextChar::
  ds 1
TmpChar::
  ds 1
FlagDo4C::
  ds 1