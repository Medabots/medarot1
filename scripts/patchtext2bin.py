#!/bin/python

import os, sys
from ast import literal_eval
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
	input_file = sys.argv[1]
	output_file = sys.argv[2]

	char_table = utils.merge_dicts([
		utils.read_table("scripts/res/tileset_MainDialog.tbl", reverse=True), 
		utils.read_table("scripts/res/tileset_MainSpecial.tbl", reverse=True),
	])
	char_table['\n'] = 0x49

	try:
		with open(output_file, 'wb') as o, open(input_file, 'r', encoding="utf-8") as i:
			for line in i:
				assert(len(line) <= 0xFF)
				o.write(bytearray(utils.txt2bin(line, char_table)))
			o.write(bytearray([0x50]))
	except:
		try:
		    os.remove(output_file)
		except OSError:
		    pass