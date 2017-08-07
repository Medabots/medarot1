#!/bin/python

from binascii import unhexlify, hexlify
from collections import OrderedDict
from struct import *
import os

def table_convert(txt, tbl):
    t = bytearray(txt, encoding = 'utf-8')
    result = bytearray()
    i = 0
    endcode = 0x00
    while i < len(t):
        try:
            if chr(t[i]) == '<':
                i += 1
                special_type = chr(t[i])
                i += 1
                special_data = []
                while chr(t[i]) != '>':
                    try:
                        special_data.append(chr(t[i]))
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
                    if s == "MEDA":
                        result.append(0x23)
                        result.append(0xC9)
                    elif s == "NAME":
                        result.append(0xD1)
                        result.append(0xDE)
                elif special_type == '`':
                    result.append(0x50)
                elif special_type == '4':
                    result.append(int( special_type + ''.join(special_data), 16))
            elif chr(t[i]) in tbl:
                result.append(tbl[chr(t[i])])
            else:
                print("Unable to find mapping for 0x%02X (%c)" % (t[i], t[i]))
                result.append(tbl['?'])
        finally:
            i += 1
    
    if len(t):
        result.append(0x4F)
        result.append(endcode)
    return result

if __name__ == '__main__':
    # TODO: Set this up to take these as an argument
    arg0 = 'eng' #language
    arg1 = 'build' #output directory
    arg2 = '21,22,23'

    trans_dir = 'translation/%s/text' % (arg0)
    output_dir = arg1
    with open('translation/%s/chars.tbl' % (arg0)) as f:
        char_table = dict((line.strip('\r\n').strip('\n').split('=', 1)[1], int(line.strip().split('=', 1)[0],16)) for line in f)
    additional_banks = arg2.split(',')

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    #Reads from the text_tables.asm file to determine banks
    sections = ['Snippet1', 'Snippet2', 'Snippet3', 'Snippet4', 'Snippet5', 'StoryText1', 'StoryText2', 'StoryText3', 'BattleText']
    bank_size_max = 0x7FFF
    ptr_size = 3

    bank_map = OrderedDict()
    with open('game/src/story/text_tables.asm', 'r') as txt_file:
        for line in txt_file:
            if line.startswith('SECTION'):
                o = line.lstrip('SECTION ').replace(' ', '').replace('\n','').replace('\r\n','').replace('"','').split(',')
                #Name ROMX[$OFFSET] BANK[$BANK]
                if o[0] in sections:
                    bank_map[o[0]] = { "BANK": int(o[2].replace('BANK','').replace('[','').replace(']','').replace('$','0x'), 16), "OFFSET": int(o[1].replace('ROMX','').replace('[','').replace(']','').replace('$','0x'), 16) }

    for f in additional_banks:
        name = "Additional_b%s" % f 
        bank_map[f] = { "BANK": int(f, 16), "OFFSET": 0x4000 } 
    
    reverse_bank_map = dict((v['BANK'], k) for k,v in bank_map.items())

    txt = OrderedDict()
    #Get translated text
    for section in sections:
        fn = '%s/%s.csv' % (trans_dir, section)
        txt[section] = []
        print("Starting on %s" % (fn))
        with open(fn, 'r') as f:
            for line in f:
                if line.startswith('Pointer'):
                    continue
                #Pointer, Original, Translated
                l = line.strip('\r\n').strip('\n').split(',')
                original_txt = l[1].strip('"')
                translated_txt = l[2].strip('"')
                ptr = l[0]
                if not translated_txt and original_txt:
                    translated_txt = ptr
                elif not translated_txt and not original_txt:
                    translated_txt = " " # TODO: What needs to happen with the empty strings?
                elif translated_txt.startswith('='):
                    ptr = translated_txt.strip('=')
                    translated_txt = ''
                converted_txt = table_convert(translated_txt, char_table)
                txt[section].append((int(ptr, 16), converted_txt))
        if bank_map[section]['OFFSET'] + len(txt[section]) * 3 > bank_size_max:
            raise Exception("ERROR: Pointers in %s take up %i bytes (max %i)", section, bank_map[section]['OFFSET'] + len(txt[section]) * 3, bank_size_max)
        else: 
            bank_map[section]['OFFSET'] = bank_map[section]['OFFSET'] + len(txt[section]) * 3
    
    for section in sections:
        offsets = []
        ptr_offset_map = {}
        for t in txt[section]:
            if not len(t[1]):
                offsets.append(ptr_offset_map[t[0]])
                continue
            #Get first bank with free space
            for b in bank_map:
                if bank_map[b]['OFFSET'] + len(t[1]) <= bank_size_max:
                    offsets.append((bank_map[b]['BANK'], bank_map[b]['OFFSET']))
                    ptr_offset_map[t[0]] = (bank_map[b]['BANK'], bank_map[b]['OFFSET'])
                    bank_map[b]['OFFSET'] = bank_map[b]['OFFSET'] + len(t[1])
                    break
            else:
                raise Exception("ERROR: Could not find room for %s", t)
        with open('%s/%s.bin' % (output_dir, section), 'wb') as bin_file:
            [bin_file.write(pack('<BH', b[0], b[1])) for b in offsets]

        curr_bank = 0
        curr_file = 0
        for i, t in enumerate(txt[section]):
            if curr_bank != offsets[i][0]:
                if curr_file:
                    curr_file.close()
                curr_file = open('%s/%s.bin' % (output_dir, reverse_bank_map[offsets[i][0]]), 'ab')
            curr_file.write(t[1])
        
        curr_file.close()