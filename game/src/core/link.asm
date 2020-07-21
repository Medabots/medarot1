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
  jr .return

.packetXfrMode
  ld a, 1
  ld [SerIO_DoingXfer], a
  ldh a, [hRegSB]
  ld [SerIO_DriverInByte], a
  add hl, de
  ld a, [SerIO_DriverOutByte]
  ldh [hRegSB], a
  ld bc, $20
  call SerIO_Wait
  ld a, $80
  ldh [hRegSC], a
  xor a
  ld [SerIO_TransferLocationOffset], a
  ld [SerIO_DoingXfer], a
  call $3F88
  call $3F4A

.return
  pop hl
  pop de
  pop bc
  pop af
  reti

.end
REPT $3EB5 - .end
  nop
ENDR

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
