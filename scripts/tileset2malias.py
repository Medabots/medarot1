#!/bin/python

import os, sys
from shutil import copyfile
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    fname = os.path.splitext(os.path.basename(input_file))[0]

    prebuilt = "game/tilesets/{}.malias".format(fname)
    if os.path.isfile(prebuilt):
        print("\tUsing prebuilt {}".format(prebuilt))
        copyfile(prebuilt, output_file)
        os.utime(output_file, None)
        quit()
    
    with open(input_file, 'rb') as i:
        ba = bytearray(tilesets.compress_tileset(i))
        with open(output_file, 'wb') as o:
            o.write(ba)