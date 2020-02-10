#!/usr/bin/python
#
# Read a CSV file and make some of its columns human-readable.
#
# Igor Konnov, 2020

import argparse
import csv
import getopt
import io
import math
import re
from sys import stdout
import sys

NUM_UNITS = ["", "K", "M", "G", "T", "P", "E", "Z", "Y"]
TIME_UNITS = ["s", "m", "h"]

def humanise_row(fields, row):
    """make a row human-readable"""
    # hard-coded rules for making fields better readable
    def update_index(field, fun):
        idx = fields.index(field)
        if idx < 0:
            raise Exception("Field %s not found" % field)
        else:
            row[idx] = fun(row[idx])

    update_index("04:time_sec", human_sec)
    update_index("05:mem_kb", human_bytes)
    update_index("12:ncells", human_num)
    update_index("13:nclauses", human_num)
    update_index("14:navg_clause_len", human_num)

    return row

def transform(infile):
    reader = csv.reader(infile)
    writer = csv.writer(sys.stdout, dialect = reader.dialect, escapechar = '"')
    fields = None

    for row_arr in reader:
        out_row = row_arr
        if not fields:
            fields = row_arr # the first row is the header
        else:
            out_row = humanise_row(fields, out_row)
                
        writer.writerow(out_row)

def human_power(num, divider, units):
    power = 0
    max_power = len(units)
    fraction = 0
    while num >= divider and power < max_power:
        num = int(round(num / divider))
        fraction = num % divider
        power += 1

    return (num, fraction, units[power])

def human_bytes(num):
    val, frac, unit = human_power(int(num), 1024, NUM_UNITS)
    if val < 10:
        return "%d.%d%sB" % (val, int(frac / 100), unit)
    else:
        return "%d%sB" % (val, unit)

def human_num(num):
    val, frac, unit = human_power(int(num), 1000, NUM_UNITS)
    if val < 10:
        return "%d.%d%s" % (val, int(frac / 100), unit)
    else:
        return "%d%s" % (val, unit)

def human_sec(num):
    val, frac, unit = human_power(int(num), 60, TIME_UNITS)
    if val < 10 and unit == "m":
        return "%dm%02ds" % (val, frac % 100)
    elif val < 10 and unit == "h":
        return "%dh%02dm" % (val, frac % 100)
    else:
        return "%d%s" % (val, unit)

def use():
    print("Use: {} <in.csv >out.csv".format(sys.argv[0]))
    print("")
    sys.exit(1)

if __name__ == "__main__":
    transform(sys.stdin)

