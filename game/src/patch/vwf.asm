INCLUDE "game/src/common/constants.asm"

SECTION "VWF Core Functions", ROM0[$1db2]
VWFWordLengthTest::
  ld a, [hl]
  or a
  ret nz
  ld a, [VWFCurrentFont]
  push af
  xor a
  ld [VWFNextWordLength], a
  push bc

.loop
  ld d, h
  ld e, l
  push hl
  ld hl, VWFCurrentLetter
  ld b, $C

  ; Buffer up to 10 characters + 2 potential arguments.

.bufferLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec b
  jr nz, .bufferLoop

  ld hl, VWFCurrentLetter
  ld a, BANK(VWFMeasureCharacter)
  rst $10

  call VWFMeasureStringPart

  ld a, [VWFTrackBank]
  pop hl
  jr nz, .exitLoop
  ld d, 0
  add hl, de
  rst $10
  jr .loop

.exitLoop
  rst $10
  pop bc
  pop af
  ld [VWFCurrentFont], a
  ret

; Tilemaps are loaded from a different branch, so we make sure to keep track
LoadTilemapInWindowWrapper::
  call $0f84
  ld a, BANK(VWFDrawCharLoop)
  rst $10
  ret

VWFPutStringTo8::
  ld a, 8
  ; Continues into VWFPutString.

VWFPutString::
  ; hl is the address of the string to print, terminated by 0x50.
  ; a is the number of tiles our drawing area is comprised of.
  ; b is the tile index of our drawing area.
  ; c is a single-byte representation of an address for mapping tiles to.

  ld [VWFTileLength], a

.skipSettingLength
  ld a, 4
  rst $8 ; VWFPutStringInit

VWFPutStringLoop::
  ld a, [hli]
  cp $50
  jr z, .exit
  cp $4F
  jr z, .exit49
  cp $49
  jr z, .exit49
  push hl
  ld [VWFCurrentLetter], a
  ld a, 5
  rst $8 ; VWFWriteCharLimited
  pop hl
  jr VWFPutStringLoop

.exit
  dec hl

.exit49
  push hl
  ld a, 6
  rst $8 ; VWFMapRenderedString
  pop hl
  ret

VWFPadTextCommon::
  ld [VWFTileLength], a
  xor a
  rst $8 ; VWFPadTextInit

.loop
  ld a, [hli]
  cp $50
  jr z, .exit
  cp $4F
  jr z, .exit
  push hl
  ld [VWFCurrentLetter], a
  ld a, 3
  rst $8 ; VWFCountCharForCentring
  pop hl
  jr .loop

.exit
  ret

VWFPadTextTo8::
  ld a, 8
  ; Continues into VWFPadText.
  
VWFPadText::
  push hl
  push de
  call VWFPadTextCommon
  ld a, 9
  rst $8 ; VWFCalculateCentredTextOffsets

  ; To do: We need to in the future force this to run again if the font changed to narrow.

  xor a
  pop de
  pop hl
  ret

; Copy of VWFPadTextTo8, but for right-aligned text
VWFLeftPadTextTo8::
  ld a, 8

VWFLeftPadText::
  push hl
  push de
  call VWFPadTextCommon
  ld a, $c
  rst $8 ; VWFCalculateRightAlignedTextOffsets

  ; To do: We need to in the future force this to run again if the font changed to narrow.

  xor a
  pop de
  pop hl
  ret

VWFAutoNarrowTo8::
  ld a, 8
  ; Continues into VWFAutoNarrow.
  
VWFAutoNarrow::
  push de
  call VWFPadTextCommon
  ld a, $d
  rst $8 ; VWFCalculateAutoNarrow
  xor a
  pop de
  ret

VWFPutStringAutoNarrowTo8Pad2::
  ld a, $02
  ld [VWFInitialPaddingOffset], a

VWFPutStringAutoNarrowTo8::
  ld a, 8

VWFPutStringAutoNarrow::
  push hl
  push bc
  call VWFPadTextCommon
  ld a, $d
  rst $8 ; VWFCalculateAutoNarrow
  pop bc
  pop hl
  jp VWFPutString.skipSettingLength

