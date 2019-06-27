#!/bin/python

# Script to dump text lists with pointers
# We make an assumption that objects will be adjacent to each other

import os, sys
from functools import partial
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

list_map = ({
	# 'Type' : (Start of Pointers, Terminator, Number of Items)
	'PartTypes' : ((0x1, 0x750b), 0x50, 4),
})

tileset = utils.merge_dicts([utils.read_table("scripts/res/tileset_MainDialog.tbl"), utils.read_table("scripts/res/tileset_MainSpecial.tbl"), utils.read_table("scripts/res/dakuten.tbl")])
with open("baserom.gbc", "rb") as rom:
	for l in list_map:
		addr, term, n = list_map[l]
		if isinstance(addr, tuple):
			bank = addr[0]
			addr = utils.rom2realaddr(addr)
		else:
			bank = utils.real2romaddr(addr)[0]
		rom.seek(addr)
		with open('text/ptrlists/{}.txt'.format(l), 'w', encoding = "utf-8") as output:
			output.write("{}\n".format(term))
			ptrs = [utils.read_short(rom) for i in range(0, n)]
			for ptr in ptrs:
				rom.seek(utils.rom2realaddr((bank, ptr)))
				b = list(iter(partial(utils.read_byte, rom), term))
				output.write("{}\n".format("".join(utils.bin2txt(bytearray(b), tileset))))