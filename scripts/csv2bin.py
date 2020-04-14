#!/bin/python
# -*- coding: utf-8 -*-

from binascii import unhexlify, hexlify
from collections import OrderedDict
from struct import *
import os
import csv
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

ptr_names = {}
with open(os.path.join(os.path.dirname(__file__), 'res', 'ptrs.tbl'),"r") as f:
    for line in f:
        l = line.split('=')
        l[1] = "{:X}".format(int(l[1], 16))
        ptr_names[l[0].strip()] = (int(l[1][2:4], 16), int(l[1][0:2], 16))

def table_convert(txt, tbl):
    result = bytearray()
    i = 0
    endcode = 0x00
    while i < len(txt):
        try: 
            if txt[i] == '<':
                i += 1
                special_type = txt[i]
                i += 1
                special_data = []
                while txt[i] != '>':
                    try:
                        special_data.append(txt[i])
                    finally:
                        i += 1
                if special_type == '*':
                    endcode = int(special_data[0])
                    break
                elif special_type == 'S':
                    result.append(0x4D)
                    result.append(int(''.join(special_data), 16))
                elif special_type == '&':
                    result.append(0x4B)
                    s = ''.join(special_data)
                    if s in ptr_names:
                        result.append(ptr_names[s][0])
                        result.append(ptr_names[s][1])
                    else:
                        print("Unable to find ptr name for {0}".format(s))
                        result.append(int(s[2:4], 16))
                        result.append(int(s[0:2], 16))
                elif special_type == '`':
                    result.append(0x50)
                elif special_type == '4':
                    result.append(int( special_type + ''.join(special_data), 16))
            else: # We don't check, as every character should be mapped
                result.append(tbl[txt[i]])
        finally:
            i += 1
    
    if len(txt):
        result.append(0x4F)
        result.append(endcode)
    return result

if __name__ == '__main__':
    # TODO: Set this up to take these as an argument
    arg1 = 'build' #output directory
    trans_dir = 'text/dialog'
    output_dir = 'build'
    char_table = utils.merge_dicts([
        utils.read_table("scripts/res/medarot.tbl", reverse=True), # FIXME: There are missing tileset mappings, for now just read medarot.tbl
        #utils.read_table("scripts/res/tileset_MainDialog.tbl", reverse=True),
        #utils.read_table("scripts/res/tileset_MainSpecial.tbl", reverse=True),
        #utils.read_table("scripts/res/dakuten.tbl", reverse=True),
    ])
    char_table['\\'] = 0x4A
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    #Reads from the text_tables.asm file to determine banks
    sections = ['Snippet1', 'Snippet2', 'Snippet3', 'Snippet4', 'Snippet5', 'StoryText1', 'StoryText2', 'StoryText3', 'BattleText']
    bank_size_max = 0x7FFF
    ptr_size = 3

    bank_map = {}
    with open('game/src/story/text_tables.asm', 'r') as txt_file:
        for line in txt_file:
            if line.startswith('SECTION'):
                o = line.lstrip('SECTION ').replace(' ', '').replace('\n','').replace('\r\n','').replace('"','').split(',')
                #Name ROMX[$OFFSET] BANK[$BANK]
                if o[0] in sections:
                    bank_map[o[0]] = { "BANK": int(o[2].replace('BANK','').replace('[','').replace(']','').replace('$','0x'), 16), "OFFSET": int(o[1].replace('ROMX','').replace('[','').replace(']','').replace('$','0x'), 16) }
        assert(len(bank_map) == len(sections))

    for section in sections:
        fn = os.path.join(trans_dir, "{}.csv".format(section))
        of = os.path.join(output_dir, "{}.bin".format(section))
        print("Starting on {}".format(fn))
        output_text = OrderedDict()
        with open(fn, 'r', encoding="utf-8") as f:
            reader = csv.reader(f, delimiter=',', quotechar='"')
            next(reader, None) #Skip header
            for line in reader:
                if line[0][0] == '#': # Comment
                    continue
                # Pointer,Original
                ptr = line[0]
                txt = line[1].strip('"')
                if txt.startswith('='):
                    output_text[ptr] = int(txt.strip('='), 16)
                elif txt == "<IGNORED>":
                    output_text[ptr] = int(0)
                elif not txt:
                    output_text[ptr] = bytearray()
                else:
                    output_text[ptr] = table_convert(txt, char_table)
        ptrs_map = {}
        curr_txt = bank_map[section]["OFFSET"] + 2 * len(output_text) # Start the text after the pointer table
        with open(of, 'wb') as bin_file:
            # First pass, write out all the pointers
            for p in output_text:
                if isinstance(output_text[p], int) and output_text[p] != 0:
                    bin_file.write(pack('<H', ptrs_map[output_text[p]]))
                else:
                    bin_file.write(pack('<H', curr_txt))
                    ptrs_map[int(p, 16)] = curr_txt
                    if output_text[p] != 0: # Ignore it if 0 (no-op), but we want to make sure we take it into account for the pointer table
                        curr_txt = curr_txt + len(output_text[p])
            # Second pass, write out text
            #[bin_file.write(output_text[p]) for p in output_text if not isinstance(output_text[p], int) and len(output_text[p])]