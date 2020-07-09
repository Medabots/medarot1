SECTION "Titlescreen State Machine", ROMX[$421D], BANK[$1]
TitlescreenStateMachine::
  ld a, [CoreSubStateIndex]
  ld hl, .table
  ld d, 0
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp hl

.table
  dw TitlescreenStateInitialize ; Version specific files, check corresponding version folders
  dw $42B6
  dw $42C0
  dw $42C3
  dw $42ED
  dw $4348
  dw $4354
