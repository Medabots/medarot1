#!/bin/python

# Script to initially dump tilemaps, shouldn't really need to be run anymore, and is mainly here as a reference

import os, sys
import json
from functools import partial

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilemaps

table = utils.read_table("scripts/res/medarot.tbl")

# tilemap bank is 1e (0x78000)
BANK_SIZE = 0x4000
BASE_ADDR = 0x78000
MAX_ADDR = BASE_ADDR + BANK_SIZE - 1

tilemap_ptr = {}
tilemap_bytes = {}
tilemap_files = {}
with open("baserom.gbc", "rb") as rom:
    rom.seek(BASE_ADDR)
    for i in range(0xf0):
        tilemap_ptr[i] = utils.read_short(rom)

    with open("scripts/res/tilemaps.tbl", "w+") as ptrfile:
        for i in sorted(tilemap_ptr):
            ptr = tilemap_ptr[i]
            addr = BASE_ADDR + ptr - BANK_SIZE
            rom.seek(addr)
            compressed = utils.read_byte(rom)
            assert compressed in [0x0, 0x1], "Unexpected compression byte 0x{:02x}".format(compressed)
            print("{:02x} @ [{:04X} / {:08X}] {} | ".format(i, ptr, rom.tell()-1, "Compressed" if compressed else "Uncompressed"), end="")
            tilemap_bytes[i] = list(iter(partial(utils.read_byte, rom), 0xFF)) # Read ROM until 0xFF
            # tilemaps are all adjacent to each other, so we don't need to do anything more than make sure they're sorted
            fname = "Tilemap_{:04X}".format(ptr)
            txt_path = "text/tilemaps/{}.txt".format(fname)
            tmap_path = "game/tilemaps/{}.tmap".format(fname)
            if not os.path.isfile(tmap_path):
                with open(tmap_path, "wb") as binary, open(txt_path, "w", encoding = "utf-8") as output:
                    binary.write(bytearray([compressed] + tilemap_bytes[i] + [0xFF]))
                    if compressed:
                        output.write("[DIRECT]\n")
                        tilemap_bytes[i] = tilemaps.decompress_tilemap(tilemap_bytes[i])
                    else:
                        output.write("[OVERLAY]\n")
                    output.write("".join(tilemaps.dump_tilemap(tilemap_bytes[i], table)))
                print("total length 0x{:02x}".format(len(tilemap_bytes[i])))
            else:
                print("Duplicate")
            ptrfile.write("{:02X}={}\n".format(i, fname))