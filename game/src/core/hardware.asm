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
