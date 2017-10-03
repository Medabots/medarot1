SECTION "User Functions (Hack)", ROMX[$4000], BANK[$24]
HackPredef::
  push af
  ld a, h
  ld [TempH], a
  ld a, l
  ld [TempL], a
  pop af
  ld hl, HackPredefTable
  rst $30
  push hl ; Change return pointer to Hack function
  ld a, [TempH]
  ld h, a
  ld a, [TempL]
  ld l, a
  ret

HackPredefTable:
  dw IncTextOffset ;0
  dw GetTextOffset ;1
  dw ZeroTextOffset ;2
  dw IncrementTileOffset ;3
  dw ClearTextBox ;4
  dw CheckCallClearTextBox ;5
  dw SkipSpaceHack ; 6
  dw SetInitialName ; 7
  dw SetNextChar ; 8
  dw CheckIncTextOffset ; 9

; [[WTextOffsetHi][$c6c0]]++
IncTextOffset:
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  ret nz
  ld a, [WTextOffsetHi]
  inc a
  ld [WTextOffsetHi], a
  ret

; [[WTextOffsetHi][$c6c0]]--
DecTextOffset:
  ld a, [$c6c0]
  dec a
  ld [$c6c0], a
  ret nc
  ld a, [WTextOffsetHi]
  dec a
  ld [WTextOffsetHi], a
  ret


; bc = [WTextOffsetHi][$c6c0]
GetTextOffset:
  ld a, [$c6c0]
  ld c, a
  ld a, [WTextOffsetHi]
  ld b, a
  ret

ZeroTextOffset:
  xor a
  ld [$c6c0], a
  ld [WTextOffsetHi], a
  ld [FlagClearText], a
  ld [FlagNewLine], a
  ret

hLineMax           EQU $11 ;Max offset from start of line
hLineOffset        EQU $20 ;Bytes between line tiles
hLineCount         EQU $04 ;Total number of lines
hLineVRAMStart     EQU $9C00 ;Initial Tile VRAM location
IncrementTileOffset:
  push bc ; save original bc
  push hl ; save original hl
  ld a, hLineMax 
  ld b, $0
  ld c, hLineOffset
.loop
  add c ; a becomes upper limit
  inc b ; b is the line number (first line is 1)
  cp l
  jr z, .skip_compare ; if curr_off == max
  jr c, .loop
.endloop
  ; Add current word length to make sure words don't get clipped
  ld c, a ; c = max_length
  ld a, [CurrentWordLen]
  add l ; a += l
  jr c, .skip_compare ; l + a > 0xFF ? Skip to next line/box
  ld l, a ; l = curr_offset
  ld a, c ; a = max_length
  cp l
  jr c, .skip_compare ; curr_off > max_length ? Skip to next line/box
  inc l ; this is a terrible hack and I should be ashamed of myself,
        ; but it guarantees that the zero flag won't be set for a situation that gets to this point
        ; (if it gets to this point, it should be normal incremented)
.skip_compare
  ld a, $0 ; if xor is used, it changes the flags
  ld [FlagNewLine], a
  ld [CurrentWordLen], a
  ld a, b ; save current line #
  pop hl ; restore original hl
  pop bc ; restore original bc
  jr z, .reset_offset
  jr nc, .normal_increment
.reset_offset
  cp $3
  ld a, $1
  ld [FlagNewLine], a
  jr c, .new_line
.new_textbox
  ld a, $1
  ld [FlagClearText], a
  ld [FlagDo4C], a
  push bc
  ld hl, $9c00
  ld bc, $0040 ; 40 instead of 41 since it gets incremented below
  ld a, [$c5c7]
  cp $1
  jr z, .new_textbox_normal_type
  ld bc, $0020
.new_textbox_normal_type
  add hl, bc
  pop bc
  jr .normal_increment
.new_line
  push bc
  ld hl, $9c00
  ld bc, $0080 ; 80 instead of 81 since it gets incremented below
  ld a, [$c5c7]
  cp $1
  jr z, .new_line_normal_type
  ld bc, $0060
.new_line_normal_type
  add hl, bc
  pop bc
.normal_increment
  inc hl
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ret

ClearTextBox:
  push af
  push bc
  push hl
  ld c, $1
.clear_lines
  ld hl, hLineVRAMStart + $1 ; Actual start point is 9C21, not 9C20
  ld b, c
.inc_line_offset
  ld a, hLineOffset
  rst $28
  dec b
  jr nz, .inc_line_offset
  ld b, hLineMax
  xor a
.clear_line
  di
  call WaitLCDController
  ld [hli], a
  ei
  dec b
  jr nz, .clear_line
  inc c
  ld a, hLineCount
  cp c
  jr nc, .clear_lines
  pop hl
  pop bc
  pop af
  ret

CheckCallClearTextBox:
  ld a, [FlagClearText]
  cp $0
  jr z, .check_clear_text_ret
  call ClearTextBox
  xor a
  ld [FlagClearText], a
.check_clear_text_ret
  ret

SkipSpaceHack:: ; TODO: Move SkipSpace logic here from core_hack.asm to save space 
  ret

SetInitialName: ; TODO: In the future, we might be able to just set this as a loop and pull it from a build obj for different language support
  ld a, $87 ; H
  ld [hli], a
  ld a, $bf ; i
  ld [hli], a
  ld a, $c1 ; k
  ld [hli], a
  ld a, $b7 ; a
  ld [hli], a
  ld a, $c8 ; r
  ld [hli], a
  ld a, $cb ; u
  ld [hli], a
	ld a, $50 ; EOL
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $6
  ld [$c5ce], a
  ret

SetNextChar: ; Override next character based on flags
  ld a, [FlagDo4C]
  cp $0
  jr z, .return
  ld a, [NextChar]
  cp $4c
  jr z, .is_4c
  ld a, $4c
  ld [TmpChar], a
  ld hl, TmpChar
.return
  ret
.is_4c
  xor a
  ld [FlagDo4C], a
  ret

; [hl] ? nop : IncTextOffset
CheckIncTextOffset:
  ld a, [hl]
  cp $0
  jr nz, .return
  call IncTextOffset
.return
  ret