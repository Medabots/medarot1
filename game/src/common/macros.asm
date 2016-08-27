; macro for putting a byte then a word
dbw: MACRO
	db \1
	dw \2
	ENDM

; macro for putting a word then a byte
dwb: MACRO
	dw \1
	db \2
	ENDM
