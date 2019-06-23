;Table that contains pointer to {Bank:db, Addr:dw, Unk (maybe size):dw} structure
;Probably actually just contains a bunch of pointers to raw data
SECTION "Font Table", ROM0[$10f0]
FontTable:
  dw $1156
  dw $115b
  dw $1160 ; Special characters in font (!, heart symbol, yen, etc...)
  dw $1165 ; Main dialogue font {08, 4168}
  dw $1156
  dw $116a
  dw $116f
  dw $1174
  dw $1179
  dw $117e
  dw $1188 ; Loaded in Medarot Menu
  dw $118d
  dw $1192
  dw $1197
  dw $119c
  dw $11a1
  dw $11a6
  dw $11ab
  dw $11b0
  dw $11b5
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ab
  dw $11ba
  dw $11bf
  dw $11c4
  dw $11c9
  dw $11ce
  dw $11d3
  dw $11d8
  dw $11dd
  dw $11e2
  dw $11e7
  dw $11ec
  dw $11f1
  dw $11f6
  dw $11fb
  dw $1200
  dw $1205
  dw $120a
  dw $120f
  dw $1183

SECTION "Font Table Data", ROM0[$1156]
  dbww $08,$59c5,$8800
  dbww $08,$58dd,$9500
  dbww BANK(Tileset02), Tileset02, $9000
  dbww BANK(Tileset03), Tileset03, $8800

SECTION "Font Table Data 0A", ROM0[$1188] ; For Menu text
  dbww BANK(Tileset0A), Tileset0A, $8800
  dbww BANK(Tileset0B), Tileset0B, $8000
  dbww BANK(Tileset0C), Tileset0C, $9400
