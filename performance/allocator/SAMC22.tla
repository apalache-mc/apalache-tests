---- MODULE SAMC22 ----
EXTENDS APASimpleAllocator, TLC

\* CONSTANT definitions @modelParameterConstants:0Clients
MC_Clients == 
{"c1","c2"}
----

\* CONSTANT definitions @modelParameterConstants:1Resources
MC_Resources == 
{"r1", "r2"}
=============================================================================
\* Modification History
\* Created Sun Mar 17 19:07:28 CET 2019 by igor
