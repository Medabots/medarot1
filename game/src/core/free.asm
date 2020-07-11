; Sections of nops
SECTION "Free3", ROM0[$CD]
REPT $33
  nop
ENDR

; Free space at the end of banks
SECTION "BANK01_END", ROMX[$7d6f], BANK[$1]
BANK01_END::
REPT $8000 - BANK01_END
  db 0
ENDR

SECTION "BANK02_END", ROMX[$7ff5], BANK[$2]
BANK02_END::
REPT $8000 - BANK02_END
  db 0
ENDR

SECTION "BANK03_END", ROMX[$7f6c], BANK[$3]
BANK03_END::
REPT $8000 - BANK03_END
  db 0
ENDR

SECTION "BANK04_END", ROMX[$7977], BANK[$4]
BANK04_END::
REPT $8000 - BANK04_END
  db 0
ENDR

SECTION "BANK05_END", ROMX[$7f82], BANK[$5]
BANK05_END::
REPT $8000 - BANK05_END
  db 0
ENDR

SECTION "BANK06_END", ROMX[$7925], BANK[$6]
BANK06_END::
REPT $8000 - BANK06_END
  db 0
ENDR

SECTION "BANK07_END", ROMX[$7240], BANK[$7]
BANK07_END::
REPT $8000 - BANK07_END
  db 0
ENDR

SECTION "BANK08_END", ROMX[$7e36], BANK[$8]
BANK08_END::
REPT $8000 - BANK08_END
  db 0
ENDR

SECTION "BANK09_END", ROMX[$7fb4], BANK[$9]
BANK09_END::
REPT $8000 - BANK09_END
  db 0
ENDR

SECTION "BANK0A_END", ROMX[$7a86], BANK[$a]
BANK0A_END::
REPT $8000 - BANK0A_END
  db 0
ENDR

SECTION "BANK0B_END", ROMX[$785e], BANK[$b]
BANK0B_END::
REPT $8000 - BANK0B_END
  db 0
ENDR

SECTION "BANK0C_END", ROMX[$7ff9], BANK[$c]
BANK0C_END::
REPT $8000 - BANK0C_END
  db 0
ENDR

SECTION "BANK0D_END", ROMX[$7fea], BANK[$d]
BANK0D_END::
REPT $8000 - BANK0D_END
  db 0
ENDR

SECTION "BANK0E_END", ROMX[$7fa8], BANK[$e]
BANK0E_END::
REPT $8000 - BANK0E_END
  db 0
ENDR

SECTION "BANK0F_END", ROMX[$7f38], BANK[$f]
BANK0F_END::
REPT $8000 - BANK0F_END
  db 0
ENDR

SECTION "BANK10_END", ROMX[$7873], BANK[$10]
BANK10_END::
REPT $8000 - BANK10_END
  db 0
ENDR

SECTION "BANK11_END", ROMX[$7f52], BANK[$11]
BANK11_END::
REPT $8000 - BANK11_END
  db 0
ENDR

SECTION "BANK12_END", ROMX[$72c3], BANK[$12]
BANK12_END::
REPT $8000 - BANK12_END
  db 0
ENDR

SECTION "BANK13_END", ROMX[$79a5], BANK[$13]
BANK13_END::
REPT $8000 - BANK13_END
  db 0
ENDR

; Bank 14 is used entirely for the robattle portraits and background graphics

SECTION "BANK15_END", ROMX[$7f19], BANK[$15]
BANK15_END::
REPT $8000 - BANK15_END
  db 0
ENDR

;SECTION "BANK16_END", ROMX[$7d00], BANK[$16]
;BANK16_END::
;REPT $8000 - BANK16_END
;  db 0
;ENDR

SECTION "BANK17_END", ROMX[$7753], BANK[$17]
BANK17_END::
REPT $8000 - BANK17_END
  db 0
ENDR

SECTION "BANK18_END", ROMX[$7fb3], BANK[$18]
BANK18_END::
REPT $8000 - BANK18_END
  db 0
ENDR

SECTION "BANK19_END", ROMX[$7fc0], BANK[$19]
BANK19_END::
REPT $8000 - BANK19_END
  db 0
ENDR

SECTION "BANK1A_END", ROMX[$7fc4], BANK[$1a]
BANK1A_END::
REPT $8000 - BANK1A_END
  db 0
ENDR

SECTION "BANK1B_END", ROMX[$781f], BANK[$1b]
BANK1B_END::
REPT $8000 - BANK1B_END
  db 0
ENDR

SECTION "BANK1C_END", ROMX[$74cc], BANK[$1c]
BANK1C_END::
REPT $8000 - BANK1C_END
  db 0
ENDR

SECTION "BANK1D_END", ROMX[$76d3], BANK[$1d]
BANK1D_END::
REPT $8000 - BANK1D_END
  db 0
ENDR

SECTION "BANK1E_END", ROMX[$73f4], BANK[$1e]
BANK1E_END::
REPT $8000 - BANK1E_END
  db 0
ENDR

SECTION "BANK1F_END", ROMX[$729E], BANK[$1f]
BANK1F_END::
REPT $8000 - BANK1F_END
  db 0
ENDR