SECTION "VWF Drawing Functions", ROMX[$4C00], BANK[$24]
VWFDrawLetterTable::
  ; This determines the width of each character (excluding the 1px between characters).
  ; The address of this table must be a multiple of $100.

  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF
  db 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 0x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 1x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 2x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 3x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 4x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 5x
  db 7, 7, 4, 4, 4, 3, 1, 3, 4, 5, 5, 4, 4, 4, 4, 4 ; 6x
  db 4, 4, 4, 4, 4, 5, 1, 5, 4, 5, 4, 7, 7, 1, 4, 7 ; 7x
  db 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ; 8x
  db 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4 ; 9x
  db 4, 4, 1, 2, 4, 1, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Ax
  db 5, 4, 4, 4, 3, 5, 5, 5, 2, 2, 4, 1, 7, 1, 7, 2 ; Bx
  db 2, 3, 5, 3, 4, 2, 6, 5, 5, 7, 7, 7, 7, 4, 7, 2 ; Cx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Dx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Ex
  db 7, 7, 3, 7, 3, 3, 3, 3, 4, 4, 7, 5, 7, 7, 7, 7 ; Fx
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF

VWFDrawNarrowLetterTable::
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF
  db 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 0x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 1x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 2x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 3x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 4x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 5x
  db 7, 6, 4, 3, 4, 3, 1, 3, 3, 4, 4, 4, 2, 4, 4, 4 ; 6x
  db 4, 4, 4, 4, 4, 4, 1, 5, 3, 5, 3, 5, 5, 1, 3, 5 ; 7x
  db 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 5, 4, 4, 4 ; 8x
  db 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 4, 3, 3, 3, 3, 3 ; 9x
  db 3, 3, 1, 2, 3, 1, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3 ; Ax
  db 5, 4, 3, 3, 3, 5, 5, 4, 2, 2, 3, 1, 3, 1, 5, 2 ; Bx
  db 2, 3, 5, 3, 3, 2, 5, 5, 5, 5, 5, 5, 5, 4, 5, 2 ; Cx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Dx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Ex
  db 7, 7, 3, 7, 3, 3, 3, 3, 3, 3, 5, 3, 6, 7, 7, 7 ; Fx
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF

VWFDrawBoldLetterTable::
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF
  db 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 0x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 1x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 2x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 3x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 4x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 5x
  db 7, 7, 4, 5, 4, 4, 2, 4, 4, 6, 6, 5, 3, 5, 5, 5 ; 6x
  db 5, 5, 5, 5, 5, 6, 2, 5, 4, 5, 4, 7, 7, 1, 4, 7 ; 7x
  db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ; 8x
  db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 4 ; 9x
  db 5, 5, 2, 3, 5, 2, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5 ; Ax
  db 6, 6, 5, 4, 3, 5, 5, 6, 2, 2, 4, 1, 7, 1, 7, 3 ; Bx
  db 3, 3, 5, 3, 4, 2, 6, 5, 6, 7, 7, 7, 7, 4, 7, 2 ; Cx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Dx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Ex
  db 7, 7, 3, 7, 3, 3, 3, 3, 4, 4, 7, 5, 7, 7, 7, 7 ; Fx
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF

VWFDrawRoboticLetterTable::
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF
  db 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 0x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 1x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 2x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 3x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 4x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 5x
  db 7, 7, 4, 4, 4, 3, 1, 3, 4, 5, 5, 4, 2, 4, 4, 4 ; 6x
  db 4, 4, 4, 4, 4, 5, 1, 5, 4, 5, 4, 7, 7, 1, 4, 7 ; 7x
  db 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ; 8x
  db 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4 ; 9x
  db 4, 4, 1, 2, 4, 1, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Ax
  db 5, 5, 4, 4, 3, 5, 5, 5, 2, 2, 4, 1, 7, 1, 7, 2 ; Bx
  db 2, 3, 5, 3, 4, 2, 6, 5, 5, 7, 7, 7, 7, 4, 7, 2 ; Cx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Dx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Ex
  db 7, 7, 3, 7, 3, 3, 3, 3, 4, 4, 7, 5, 7, 7, 7, 7 ; Fx
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF

