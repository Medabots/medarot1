#!/bin/python
import os
import sys
from collections import OrderedDict

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

rom = open("baserom.gbc", "rb")
log = open("./scripts/res/ptrs.tbl", "a+")
log.seek(0)

name_table = {}
for line in log:
    n, p = line.strip().split("=")
    name_table[int(p, 16)] = n

class NotPointerException(ValueError): pass

def readpointer(bank):
    s = readshort()
    if 0x4000 > s or 0x8000 <= s:
        raise NotPointerException(s)
    return (bank * 0x4000) + (s - 0x4000)

def readshort():
    return readbyte() + (readbyte() << 8)

def readbyte():
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


def dump_text(addr):
    global name_table
    rom.seek(addr)
    text = ""
    while True:
        b = readbyte()
        if b in table:
            token = table[b]
            if type(token) == str:
                text += token
            elif isinstance(token, Special):
                param = {0: lambda: None, 1: readbyte, 2: readshort}[token.bts]()
                if param != None:
                    if (not token.end and param != token.default) or (token.end and param != token.default):
                        text += "<"+token.symbol
                        if param != token.default:
                            if token.names and param in token.names:
                                text += token.names[param]
                            else:
                                if token.names is not None:
                                    n = "BUF{:02X}".format(len(name_table))
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

addrs = [0x33e00, 0x37e00, 0x3be00, 0x3fe00, 0x4f800, 0x5a000, 0x60000, 0x68000, 0x74000]
filenames = ["Snippet1", "Snippet2", "Snippet3", "Snippet4", "Snippet5", "StoryText1", "StoryText2", "StoryText3" , "BattleText"]
ptr_range = [1024, 1024, (10, 16), 1024, 1024, 1024, 1024, 1024 , (457, 464)] #Specify # of pointers if necessary (Snippet 3 has pointers to graphics as well)

if not os.path.exists("text/dialog"):
    os.makedirs("text/dialog")

for n, file in enumerate(filenames):
    texts = OrderedDict()
    addr = addrs[n]
    bank = addr//0x4000
    print("Working on {}".format(file))
    pts = {}
    for i in range(ptr_range[n] if isinstance(ptr_range[n], int) else ptr_range[n][1]):
        rom.seek(addr)
        try:
            ptr = readpointer(bank) # actual pointer to text
        except NotPointerException:
            break
        print(hex(ptr))
        idx = rom.tell()-2 # position in ptr table
        text = ""
        if ptr not in pts:
            pts[ptr] = idx
            if not isinstance(ptr_range[n], int) and i >= ptr_range[n][0]:
                text = "<IGNORED>"
            else:    
                text = dump_text(ptr)
        else:
            text = "={}".format(hex(pts[ptr]))
        addr += 2
        texts[idx] = "{}".format(text.replace('\n\n','<4C>').replace('\n','<4E>').replace('"','""'))

    with open("text/dialog/" + file + ".csv", "w", encoding="utf-8") as fp:
        fp.write("Pointer,Original\n")
        for idx in texts:
            fp.write("{},{}\n".format(hex(idx), texts[idx]))


log.truncate()
log.close()
rom.close()