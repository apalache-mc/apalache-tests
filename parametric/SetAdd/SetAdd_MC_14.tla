---- MODULE SetAdd_MC_14 ----
EXTENDS SetAdd, TLC

MC_values == {"v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13"}
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created Tue Apr 21 18:53:51 CEST 2020 by andrey
