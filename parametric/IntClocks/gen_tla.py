#!/usr/bin/env python3
#
# TLA+/TLC generator for parametric IntCLocks example.
# See IntClocks.tla for the description.
#
# Andrey Kuprianov, 2020

import sys
import os
sys.path.append(os.path.dirname(sys.argv[0]) + "/../../scripts")
import genutils as g

def print_tla():
    clocks = "{" + ", ".join("\"c"+str(x)+"\"" for x in range(g.N)) + "}"
    errmax = 10   
    if g.VARIANT == "Bounded":
        bound = errmax - 1
    else:
       bound = errmax
    with open(f"{g.FILE}.tla", "w") as file:
        file.write(f"""---- MODULE {g.FILE} ----
EXTENDS {g.NAME}, TLC

MC_CLOCKS == {clocks}
----
MC_BOUND == {bound}
----
MC_ERRMAX == {errmax}
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
CLOCKS <- MC_CLOCKS
BOUND <- MC_BOUND
ERRMAX <- MC_ERRMAX

INIT
MC_Init

NEXT
MC_Next

INVARIANT
MC_Inv
\* Generated on {g.NOW}
""")

g.init("IntClocks","TLA+/TLC")
print_tla()
print_cfg()

g.init("IntClocks","TLA+/TLC", "Bounded")
print_tla()
print_cfg()
