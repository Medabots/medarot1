import struct

def read_short(rom):
    return struct.unpack("<H", rom.read(2))[0]

def read_byte(rom):
    return struct.unpack("B", rom.read(1))[0]

def read_table(filename):
    table = {}
    for line in open(filename, encoding = "utf-8").readlines():
        if line.strip():
            a, b = line.strip('\n').split("=", 1)
            table[int(a, 16)] = b.replace("\\n", '\n')
    return table