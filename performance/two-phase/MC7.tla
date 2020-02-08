---- MODULE MC7 ----
EXTENDS APATwoPhase, TLC

\* CONSTANT definitions @modelParameterConstants:0RM
const_1553089336183298000 == 
{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}
----

\* INIT definition @modelBehaviorInit:0
init_1553089336183299000 ==
Init
----
\* NEXT definition @modelBehaviorNext:0
next_1553089336183300000 ==
Next
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1553089336183301000 ==
TCConsistent
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 14:42:16 CET 2019 by igor
