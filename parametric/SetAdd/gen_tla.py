#!/usr/bin/env python3
#
# TLA+/TLC generator for parametric SetAdd example.
# See SetAdd.tla for the description.
#
# Andrey Kuprianov, 2020

import sys
import os
sys.path.append(os.path.dirname(sys.argv[0]) + "/../../scripts")
import genutils as g

g.init("SetAdd","TLA+/TLC")

def print_tla():
    values = "{" + ", ".join("\"v"+str(x)+"\"" for x in range(g.N)) + "}"
    with open(f"{g.FILE}.tla", "w") as file:
        file.write(f"""---- MODULE {g.NAME}_MC_{g.N} ----
EXTENDS {g.NAME}, TLC

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
\* Created {g.NOW} by {g.USER}
""")

def print_cfg():
    values = " ".join("v"+str(x) for x in range(g.N))
    with open(f"{g.FILE}.cfg", "w") as file:
        file.write(f"""\* CONSTANT definitions
CONSTANT
values <- MC_values
INIT
MC_Init
NEXT
MC_Next
INVARIANT
MC_Inv
\* Generated on {g.NOW}
""")

print_tla()
print_cfg()

