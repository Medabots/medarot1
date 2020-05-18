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
    original = [compressed] + list(total.to_bytes(2, byteorder='little'))
    if compressed:
        while len(data) < total:
            modes = utils.read_short(rom)
            original += list(modes.to_bytes(2, byteorder='little'))
            for mode in bin(modes)[2:].zfill(16)[::-1]:
                if int(mode) == 1:
                    e = rom.read(1)
                    d = rom.read(1)
                    original += [struct.unpack("B", e)[0], struct.unpack("B", d)[0]]
                    loc = -(struct.unpack("<H", e+d)[0]  & 0x07ff)
                    num = ((struct.unpack("<B", d)[0] >> 3) & 0x1f) + 0x03
                    loc += len(data)-1
                    for j in range(num):
                        if loc < 0:
                            raise "Unknown location"
                        else:
                            data.append(data[loc+j])
                else:
                    d = utils.read_byte(rom)
                    data.append(d)
                    original.append(d)
                if len(data) == total: # We'll read bytes that we don't need to if we don't check this here
                    break
    elif compressed == 0:
        data = [utils.read_byte(rom) for i in range(0,total)]
        original += data
    else:
        raise "Unknown compression flag (expect 0 or 1)"
    return data, original

def compress_tileset(file):
    file.seek(0, 2)
    total = file.tell()
    file.seek(0)
    compressed_data = [0x0] + list(total.to_bytes(2, byteorder='little'))
    loc = 0
    while loc < total:
        b = utils.read_byte(file)
        compressed_data.append(b)
        loc += 1
    return compressed_data

if __name__ == "__main__":
    operation = int(sys.argv[1])
    input_file = sys.argv[2]
    output_file = sys.argv[3]
    offset = int(sys.argv[4])

    with open(input_file, 'rb') as i, open(output_file, 'wb') as o:
        if operation == 0: # Decompress
            o.write(bytearray(decompress_tileset(i, offset)[0]))
        elif operation == 1: # Compress
            o.write(bytearray(compress_tileset(i)))
