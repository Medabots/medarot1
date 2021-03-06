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

pshl: MACRO
  ld hl, (((\2&$FF)*$100)+((((\1-$20)>>1)&$F0)+((\1-1)&$F)))
  ENDM

psa: MACRO
  ld a, ((((\1-$20)>>1)&$F0)+((\1-1)&$F))
  ENDM

psc: MACRO
  ld c, ((((\1-$20)>>1)&$F0)+((\1-1)&$F))
  ENDM
  
atfline: MACRO
  db ((((\1 % 10000) / 1000) % 4) << 6) + ((((\1 % 1000) / 100) % 4) << 4) + ((((\1 % 100) / 10) % 4) << 2) + ((\1 % 10) % 4)
  db ((((\2 % 10000) / 1000) % 4) << 6) + ((((\2 % 1000) / 100) % 4) << 4) + ((((\2 % 100) / 10) % 4) << 2) + ((\2 % 10) % 4)
  db ((((\3 % 10000) / 1000) % 4) << 6) + ((((\3 % 1000) / 100) % 4) << 4) + ((((\3 % 100) / 10) % 4) << 2) + ((\3 % 10) % 4)
  db ((((\4 % 10000) / 1000) % 4) << 6) + ((((\4 % 1000) / 100) % 4) << 4) + ((((\4 % 100) / 10) % 4) << 2) + ((\4 % 10) % 4)
  db ((((\5 % 10000) / 1000) % 4) << 6) + ((((\5 % 1000) / 100) % 4) << 4) + ((((\5 % 100) / 10) % 4) << 2) + ((\5 % 10) % 4)
  ENDM

Load1BPPTilesetLocal: MACRO
  ld hl, \1
  ld de, \2
  ld b, (\3 - \2) / $8
  call Load1BPPTiles
  ENDM

Load1BPPTileset: MACRO
  ld hl, \1
  ld de, \2
  ld b, (\3 - \2) / $8
  call Load1BPPTilesFrom2D
  ENDM