VWFDrawRoboticBoldLetterTable::
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF
  db 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 0x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 1x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 2x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 3x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 4x
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; 5x
  db 7, 7, 4, 5, 4, 4, 2, 4, 4, 6, 6, 5, 3, 5, 5, 5 ; 6x
  db 5, 5, 5, 5, 5, 6, 2, 5, 4, 5, 4, 7, 7, 1, 4, 7 ; 7x
  db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ; 8x
  db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5 ; 9x
  db 5, 5, 2, 3, 5, 2, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5 ; Ax
  db 6, 6, 5, 5, 3, 5, 5, 6, 2, 2, 4, 1, 7, 1, 7, 3 ; Bx
  db 3, 3, 5, 3, 4, 2, 6, 5, 6, 7, 7, 7, 7, 4, 7, 2 ; Cx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Dx
  db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ; Ex
  db 7, 7, 3, 7, 3, 3, 3, 3, 4, 4, 7, 5, 7, 7, 7, 7 ; Fx
  ;  x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF

VWFFont::
  INCBIN "build/tilesets/patch/Font.1bpp"

VWFNarrowFont::
  INCBIN "build/tilesets/patch/NarrowFont.1bpp"

VWFBoldFont::
  INCBIN "build/tilesets/patch/BoldFont.1bpp"

VWFRoboticFont::
  INCBIN "build/tilesets/patch/RoboticFont.1bpp"

VWFRoboticBoldFont::
  INCBIN "build/tilesets/patch/RoboticBoldFont.1bpp"

VWFMessageBoxInputHandler::
  ; Advance on button press.

  ld a, [hJPInputChanged]
  and hJPInputA | hJPInputB
  ret nz

  ; Auto-advance if button held down.

  ld a, [hJPInputHeldDown]
  and hJPInputA | hJPInputB
  ret z

  ; Wait 10 frames before advancing.

  ld a, [$c6c5]
  cp $10
  jr nz, .buttonNotPressedLongEnough
  xor a
  inc a
  ret

.buttonNotPressedLongEnough
  inc a
  ld [$c6c5], a
  xor a
  ret

.buttonPressed

VWFIncTextOffset::
  ; Copy of IncTextOffset, because I can.

  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  ret nz
  ld a, [WTextOffsetHi]
  inc a
  ld [WTextOffsetHi], a
  ret

VWFDecTextOffset::
  ; Copy of DecTextOffset, because I can.

  ld a, [$c6c0]
  dec a
  ld [$c6c0], a
  ret nc
  ld a, [WTextOffsetHi]
  dec a
  ld [WTextOffsetHi], a
  ret

VWFCountChar4B::
  inc hl
  push hl
  rst $38

.loop
  ; Abort count if the counted text is already too long.

  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFTextLength]
  add d
  jr c, .endCode
  cp $89
  jr nc, .endCode

  ld a, [hl]
  cp $50
  jr z, .endCode
  call VWFMeasureCharacter
  jr .loop

.endCode
  pop hl
  inc hl
  inc hl
  inc e
  inc e
  inc e
  jr VWFMeasureStringPart.loop

VWFCountChar47::
  inc hl
  ld a, [hli]
  ld [VWFCurrentFont], a
  inc e
  inc e
  jr VWFMeasureStringPart.loop

VWFCountCharOneArg::
  inc hl
  inc e
  ; Continue into VWFCountCharNoArg

VWFCountCharNoArg::
  inc hl
  inc e
  jr VWFMeasureStringPart.loop

VWFMeasureStringPart::
  ; Measures 10 characters at a time. The remaining 2 buffered characters are reserved for if the 9th or 10th character is a 4B control code.

  ld e, 0

.loop
  ld a, e
  cp $A
  jp nc, .exit
  ld a, [VWFNextWordLength]
  or a
  ld a, [hl]
  
  ; Space only acts as a terminator after the first character, since the string we are counting will contain a leading space.
  
  jr z, .ignoreFirstSpace
  or a
  jp nz, .ignoreFirstSpace

.foundTerminator
  xor a
  inc a
  ret

.ignoreFirstSpace
  cp $50
  jr nc, .notControlCode
  cp $40
  jr c, .notControlCode

  ; Treat 4F, 4E, 4C, 4A, and 49 as terminators.

  cp $4f
  jr z, .foundTerminator
  cp $4e
  jr z, .foundTerminator
  cp $4c
  jr z, .foundTerminator
  cp $4a
  jr z, .foundTerminator
  cp $49
  jr z, .foundTerminator

  ; Count substrings.
  
  cp $4b
  jp z, VWFCountChar4B
  cp $47
  jp z, VWFCountChar47
  cp $4D
  jp z, VWFCountCharOneArg
  cp $48
  jp z, VWFCountCharOneArg
  jp VWFCountCharNoArg

