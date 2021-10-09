; Wrapper functions (useful for maintaining bank information when swapping)
SECTION "Wrappers", ROM0[$058d]
WrapPlaySound::
  ld a, $06
  rst $10
  call PlaySound
  ld a, $01
  rst $10
  ret
  nop
  nop
  nop
  nop
Wrapper_59b::
  jp $d78
Wrapper_59e::
  jp $d86
Wrapper_5a1::
  jp $d99
WrapLoadTilemap::
  call LoadTilemap
  rst $18
  ret
WrapLoadFont::
  call LoadFont0
  rst $18
  ret
Wrapper_5ae::
  jp $1410
Wrapper_5b1::
  jp $1555
WrapIncSubStateIndex::
  jp IncSubStateIndex
Wrapper_5b7::
  ld a, $1b
  rst $10
  call $633b
  push af
  rst $18
  pop af
  ret
  nop
  nop
WrapWaitLCDController::
  jp WaitLCDController
Wrapper_5c6::
  jp $da7
Wrapper_5c9::
  jp $17d4
Wrapper_5cc::
  jp $17df
Wrapper_5cf::
  jp $17eb
Wrapper_5d2::
  jp $17f9
Wrapper_5d5::
  jp $1804
Wrapper_5d8::
  call $f84
  rst $18
  ret
Wrapper_5dd::
  call $3ca6
  rst $18
  ret
Wrapper_5e2::
  ld a, $03
  rst $10
  call $5751
  rst $18
  ret
Wrapper_5ea::
  ld a, $03
  rst $10
  call $52e7
  rst $18
  ret
Wrapper_5f2::
  jp $d6d
Wrapper_5f5::
  jp $c80
Wrapper_5f8::
  call $4133 ; Possibly SGB_SendPackets?
  rst $18
  ret
Wrapper_5fd::
  call $4169 ; Possibly SGB_SendPacketsWithVRAM?
  rst $18
  ret
Wrapper_602::
  jp $c98
Wrapper_605::
  call $38d0
  rst $18
  ret
Wrapper_60a::
  call $1591
  rst $18
  ret
Wrapper_60f::
  jp CopyVRAMData
Wrapper_612::
  jp $dea
Wrapper_615::
  jp $dfd
Wrapper_618::
  rst $18
  ret
Wrapper_61a::
  ret
Wrapper_61b::
  jp $c53
Wrapper_61e::
  ret
Wrapper_61f::
  call $18e5
  rst $18
  ret
Wrapper_624::
  jp $1a77
Wrapper_627::
  jp $1a87
Wrapper_62a::
  jp $1a94
Wrapper_62d::
  jp $1aa2
Wrapper_630::
  ld a, $2b
  rst $8 ; VWFPortraitClearSGBAttribAndWindowOnEndcode
  rst $18
  ret
Wrapper_635::
  call $1cc9
  rst $18
  ret
WrapSetupDialog::
  call $1c87
  rst $18
  ret
Wrapper_63f::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $01
  rst $10
  ld [$c6e0], a
  call $4c12
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_658::
  jp $377c
Wrapper_65b::
  call $25e5
  rst $18
  ret
WrapLoadItemList::
  call LoadItemList
  rst $18
  ret
WrapEnableSRAM::
  jp EnableSRAM
Wrapper_668::
  jp $dc6
WrapDrawNumber::
  call DrawNumber
  rst $18
  ret
Wrapper_670::
  jp $39c5
Wrapper_673::
  call $2088
  rst $18
  ret
Wrapper_678::
  call $265c
  rst $18
  ret
Wrapper_67d::
  call $2770
  rst $18
  ret
Wrapper_682::
  jp $296b
Wrapper_685::
  jp $2600
Wrapper_688::
  jp $2628
Wrapper_68b::
  jp $1ba6
Wrapper_68e::
  jp $1c45
Wrapper_691::
  jp $2a2a
Wrapper_694::
  jp $2a5f
Wrapper_697::
  jp $2a94
Wrapper_69a::
  jp $e10
WrapGenerateSaveHeaderAndChecksum::
  jp GenerateSaveHeaderAndChecksum
WrapGenerateSaveChecksum::
  jp GenerateSaveChecksum
WrapSaveDataVerification::
  jp SaveDataVerification
WrapInitiateNewSave::
  jp InitiateNewSave
Wrapper_6a9::
  ld [$c64e], a
  ld a, $02
  rst $10
  ld a, [$c6e0]
  push af
  ld a, $02
  ld [$c6e0], a
  ld a, [$c64e]
  call $42d3
  pop af
  ld [$c6e0], a
  rst $18
  ret
Wrapper_6c4::
  ld [$c64e], a
  ld a, $02
  rst $10
  ld a, [$c6e0]
  push af
  ld a, $02
  ld [$c6e0], a
  ld a, [$c64e]
  call $441a
  pop af
  ld [$c6e0], a
  rst $18
  ret
Wrapper_6df::
  jp $2b79
Wrapper_6e2::
  jp $2b9f
