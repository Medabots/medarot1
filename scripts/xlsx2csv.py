#!/bin/python

## Converts translator-defined XLSX file to CSV file for bin conversion
## Usage: python3 scripts/xlsx2csv.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/dialog
import sys
import openpyxl as xl
from os import path

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

def transform_line(line):
	line = (line or "")
	for ptr in ptr_names.keys():
		line = line.replace("<&{0:X}>".format(ptr, 'x').lower(), "<&{0}>".format(ptr_names[ptr]))
	return line.replace('\n\n','<4C>').replace('\n','<4E>').replace('"','""')

xlsx = sys.argv[1]
csvdir = sys.argv[2]

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
	pointer_idx = header.index('Pointer')
	original_idx = header.index('Original')
	translated_idx = header.index('Translated')
	file_path = path.join(csvdir, "{0}.csv".format(sheet.title))
	print("Writing {0}".format(file_path))
	with open(file_path, "w", encoding='utf-8') as csv:
		csv.write("Pointer,Original,Translated\n")
		for line in data:
			try:
				int(line[pointer_idx], 16)
			except ValueError:
				continue
			csv.write('{0},"{1}","{2}"\n'.format(line[pointer_idx],\
				transform_line(line[original_idx]),
				transform_line(line[translated_idx])
			))