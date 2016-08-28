SECTION "CopyVRAMData", ROM0[$CB7]
;CopyVRAMData (copy with LCD interrupt)
; hl - address to copy from
; de - address to copy to
; bc - length
CopyVRAMData:: ;  cb7
	ld a, [hli]
	di
	call WaitLCDController
	ld [de], a
	ei
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyVRAMData ; 0xcc2 $f3
	ret
; 0xcc5