.notControlCode
  ; Abort count if the counted text is already too long.

  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFTextLength]
  add d
  jr c, .tooLong
  cp $89
  jr nc, .tooLong

  ; Measure character.

  ld a, [hl]
  call VWFMeasureCharacter
  inc e
  jr .loop

.exit
  xor a
  ret

.tooLong
  xor a
  inc a
  ret
  
VWFMeasureCharacter::
  push hl
  ld h, VWFDrawLetterTable >> 8
  ld l, a
  ld a, [VWFCurrentFont]
  add h
  ld h, a
  ld d, [hl]
  ld a, [VWFNextWordLength]
  add d
  inc a
  ld [VWFNextWordLength], a
  pop hl
  inc hl
  ret

VWFDrawCharLoop::
  call VWFCheckInit
  ld a, [hl]
  or a
  jr nz, .notSpace

  ; Treat spaces as 49 control codes if they preceed a word that will overflow the current line.

  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFTextLength]
  add d
  jp c, VWFChar49
  cp $89
  jp nc, VWFChar49

.noAutoLinebreak
  ld a, [hl]

.notSpace
  cp $50
  jr nc, .notControlCode
  cp $40
  jr c, .notControlCode

  cp $4f
  jp z, VWFChar4F
  cp $4e
  jp z, VWFChar4E
  cp $4d
  jp z, VWFChar4D
  cp $4c
  jp z, VWFChar4C
  cp $4b
  jp z, VWFChar4B
  cp $4a
  jp z, VWFChar4A
  cp $49
  jp z, VWFChar49
  cp $48
  jp z, VWFChar48
  cp $47
  jp z, VWFChar47
  cp $46
  jp z, VWFChar46
  cp $45
  jp z, VWFChar45
  cp $44
  jp z, VWFChar44
  cp $43
  jp z, VWFChar43
  cp $42
  jp z, VWFChar42
  cp $41
  jp z, VWFChar41
  cp $40
  jp z, VWFChar40

.notControlCode
  pop hl
  call VWFWriteChar
  jp VWFIncTextOffset

VWFEmptyDrawingRegion::
  ld c, 4

.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb
  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ei
  dec c
  jr nz, .loop
  dec b
  jr nz, VWFEmptyDrawingRegion
  ret

VWFResetMessageBoxTilemapLine::
  ld b, 5

.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb
  ld a, c
  ld [hli], a
  inc a
  ld [hli], a
  inc a
  ld [hli], a
  ei
  inc a
  ld c, a
  dec b
  jr nz, .loop
  di

.wfbB
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfbB
  ld a, c
  ld [hli], a
  inc a
  ld [hli], a
  ei
  inc a
  ld c, a
  ret

VWFCheckInit::
  ld a, [VWFIsInit]
  or a
  ret z
  xor a
  ld [VWFIsInit], a
  ld [VWFPortraitDrawn], a
  ld [VWFCurrentFont], a
  ld a, $D0
  ld [VWFTileBaseIdx], a
  call VWFResetMessageBox
  call VWFResetMessageBoxTilemaps
  ret

VWFResetMessageBoxTilemaps::
  push hl

  ld h, $9c
  ld l, $41
  ld a, [$c5c7]
  cp 1
  jr z, .windowUsed
  ld l, $21

.windowUsed
  ld c, $D0
  call VWFResetMessageBoxTilemapLine
  ld a, l
  add $2F
  ld l, a
  call VWFResetMessageBoxTilemapLine
  pop hl
  ret

VWFResetMessageBox::
  push hl
  ld b, $22
  ld hl, $8D00
  call VWFEmptyDrawingRegion
  pop hl
  ; "a" should be 0 after calling VWFEmptyDrawingRegion so a "xor a" here would feel redundant.
  ld [VWFIsSecondLine], a
  ld a, [VWFPortraitDrawn]
  ld [VWFTilesDrawn], a ; either 0 or 4
  xor a ; Expect a to be 0
  jr VWFResetForNewline.common

