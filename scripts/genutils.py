#!/usr/bin/env python3
#
# This script provides some convenience varialbles and functions 
# for generators of parametric examples
#
# Andrey Kuprianov, 2020

import os
import sys
import datetime
from tzlocal import get_localzone
import getpass

CMD = sys.argv[0]
USER = getpass.getuser()
NOW = datetime.datetime.now(get_localzone()).strftime("%a %b %d %H:%M:%S %Z %Y")
NAME = None
KIND = None
N = None
VARIANT = None
FILE = None

def usage(msg):
    print(f"""
ERROR: {msg}
USAGE: {CMD} N
       generate {VARIANT} {KIND} encoding for {NAME} example of size N 
""")
    sys.exit(1)

# initialize this script by providing the general example name, 
# as well as the kind and the variant of generated parametric examples
def init(name, kind, variant = ""):
    global NAME, KIND, N, VARIANT, FILE
    NAME = name
    KIND = kind
    VARIANT = variant
    if len(sys.argv) != 2:
        usage("wrong number of arguments")
    try:
        N = int(sys.argv[1])
    except ValueError:
        usage("can't parse the input as integer parameter") 
    FILE = os.path.dirname(sys.argv[0]) + "/"     
    if not VARIANT:    
        FILE += f"{NAME}_{N}"
    else:
        FILE += f"{NAME}_{VARIANT}_{N}"




