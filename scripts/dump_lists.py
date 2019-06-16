#!/bin/python

# Script to dump pointer-less lists (ptr lists are a bit different)
# Shouldn't need to be run more than once, just here for reference

import os, sys

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

list_map = ({
	# 'Type' : (Ptr, Total Length, Number of Items)
	'Items' : ((0x17, 0x5af0), 16, 38),
	'Medals' : ((0x17, 0x5d50), 0x8, 28),
})

tileset = utils.merge_dicts([utils.read_table("scripts/res/tileset_03.tbl"), utils.read_table("scripts/res/tileset_02.tbl"), utils.read_table("scripts/res/dakuten.tbl")])
with open("baserom.gbc", "rb") as rom:
	for l in list_map:
		addr = list_map[l][0]
		length = list_map[l][1]
		n = list_map[l][2]
		if isinstance(addr, tuple):
			addr = utils.rom2realaddr(addr)
		rom.seek(addr)
		with open('text/lists/{}.txt'.format(l), 'w', encoding = "utf-8") as output:
			for b in zip(*[iter([utils.read_byte(rom) for i in range(0, n * length)])]*length):
				output.write("{}\n".format("".join(utils.bin2txt(b, tileset))))