#!/bin/python

import os, sys
from shutil import copyfile
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilemaps

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    fname = os.path.splitext(os.path.basename(input_file))[0]
    char_table = utils.merge_dicts([utils.read_table(tbl, reverse=True) for tbl in utils.read_table("scripts/res/tilesets.tbl", keystring=True)[fname].split(",")])
    
    prebuilt = "game/tilemaps/{}.tmap".format(fname)
    if os.path.isfile(prebuilt):
        print("\tUsing prebuilt {}".format(prebuilt))
        copyfile(prebuilt, output_file)
        os.utime(output_file, None)
        quit()
    
    with open(input_file, 'r', encoding='utf-8-sig') as f:
        mode = f.readline().strip()
        tmap = []
        if mode == '[DIRECT]':
            text = f.read().replace('\n','').replace('\r\n','')
            tmap = [0x01] + tilemaps.compress_tmap(utils.txt2bin(text, char_table))
        elif mode == '[OVERLAY]':
            text = f.read().replace('\r\n','\n')
            tmap = [0x00] + utils.txt2bin(text, char_table)
        else:
            raise TypeError("  Tilemap type is in an incorrect format")

        tmap.append(0xFF)
        with open(output_file, 'wb') as of:
            of.write(bytearray(tmap))