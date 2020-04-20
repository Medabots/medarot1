SECTION "VWF Variables", WRAMX[$DC00], BANK[$1]
VWFTilesDrawn:: ds 1
VWFCurrentLetter:: ds 1
VWFControlCodeArguments:: ds 2
VWFCompositeAreaAddress:: ds 2
VWFLetterShift:: ds 1
VWFOldTileMode:: ds 1
VWFTileBaseIdx:: ds 1
VWFIsInit:: ds 1
VWFIsSecondLine:: ds 1
VWFTrackBank:: ds 1

SECTION "VWF Composite Area", WRAMX[$DCD0], BANK[$1]
VWFCompositeArea:: ds $30

SECTION "VWF Drawing Functions", ROMX[$6000], BANK[$24]
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

VWFFont::
	INCBIN "build/tilesets/Font.vwffont"

VWFMessageBoxInputHandler::
	; Advance on button press.

	ld a, [hJPInputChanged]
	and hJPInputA + hJPInputB
	ret nz

	; Auto-advance if button held down.

	ld a, [hJPInputHeldDown]
	and hJPInputA + hJPInputB
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

VWFDrawCharLoop::
	call VWFCheckInit
	ld a, [hl]
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
	pop hl
	call VWFWriteChar
	jp VWFIncTextOffset

VWFEmptyDrawingRegion::
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
	ld b, $88
	ld hl, $8D00
	call VWFEmptyDrawingRegion
	pop hl
	; "a" should be 0 after calling VWFEmptyDrawingRegion so a "xor a" here would feel redundant.
	ld [VWFTilesDrawn], a
	ld [VWFIsSecondLine], a
	jr VWFResetForNewline.common

VWFResetForNewline::
	ld a, $11
	ld [VWFTilesDrawn], a
	ld a, 1
	ld [VWFIsSecondLine], a
	xor a

.common
	ld [VWFOldTileMode], a
	ld [VWFLetterShift], a

	push hl
	ld hl, VWFCompositeArea
	ld b, $10

.clearCompositeAreaLoop
	ld [hli], a
	dec b
	jr nz, .clearCompositeAreaLoop
	pop hl
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

	; No idea what this does either.

	call $1ab0

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

	; No idea what this does either.

	call $1ab0

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

	; End message indicator variable.

	ld a, 1
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
	call $0f84

	; Clearing some basic variables.

	xor a
	ld [$c6c5], a

	; End message indicator variable.

	ld a, 1
	ld [$c6c6], a

	ret

.endType4
	; End message indicator variable.

	ld a, 1
	ld [$c6c6], a

	ret

VWFChar4E::
	; Newline.

	call VWFResetForNewline
	call VWFIncTextOffset
	pop hl
	jp PutCharLoopWithBankswitch

VWFChar4D::
	; Text speed.

	inc hl
	ld a, [hl]
	ld [$c6c1], a
	ld [$c6c4], a
	call VWFIncTextOffset
	call VWFIncTextOffset
	pop hl
	ld a, [$c6c1]
	cp $ff
	ret nz
	xor a
	ld [$c6c1], a
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
	add hl, bc
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

	; Get the current character index using $c6c5 as the substring offset.

	ld a, [$c6c5]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]

	; Check for a string terminator.
	
	cp $50
	jr nz, .notEndCode

	; Reset offset.

	xor a
	ld [$c6c5], a

	; Reset text speed timer.

	ld a, [$c6c4]
	ld [$c6c1], a

	pop hl
	call VWFIncTextOffset
	call VWFIncTextOffset
	call VWFIncTextOffset
	jp PutCharLoopWithBankswitch

.notEndCode
	ld [VWFCurrentLetter], a
	call VWFWriteChar
	pop hl

	; Progress to next character.

	ld a, [$c6c5]
	inc a
	ld [$c6c5], a
	jp PutCharLoopWithBankswitch

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
	xor a
	ld b, [hl]

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
	di
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
	ld hl, $10
	add hl, de
	ld a, c
	call VWFExpandGlyph
	
.skipSecondTile
	ei
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

.wfb
	ldh a, [hLCDStat]
	and 2
	jr nz, .wfb

	ld a, b
	ld [hli], a
	ld [hli], a
	pop bc
	ret