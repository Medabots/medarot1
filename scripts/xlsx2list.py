#!/bin/python

## Converts translator-defined XLSX file to CSV file for bin conversion
## Usage: python3 scripts/xlsx2csv.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/dialog
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
	useful_indices = [i for i,x in enumerate(header) if x not in ['Original', 'Notes', 'OK?', '#'] ]

	with open(filename, 'w') as outfile:
		print("Writing {0}".format(filename))
		for line in data:
			if line[0] == '#':
				continue
			for i in useful_indices:
				if line[i]:
					try:
						outfile.write(line[i] + "\n")
					except:
						print("{}: {}".format(sheet.title, line[i]))