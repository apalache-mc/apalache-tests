#!/usr/bin/env python3
#
# SMT generator for parametric SetSndRcv example.
# See SetSndRcv.tla / SetSndRcv_NoFullDrop.tla for the example description.
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
; Simulates bounded model checking run of length 2*{g.N}
; Created {g.NOW} by {g.USER}

""")
  file.write("(declare-datatypes () ((Values ")
  for i in range(g.N): 
    file.write("p{} ".format(i))
  file.write(")))")
  file.write("""
(define-fun none () (Set Values)
    ((as const (Set Values)) false))

(define-fun all () (Set Values)
    ((as const (Set Values)) true))    

; sender
(declare-const s0 (Set Values))
(assert (= s0 all))

; receiver
(declare-const r0 (Set Values))
(assert (= r0 none))

; medium
(declare-const m0 (Set Values))
(assert (= m0 none))
""")




def print_level(file, i):
    if g.VARIANT == "":
        drop = """(and
  (= r{0} r{1})
  (= s{0} s{1})
  (exists 
    ((x Values)) 
    (and 
      (select m{0} x) (not (select m{1} x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m{1} y) (select m{0} y))
        )
      )
    )
  ))""".format(i, i+1)
    elif g.VARIANT == "NoFullDrop":
        drop = """(and
  (= r{0} r{1})
  (= s{0} s{1})
  (exists 
    ((x Values) (y Values)) 
    (and 
      (not (= x y)) (select m{0} y)
      (select m{0} x) (not (select m{1} x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m{1} y) (select m{0} y))
        )
      )
    )
  ))""".format(i, i+1)
    else:
        raise Exception(f"can't generate variant {g.VARIANT} of SMT encoding")
    file.write("""
(declare-const s{1} (Set Values))
(declare-const r{1} (Set Values))
(declare-const m{1} (Set Values))

(assert (or
  ; Send
  (and
  (= r{0} r{1})
  (exists 
    ((x Values)) 
    (and 
      (select s{0} x) (not (select s{1} x))
      (select m{1} x) (not (select m{0} x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s{1} y) (select s{0} y))
             (= (select m{1} y) (select m{0} y))
           )
        )
      )
    )
  ))

  ; Drop
  {2}
  ; Receive
  (and
  (= s{0} s{1})
  (= m{0} m{1})
  (exists 
    ((x Values)) 
    (and 
      (select r{1} x) (not (select r{0} x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r{1} y) (select r{0} y))
        )
      )
    )
  ))
))

(push)
(assert (= s{1} none))
(assert (= r{1} none))
(assert (= m{1} none))
(check-sat)
(pop)
""".format(i, i+1, drop))

g.init("SetSndRcv","SMT")

with open(f"{g.FILE}.smt", "w") as file:
    print_start(file)
    for i in range(2*g.N): 
      print_level(file, i)

g.init("SetSndRcv","SMT", "NoFullDrop")

with open(f"{g.FILE}.smt", "w") as file:
    print_start(file)
    for i in range(2*g.N): 
      print_level(file, i)

