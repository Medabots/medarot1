#!/bin/python

# Almost a carbon copy of dump_text
import os
import sys
from collections import OrderedDict

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

roms = [("baserom_kabuto.gb", "kabuto"), ("baserom_kuwagata.gb", "kuwagata")]
ptrs = open("./scripts/res/ptrs.tbl", "a+")
ptrs.seek(0)

addrs = [0x592ED]
filenames = ["Credits"]
ptr_range = [63] #Specify # of pointers if necessary

name_table = {}
for line in ptrs:
    n, p = line.strip().split("=")
    name_table[int(p, 16)] = n

class NotPointerException(ValueError): pass

def readpointer(rom, bank):
    s = readshort(rom)
    if 0x4000 > s or 0x8000 <= s:
        raise NotPointerException(s)
    return (bank * 0x4000) + (s - 0x4000)

def readshort(rom):
    return readbyte(rom) + (readbyte(rom) << 8)

def readbyte(rom):
    return ord(rom.read(1))

table = utils.read_table("scripts/res/medarot.tbl")

class Special():
    def __init__(self, symbol, default=0, bts=1, end=False, names=None):
        self.symbol = symbol
        self.default = default
        self.bts = bts
        self.end = end
        self.names = names

table[0x4b] = Special("&", bts=2, names=name_table)
table[0x4d] = Special('S', default=-1)
table[0x4f] = Special('*', end=True)
table[0x50] = Special('`', bts=0, end=True)


def dump_text(rom, addr):
    global name_table
    rom.seek(addr)
    text = ""
    while True:
        b = readbyte(rom)
        if b in table:
            token = table[b]
            if type(token) == str:
                text += token
            elif isinstance(token, Special):
                param = {0: lambda: None, 1: readbyte, 2: readshort}[token.bts](rom)
                if param != None:
                    if (not token.end and param != token.default) or (token.end and param != token.default):
                        text += "<"+token.symbol
                        if param != token.default:
                            if token.names and param in token.names:
                                text += token.names[param]
                            else:
                                if token.names is not None:
                                    n = "BUF{:02X}".format(len(name_table))
                                    ptrs.write("{}={}\n".format(n, hex(param)))
                                    name_table[param] = n
                                    text += n
                                else:
                                    text += hex(param)[2:]
                        text += ">"
                if token.end:
                    if not text:
                        text = "<" + token.symbol + hex(param)[2:] + ">"
                    return text
        else:
            text += "<@{0}>".format(hex(b)[2:])

if not os.path.exists("text/credits"):
    os.makedirs("text/credits")

rom_texts = OrderedDict() # Because we rely on the first rom being the default
texts = {}
for n, file in enumerate(filenames):
    print("Working on {}".format(file))
    for r in roms:
        with open(r[0], "rb") as rom:
            rom_texts[r[1]] = OrderedDict()
            addr = addrs[n]
            bank = addr//0x4000
            pts = {}
            for i in range(ptr_range[n] if isinstance(ptr_range[n], int) else ptr_range[n][1]):
                rom.seek(addr)
                try:
                    ptr = readpointer(rom, bank) # actual pointer to text
                except NotPointerException:
                    break
                idx = rom.tell()-2 # position in ptr table
                text = ""
                vramoffset = 0x00
                if ptr not in pts:
                    pts[ptr] = idx
                    if not isinstance(ptr_range[n], int) and i >= ptr_range[n][0]:
                        text = "<IGNORED>"
                    else:
                        rom.seek(ptr)
                        vramoffset = readshort(rom)
                        ptr += 2
                        text = dump_text(rom, ptr)
                else:
                    text = "={}".format(hex(pts[ptr]))
                addr += 2
                rom_texts[r[1]][idx] = "{:04X},{}".format(vramoffset, text.replace('\n\n','<4C>').replace('\n','<4E>').replace('"','""'))

    texts[file] = {}
    for suffix in rom_texts:
        for idx in rom_texts[suffix]:
            if hex(idx) in texts[file] and rom_texts[suffix][idx] != texts[file][hex(idx)]:
                # The original must have been the 'default' suffix, so copy the element and rename it
                texts[file][hex(idx) + "#" + roms[0][1]] = texts[file][hex(idx)]
                del texts[file][hex(idx)]
                texts[file][hex(idx) + "#" + suffix] = rom_texts[suffix][idx]
            else:
                texts[file][hex(idx)] = rom_texts[suffix][idx]

for file in texts:
    with open("text/credits/" + file + ".csv", "w", encoding="utf-8") as fp:
        fp.write("Pointer[#version],VRAMOffset,Original\n")
        for idx in OrderedDict(sorted(texts[file].items(), key=lambda t: t[0])):
            fp.write("{},{}\n".format(idx, texts[file][idx]))

ptrs.truncate()
ptrs.close()