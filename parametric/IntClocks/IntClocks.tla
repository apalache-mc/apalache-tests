---------------------------- MODULE IntClocks --------------------------
\* A set of independent CLOCKS evelove asynchronously.
\* Each clock can either advance, if it's value is less than BOUND,
\* or reset to 0 at any point.
\* The invariant specifies that at least one clock has not reached ERRMAX.
\* Accordingly, the error state is reached if all clocks are equal to ERRMAX.
\* The error is unreachable if BOUND < ERRMAX,
\* otherwise it's reachable in exactly (|CLOCKS| * ERRMAX) steps.
\*
\* Andrey Kuprianov, 2020

EXTENDS Naturals

CONSTANT
  CLOCKS,
  BOUND,
  ERRMAX

VARIABLE
  clocks 
  
Init ==
  clocks = [ c \in CLOCKS |-> 0 ]

Advance(c) == clocks' = [ clocks 
  EXCEPT ![c] = IF clocks[c] < BOUND THEN clocks[c] + 1 ELSE 0 ] 


Reset(c) == clocks' = [ clocks EXCEPT ![c] = 0 ] 


Next == 
  \exists c \in CLOCKS :
    Advance(c) \/ Reset(c)
       
Inv == 
  \exists c \in CLOCKS :
    clocks[c] /= ERRMAX
      

=============================================================================
\* Modification History
\* Last modified Thu Apr 30 15:13:51 CEST 2020 by andrey
\* Created Wed Apr 29 16:39:46 CEST 2020 by andrey