Wrapper_6e5::
  jp $2068
Wrapper_6e8::
  call $1891
  ret
Wrapper_6ec::
  call $2bb2
  rst $18
  ret
Wrapper_6f1::
  call $2ca1
  rst $18
  ret
Wrapper_6f6::
  call $c3b
  ret
Wrapper_6fa::
  call $56b
  ret
Wrapper_6fe::
  call $3eb5
  ret
WrapDecompressAndLoadTiles::
  call DecompressAndLoadTiles
  rst $18
  ret
WrapLoadMainDialogTileset::
  call LoadMainDialogTileset
  rst $18
  ret
Wrapper_70c::
  call $2cf5
  rst $18
  ret
Wrapper_711::
  call $2d8b
  ret
Wrapper_715::
  call $2dba
  rst $18
  ret
Wrapper_71a::
  call $2f01
  rst $18
  ret
Wrapper_71f::
  call $2f2f
  rst $18
  ret
Wrapper_724::
  jp $30da
Wrapper_727::
  call $3195
  rst $18
  ret
WrapPutString::
  call PutString
  ret
Wrapper_730::
  call $3600
  rst $18
  ret
Wrapper_735::
  ld a, $0b
  rst $10
  rst $18
  ret
  nop
  nop
Wrapper_73c::
  ld a, $1b
  rst $10
  call $606f
  rst $18
  ret
  nop
  nop
Wrapper_746::
  ld a, $02
  rst $10
  call $7b9b
  rst $18
  ret
  nop
  nop
Wrapper_750::
  push af
  ld a, $02
  rst $10
  pop af
  call $7685
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_75e::
  call Func_3117
  rst $18
  ret
Wrapper_763::
  call $3155
  rst $18
  ret
Wrapper_768::
  call MedalScreenLoadMedalIcons
  rst $18
  ret
Wrapper_76d::
  call $32ed
  ret
WrapLoadMedalList::
  call LoadMedalList
  rst $18
  ret
Wrapper_776::
  call $330e
  ret
Wrapper_77a::
  call $3480
  rst $18
  ret
Wrapper_77f::
  call $34b5
  rst $18
  ret
WrapPadTextTo8::
  call PadTextTo8
  ret
Wrapper_788::
  call $34d8
  rst $18
  ret
Wrapper_78d::
  call LoadPartList
  rst $18
  ret
Wrapper_792::
  call $356a
  rst $18
  ret
Wrapper_797::
  call $35a6
  rst $18
  ret
Wrapper_79c::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  call $7702
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_7b5::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $4c81
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_7d0::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $77e0
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
WrapMedarotScreenSetupMedarotSelect::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $2
  rst $10
  ld [$c6e0], a
  pop af
  call MedarotScreenSetupMedarotSelect
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_806::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7bea
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_821::
  push af
  ld a, $02
  rst $10
  pop af
  call $4351
  rst $18
  ret
  nop
  nop
Wrapper_82d::
  push af
  ld a, $02
  rst $10
  pop af
  call $445f
  rst $18
  ret
  nop
  nop
Wrapper_839::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7bc6
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_854::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7c01
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
WrapGetListTextOffset::
  call GetListTextOffset
  ret
Wrapper_873::
  call $35bb
  rst $18
  ret
WrapLoadMedarotList::
  call LoadMedarotList
  rst $18
  ret
Wrapper_87d::
  ld a, $02
  rst $10
  call $7bb9
  rst $18
  ret
  nop
  nop
Wrapper_887::
  call $363e
  rst $18
  ret
Wrapper_88c::
  call $36e1
  rst $18
  ret
Wrapper_891::
  call $37af
  rst $18
  ret
Wrapper_896::
  push af
  ld a, $05
  rst $10
  pop af
  rst $18
  ret
  nop
  nop
Wrapper_89f::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6098
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_8ad::
  push af
  ld a, $1b
  rst $10
  pop af
  call $60e0
  rst $18
  ret
  nop
  nop
Wrapper_8b9::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $79b4
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_8d4::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7a15
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_8ef::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $6db7
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
WrapLoadMedarotPartSelectSetupPartScreen::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $2
  rst $10
  ld [$c6e0], a
  pop af
  call LoadMedarotPartSelectSetupPartScreen
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_925::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6188
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_933::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6214
  rst $18
  ret
  nop
  nop
Wrapper_93f::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6386
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_94d::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  pop af
  call $63c9
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_968::
  call $37cd
  rst $18
  ret
Wrapper_96d::
  call $37fc
  rst $18
  ret
WrapPutShopString::
  call PutShopString
  rst $18
  ret
Wrapper_977::
  call $382d
  rst $18
  ret
Wrapper_97c::
  call $333e
  rst $18
  ret
Wrapper_981::
  call $38f8
  rst $18
  ret
Wrapper_986::
  ld a, $03
  rst $10
  call $406f
  rst $18
  ret
Wrapper_98e::
  call $3d68
  ret
Wrapper_992::
  ld a, $03
  rst $10
  call $538b
  rst $18
  ret
