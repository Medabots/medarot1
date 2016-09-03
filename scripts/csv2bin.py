#!/bin/python

from binascii import unhexlify
import os

def table_convert(txt, tbl):
    return txt

if __name__ == '__main__':
    # TODO: Set this up to take these as an argument
    arg0 = 'eng' #language
    arg1 = 'build' #output directory
    arg2 = '21,22,23' #CSV of additional banks (hex)

    trans_dir = 'translation/%s/text' % (arg0)
    output_dir = arg1
    char_table = 'translation/%s/chars.tbl' % (arg0)
    additional_banks = arg2.split(',')

    #Reads from the text_tables.asm file to determine banks
    txt_file = open('game/src/story/text_tables.asm', 'r')
    sections = ['Snippet1', 'Snippet2', 'Snippet3', 'Snippet4', 'Snippet5', 'StoryText1', 'StoryText2', 'StoryText3', 'BattleText']
    bank_size_max = 0x4000
    ptr_size = 3

    bank_map = {}
    for line in txt_file:
        if line.startswith('SECTION'):
            o = line.lstrip('SECTION ').replace(' ', '').replace('\n','').replace('\r\n','').replace('"','').split(',')
            #Name ROMX[$OFFSET] BANK[$BANK]
            if o[0] in sections:
                bank_map[o[0]] = { "BANK": int(o[2].replace('BANK','').replace('[','').replace(']','').replace('$','0x'), 16), "OFFSET": int(o[1].replace('ROMX','').replace('[','').replace(']','').replace('$','0x'), 16) }
    txt_file.close()

    additional_files = {}
    for bank in additional_banks:
        fn = '%s/Additional_b%s.bin' % (output_dir, bank)
        additional_files[bank] = open(fn,'wb')

    for section in sections:
        fn = '%s/%s.csv' % (trans_dir, section)
        print("Starting on %s" % (fn))
        txt = {}
        offsets = {}
        cur_offset = 0
        with open(fn, 'r') as f:
            for line in f:
                if line.startswith('Pointer'):
                    continue
                #Pointer, Original, Translated
                l = line.strip('\r\n').strip('\n').split(',')
                translated_txt = l[2].strip('"')
                if translated_txt.startswith('='):
                    true_ptr = int(translated_txt.lstrip('='),16)
                    if true_ptr in offsets:
                        offsets[int(l[0],16)] = offsets[true_ptr]
                    else:
                        raise Exception("ERROR: Could not find ptr %i for ptr %s" % (true_ptr, l[0]))
                else:
                    if not translated_txt:
                        translated_txt = l[0]
                    converted_txt = table_convert(translated_txt, char_table)
                    txt[int(l[0],16)] = converted_txt
                    offsets[int(l[0],16)] = cur_offset
                    cur_offset = cur_offset + len(translated_txt)
            #We have all the pointers and text, just need to write it now
            size_ptrs = len(offsets) * 3
            if size_ptrs > bank_size_max:
                raise Exception("ERROR: Pointers in %s take up %i bytes (max %i)", section, size_ptrs, bank_size_max)
            bin_file = open('%s/%s.bin' % (output_dir, section), 'wb')
            # TODO: WIP
            bin_file.close()

    for bank,f in additional_files.iteritems():
        f.close()
