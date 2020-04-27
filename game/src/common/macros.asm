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

dbww: MACRO
  db \1
  dw \2
  dw \3
  ENDM

psbc: MACRO
  ld bc, (((\2&$FF)*$100)+((((\1-$20)>>1)&$F0)+((\1-1)&$F)))
  ENDM

psa: MACRO
  ld a, ((((\1-$20)>>1)&$F0)+((\1-1)&$F))
  ENDM
