INCLUDE "game/src/common/constants.asm"

SECTION "SGB Functions 1", ROMX[$4000], BANK[$1F]
SGB_InstallBorderAndHotpatches::
    ld bc, $78
    call SGB_AdjustableWait

    ld hl, SGB_PacketFreezeScreen
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait

    ld hl, SGB_PacketHotfix + ($10 * 0)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 1)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 2)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 3)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 4)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 5)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 6)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait
    ld hl, SGB_PacketHotfix + ($10 * 7)
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait

    ld hl, $4320
    ld de, SGB_PacketPaletteTransfer
    call SGB_SendPacketsWithVRAM

    ld hl, $44E8
    ld de, SGB_PacketAttrTransfer
    call SGB_SendPacketsWithVRAM

    ld hl, $49D4
    ld de, SGB_PacketTileTransferLow
    call SGB_SendPacketsWithVRAM

    ld hl, $59D4
    ld de, SGB_PacketTileTransferHigh
    call SGB_SendPacketsWithVRAM

    ld hl, $69D4
    ld de, SGB_PacketBorderTmapTransfer
    call SGB_SendPacketsWithVRAM

    ld hl, SGB_PacketUnfreezeScreen
    call SGB_SendPackets

    ld bc, $40
    call SGB_AdjustableWait

    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    ld a, 0
    jp JumpTable_309

SGB_ReinstallBorder::
    ld hl, SGB_PacketFreezeScreen
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait

    ld hl, $49D4
    ld de, SGB_PacketTileTransferLow
    call SGB_SendPacketsWithVRAM

    ld hl, $59D4
    ld de, SGB_PacketTileTransferHigh
    call SGB_SendPacketsWithVRAM

    ld hl, $69D4
    ld de, SGB_PacketBorderTmapTransfer
    call SGB_SendPacketsWithVRAM

    ld hl, SGB_PacketUnfreezeScreen
    call SGB_SendPackets
    ld bc, $20
    call SGB_AdjustableWait
    ret

SGB_EnableDefaultScreenAttributes::
    ld hl, SGB_PacketFreezeScreen
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait

    ld hl, SGB_PacketSetDefaultPaletteAttrs
    call SGB_SendPackets
    ld bc, 4
    call SGB_AdjustableWait

    ret

SGB_SendConstructedPaletteSetPacket::
    ld hl, $C8D0
    call SGB_SendPackets
    ld bc, 3
    call SGB_AdjustableWait
    ret

SGB_PacketSetDefaultPaletteAttrs::
    db $51          ;PAL_SET
    dw 0,0,0,0      ;Use all palette 0
    db $C2          ;Use attribute file $2, unfreeze screen
    db 0,0,0,0,0,0

SGB_AdjustableWait::
    ld de, $6D6

.wasteCycles
    nop
    nop
    nop
    dec de

    ld a, d
    or e
    jr nz, .wasteCycles

    dec bc
    ld a, b
    or c
    jr nz, SGB_AdjustableWait
    ret

SGB_SendPackets::
    ld a, [hl]
    and 7
    ret z

    ld b, a
    ld c, 0

.beginPacket
    push bc

    ld a, 0
    ld [c], a
    ld a, $30
    ld [c], a

    ld b, $10

.beginByte
    ld e, 8

    ld a, [hli]
    ld d, a

.beginBit
    bit 0, d
    ld a, $10
    jr nz, .sendOneBit

.sendZeroBit
    ld a, $20

.sendOneBit
    ld [c], a

    ld a, $30
    ld [c], a

    rr d
    dec e
    jr nz, .beginBit

    dec b
    jr nz, .beginByte

    ld a, $20
    ld [c], a
    ld a, $30
    ld [c], a

    pop bc
    dec b
    ret z

.nextPacket
    call SGB_FrameWait
    jr .beginPacket

SGB_SendPacketsWithVRAM::
    di

    push de
    call JumpTable_192
    ld a, $E4
    ldh [hRegBGP], a

    ld de, $8800
    ld bc, $1000
    call SGB_CopyVRAMPacketData

    ld hl, $9800
    ld de, $C
    ld a, $80
    ld c, $D

.drawLine
    ld b, $14

.drawTile
    ld [hli], a
    inc a
    dec b
    jr nz, .drawTile

    add hl, de
    dec c
    jr nz, .drawLine

    ld a, $81
    ldh [hRegLCDC], a

    ld bc, 5
    call SGB_AdjustableWait

    pop hl
    call SGB_SendPackets
    ld bc, 6
    call SGB_AdjustableWait

    ei

    ret

SGB_CopyVRAMPacketData::
    ld a, [hli]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, SGB_CopyVRAMPacketData
    ret

SGB_DetectICDPresence::
    ld hl, SGB_PacketEnableMultiplayer
    call SGB_SendPackets
    call SGB_FrameWait

    ldh a, [hRegJoyp]
    and 3
    cp 3
    jr nz, .sgbNotDetected

.secondarySgbCheck
    ld a, $20
    ldh [hRegJoyp], a

    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]

    ld a, $30
    ldh [hRegJoyp], a
    ld a, $10
    ldh [hRegJoyp], a

    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]

    ld a, $30
    ldh [hRegJoyp], a

    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]
    ldh a, [hRegJoyp]

    and 3
    cp 3
    jr nz, .sgbNotDetected

.sgbDetected
    ld hl, SGB_PacketDisableMultiplayer
    call SGB_SendPackets
    call SGB_FrameWait
    sub a
    ret

.sgbNotDetected
    ld hl, SGB_PacketDisableMultiplayer
    call SGB_SendPackets
    call SGB_FrameWait
    scf
    ret

SGB_PacketDisableMultiplayer::
    db $89
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketEnableMultiplayer::
    db $89
    db 1
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_FrameWait::
    ld de, $1B58

.wasteCycles
    nop
    nop
    nop

    dec de
    ld a, d
    or e
    jr nz, .wasteCycles

    ret

SGB_PacketPaletteTransfer::
    db $59
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketTileTransferLow::
    db $99
    db 0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketTileTransferHigh::
    db $99
    db 1
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketBorderTmapTransfer::
    db $A1
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketAttrTransfer::
    db $A9
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketUnfreezeScreen::
    db $B9
    db 0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketFreezeScreen::
    db $B9
    db 1
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketHotfix::
    db $79
    dw $085D
    db 0
    db $B
    db $8C, $D0, $F4, $60, 0, 0, 0, 0, 0, 0, 0

    db $79
    dw $0852
    db 0
    db $B
    db $A9, $E7, $9F, $01, $C0, $7E, $E8, $E8, $E8, $E8, $E0

    db $79
    dw $0847
    db 0
    db $B
    db $C4, $D0, $16, $A5, $CB, $C9, $05, $D0, $10, $A2, $28

    db $79
    dw $083C
    db 0
    db $B
    db $F0, $12, $A5, $C9, $C9, $C8, $D0, $1C, $A5, $CA, $C9

    db $79
    dw $0831
    db 0
    db $B
    db $0C, $A5, $CA, $C9, $7E, $D0, $06, $A5, $CB, $C9, $7E

    db $79
    dw $0826
    db 0
    db $B
    db $39, $CD, $48, $0C, $D0, $34, $A5, $C9, $C9, $80, $D0

    db $79
    dw $081B
    db 0
    db $B
    db $EA, $EA, $EA, $EA, $EA, $A9, $01, $CD, $4F, $0C, $D0

    db $79
    dw $0810
    db 0
    db $B
    db $4C, $20, $08, $EA, $EA, $EA, $EA, $EA, $60, $EA, $EA
