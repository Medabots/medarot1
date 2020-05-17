MODE_LIT = 0
MODE_REP = 1
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
            if command == MODE_LIT:
                for i in range(count+1):
                    tmap.append(next(rom))
            elif command == MODE_REP:
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

MAX_COUNT = 63
MIN_COUNT = 1
def compress_mode_literal(idx, tmap):
    return MIN_COUNT

# All non-literal methods must have a minimum size of 2 bytes to make sense
def compress_mode_repeat(idx, tmap):
    i = 0
    curbyte = tmap[idx]
    for i, byte in zip(range(MAX_COUNT+1), tmap[idx + 1:]):
        if byte != curbyte:
            break
    return i

def compress_mode_increment(idx, tmap):
    i = 0
    curbyte = tmap[idx]
    for i, byte in zip(range(MAX_COUNT+1), tmap[idx + 1:]):
        if byte != (curbyte + 1 + i) & 0xFF:
            break
    return i

def compress_mode_decrement(idx, tmap):
    i = 0
    curbyte = tmap[idx]
    for i, byte in zip(range(MAX_COUNT+1), tmap[idx + 1:]):
        if byte != (curbyte - 1 - i) & 0xFF:
            break
    return i

COMPRESSION_METHODS = {
    MODE_LIT : compress_mode_literal,
    MODE_REP : compress_mode_repeat,
    MODE_INC : compress_mode_increment,
    MODE_DEC : compress_mode_decrement,
}
def compress_tmap(tmap):
    compressed_tmap = []
    idx = 0
    while idx < len(tmap):
        best_method = MODE_LIT
        best_size = MIN_COUNT
        curbyte = tmap[idx]
        for m in COMPRESSION_METHODS: # Just greedily figure out how to compress the next N bytes
            size = COMPRESSION_METHODS[m](idx, tmap)
            if size > best_size:
                best_size = size
                best_method = m
        command = (best_method << 6) | (best_size - 1)
        compressed_tmap.append(command)
        compressed_tmap.append(curbyte)
        idx += best_size
        if best_method != MODE_LIT:
            idx += 1 # In non-literal mode, skip the next byte 
    return compressed_tmap