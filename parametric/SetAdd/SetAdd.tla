---------------------------- MODULE SetAdd --------------------------
EXTENDS FiniteSets

(* APALACHE *)
a <: b == a

CONSTANT
  values

VARIABLE
  set

Init ==
  set = {} <: {STRING}

AddOne == 
  \E x \in (values \ set) : set' = set \union {x}

Next ==
 AddOne

Inv == set /= values

=============================================================================
\* Modification History
\* Created Tue Apr 21 17:12:59 CEST 2020 by andrey

