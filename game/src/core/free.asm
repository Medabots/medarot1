; Sections of nops

SECTION "Free1", ROM0[$E]
db 0, 0

SECTION "Free2", ROM0[$16]
db 0, 0

SECTION "Free3", ROM0[$A7]
REPT $59
	nop
ENDR