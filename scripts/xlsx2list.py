#!/bin/python

## Converts translator-defined XLSX file to text files for bin conversion
## Usage: python3 scripts/xlsx2list.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/lists <Localization Version> <List Types>
import sys
import openpyxl as xl
from collections import OrderedDict
import csv
from os import path
import re

sys.path.append(path.join(path.dirname(__file__), 'common'))
from common import utils

xlsx = sys.argv[1]
outdir = sys.argv[2]
localization = sys.argv[3]
SHEETS = list(sys.argv[4:])

localization_table = utils.read_table("scripts/res/patch/localization_{0}.tbl".format(localization), keystring=True)

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
			# Replace based on localization
			pattern = '|'.join(sorted(r"(?<!\[)\b{0}\b(?!\])".format(re.escape(key)) for key in localization_table))
			outtext = re.sub(pattern, lambda m: localization_table.get(m.group(0)), outtext)
			print(outtext, file=outfile)