#!/bin/python

import os, sys
from ast import literal_eval
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
	input_file = sys.argv[1]
	output_file = sys.argv[2]

	prefix = os.path.splitext(os.path.basename(input_file))[0]

	char_table = utils.merge_dicts([
		utils.read_table("scripts/res/tileset_MainDialog.tbl", reverse=True), 
		utils.read_table("scripts/res/tileset_MainSpecial.tbl", reverse=True), 
		utils.read_table("scripts/res/dakuten.tbl", reverse=True)
	])

	with open(input_file, 'r', encoding="utf-8") as i, open(output_file, 'w') as o:
		term, = (int(x) if x.isdigit() else literal_eval(x) for x in i.readline().strip().split("|"))
		char_table['\n'] = term
		ptrs = []
		for n, line in enumerate(i):
			ptrs.append(("{}_{:02X}".format(prefix, n),", ".join("${:02X}".format(x) for x in utils.txt2bin(line, char_table))))
		o.write("".join("dw {}\n".format(ptr[0]) for ptr in ptrs))

		for ptr in ptrs:
			o.write("{}:\n".format(ptr[0]))
			o.write("  db {}\n".format(ptr[1]))