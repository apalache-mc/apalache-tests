#!/usr/bin/env python3
#
# SMT generator for parametric SetAdd example.
# See SetAdd.tla for the example description.
# SMT encoding uses quantifiers, and models bounded model checking,
# where invariant violation is checked at each step.
#
# Andrey Kuprianov, 2020

import sys
import os
sys.path.append(os.path.dirname(sys.argv[0]) + "/../../scripts")
import genutils as g

g.init("SetAdd","SMT")

def print_start(file):
  file.write(f"""; Quantified encoding for {g.NAME} example of size {g.N}
; Simulates bounded model checking run of length {g.N}
; Created {g.NOW} by {g.USER}

""")
  file.write("(declare-datatypes () ((Values ")
  for i in range(g.N): 
    file.write("p{} ".format(i))
  file.write(")))")
  file.write("""
(define-fun init () (Set Values)
    ((as const (Set Values)) false))

(define-fun all () (Set Values)
    ((as const (Set Values)) true))    

(declare-const s0 (Set Values))
(assert (= s0 init))
""")


def print_level(file, i):
    file.write("""
(declare-const s{1} (Set Values))

(assert 
  (exists 
    ((x Values)) 
    (and 
      (select s{1} x) (not (select s{0} x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s{1} y) (select s{0} y))
        )
      )
    )
  )
)

(push)
(assert (= s{1} all))
(check-sat)
(pop)
""".format(i, i+1))

with open(f"{g.FILE}.smt", "w") as file:
    print_start(file)
    for i in range(g.N): 
      print_level(file, i)
