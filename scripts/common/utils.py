import struct
from ast import literal_eval

def merge_dicts(dict_list):
    result = {}
    for dictionary in dict_list:
        result.update(dictionary)
    return result

def bin2txt(bin, tbl):
    tilemap = []
    for b in bin:
        if b in tbl:
            tilemap += tbl[b]
        else:
            tilemap += '\\x{:02x}'.format(b)
    return tilemap

def rom2realaddr(i):
    return i[0] * 0x4000 + i[1] - 0x4000

def real2romaddr(i):
    return (int(i / 0x4000), i % 0x4000 + 0x4000)

class ContinueLoopException(Exception):
    pass
def txt2bin(txt, tbl, pad=0, padbyte=0):
    tbl_max = 4 # Most characters we see are 4
    tmap = []
    idx = 0
    while idx < len(txt):
        try:
            if txt[idx] == '\\' and idx + 3 < len(txt) and txt[idx + 1] == 'x': # \xHH
                tmap.append(int(txt[idx + 2:idx + 4], 16))
                idx += 3
            else:
                for i in reversed(range(1, tbl_max + 1)): # This should be looked at and probably redone later
                    if idx + i > len(txt):
                        continue
                    if txt[idx:idx+i] in tbl:
                        tmap.append(tbl[txt[idx:idx+i]])
                        idx += i-1
                        raise ContinueLoopException
                print("WARNING: Unable to find mapping for 0x%02X (%c)" % (ord(txt[idx]), txt[idx]))
                tmap.append(0x75) # ? in english, ？ in JP
        except ContinueLoopException:
            continue 
        finally:
            idx += 1
    assert(pad == 0 or pad-len(tmap) >= 0)
    return tmap if not pad else (tmap + ([padbyte]*(pad-len(tmap))))[0:pad] # Always terminate with a padbyte

def read_short(rom):
    return struct.unpack("<H", rom.read(2))[0]

def read_byte(rom):
    return struct.unpack("B", rom.read(1))[0]

def read_table(filename, reverse = False, keystring=False):
    table = {}
    with open(filename, 'r', encoding='utf-8') as f:
        if reverse:
            return dict((literal_eval("'{0}'".format(line.strip('\n').strip('\r\n').split('=', 1)[1].replace("'","\\\'"))), int(line.strip().split('=', 1)[0],16) if not keystring else line.strip().split('=', 1)[0]) for line in f if line.strip())
        else:
            return dict((int(line.strip().split('=', 1)[0],16) if not keystring else line.strip().split('=', 1)[0], literal_eval("'{0}'".format(line.strip('\n').strip('\r\n').split('=', 1)[1].replace("'","\\\'")))) for line in f if line.strip())
    return table
