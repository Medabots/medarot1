#!/bin/python

# Script to initially dump tilesets

import os, sys
from functools import partial

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

nametable = {}
namefile = None
if os.path.exists("scripts/res/tileset_names.tbl"):
	nametable = utils.read_table("scripts/res/tileset_names.tbl")
else:
	namefile = open("scripts/res/tileset_names.tbl","w")

tiletable = 0x10f0
count = 51
with open("baserom_kabuto.gb", "rb") as rom, open("game/src/gfx/tileset_table.asm", "w") as output:
	rom.seek(tiletable)
	ptrs = [utils.read_short(rom) for i in range(0, count)]
	data = {}
	for ptr in ptrs:
		rom.seek(ptr) # Bank 0, no need to convert addresses
		# (Bank, Pointer, VRAM Offset, Name)
		if namefile: # We assume the table file not existing is fine
			nametable[ptr] = "{:04X}".format(ptr)
			namefile.write("{:04X}={}\n".format(ptr, nametable[ptr]))
		data[ptr] = (utils.read_byte(rom), utils.read_short(rom), utils.read_short(rom), nametable[ptr])
	output.write('SECTION "Tileset Table", ROM0[${:04X}]\n'.format(tiletable))
	output.write('TilesetTable:\n')
	for i in ptrs:
		output.write("  dw TilesetInfo{}\n".format(data[i][3]))
	output.write("TilesetTableEnd::\n");
	with open("game/src/gfx/tileset_files.asm", "w") as outputf:
		for ptr in sorted(data):
			with open("game/tilesets/{}.malias".format(data[ptr][3]),"wb") as compressed, open("text/tilesets/{}.2bpp".format(data[ptr][3]),"wb") as uncompressed:
				f = tilesets.decompress_tileset(rom, utils.rom2realaddr((data[ptr][0],data[ptr][1])))
				uncompressed.write(bytearray(f[0]))
				compressed.write(bytearray(f[1]))
				output.write('SECTION "TilesetInfo {0}", ROM0[${1:04X}]\n'.format(data[ptr][3], ptr))
				output.write("TilesetInfo{}:\n".format(data[ptr][3]))
				output.write('  dbww BANK(Tileset{0}), Tileset{0}, ${1:04X}\n'.format(data[ptr][3], data[ptr][2]))
				outputf.write('SECTION "Tileset Data {0}", ROMX[${1:04X}], BANK[${2:02X}]\n'.format(data[ptr][3], data[ptr][1], data[ptr][0]))
				outputf.write("Tileset{}:\n".format(data[ptr][3]))
				outputf.write("TilesetStart{}\n".format(data[ptr][3]))
				outputf.write('  INCBIN "build/tilesets/{}.malias"\n'.format(data[ptr][3]))
				outputf.write("TilesetEnd{}\n\n".format(data[ptr][3]))
		output.write("TilesetInfoEnd::\n");
