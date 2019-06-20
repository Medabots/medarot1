#!/bin/python

# Script to dump pointer-less lists (ptr lists are a bit different)
# Shouldn't need to be run more than once, just here for reference

import os, sys
from functools import partial
import struct
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

list_map = ({
	# 'Type' : (Ptr, Total Length, Terminator, PadByte, Number of Items, Struct Pack String)
	'Items' : ((0x17, 0x5af0), 0x10, 0x50, 0x0, 38, None),
	'Medals' : ((0x17, 0x5d50), 0x8, 0x50, 0x0, 28, None),
	'Medarots' : ((0x17,0x6c36), 0x10, 0x50, 0x0, 60, None),
	# Parts are [PartName:7+1][PartCode:7+1]
	'HeadParts' : ((0x1c, 0x65cc), 0x10, 0x50, 0x50, 60, '8B8B'),
	'RightParts' : ((0x1c, 0x698c), 0x10, 0x50, 0x50, 60, '8B8B'),
	'LeftParts' : ((0x1c, 0x6d4c), 0x10, 0x50, 0x50, 60, '8B8B'),
	'LegParts' : ((0x1c, 0x710c), 0x10, 0x50, 0x50, 60, '8B8B'),
})

tileset = utils.merge_dicts([utils.read_table("scripts/res/tileset_03.tbl"), utils.read_table("scripts/res/tileset_02.tbl"), utils.read_table("scripts/res/dakuten.tbl")])
with open("baserom.gbc", "rb") as rom:
	for l in list_map:
		addr, length, term, pad, n, fmt = list_map[l]
		if isinstance(addr, tuple):
			addr = utils.rom2realaddr(addr)
		rom.seek(addr)
		with open('text/lists/{}.txt'.format(l), 'w', encoding = "utf-8") as output:
			output.write("{},{},{},{}\n".format(length, term, pad, fmt if fmt else ""))
			for i in range(0, n):
				if fmt:
					unpack = struct.Struct(fmt).unpack_from
					b = unpack(rom.read(length))
				else:
					b = list(iter(partial(utils.read_byte, rom), term))
					rom.seek(length-len(b)-1,1) # Account for the terminator
				output.write("{}\n".format("".join(utils.bin2txt(bytearray(b), tileset))))