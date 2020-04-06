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

def compress_mode_literal(idx, tmap, do_compression = False):
    return 0

def compress_mode_repeat(idx, tmap, do_compression = False):
    curbyte = tmap[idx]
    i = 0
    for i, byte in zip(range(64), tmap[idx + 1:]):
        if byte != curbyte:
            break
        elif do_compression:
            tmap[idx + 1 + i] = 0xFFFF
    return i

def compress_mode_increment(idx, tmap, do_compression = False):
    i = 0
    curbyte = tmap[idx]
    for i, byte in zip(range(64), tmap[idx + 1:]):
        if byte != (curbyte + 1 + i) & 0xFF:
            break
        elif do_compression:
            tmap[idx + 1 + i] = 0xFFFF
    return i   

def compress_mode_decrement(idx, tmap, do_compression = False):
    i = 0
    curbyte = tmap[idx]
    for i, byte in zip(range(64), tmap[idx + 1:]):
        if byte != (curbyte - 1 - i) & 0xFF:
            break
        elif do_compression:
            tmap[idx + 1 + i] = 0xFFFF
    return i

COMPRESSION_METHODS = {
    MODE_LIT : compress_mode_literal,
#    MODE_REP : compress_mode_repeat,
#    MODE_INC : compress_mode_increment,
#    MODE_DEC : compress_mode_decrement
}
def compress_tmap(tmap):
    idx = 0
    while idx < len(tmap):
        best = max(COMPRESSION_METHODS, key=lambda x : COMPRESSION_METHODS[x](idx, tmap))
        byte_count = COMPRESSION_METHODS[best](idx, tmap, True)
        if best != MODE_LIT:
            tmap[idx + 1] = tmap[idx]
            tmap[idx] = ((best << 6) & 0b11000000) + ((byte_count-1) & 0b00111111) # +1 is implied during decompress
        else:
            tmap[idx] |= 0x0100
        idx += 1 + byte_count
    tmap = [b for b in tmap if b != 0xFFFF]
    idx = 0
    while idx < len(tmap):
        if tmap[idx] & 0x0100:
            tmap.insert(idx, 0xFF) # +1 is implied during decompress
            j = 1
            while j < 64 and j + idx < len(tmap) and tmap[idx + j] & 0x0100:
                tmap[idx + j] &= 0xFF
                tmap[idx] += 1
                j += 1
            tmap[idx] &= 0xFF
            idx += j
        else:
            idx += 1
    return tmap