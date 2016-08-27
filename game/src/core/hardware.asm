SECTION "vblank",ROM0[$40] ; vblank interrupt
	jp $049b

SECTION "lcd",ROM0[$48] ; lcd interrupt
	jp $04d0

SECTION "timer",ROM0[$50] ; timer interrupt
	nop

SECTION "serial",ROM0[$58] ; serial interrupt
	jp $3e12

SECTION "joypad",ROM0[$60] ; joypad interrupt
	reti

SECTION "WaitLCDController", ROM0[$17cb]
WaitLCDController:: ; 17cb (0:17cb)
	push af
.asm_17cc
	ld a, [hLCDStat]
	and $02
	jr nz, .asm_17cc
	pop af
	ret
; 0x17d4
