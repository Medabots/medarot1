#!/bin/python

## Converts translator-defined XLSX file to CSV file for bin conversion
## Usage: python3 scripts/xlsx2csv.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/dialog
import sys
import openpyxl as xl
from collections import OrderedDict
import csv
from os import path

def transform_line(line):
	line = (line or "").replace('""', '"')
	for ptr in ptr_names.keys():
		line = line.replace("<&{0:X}>".format(ptr, 'x').lower(), "<&{0}>".format(ptr_names[ptr]))
	return line.replace('\n\n','<4C>').replace('\n','<49>')

xlsx = sys.argv[1]
csvdir = sys.argv[2]

if len(sys.argv) < 4:
	SHEETS = ([
		"StoryText1",
		"StoryText2",
		"StoryText3",
		"Snippet1",
		"Snippet2",
		"Snippet3",
		"Snippet4",
		"Snippet5",
		"BattleText",
	])
else:
	SHEETS = list(sys.argv[3:])

wb = xl.load_workbook(filename = xlsx)
ptr_names = {}
with open(path.join(path.dirname(__file__), 'res', 'ptrs_orig.tbl'),"r") as f:
	for line in f:
		l = line.split('=')
		ptr_names[int(l[1].strip(), 16)] =  l[0].strip()

for sheet in wb.worksheets:
	if not sheet.title in SHEETS:
		continue
	data = sheet.values
	header = next(data)
	pointer_idx = header.index('Pointer') # Pointer index must precede all useful data (data before the pointer index is ignored)
	original_idx = header.index('Original')
	translated_idx = header.index('Translated') # Translated is the end of useful data, everything after this is ignored
	file_path = path.join(csvdir, "{0}.csv".format(sheet.title))
	text = {}
	for line in data:
		if line[0] == '#':
			continue
		ptr = line[pointer_idx]
		try:
			int(line[pointer_idx].split("#")[0], 16)
		except ValueError:
			continue
		text[ptr] = line[:translated_idx+1]
	
	orig_text = OrderedDict()
	fieldnames = []
	orig_text_idx = None
	with open(file_path, "r", encoding='utf-8', newline='\n') as csvfile:
		reader = csv.reader(csvfile, delimiter=',')
		fieldnames = next(reader)
		while "Translated" in fieldnames:
			fieldnames.remove("Translated")
		orig_text_idx = fieldnames.index("Original")
		for line in reader:
			ptr = line[0]
			orig_text[ptr.strip()] = line[:len(fieldnames)]

	with open(file_path, "w", encoding='utf-8', newline='\n') as csvfile:
		print("Writing {0}".format(file_path))
		writer = csv.writer(csvfile, delimiter=',', lineterminator='\n')
		fieldnames.append("Translated")
		writer.writerow(fieldnames)
		for ptr in orig_text:
			row = []
			original_text = orig_text[ptr][orig_text_idx]
			if original_text.startswith("="):
				row = orig_text[ptr]
				row.append(original_text)				
			elif original_text == "<IGNORED>":
				row = orig_text[ptr]
				row.append(ptr)
			elif ptr not in text:
				print("\tWarning: Missing text for {}".format(ptr))
				row = orig_text[ptr]
				row.append("")
			else:
				row = [transform_line(x) if i == (original_idx - pointer_idx) or i == (translated_idx - pointer_idx) else x for i, x in enumerate(text[ptr][pointer_idx:translated_idx+1])]
				row[original_idx - pointer_idx] = original_text # Keep our dumped version of the original text at all times
			writer.writerow(row)