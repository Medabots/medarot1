SECTION "VWFChar48", ROMX[$7FEE], BANK[$24]
VWFChar48::
  ; Draw character portrait if called
  ; csv2bin will forcibly add 4C before this, if it isn't the first character in dialog
IF DEF(FEATURE_PORTRAITS)
  inc hl
  ld a, [hl]
  call DrawPortrait ; Sets VWFPortraitDrawn
  pop hl
  call VWFIncTextOffset
  call VWFIncTextOffset
  call VWFResetMessageBox ; Need to set start offsets
ELSE
  pop hl
  call VWFIncTextOffset
  call VWFIncTextOffset
ENDC
  jp PutCharLoopWithBankSwitch