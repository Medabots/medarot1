INCLUDE "game/src/common/constants.asm"

SECTION "Fortune Spinner Disassembly 1", ROMX[$7907], BANK[$3]
FortuneSpinnerLoad:
  or a
  ret nz
  ld a, $01
  ld [$c6c7], a
  ld b, $18 ; Moved one tile up, originally $20
  ld c, $38 ; Moved one tile up, originally $40
  ld d, $30 ; Expanded one tile to the left of original, originally $38
  ld e, $70
  call JumpTable_204 ; OAM Tilemap detection function
  ; FortuneSpinnerUnload should match these values
  ld a, $04 ; Originally 6, height to save
  ld [$c64e], a
  ld a, $09 ; Originally 7, width to save
  ld [$c64f], a
  ld a, $01 ; Originally 2, starting y position
  ld [$c650], a
  ld a, $04 ; Starting x position
  ld [$c651], a
  ld a, $00
  call JumpTable_2c4
  ld b, $05
  ld c, $01
  ld e, $F2 ; Width8TextBox
  ld a, $29 ; LoadLuckLotteryTextAndJump2ca
  rst $08
  xor a
  ld [$c884], a
  ld [$c885], a
  ld [$c886], a
  call FortuneSpinnerLoadFortuneText
  jp $659c
; 0xf94b

SECTION "Fortune Spinner Disassembly 2", ROMX[$79c7], BANK[$3]
FortuneSpinnerStopping:
  ld a, [$c5a0]
  and $03
  ret nz
  ld a, [$c886]
  inc a
  ld [$c886], a
  cp $10
  jp z, FortuneSpinnerSlowingDown
  ld a, [$c885]
  inc a
  and $01
  ld [$c885], a
  jp z, FortuneSpinnerStoppingLoadBoxTilemap
  ld a, [$c884]
  jp FortuneSpinnerLoadFortuneText
FortuneSpinnerStoppingLoadBoxTilemap: ; f9eb (3:79eb)
  ld b, $05
  ld c, $01
  ld e, $F2
  jp JumpTable_2ca
FortuneSpinnerSlowingDown: ; f9f4 (3:79f4)
  ld a, [$c884]
  call FortuneSpinnerLoadFortuneText
  jp $659c
FortuneSpinnerUnload: ; f9fd (3:79fd), restores textbox
  ld a, [hJPInputChanged]
  and hJPInputA
  ret z
  ld a, $01
  ld [$c6c7], a
  call JumpTable_207
  ld a, $04 ; Originally 6
  ld [$c64e], a
  ld a, $09 ; Originally 7
  ld [$c64f], a
  ld a, $01 ; Originally 2
  ld [$c650], a
  ld a, $04
  ld [$c651], a
  ld a, $00
  call JumpTable_2c7
  jp $659c
; fa26

FortuneGreatLuck EQU $00
FortuneGoodLuck EQU $01
FortuneSomeLuck EQU $02
FortuneUncertain EQU $03
FortuneBadLuck EQU $04
FortuneDisaster EQU $05
SECTION "Fortune Spinner Disassembly 3", ROMX[$7ab6], BANK[$3]
FortuneSpinnerLoadFortuneText: ; fab6 (3:7ab6)
  ld e, a
  ld d, $00
  ld hl, .table
  add hl, de
  ld a, [hl]
  add $58
  ld e, a
  ld b, $06
  ld c, $02
  jp JumpTable_2ca
.table
  db FortuneSomeLuck
  db FortuneGoodLuck
  db FortuneSomeLuck
  db FortuneGreatLuck
  db FortuneSomeLuck
  db FortuneDisaster
  db FortuneSomeLuck
  db FortuneGoodLuck