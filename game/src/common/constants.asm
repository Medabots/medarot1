INCLUDE "build/buffer_constants.asm"

hRegJoyp           EQU $ff00
hRegSB             EQU $ff01
hRegSC             EQU $ff02
hRegIF             EQU $ff0f
hRegNR10           EQU $ff10
hRegNR11           EQU $ff11
hRegNR12           EQU $ff12
hRegNR13           EQU $ff13
hRegNR14           EQU $ff14
hRegNR21           EQU $ff16
hRegNR22           EQU $ff17
hRegNR23           EQU $ff18
hRegNR24           EQU $ff19
hRegNR30           EQU $ff1a
hRegNR31           EQU $ff1b
hRegNR32           EQU $ff1c
hRegNR33           EQU $ff1d
hRegNR34           EQU $ff1e
hRegNR41           EQU $ff20
hRegNR42           EQU $ff21
hRegNR43           EQU $ff22
hRegNR44           EQU $ff23
hRegNR50           EQU $ff24
hRegNR51           EQU $ff25
hRegNR52           EQU $ff26
hRegLCDC           EQU $ff40
hLCDStat           EQU $ff41
hRegSCY            EQU $ff42
hRegSCX            EQU $ff43
hRegLY             EQU $ff44
hRegLYC            EQU $ff45
hRegDMA            EQU $ff46
hRegBGP            EQU $ff47
hRegOBP0           EQU $ff48
hRegOBP1           EQU $ff49
hRegWY             EQU $ff4a
hRegWX             EQU $ff4b
hRegKEY1           EQU $ff4d
hRegVBK            EQU $ff4f
hRegRP             EQU $ff56
hRegBGPI           EQU $ff68
hRegBGPD           EQU $ff69
hRegOBPI           EQU $ff6a
hRegOBPD           EQU $ff6b
hRegSVBK           EQU $ff70
hRegIE             EQU $ffff

hPushOAM           EQU $ff80

hBuffer            EQU $ff8b

hRTCDayHi          EQU $ff8d
hRTCDayLo          EQU $ff8e
hRTCHours          EQU $ff8f
hRTCMinutes        EQU $ff90
hRTCSeconds        EQU $ff91

hHours             EQU $ff94

hMinutes           EQU $ff96

hSeconds           EQU $ff98

hROMBank           EQU $ff9d

hJoypadReleased    EQU $ffa2
hJoypadPressed     EQU $ffa3
hJoypadDown        EQU $ffa4
hJoypadSum         EQU $ffa5
hJoyReleased       EQU $ffa6
hJoyPressed        EQU $ffa7
hJoyDown           EQU $ffa8

hPastLeadingZeroes EQU $ffb3

hDividend          EQU $ffb3
hDivisor           EQU $ffb7
hQuotient          EQU $ffb4

hMultiplicand      EQU $ffb4
hMultiplier        EQU $ffb7
hProduct           EQU $ffb3

hMathBuffer        EQU $ffb8

hLCDStatCustom     EQU $ffc6

hBGMapMode         EQU $ffd4
hBGMapThird        EQU $ffd5
hBGMapAddress      EQU $ffd6

hOAMUpdate         EQU $ffd8
hSPBuffer          EQU $ffd9

hBGMapUpdate       EQU $ffdb

hTileAnimFrame     EQU $ffdf

hRandomAdd         EQU $ffe1
hRandomSub         EQU $ffe2

hBattleTurn        EQU $ffe4
hCGBPalUpdate      EQU $ffe5
hCGB               EQU $ffe6
hSGB               EQU $ffe7
hDMATransfer       EQU $ffe8

; Joypad
hJPInputHeldDown   EQU $ff8c
hJPInputChanged    EQU $ff8d

hJPInputA          EQU $1
hJPInputB          EQU $2
hJPInputSelect     EQU $4
hJPInputStart      EQU $8
hJPInputRight      EQU $10
hJPInputLeft       EQU $20
hJPInputUp         EQU $40
hJPInputDown       EQU $80

; For SGB Tilemaps.
P4 EQU $1000
P5 EQU $1400
P6 EQU $1800
