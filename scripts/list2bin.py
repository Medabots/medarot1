#!/bin/python

import os, sys
from ast import literal_eval
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
	input_file = sys.argv[1]
	output_file = sys.argv[2]
	version_suffix = sys.argv[3]

	# This is actually a hack with how lists work
	# TODO: Tilesets are probably going to vary between lists, so this may break in the future
	char_table = utils.merge_dicts([
		utils.read_table("scripts/res/tileset_MainDialog.tbl", reverse=True), 
		utils.read_table("scripts/res/tileset_MainSpecial.tbl", reverse=True),
		utils.read_table("scripts/res/tileset_MenuText.tbl", reverse=True),
		utils.read_table("scripts/res/dakuten.tbl", reverse=True),
	])

	char_table2 = utils.merge_dicts([
		char_table,
		utils.read_table("scripts/res/tileset_BoldLetters.tbl", reverse=True)
	])

	with open(output_file, 'wb') as o, open(input_file, 'r', encoding="utf-8") as i:
		length,term,padbyte = (int(x) if x.isdigit() else literal_eval(x) for x in i.readline().split("|"))
		char_table['\n'] = term
		char_table2['\n'] = term

		prefix = "[{}]".format(version_suffix)
		line = i.readline()
		while line:
			for x,l in enumerate(length) if isinstance(length, tuple) else enumerate((length,)):
				if not line.startswith("[") or line.startswith(prefix):
					line = line.replace(prefix,"") # Not the best way to do it, but it's good enough
					o.write(bytearray(utils.txt2bin(line, char_table if x == 0 else char_table2, pad=l, padbyte=padbyte)))
				line = i.readline()
