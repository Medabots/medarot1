INCLUDE "game/src/common/constants.asm"

SECTION "SerIO Variables", WRAMX[$DA00], BANK[$1]
SerIO_PacketType:: ds 1
SerIO_Connected:: ds 1
SerIO_NumConnectionPackets:: ds 1
SerIO_TransferLocationOffset:: ds 1
SerIO_DoingXfer:: ds 1
SerIO_State:: ds 1
SerIO_ShadowREG_SB:: ds 1
SerIO_IdleCounter:: ds 1

SECTION "SerIO Variables 2", WRAMX[$DA11], BANK[$1]
SerIO_DriverInByte:: ds 1

SECTION "SerIO Variables 3", WRAMX[$DA20], BANK[$1]
SerIO_DriverOutByte:: ds 1

SECTION "Connection Test Variables", WRAM0[$C64E]
SerIO_ConnectionTestResult:: ds 1

SECTION "SerIO IRQ",  ROM0[$3E12]
SerIO_IRQ::
  push af
  push bc
  push de
  push hl
  xor a
  ld [SerIO_IdleCounter], a

  ld a, [SerIO_State]
  and a
  jr nz, .packetXfrMode

  ld a, [SerIO_ShadowREG_SB]
  and a
  jr z, .sendNull

  ldh a, [hRegSB]
  cp $DD
  jr z, .gotConnectPacket

  cp $FE
  jr z, .jpA

  xor a
  ld [SerIO_PacketType], a
  ld a, $DD
  ldh [hRegSB], a
  ld a, $80
  ldh [hRegSC], a
  jp .return

.gotConnectPacket
  ld a, 1
  ld [SerIO_PacketType], a
  ld [SerIO_Connected], a

.jpA
  ld a, 1
  ld [SerIO_State], a
  ld a, [SerIO_NumConnectionPackets]
  inc a
  ld [SerIO_NumConnectionPackets], a

.sendNull
  xor a
  ldh [hRegSB], a
  ld a, $80
  ldh [hRegSC], a
  jp .return

; This makes no fucking sense. Obviously this is meant to buffer a number of bytes of transferred data at a time, but SerIO_NumConnectionPackets is always 1, so the buffer length is always 1. It may be that $FE plays into this, but it is never used to my knowledge.

.packetXfrMode
  ld a, 1
  ld [SerIO_DoingXfer], a
  ld a, [SerIO_PacketType]
  xor 1
  ld [SerIO_PacketType], a
  ld hl, SerIO_DriverInByte
  ld a, [SerIO_TransferLocationOffset]
  ld e, a
  xor a
  ld d, a
  add hl, de
  ldh a, [hRegSB]
  ld [hl], a
  ld hl, SerIO_DriverOutByte
  add hl, de
  ld a, [hl]
  ldh [hRegSB], a
  ld a, $80
  ldh [hRegSC], a
  ld a, [SerIO_TransferLocationOffset]
  inc a
  ld [SerIO_TransferLocationOffset], a
  ld b, a
  ld a, [SerIO_NumConnectionPackets]
  cp b
  jp nz, .doWait
  xor a
  ld [SerIO_TransferLocationOffset], a
  ld [SerIO_DoingXfer], a
  call $3F88
  call $3F4A
  jr .return

.doWait
  ld a, [SerIO_PacketType]
  and a
  jr z, .return
  ld bc, $1A
  call SerIO_Wait
  ld a, $81
  ldh [hRegSC], a

.return
  pop hl
  pop de
  pop bc
  pop af
  reti

SECTION "SerIO Functions",  ROM0[$3EF8]
SerIO_SendConnectPacket::
  ld a, [SerIO_State]
  and a
  ret nz
  ld a, $DD
  ldh [hRegSB], a
  ld [SerIO_ShadowREG_SB], a
  ld a, $80
  ldh [hRegSC], a
  ret

SerIO_Wait::
  dec bc
  ld a, b
  or c
  jr nz, SerIO_Wait
  ret
