INCLUDE "build/buffer_constants.asm"

DEF    hRegJoyp           EQU $ff00
DEF    hRegSB             EQU $ff01
DEF    hRegSC             EQU $ff02
DEF    hRegIF             EQU $ff0f
DEF    hRegNR10           EQU $ff10
DEF    hRegNR11           EQU $ff11
DEF    hRegNR12           EQU $ff12
DEF    hRegNR13           EQU $ff13
DEF    hRegNR14           EQU $ff14
DEF    hRegNR21           EQU $ff16
DEF    hRegNR22           EQU $ff17
DEF    hRegNR23           EQU $ff18
DEF    hRegNR24           EQU $ff19
DEF    hRegNR30           EQU $ff1a
DEF    hRegNR31           EQU $ff1b
DEF    hRegNR32           EQU $ff1c
DEF    hRegNR33           EQU $ff1d
DEF    hRegNR34           EQU $ff1e
DEF    hRegNR41           EQU $ff20
DEF    hRegNR42           EQU $ff21
DEF    hRegNR43           EQU $ff22
DEF    hRegNR44           EQU $ff23
DEF    hRegNR50           EQU $ff24
DEF    hRegNR51           EQU $ff25
DEF    hRegNR52           EQU $ff26
DEF    hRegLCDC           EQU $ff40
DEF    hLCDStat           EQU $ff41
DEF    hRegSCY            EQU $ff42
DEF    hRegSCX            EQU $ff43
DEF    hRegLY             EQU $ff44
DEF    hRegLYC            EQU $ff45
DEF    hRegDMA            EQU $ff46
DEF    hRegBGP            EQU $ff47
DEF    hRegOBP0           EQU $ff48
DEF    hRegOBP1           EQU $ff49
DEF    hRegWY             EQU $ff4a
DEF    hRegWX             EQU $ff4b
DEF    hRegKEY1           EQU $ff4d
DEF    hRegVBK            EQU $ff4f
DEF    hRegRP             EQU $ff56
DEF    hRegBGPI           EQU $ff68
DEF    hRegBGPD           EQU $ff69
DEF    hRegOBPI           EQU $ff6a
DEF    hRegOBPD           EQU $ff6b
DEF    hRegSVBK           EQU $ff70
DEF    hRegIE             EQU $ffff

DEF    hPushOAM           EQU $ff80

DEF    hBuffer            EQU $ff8b

DEF    hRTCDayHi          EQU $ff8d
DEF    hRTCDayLo          EQU $ff8e
DEF    hRTCHours          EQU $ff8f
DEF    hRTCMinutes        EQU $ff90
DEF    hRTCSeconds        EQU $ff91

DEF    hHours             EQU $ff94

DEF    hMinutes           EQU $ff96

DEF    hSeconds           EQU $ff98

DEF    hROMBank           EQU $ff9d

DEF    hJoypadReleased    EQU $ffa2
DEF    hJoypadPressed     EQU $ffa3
DEF    hJoypadDown        EQU $ffa4
DEF    hJoypadSum         EQU $ffa5
DEF    hJoyReleased       EQU $ffa6
DEF    hJoyPressed        EQU $ffa7
DEF    hJoyDown           EQU $ffa8

DEF    hPastLeadingZeroes EQU $ffb3

DEF    hDividend          EQU $ffb3
DEF    hDivisor           EQU $ffb7
DEF    hQuotient          EQU $ffb4

DEF    hMultiplicand      EQU $ffb4
DEF    hMultiplier        EQU $ffb7
DEF    hProduct           EQU $ffb3

DEF    hMathBuffer        EQU $ffb8

DEF    hLCDStatCustom     EQU $ffc6

DEF    hBGMapMode         EQU $ffd4
DEF    hBGMapThird        EQU $ffd5
DEF    hBGMapAddress      EQU $ffd6

DEF    hOAMUpdate         EQU $ffd8
DEF    hSPBuffer          EQU $ffd9

DEF    hBGMapUpdate       EQU $ffdb

DEF    hTileAnimFrame     EQU $ffdf

DEF    hRandomAdd         EQU $ffe1
DEF    hRandomSub         EQU $ffe2

DEF    hBattleTurn        EQU $ffe4
DEF    hCGBPalUpdate      EQU $ffe5
DEF    hCGB               EQU $ffe6
DEF    hSGB               EQU $ffe7
DEF    hDMATransfer       EQU $ffe8

; Joypad
DEF    hJPInputHeldDown   EQU $ff8c
DEF    hJPInputChanged    EQU $ff8d

DEF    hJPInputA          EQU $1
DEF    hJPInputB          EQU $2
DEF    hJPInputSelect     EQU $4
DEF    hJPInputStart      EQU $8
DEF    hJPInputRight      EQU $10
DEF    hJPInputLeft       EQU $20
DEF    hJPInputUp         EQU $40
DEF    hJPInputDown       EQU $80

; For SGB Tilemaps.
DEF    P4 EQU $1000
DEF    P5 EQU $1400
DEF    P6 EQU $1800
