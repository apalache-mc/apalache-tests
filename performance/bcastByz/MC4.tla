---- MODULE MC4 ----
EXTENDS APAbcastByz, TLC

\* CONSTANT definitions @modelParameterConstants:0F
const_1552924728004170000 == 
1
----

\* CONSTANT definitions @modelParameterConstants:1N
const_1552924728004171000 == 
4
----

\* CONSTANT definitions @modelParameterConstants:2T
const_1552924728004172000 == 
1
----

\* CONSTANT definitions @modelParameterConstants:3Faulty
const_1552924728004173000 == 
{4}
----

\* CONSTANT definitions @modelParameterConstants:4Corr
const_1552924728004174000 == 
1..3
----

MC_Init ==
Init
----
=============================================================================
\* Modification History
\* Created Mon Mar 18 16:58:48 CET 2019 by igor
