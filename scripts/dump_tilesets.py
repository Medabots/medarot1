#!/bin/python

# Script to initially dump tilesets
# TODO: Should modify this to not overwrite changes, but for now we just don't add it to 'make dump'

import os, sys
from functools import partial

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

tiletable = 0x10f0
count = 51
with open("baserom.gbc", "rb") as rom, open("game/src/gfx/tileset_table.asm", "w") as output:
	rom.seek(tiletable)
	ptrs = [utils.read_short(rom) for i in range(0, count)]
	data = {}
	for ptr in ptrs:
		rom.seek(ptr) # Bank 0, no need to convert addresses
		# (Bank, Pointer, VRAM Offset)
		data[ptr] = (utils.read_byte(rom), utils.read_short(rom), utils.read_short(rom))
	output.write('SECTION "Tileset Table", ROM0[${:04X}]\n'.format(tiletable))
	output.write('TilesetTable:\n')
	for i in ptrs:
		output.write("  dw TilesetInfo{:04X}\n".format(i))
	with open("game/src/gfx/tileset_files.asm", "w") as outputf:
		for ptr in sorted(data):
			with open("game/tilesets/{:04X}.malias".format(ptr),"wb") as compressed, open("game/tilesets/{:04X}.2bpp".format(ptr),"wb") as uncompressed:
				f = tilesets.decompress_tileset(rom, utils.rom2realaddr((data[ptr][0],data[ptr][1])))
				uncompressed.write(bytearray(f[0]))
				compressed.write(bytearray(f[1]))
				output.write('SECTION "TilesetInfo ${0:04X}", ROM0[${0:04X}]\n'.format(ptr))
				output.write("TilesetInfo{:04X}:\n".format(ptr))
				output.write('  dbww BANK(Tileset{0:04X}), Tileset{0:04X}, ${1:04X}\n'.format(ptr, data[ptr][2]))
				outputf.write('SECTION "Tileset Data ${0:04X}", ROMX[${1:04X}], BANK[${2:02X}]\n'.format(ptr, data[ptr][1], data[ptr][0]))
				outputf.write("Tileset{:04X}:\n".format(ptr))
				outputf.write('  INCBIN "game/tilesets/{:04X}.malias"\n'.format(ptr))
