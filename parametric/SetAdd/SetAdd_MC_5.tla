---- MODULE SetAdd_MC_5 ----
EXTENDS SetAdd, TLC

MC_values == {"v0", "v1", "v2", "v3", "v4"}
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created Tue Apr 21 18:53:29 CEST 2020 by andrey
