; Fill this with the giant jump table and wrapper functions, eventually should only be 2 sections (JumpTable and Wrappers)
SECTION "JumpTable_0", ROM0[$0264]
JumpPutString:: jp WrapPutString

SECTION "JumpTable_1", ROM0[$028e]
JumpPadTextTo8:: jp WrapPadTextTo8

SECTION "Wrappers_0", ROM0[$072c]
WrapPutString:
	call PutString
	ret

SECTION "Wrappers_1", ROM0[$0784]
WrapPadTextTo8:
	call PadTextTo8
	ret