VWFResetForNewline::
  ld a, [VWFPortraitDrawn]
  add $11
  ld [VWFTilesDrawn], a
  ld a, 1
  ld [VWFIsSecondLine], a
  xor a

.common
  ld [VWFOldTileMode], a
  ld [VWFTextLength], a
  ld [VWFDiscardSecondTile], a

  ; Shift letters if portrait is drawn
  ld a, [VWFPortraitDrawn]
  rr a
  ld [VWFLetterShift], a
  jr z, .noportrait
  ld a, $22
  ld [VWFTextLength], a
  xor a
.noportrait

  push hl
  ld hl, VWFCompositeArea
  ld b, $10

.clearCompositeAreaLoop
  ld [hli], a
  dec b
  jr nz, .clearCompositeAreaLoop
  pop hl
  ret

VWFPadTextInit::
  ld a, [VWFTileLength]
  add a
  add a
  add a
  ld [VWFDrawingAreaLengthInPixels], a
  ld a, [VWFInitialPaddingOffset]
  ld [VWFNextWordLength], a
  ret

VWFCountCharForCentring::
  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFDrawingAreaLengthInPixels]
  inc a
  cp d
  ret c
  ld a, [VWFCurrentLetter]
  call VWFMeasureCharacter
  ret

VWFCalculateCentredTextOffsets::
  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFDrawingAreaLengthInPixels]
  sub d
  jr c, .limitsExceeded
  ld e, 0
  rra

.loop
  cp 8
  jr c, .exitLoop
  sub 8
  inc e
  jr .loop

.exitLoop
  ld [VWFInitialLetterOffset], a
  ld a, e
  ld [VWFInitialTileOffset], a
  xor a
  ld [VWFInitialPaddingOffset], a
  ret

.limitsExceeded
  inc a
  jr z, .onlyOnePixelOver
  ld a, 1
  ld [VWFCurrentFont], a

.onlyOnePixelOver
  xor a
  ld [VWFInitialLetterOffset], a
  ld [VWFInitialTileOffset], a
  ld [VWFInitialPaddingOffset], a
  ret

; Identical to VWFCalculateCentredTextOffsets without calling rra
VWFCalculateRightAlignedTextOffsets::
  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFDrawingAreaLengthInPixels]
  sub d
  jr c, VWFCalculateCentredTextOffsets.limitsExceeded
  ld e, 0
  jr VWFCalculateCentredTextOffsets.loop

VWFCalculateAutoNarrow::
  ld a, [VWFNextWordLength]
  ld d, a
  ld a, [VWFDrawingAreaLengthInPixels]
  sub d
  jr c, .limitsExceeded
  jr .onlyOnePixelOver

.limitsExceeded
  inc a
  jr z, .onlyOnePixelOver
  ld a, 1
  ld [VWFCurrentFont], a

.onlyOnePixelOver
  ld a, [VWFInitialPaddingOffset]
  ld d, a
  ld e, 0
  jr VWFCalculateCentredTextOffsets.loop

VWFPutStringInitFullTileLocation::
  ld a, d
  ld [VWFTileMappingAddress + 1], a
  ld a, e
  ld [VWFTileMappingAddress], a
  jr VWFPutStringInit.skipMappingLocation

VWFPutStringInit::
  ; Store mapping location.

  call VWFExpandMappingPseudoIndex

.skipMappingLocation
  ; Store drawing location.

  ld a, b
  ld [VWFTileBaseIdx], a

  ; Store text centring offsets.

  ld a, [VWFInitialLetterOffset]
  ld [VWFLetterShift], a

  ld a, [VWFInitialTileOffset]
  ld [VWFTilesDrawn], a

  ; Reset some variables, including the centring variables so that they can't be accidentally picked up by later calls to VWFPutString.

  xor a
  ld [VWFOldTileMode], a
  ld [VWFInitialLetterOffset], a
  ld [VWFInitialTileOffset], a
  ld [VWFTextLength], a
  ld [VWFDiscardSecondTile], a

  ; Clear all tiles in the designated drawing region.

  push hl

  ld a, [VWFTileBaseIdx]
  call VWFTileIdx2Ptr
  ld a, [VWFTileLength]
  ld b, a
  call VWFEmptyDrawingRegion

  ; Clear the first tile in the composite area to avoid visual bugs with centred text.

  ld hl, VWFCompositeArea
  ld b, $10

  ; hl is popped after the jump.

  jp VWFResetForNewline.clearCompositeAreaLoop

