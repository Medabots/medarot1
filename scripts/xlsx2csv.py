#!/bin/python

## Converts translator-defined XLSX file to CSV file for bin conversion
## Usage: python3 scripts/xlsx2csv.py ../Medarot\ 1\ Translation\ Sheet.xlsx ./text/dialog
import sys
import openpyxl as xl
from collections import OrderedDict
import csv
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
	return line.replace('\n\n','<4C>').replace('\n','<49>')

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
	text = {}
	for line in data:
		ptr = line[pointer_idx]
		original = line[original_idx]
		translated = line[translated_idx]
		try:
			int(line[pointer_idx].split("#")[0], 16)
		except ValueError:
			continue
		text[ptr] = translated.replace('""', '"') if translated else None
	
	orig_text = OrderedDict()
	with open(file_path, "r", encoding='utf-8', newline='\n') as csvfile:
		csvfile.readline()
		reader = csv.reader(csvfile, delimiter=',')
		for line in reader:
			ptr = line[0]
			txt = line[1]
			orig_text[ptr.strip()] = txt.strip()

	with open(file_path, "w", encoding='utf-8', newline='\n') as csvfile:
		print("Writing {0}".format(file_path))
		writer = csv.writer(csvfile, delimiter=',', lineterminator='\n')
		writer.writerow(["Pointer[#version]","Original","Translated"])
		for ptr in orig_text:
			writer.writerow([
				ptr, 
				transform_line(orig_text[ptr]),
			 	transform_line(text[ptr]) if ptr in text else ptr
			])