SECTION "CopyVRAMData", ROM0[$CB7]
CopyVRAMData: ;  cb7
	ld a, [hli]
	di
	call CopyVRAMData_Sub
	ld [de], a
	ei
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyVRAMData ; 0xcc2 $f3
	ret
; 0xcc5

SECTION "CopyVRAMData_Sub", ROM0[$17cb]
CopyVRAMData_Sub: ; 17cb (0:17cb)
	push af
.asm_17cc
	ld a, [$ff41]
	and $02
	jr nz, .asm_17cc
	pop af
	ret
; 0x17d4
