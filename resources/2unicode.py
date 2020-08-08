#!/usr/bin/env python
import csv
print("""
# Automatically generated from 2unicode.py

MMA2Unicode = {"
""")
with open("../resources/UnicodeLongNames.csv") as csvfile:
    csvreader = csv.reader(csvfile)
    # This skips the first row of the CSV file.
    # csvreader.next() also works in Python 2.
    next(csvreader)
    for hexcode, mma in csvreader:
        uni = "\\u" + hexcode[2:]
        print(f'    "\\{mma}": "{uni}"')
        pass
    print("}")