VWFExpandMappingPseudoIndex::
  ; Convert our 1 byte representation into a full address for mapping tiles.

  push hl
  ld h, $4C
  ld a, c
  and $F0
  add $10
  jr nc, .noOverflow
  inc h
.noOverflow
  ld l, a
  add hl, hl
  ld a, c
  inc a
  and $F
  add l
  ld [VWFTileMappingAddress], a
  ld a, h
  ld [VWFTileMappingAddress + 1], a
  pop hl
  ret

VWFMapRenderedString::
  ; Reset font to normal after rendering (for after auto-narrowing).

  xor a
  ld [VWFCurrentFont], a
  
  ; Load our mapping address.
  
  ld a, [VWFTileMappingAddress + 1]
  ld h, a
  ld a, [VWFTileMappingAddress]
  ld l, a

  ; Map all tiles within the drawing area.

  ld a, [VWFTileBaseIdx]
  ld c, a
  ld a, [VWFTileLength]
  ld b, a
  ld d, a

.loop
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, c
  ld [hli], a
  ei
  inc c
  dec b
  jr nz, .loop
  ld a, d
  ret

VWFChar4F::
  ; End of text.
  inc hl
  ld a, [hl]
  pop hl

.checkEndType0
  or a
  jr nz, .checkEndType1

.endType0
  ; Advance on button press.

  call VWFMessageBoxInputHandler
  ret z

  ; No idea what this does.

  ld a, $22
  ld [$ffa1], a

  ; Clearing some basic variables.

  xor a
  ld [$c5c7], a
  ld [$c6c5], a
  ld [VWFCurrentFont], a

  ; No idea what this does either.

  call VWFPortraitClearSGBAttribAndWindowOnEndcode

  ; End message indicator variable.

  ld a, 1
  ld [$c6c6], a

  ret

.checkEndType1
  cp 1
  jr nz, .checkEndType2

.endType1
  ; Clearing some basic variables.

  xor a
  ld [$c5c7], a
  ld [$c6c5], a
  ld [VWFCurrentFont], a

  ; No idea what this does either.

  call VWFPortraitClearSGBAttribAndWindowOnEndcode

  ; End message indicator variable.

  ld a, 1
  ld [$c6c6], a

  ret

.checkEndType2
  cp 2
  jr nz, .checkEndType3

.endType2
  ; Advance on button press.

  call VWFMessageBoxInputHandler
  ret z

  ; No idea what this does.

  ld a, $22
  ld [$ffa1], a

  ; Clearing some basic variables.

  xor a
  ld [$c6c5], a
  ld [VWFCurrentFont], a

  ; End message indicator variable.

  inc a
  ld [$c6c6], a

  ret

.checkEndType3
  cp 3
  jr nz, .endType4

.endType3
  ; Advance on button press.

  call VWFMessageBoxInputHandler
  ret z

  ; No idea what this does.

  ld a, $22
  ld [$ffa1], a

  ; Or this.

  ld b, $1
  ld c, $1
  ld e, $2f
  call LoadTilemapInWindowWrapper

  ; Clearing some basic variables.

  xor a
  ld [$c6c5], a
  ld [VWFCurrentFont], a

  ; End message indicator variable.

  inc a
  ld [$c6c6], a

  ret

.endType4
  ; Clearing some basic variables.

  xor a
  ld [VWFCurrentFont], a
  
  ; End message indicator variable.

  ld a, 1
  ld [$c6c6], a

  ret

VWFChar4E::
  ; Newline.

  call VWFResetForNewline
  call VWFIncTextOffset
  pop hl
  jp PutCharLoopWithBankSwitch

VWFChar4D::
  ; Text speed.

  inc hl
  ld a, [hl]
  ld [$c6c4], a
  srl a
  ld [$c6c1], a
  call VWFIncTextOffset
  call VWFIncTextOffset
  pop hl
  ld a, [$c6c1]
  cp $7f
  ret nz
  xor a
  ld [$c6c1], a
  ld [$c6c4], a
  ret

