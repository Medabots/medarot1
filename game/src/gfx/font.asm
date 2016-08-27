SECTION "Load Font", ROM0[$2d85]
LoadFont::
	ld a, 3
	call DecompressTiles ; Decompress
	ret
