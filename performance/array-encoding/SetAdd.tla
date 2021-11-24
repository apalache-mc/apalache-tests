---------------------------- MODULE SetAdd --------------------------
\* In this parametric example we have N values, and a set variable, initially empty.
\* At each step we can add one element to the set.
\* The invariant specifies that the set is not complete,
\* i.e., we ask whether a state where the set contains all the values is reachable.
\* This final configuration is reachable in exactly N steps.
\*
\*
\* check the spec with arguments --cinit=CInit<N> --length=<N>
\*
\* Andrey Kuprianov, Shon Feder 2021

EXTENDS FiniteSets

CONSTANT
  \* @type: Set(Int);
  values

VARIABLE
  \* @type: Set(Int);
  set

\* Constant intialization predicates allowing to run the spec for sets of different
\* cardinalities
CInit1 == values = {1}
CInit2 == values = {1, 2}
CInit3 == values = {1, 2, 3}
CInit4 == values = {1, 2, 3, 4}
CInit5 == values = {1, 2, 3, 4, 5}
CInit6 == values = {1, 2, 3, 4, 5, 6}
CInit7 == values = {1, 2, 3, 4, 5, 6, 7}
CInit8 == values = {1, 2, 3, 4, 5, 6, 7, 8}
CInit9 == values = {1, 2, 3, 4, 5, 6, 7, 8, 9}
CInit10 == values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

Init ==
  set = {}

AddOne == 
  \E x \in (values \ set) : set' = set \union {x}

Next ==
 AddOne

Inv == set /= values

=============================================================================