VWFChar4C::
  ; New text box.
  pop hl

  ; Map next page indicator arrow.

  ld h, $9c
  ld l, $92
  ld a, [$c5c7]
  cp 1
  jr z, .windowUsed
  ld l, $72

.windowUsed
  ld a, $fa
  di
  call WaitLCDController
  ld [hl], a
  ei

  ; Advance on button press.

  call VWFMessageBoxInputHandler
  ret z

  ; No idea what this does.

  ld a, $22
  ld [$ffa1], a

  ; Reset auto-advance timer.

  xor a
  ld [$c6c5], a

  ; Clear message box and reset variables.

  call VWFResetMessageBox

  ; Remove next page indicator arrow.

  ld h, $9c
  ld l, $92
  ld a, [$c5c7]
  cp 1
  jr z, .windowUsedB
  ld l, $72

.windowUsedB
  xor a
  di
  call WaitLCDController
  ld [hl], a
  ei

  jp VWFIncTextOffset

VWFChar4B::
  ; Call subtext.
  ; hl = base memory address to pull from

  inc hl
  rst $38

  ; Reset text speed timer.

  ld a, [$c6c4]
  srl a
  ld [$c6c1], a

  ; Get the current character index using $c6c5 as the substring offset.

  ld a, [$c6c5]
  ld c, a
  ld b, 0
  add hl, bc
  ld a, [hl]

  ; Check for a string terminator.
  
  cp $50
  jr nz, .notEndCode

.endCode

  ; Reset offset.

  xor a
  ld [$c6c5], a

  pop hl
  call VWFIncTextOffset
  call VWFIncTextOffset
  call VWFIncTextOffset
  ret

.notEndCode
  ld [VWFCurrentLetter], a
  call VWFWriteChar

  ; Check if the character we just drew is followed by a string terminator.

  inc hl
  ld a, [hl]
  cp $50
  jr z, .endCode

  pop hl

  ; Progress to next character.

  ld a, [$c6c5]
  inc a
  ld [$c6c5], a
  ret

VWFChar4A::
  ; New text box without user input.

  xor a
  ld [$c6c5], a

  ; Clear message box and reset variables.

  call VWFResetMessageBox
  pop hl
  jp VWFIncTextOffset

VWFChar49::
  ; Universal linebreak.
  ld a, [VWFIsSecondLine]
  or a
  jp z, VWFChar4E
  jp VWFChar4C

; VWFChar48 is defined in version/portraits.asm

VWFChar47::
  inc hl
  ld a, [hl]
  ld [VWFCurrentFont], a
  pop hl
  call VWFIncTextOffset
  jp VWFIncTextOffset

VWFChar46::
  pop hl
  jp VWFIncTextOffset

VWFChar45::
  pop hl
  jp VWFIncTextOffset

VWFChar44::
  pop hl
  jp VWFIncTextOffset

VWFChar43::
  pop hl
  jp VWFIncTextOffset

VWFChar42::
  pop hl
  jp VWFIncTextOffset

VWFChar41::
  pop hl
  jp VWFIncTextOffset

VWFChar40::
  pop hl
  jp VWFIncTextOffset

VWFWriteCharLimited::
  ld a, [VWFTileLength]
  ld b, a
  ld a, [VWFTilesDrawn]

  ; If the number of tiles drawn match (or exceed) the max number of tiles then stop drawing.

  cp b
  ret nc

  ; If the number of tiles drawn are 1 less than the max number of tiles then stop drawing the second tile from the composite area.

  inc a
  cp b
  jr c, VWFWriteChar
  ld a, 1
  ld [VWFDiscardSecondTile], a
  ; Continue into VWFWriteChar.

VWFWriteChar::
  ; Get tile address.

  ld a, [VWFTilesDrawn]
  ld b, a
  ld a, [VWFTileBaseIdx]
  add b
  call VWFTileIdx2Ptr

  ; Draw character.

  call VWFDrawLetter

  ; Progress to next tile (if applicable).

  ld a, [VWFOldTileMode]
  cp 1
  ld a, [VWFTilesDrawn]
  jr c, .noIncrement
  inc a
  ld [VWFTilesDrawn], a
  
.noIncrement
  ; Reset text speed timer.

  ld a, [$c6c4]
  srl a
  ld [$c6c1], a
  ret

