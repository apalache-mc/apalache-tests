#!/usr/bin/env python3

import sys
import datetime
from tzlocal import get_localzone
import getpass

NAME = "SetAdd"
USER = getpass.getuser()

def usage(msg):
    print("""
ERROR: {}
USAGE: {} N
       generate TLA+/TLC configuration for {} example of size N 
""".format(msg, sys.argv[0], NAME))
    sys.exit(1)

if len(sys.argv) != 2:
    usage("wrong number of arguments")

try:
    N = int(sys.argv[1])
except ValueError:
    usage("can't parse the input as integer parameter") 

NOW = datetime.datetime.now(get_localzone()).strftime("%a %b %d %H:%M:%S %Z %Y")

def print_tla():
    values = "{" + ", ".join("\"v"+str(x)+"\"" for x in range(N)) + "}"
    with open(f"{NAME}_MC_{N}.tla", "w") as file:
        file.write(f"""---- MODULE {NAME}_MC_{N} ----
EXTENDS {NAME}, TLC

MC_values == {values}
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created {NOW} by {USER}
""")

def print_cfg():
    values = " ".join("v"+str(x) for x in range(N))
    with open(f"{NAME}_MC_{N}.cfg", "w") as file:
        file.write(f"""\* CONSTANT definitions
CONSTANT
values <- MC_values
INIT
MC_Init
NEXT
MC_Next
INVARIANT
MC_Inv
\* Generated on {NOW}
""")

print_tla()
print_cfg()

