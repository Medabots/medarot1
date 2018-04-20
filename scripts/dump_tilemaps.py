#!/bin/python

import struct
from functools import partial
import os

def readshort(rom):
    return struct.unpack("<H", rom.read(2))[0]

def readbyte(rom):
    return struct.unpack("B", rom.read(1))[0]

def dump_tilemap(tilemap_bytes, table):
    tilemap = []
    for b in tilemap_bytes:
        if b in table:
            tilemap += table[b]
        else:
            tilemap += '\\x{:02X}'.format(b)
    return tilemap

table = {}
for line in open("scripts/res/medarot.tbl", encoding = "utf-8").readlines():
    if line.strip():
        a, b = line.strip('\n').split("=", 1)
        table[int(a, 16)] = b.replace("\\n", '\n')

if not os.path.exists("text/tilemaps"):
    os.makedirs("text/tilemaps")

# tilemap bank is 1e (0x78000)
BANK_SIZE = 0x4000
BASE_ADDR = 0x78000
MAX_ADDR = BASE_ADDR + BANK_SIZE - 1

tilemap_ptr = {}
tilemap_bytes = {}
with open("baserom.gbc", "rb") as rom:
    rom.seek(BASE_ADDR)
    for i in range(0xf1):
        tilemap_ptr[i] = readshort(rom)

    for i, ptr in tilemap_ptr.items():
        addr = BASE_ADDR + ptr - BANK_SIZE
        rom.seek(addr)
        compressed = readbyte(rom)
        print("{:02X} @ [{:04X} / {:08X}]".format(i, ptr, rom.tell()), end="")
        if compressed == 0x00:
            print("Uncompressed, ", end="")
            tilemap_bytes[i] = list(iter(partial(readbyte, rom), 0xFF))
            print("length {:02X}".format(len(tilemap_bytes[i])))
            with open("text/tilemaps/{:02X}.txt".format(i), "w", encoding = "utf-8") as output:
                output.write("[OVERLAY]\n")
                output.write("".join(dump_tilemap(tilemap_bytes[i], table)))
        elif compressed == 0x01:
            print("Compressed")
        else:
            print("Unknown: {:02X}".format(compressed))
