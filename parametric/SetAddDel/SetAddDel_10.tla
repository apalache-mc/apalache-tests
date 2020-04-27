---- MODULE SetAddDel_10 ----
EXTENDS SetAddDel, TLC

MC_values == {"v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9"}
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created Mon Apr 27 16:55:33 CEST 2020 by andrey
