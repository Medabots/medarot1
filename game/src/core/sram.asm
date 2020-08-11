SECTION "Robattle Medarot Data", SRAM[$ac00], BANK[$1]
RobattleMedarots::
RobattlePlayerMedarot1:: ds $100
RobattlePlayerMedarot2:: ds $100
RobattlePlayerMedarot3:: ds $100
RobattleEnemyMedarot1:: ds $100
RobattleEnemyMedarot2:: ds $100
RobattleEnemyMedarot3:: ds $100

SECTION "Save Handling", ROM0[$2AAC]
GenerateSaveHeaderAndChecksum::
  ld a, 0
  call EnableSRAM
  ld de, SaveHeaderString
  ld hl, $A000
  ld bc, $10

.headerCopyLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .headerCopyLoop
  jp GenerateSaveChecksum

SaveHeaderString::
  db $20,$4D,$45,$44,$41,$52,$4F,$54,$20,$20,$20,$20,$20,$20,$20,$00 ; " MEDAROT       " in ascii followed by a null byte.

GenerateSaveChecksum::
  ld a, 0
  call EnableSRAM
  xor a
  ld [$BFFE], a
  ld [$BFFF], a
  ld de, $A000
  ld bc, $1FF0

.checksumCalculationLoop
  push bc
  ld hl, $BFFF
  ld a, [de]
  ld b, a
  ld a, [hl]
  add b
  ld [hl], a
  inc de
  ld hl, $BFFE
  ld a, [de]
  ld b, a
  ld a, [hl]
  adc b
  ld [hl], a
  pop bc
  dec bc
  ld a, b
  or c
  jr nz, .checksumCalculationLoop
  ret

SaveDataVerification::
  ld a, 0
  call EnableSRAM
  ld hl, SaveHeaderString
  ld de, $A000
  ld bc, $10

.headerComparisonLoop
  push bc
  ld a, [hli]
  ld b, a
  ld a, [de]
  cp b
  jr nz, .uninitiatedSave
  inc de
  pop bc
  dec bc
  ld a, b
  or c
  jr nz, .headerComparisonLoop

  xor a
  ld [$C623], a
  ld [$C624], a
  ld de, $A000
  ld bc, $1FF0

.checksumCalculationLoop
  push bc
  ld hl, $C624
  ld a, [de]
  ld b, a
  ld a, [hl]
  add b
  ld [hl], a
  inc de
  inc hl
  ld hl, $C623
  ld a, [de]
  ld b, a
  ld a, [hl]
  adc b
  ld [hl], a
  pop bc
  dec bc
  ld a, b
  or c
  jr nz, .checksumCalculationLoop

.checksumComparison
  ld a, [$C624]
  ld b, a
  ld a, [$BFFF]
  cp b
  jr nz, .corruptSave
  ld a, [$C623]
  ld b, a
  ld a, [$BFFE]
  cp b
  jr nz, .corruptSave

.validSave
  ld a, 0
  ret

.uninitiatedSave
  pop bc
  ld a, 1
  ret

.corruptSave
  ld a, 2
  ret

InitiateNewSave::
  ld a, 0
  call EnableSRAM
  ld hl, $A000
  ld bc, $1FF0

.zerofillLoop
  xor a
  ld [hli], a
  dec bc
  ld a, c
  or b
  jr nz, .zerofillLoop
  xor a
  ld [$BFFD], a
  jp GenerateSaveHeaderAndChecksum

SECTION "Enable SRAM", ROM0[$32DF]
EnableSRAM::
  ld b, a
  ld a, 1
  ld [$6000], a ; I can only assume this to be an alternate form of ld a,$A ld [$0000],a for RTC-less MBC3.
  ld a, b
  ld [$4000], a
  ld [$C6D7],a
  ret
