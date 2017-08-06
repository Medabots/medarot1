#!/bin/python

from binascii import unhexlify
from collections import OrderedDict
from struct import *
import os

def table_convert(txt, tbl):
    return bytearray(txt, encoding = 'utf-8')

if __name__ == '__main__':
    # TODO: Set this up to take these as an argument
    arg0 = 'eng' #language
    arg1 = 'build' #output directory
    arg2 = '21,22,23'

    trans_dir = 'translation/%s/text' % (arg0)
    output_dir = arg1
    char_table = 'translation/%s/chars.tbl' % (arg0)
    additional_banks = arg2.split(',')

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

    txt = {}
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
                translated_txt = l[2].strip('"')
                if not translated_txt:
                    translated_txt = l[0]
                converted_txt = table_convert(translated_txt, char_table)
                txt[section].append((int(l[0], 16), converted_txt))
        if bank_map[section]['OFFSET'] + len(txt[section]) * 3 > bank_size_max:
            raise Exception("ERROR: Pointers in %s take up %i bytes (max %i)", section, bank_map[section]['OFFSET'] + len(txt[section]) * 3, bank_size_max)
        else: 
            bank_map[section]['OFFSET'] = bank_map[section]['OFFSET'] + len(txt[section]) * 3
    
    for section in sections:
        offsets = []
        for t in txt[section]:
            #Get first bank with free space
            # TODO: When it starts with '='
            for b in bank_map:
                if bank_map[b]['OFFSET'] + len(t[1]) <= bank_size_max:
                    offsets.append((bank_map[b]['BANK'], bank_map[b]['OFFSET']))
                    bank_map[b]['OFFSET'] = bank_map[b]['OFFSET'] +  len(t[1])
                    break
            else:
                raise Exception("ERROR: Could not find room for %s", t)
        print("%s" % offsets) #All text and bank offsets accounted for
        