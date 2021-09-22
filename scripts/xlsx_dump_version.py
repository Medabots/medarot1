#!/bin/python

# python3 scripts/xlsx_dump_version.py ~/sheet.xlsx text/patch/text_version.txt
import sys
import openpyxl as xl

xlsx = sys.argv[1]
version_file = sys.argv[2]

wb = xl.load_workbook(filename = xlsx)
status_sheet = [sheet for sheet in wb.worksheets if sheet.title == 'Status'][0]
version = status_sheet.cell(1, 1).value.lstrip("rev. ")

with open(version_file, "w") as f:
	f.write(f".txt.{version}")