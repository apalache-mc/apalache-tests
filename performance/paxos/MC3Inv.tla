---- MODULE MC3Inv ----
EXTENDS Paxos, TLC

\* CONSTANT definitions @modelParameterConstants:0Ballot
const_1552928839273213000 == 
0..2
----

\* CONSTANT definitions @modelParameterConstants:1Acceptor
const_1552928839273214000 == 
{"a1", "a2", "a3"}
----

\* CONSTANT definitions @modelParameterConstants:2Value
const_1552928839273215000 == 
0..1
----

\* CONSTANT definitions @modelParameterConstants:3Quorum
const_1552928839273216000 == 
{{"a1", "a2"}, {"a2", "a3"}, {"a1", "a3"}}
----

\* INIT definition @modelBehaviorInit:0
init_1552928839273217000 ==
Inv
----
\* NEXT definition @modelBehaviorNext:0
next_1552928839273218000 ==
Next
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1552928839273219000 ==
Inv
----
=============================================================================
\* Modification History
\* Created Mon Mar 18 18:07:19 CET 2019 by igor
