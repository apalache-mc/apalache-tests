---------------------------- MODULE SetAddDel --------------------------
\* In this parametric example we have N values, and a set variable, initially empty.
\* At each step we can add one element to the set, or remove one element from the set.
\* The invariant specifies that the set is not complete,
\* i.e., we ask whether a state where the set contains all the values is reachable.
\* This final configuration is reachable in exactly N steps.
\*
\* Andrey Kuprianov, 2020

EXTENDS FiniteSets

(* APALACHE type annotation *)
a <: b == a

CONSTANT
  values

VARIABLE
  set

Init ==
  set = {} <: {STRING}

AddOne == 
  \E x \in (values \ set) : set' = set \union {x}

DelOne == 
  \E x \in set : set' = set \ {x}

Next ==
 \/ AddOne
 \/ DelOne

Inv == set /= values

=============================================================================
\* Modification History
\* Last modified Mon Apr 27 14:55:52 CEST 2020 by andrey
\* Created Tue Apr 21 17:12:59 CEST 2020 by andrey


