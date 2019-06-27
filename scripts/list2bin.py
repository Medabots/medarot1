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
		utils.read_table("scripts/res/dakuten.tbl", reverse=True)
	])

	with open(output_file, 'wb') as o, open(input_file, 'r', encoding="utf-8") as i:
		length,term,padbyte = (int(x) if x.isdigit() else literal_eval(x) for x in i.readline().split("|"))
		char_table['\n'] = term

		line = i.readline()
		while line:
			for l in length if isinstance(length, tuple) else (length,):
				o.write(bytearray(utils.txt2bin(line, char_table, pad=l, padbyte=padbyte)))
				line = i.readline()
