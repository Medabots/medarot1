#!/bin/python

# Script to initially dump tilemaps, shouldn't really need to be run anymore, and is mainly here as a reference

import os, sys
from functools import partial

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilemaps

# tilemap bank is 1e (0x78000)
BANK_SIZE = 0x4000
BASE_ADDR = 0x78000
MAX_ADDR = BASE_ADDR + BANK_SIZE - 1

tilemap_ptr = {}
tilemap_bytes = {}
tilemap_files = []
with open("baserom.gbc", "rb") as rom:
    rom.seek(BASE_ADDR)
    for i in range(0xf0):
        tilemap_ptr[i] = utils.read_short(rom)

    ptrfile = None
    if os.path.exists("scripts/res/tilemap_files.tbl"):
        ptrtable = utils.read_table("scripts/res/tilemap_files.tbl")
    else:
        ptrfile = open("scripts/res/tilemap_files.tbl","w")

    # Load previously generated/manually written tilemap <-> tileset mapping
    tileset_file = None
    tilesets = {}
    tiletables = {}
    tileset_default = utils.read_table("scripts/res/tileset_03.tbl")
    if os.path.exists("scripts/res/tilesets.tbl"):
        tilesets = utils.read_table("scripts/res/tilesets.tbl", keystring=True)
        for fname in tilesets:
            if tilesets[fname] not in tiletables:
                tiletables[tilesets[fname]] = utils.merge_dicts([utils.read_table(tbl) for tbl in tilesets[fname].split(",")])
                tiletables[tilesets[fname]][0xFE] = '\n' # 0xFE is a special control code for a new line, not really a tile
    else:
        tileset_file = open("scripts/res/tilesets.tbl","w")

    try:
        for i in sorted(tilemap_ptr):
            ptr = tilemap_ptr[i]
            addr = BASE_ADDR + ptr - BANK_SIZE
            rom.seek(addr)
            compressed = utils.read_byte(rom)
            assert compressed in [0x0, 0x1], "Unexpected compression byte 0x{:02x}".format(compressed)
            print("{:02x} @ [{:04X} / {:08X}] {} | ".format(i, ptr, rom.tell()-1, "Compressed" if compressed else "Uncompressed"), end="")
            tilemap_bytes[i] = list(iter(partial(utils.read_byte, rom), 0xFF)) # Read ROM until 0xFF
            # tilemaps are all adjacent to each other, so we don't need to do anything more than make sure they're sorted
            fname = "Tilemap_{:04X}".format(ptr) if i not in ptrtable else ptrtable[i]
            txt_path = "text/tilemaps/{}.txt".format(fname)

            if not fname in tilemap_files:
                tilemap_files.append(fname)
                with open(txt_path, "w", encoding = "utf-8") as output:
                    # We can rebuild every non-compressed tilemap, but we need to keep every compressed one until we figure out the compression algorithm
                    if compressed:
                        tmap_path = "game/tilemaps/{}.tmap".format(fname)
                        with open(tmap_path, "wb") as binary:
                            binary.write(bytearray([compressed] + tilemap_bytes[i] + [0xFF]))
                        output.write("[DIRECT]\n")
                        tilemap_bytes[i] = tilemaps.decompress_tilemap(tilemap_bytes[i])
                    else:
                        output.write("[OVERLAY]\n")
                    # Assume tilesets[fname] in tiletables if fname is in tilesets
                    output.write("".join(utils.bin2txt(tilemap_bytes[i], tiletables[tilesets[fname]] if fname in tilesets else tileset_default)))
                print("total length 0x{:02x}".format(len(tilemap_bytes[i])))
            else:
                print("Duplicate")
            if ptrfile:
                ptrfile.write("{:02X}={}\n".format(i, fname))
            if tileset_file:
                tileset_file.write("{}=scripts/res/tileset_03.tbl\n".format(fname))
    finally:
        if ptrfile:
            ptrfile.close()
        if tileset_file:
            tileset_file.close()