Wrapper_99a::
  jp $3db1
Wrapper_99d::
  call $3926
  rst $18
  ret
Wrapper_9a2::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6153
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_9b0::
  push af
  ld a, $1b
  rst $10
  pop af
  call $62b6
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_9be::
  push af
  ld a, $1b
  rst $10
  pop af
  call $64a3
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_9cc::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7c47
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_9e7::
  ret
Wrapper_9e8::
  push af
  ld a, $01
  rst $10
  pop af
  call $6bd1
  rst $18
  ret
Wrapper_9f2::
  push af
  ld a, $1b
  rst $10
  pop af
  call $6422
  rst $18
  ret
  nop
  nop
Wrapper_9fe::
  push af
  ld a, $01
  rst $10
  pop af
  call $7715
  rst $18
  ret
  nop
  nop
Wrapper_a0a::
  ld a, $03
  rst $10
  call $4bfc
  rst $18
  ret
Wrapper_a12::
  ld a, $03
  rst $10
  call $4c92
  rst $18
  ret
Wrapper_a1a::
  ld a, [$c7f1]
  and $3f
  cp $02
  jp z, $a27
  jp $a3b
Wrapper_a27::
  ld a, [$c7f0]
  ld e, a
  ld a, [$c7f1]
  and $3f
  sub $02
  ld d, a
  ld hl, $4000
  ld a, $16
  jp $a4a
Wrapper_a3b::
  ld a, [$c7f0]
  ld e, a
  ld a, [$c7f1]
  and $3f
  ld d, a
  ld hl, $4000
  ld a, $13
  rst $10
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c7f5]
  ld d, $00
  ld e, a
  add hl, de
  inc a
  ld [$c7f5], a
  ld a, [hl]
  push af
  rst $18
  pop af
  ret
Wrapper_a63::
  ld a, $03
  rst $10
  call $4c6f
  rst $18
  ret
Wrapper_a6b::
  call $2faa
  rst $18
  ret
Wrapper_a70::
  call $39da
  rst $18
  ret
Wrapper_a75::
  push af
  ld a, $03
  rst $10
  pop af
  call $4d83
  rst $18
  ret
Wrapper_a7f::
  push af
  ld a, $1b
  rst $10
  pop af
  call $64e6
  push af
  rst $18
  pop af
  ret
  nop
  nop
Wrapper_a8d::
  push af
  ld a, $1b
  rst $10
  pop af
  call $651a
  rst $18
  ret
  nop
  nop
Wrapper_a99::
  ld a, $03
  rst $10
  call $4edf
  rst $18
  ret
  nop
  nop
Wrapper_aa3::
  ld a, BANK(SGB_SendConstructedPaletteSetPacket)
  rst $10
  call SGB_SendConstructedPaletteSetPacket
  rst $18
  ret
Wrapper_aab::
  ld a, $03
  rst $10
  call $53f9
  rst $18
  ret
Wrapper_ab3::
  ld a, $03
  rst $10
  call $5410
  rst $18
  ret
Wrapper_abb::
  ld a, $02
  rst $10
  call $52a5
  rst $18
  ret
  nop
  nop
Wrapper_ac5::
  call $3a7d
  rst $18
  ret
Wrapper_aca::
  call $3a9d
  rst $18
  ret
Wrapper_acf::
  call $3ac8
  rst $18
  ret
Wrapper_ad4::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $01
  rst $10
  ld [$c6e0], a
  pop af
  call $677c
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_aef::
  call $3942
  rst $18
  ret
Wrapper_af4::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $6590
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
WrapRobattleSetupPrepScreenCopy::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, BANK(RobattleLoadMedarotNamesCopy)
  rst $10
  ld [$c6e0], a
  call $6b3f
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_b26::
  ld a, $02
  rst $10
  call $7dc7
  rst $18
  ret
  nop
  nop
Wrapper_b30::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  call $7deb
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_b49::
  ld a, $02
  rst $10
  call $7efa
  rst $18
  ret
  nop
  nop
Wrapper_b53::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $704e
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_b6c::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $743e
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_b85::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $7389
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_b9e::
  ld a, $1b
  rst $10
  call $74e7
  rst $18
  ret
  nop
  nop
Wrapper_ba8::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $7629
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_bc1::
  ld a, $1b
  rst $10
  call $77b9
  rst $18
  ret
  nop
  nop
Wrapper_bcb::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $7456
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
Wrapper_be4::
  call $3adc
  rst $18
  ret
Wrapper_be9::
  ld a, $07
  rst $10
  call $60b2
  rst $18
  ret
  nop
  nop
Wrapper_bf3::
  ld a, $1b
  rst $10
  call $77e1
  rst $18
  ret
  nop
  nop
Wrapper_bfd::
  push af
  ld a, $01
  rst $10
  pop af
  call $74eb
  rst $18
  ret
  nop
  nop

SECTION "Wrappers 2", ROM0[$0449]
Wrapper_630_Alt::
  call $1ab0
  rst $18
  ret
