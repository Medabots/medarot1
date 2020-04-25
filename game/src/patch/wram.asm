SECTION "VWF Variables", WRAMX[$DC00], BANK[$1]
VWFTilesDrawn:: ds 1
VWFCurrentLetter:: ds 1
VWFControlCodeArguments:: ds 2
VWFLetterCountBuffer:: ds 9
VWFCompositeAreaAddress:: ds 2
VWFLetterShift:: ds 1
VWFOldTileMode:: ds 1
VWFTileBaseIdx:: ds 1
VWFIsInit:: ds 1
VWFIsSecondLine:: ds 1
VWFTrackBank:: ds 1
VWFTextLength:: ds 1
VWFNextWordLength:: ds 1

SECTION "VWF Composite Area", WRAMX[$DCD0], BANK[$1]
VWFCompositeArea:: ds $30

SECTION "User Globals (hack)", WRAMX[$DEA0], BANK[$1] ; for DMG doesn't really matter, but rgbds needs it for overlay
TempA::
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