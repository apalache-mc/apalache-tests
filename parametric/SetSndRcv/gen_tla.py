#!/usr/bin/env python3
#
# TLA+/TLC generator for parametric SetSndRcv example.
# See SetSndRcv.tla / SetSndRcv_NoFullDrop.tla / SetSndRcv_NoFullDropCard.tla for the description.
#
# Andrey Kuprianov, 2020

import sys
import os
sys.path.append(os.path.dirname(sys.argv[0]) + "/../../scripts")
import genutils as g

def print_tla():
    values = "{" + ", ".join("\"v"+str(x)+"\"" for x in range(g.N)) + "}"
    with open(f"{g.FILE}.tla", "w") as file:
        file.write(f"""---- MODULE {g.FILE} ----
EXTENDS {g.NAMEVARIANT}, TLC

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

g.init("SetSndRcv","TLA+/TLC")
print_tla()
print_cfg()

g.init("SetSndRcv","TLA+/TLC", "NoFullDrop")
print_tla()
print_cfg()

g.init("SetSndRcv","TLA+/TLC", "NoFullDropCard")
print_tla()
print_cfg()
