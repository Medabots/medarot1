import struct

def read_short(rom):
    return struct.unpack("<H", rom.read(2))[0]

def read_byte(rom):
    return struct.unpack("B", rom.read(1))[0]

def dump_tilemap(tilemap_bytes, table):
    tilemap = []
    for b in tilemap_bytes:
        if b in table:
            tilemap += table[b]
        else:
            tilemap += '\\x{:02x}'.format(b)
    return tilemap

MODE_LITERAL = 0
MODE_REPEAT = 1
MODE_INC = 2
MODE_DEC = 3
def decompress_tilemap(original):
    tmap = []
    rom = iter(original)
    for b in rom:
        if b == 0xfe:
            tmap.append(0xfe)
        else:
            command = (b >> 6) & 0b11
            count = b & 0b00111111
            if command == MODE_LITERAL:
                for i in range(count+1):
                    tmap.append(next(rom))
            elif command == MODE_REPEAT:
                byte = next(rom)
                for i in range(count+2):
                    tmap.append(byte)
            elif command == MODE_INC:
                byte = next(rom)
                for i in range(count+2):
                    tmap.append((byte+i)&0xff)
            elif command == MODE_DEC:
                byte = next(rom)
                for i in range(count+2):
                    tmap.append((byte-i)%0xff)
    ret = []
    for i,t in enumerate(tmap):
        if i != 0 and i % 0x20 == 0:
            ret.append(0xfe)
        ret.append(t)
    return ret