VWFTileIdx2Ptr::
  cp $80
  jr c, .firstPage
  swap a
  ld h, a
  and $F0
  ld l, a
  ld a, h
  and $F
  or $80
  ld h, a
  ret

.firstPage
  swap a
  ld h, a
  and $F0
  ld l, a
  ld a, h
  and $F
  or $90
  ld h, a
  ret

VWFDrawLetter::
  ld a, [VWFCurrentLetter]

  ; Calculate the address of the relevant character.

  push hl
  ld b, 0
  add a
  jr nc, .noCarry
  inc b

.noCarry
  sla a
  rl b
  sla a
  rl b
  ld c, a
  ld hl, VWFFont
  ld a, [VWFCurrentFont]
  add a
  add a
  add a
  add h
  ld h, a
  add hl, bc
  ld d, h
  ld e, l
  pop hl

  ; Store the address of the composite area (an area to draw tile data before tranferring it to vram).

  ld b, 8
  ld a, VWFCompositeArea >> 8
  ld [VWFCompositeAreaAddress], a
  ld a, VWFCompositeArea & $FF
  ld [VWFCompositeAreaAddress + 1], a

  ; Get the width of the character.

  push hl
  push bc
  ld a, [VWFCurrentLetter]
  ld h, VWFDrawLetterTable >> 8
  ld l, a
  ld a, [VWFCurrentFont]
  add h
  ld h, a
  ld b, [hl]
  ld a, [VWFTextLength]
  add b
  inc a
  ld [VWFTextLength], a

  ; Check if the character overflows into the next tile.

  ld a, [VWFLetterShift]
  add a, b
  bit 3, a
  jr nz, .onSecondTile
  xor a
  jr .doneCalculatingTile

.onSecondTile
  ld a, 1

.doneCalculatingTile
  pop bc
  pop hl

.tileShiftLoop
  push bc
  push de
  push hl
  push af
  ld a, [VWFCompositeAreaAddress]
  ld h, a
  ld a, [VWFCompositeAreaAddress + 1]
  ld l, a
  ld b, [hl]
  inc hl
  ld c, [hl]
  dec hl
  ld a, [de]
  ld d, a
  ld e, 0
  ld a, [VWFOldTileMode]
  cp 2
  jr z, .newlineMode
  cp 1
  jr z, .secondTileMode
  jr .firstTileMode

.newlineMode
  ld c, 0

.secondTileMode
  ld b, c

.firstTileMode
  ld a, [VWFLetterShift]
  or a
  jr z, .stopShifting

.shiftLoop
  srl d
  rr e
  dec a
  jr nz, .shiftLoop

.stopShifting
  ld a, d
  or b
  ld b, a
  ld c, e
  ld [hl], b
  inc hl
  ld [hl], c
  inc hl
  ld a, h
  ld [VWFCompositeAreaAddress], a
  ld a, l
  ld [VWFCompositeAreaAddress + 1], a
  pop af
  pop hl
  ld d, h
  ld e, l
  push af
  ld a, b
  call VWFExpandGlyph
  pop af
  push hl
  push af
  or a
  jr z, .skipSecondTile
  ld a, [VWFDiscardSecondTile]
  or a
  jr nz, .skipSecondTile
  ld hl, $10
  add hl, de
  ld a, c
  call VWFExpandGlyph
  
.skipSecondTile
  pop af
  pop hl
  pop de
  pop bc
  inc de
  dec b
  jr nz, .tileShiftLoop
  xor a
  ld [VWFOldTileMode], a
  ld b, VWFDrawLetterTable >> 8
  ld a, [VWFCurrentFont]
  add b
  ld b, a
  ld a, [VWFCurrentLetter]
  ld c, a
  ld a, [bc]
  inc a
  
.addWidth
  ld b, a
  ld a, [VWFLetterShift]
  add a, b
  bit 3, a
  jr z, .noSecondTileShiftBack
  sub 8
  push af
  ld a, 1
  ld [VWFOldTileMode], a
  pop af
  
.noSecondTileShiftBack
  ld [VWFLetterShift], a
  ret

VWFExpandGlyph::
  push bc
  ld b, a
  di

.wfb
  ldh a, [hLCDStat]
  and 2
  jr nz, .wfb

  ld a, b
  ld [hli], a
  ld [hli], a
  ei
  pop bc
  ret