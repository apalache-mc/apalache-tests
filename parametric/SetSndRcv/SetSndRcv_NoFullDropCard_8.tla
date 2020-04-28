---- MODULE SetSndRcv_NoFullDropCard_8 ----
EXTENDS SetSndRcv_NoFullDropCard, TLC

MC_values == {"v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7"}
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created Tue Apr 28 15:52:53 CEST 2020 by andrey
