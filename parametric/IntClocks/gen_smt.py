#!/usr/bin/env python3
#
# SMT generator for parametric IntClocks example.
# See IntClocks.tla for the example description.
# SMT encoding uses quantifiers, and models bounded model checking,
# where invariant violation is checked at each step.
#
# Andrey Kuprianov, 2020

import sys
import os
sys.path.append(os.path.dirname(sys.argv[0]) + "/../../scripts")
import genutils as g

def print_start(file):
  file.write(f"""; Quantified encoding for {g.NAMEVARIANT} example of size {g.N}
; Simulates bounded model checking run of length {g.N}*10
; Created {g.NOW} by {g.USER}

""")
  file.write("(declare-datatypes () ((Values ")
  for i in range(g.N): 
    file.write("p{} ".format(i))
  file.write(")))")
  file.write("""
(define-fun none () (Array Values Int)
    ((as const (Array Values Int)) 0))

(define-fun all () (Array Values Int)
    ((as const (Array Values Int)) 10))

(declare-const c0 (Array Values Int))
(assert (= c0 none))
""")




def print_level(file, i):
    if g.VARIANT == "Bounded":
        bound = 9
    else:
        bound = 10
    file.write("""
(declare-const c{1} (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c{1} x) (ite (< (select c{0} x) {2}) (+ (select c{0} x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c{1} y) (select c{0} y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c{1} x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c{1} y) (select c{0} y))
        )
      )
    )
  )
))

(push)
(assert (= c{1} all))
(check-sat)
(pop)
""".format(i, i+1, bound))

g.init("IntClocks","SMT")

with open(f"{g.FILE}.smt", "w") as file:
    print_start(file)
    for i in range(10*g.N): 
      print_level(file, i)

g.init("IntClocks","SMT", "Bounded")

with open(f"{g.FILE}.smt", "w") as file:
    print_start(file)
    for i in range(10*g.N): 
      print_level(file, i)


