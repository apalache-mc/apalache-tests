---- MODULE IntClocks_9 ----
EXTENDS IntClocks, TLC

MC_CLOCKS == {"c0", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8"}
----
MC_BOUND == 10
----
MC_ERRMAX == 10
----
MC_Init == Init
----
MC_Next == Next
----
MC_Inv == Inv
----

=============================================================================
\* Modification History
\* Created Thu Apr 30 15:14:49 CEST 2020 by andrey
