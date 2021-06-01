#!/bin/python

## Converts translator-defined XLSX file to text files for bin conversion
## Usage: python3 scripts/xlsx2list.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/lists <List Types>
import sys
import openpyxl as xl
from collections import OrderedDict
import csv
from os import path

xlsx = sys.argv[1]
outdir = sys.argv[2]
SHEETS = list(sys.argv[3:])

wb = xl.load_workbook(filename = xlsx)

for sheet in wb.worksheets:
	if not sheet.title in SHEETS:
		continue
	filename = path.join(outdir, "{0}.txt".format(sheet.title))
	data = sheet.values
	header = next(data)
	useful_indices = [i for i,x in enumerate(header) if x and x not in ['Original', 'Notes', 'OK?', '#'] and not x.startswith('Prefix') ]
	prefix_indices = [i for i,x in enumerate(header) if x and x.startswith('Prefix')]

	with open(filename, 'w', encoding='utf-8') as outfile:
		print("Writing {0}".format(filename))
		for line in data:
			if line[0] == '#':
				continue
			outtext = ''
			for i in prefix_indices: # Prefix for the first element in the row
				if line[i]:
					outtext += line[i]
			# The remaining text each gets its own line (e.g. for models in part lists)
			outtext += '\n'.join([str(line[i]) for i in useful_indices if line[i]])
			print(outtext, file=outfile)