import os
import struct
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), '.'))
import utils

# Adapted from https://github.com/Sanqui/romhacking/blob/master/telefang/punika.py
def decompress_tileset(rom, offset):
    rom.seek(offset)
    compressed = utils.read_byte(rom)
    total = utils.read_short(rom)
    data = []
    if compressed:
        while len(data) < total:
            modes = utils.read_short(rom)
            for mode in bin(modes)[2:].zfill(16)[::-1]:
                if int(mode) == 1:
                    e = rom.read(1)
                    d = rom.read(1)
                    loc = -(struct.unpack("<H", e+d)[0]  & 0x07ff)
                    num = ((struct.unpack("<B", d)[0] >> 3) & 0x1f) + 0x03
                    loc += len(data)-1
                    for j in range(num):
                        if loc < 0:
                            raise "Unknown location"
                        else:
                            data.append(data[loc+j])
                else:
                    data.append(utils.read_byte(rom))
    elif compressed == 0:
        data = [utils.read_byte(rom) for i in range(0,total)]
    else:
        raise "Unknown compression flag (expect 0 or 1)"
    return data

if __name__ == "__main__":
    input_file = sys.argv[1]
    offset = int(sys.argv[2])
    output_file = sys.argv[3]

    with open(input_file, 'rb') as i, open(output_file, 'wb') as o:
        o.write(bytearray(decompress_tileset(i, offset)))