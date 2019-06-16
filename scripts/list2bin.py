#!/bin/python

import os, sys
from shutil import copyfile
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    char_table = utils.merge_dicts([utils.read_table("scripts/res/tileset_03.tbl", reverse=True), utils.read_table("scripts/res/tileset_02.tbl", reverse=True), utils.read_table("scripts/res/dakuten.tbl", reverse=True)])

    with open(output_file, 'wb') as o, open(input_file, 'r', encoding="utf-8") as i:
    	for line in i:
    	   	o.write(bytearray(utils.txt2bin(line.strip('\n').strip('\r'), char_table)))