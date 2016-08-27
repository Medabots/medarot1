SECTION "Dialog Text Tables", ROM0[$1d3b]
TextTableBanks: ; 0x1d3b
    db $0c ;Snippet 1
    db $0d ;Snippet 2
    db $0e ;Snippet 3
    db $0f ;Snippet 4
    db $16 ;StoryText 1
    db $13 ;Snippet 5
    db $00
    db $00
    db $18 ;Story Text 2
    db $00
    db $1a ;Story Text 3
    db $00
    db $00
    db $1d ;Battle Text
    db $00
    db $00

TextTableOffsets: ; 0x1d4b
    dw $7e00 ;Snippet 1
    dw $7e00 ;Snippet 2
    dw $7e00 ;Snippet 3
    dw $7e00 ;Snippet 4
    dw $6000 ;Story Text 1
    dw $7800 ;Snippet 5
    dw $4000
    dw $4000
    dw $4000 ;Story Text 2
    dw $4000
    dw $4000 ;Story Text 3
    dw $4000
    dw $4000
    dw $4000 ;Battle Text
    dw $4000
    dw $4000
