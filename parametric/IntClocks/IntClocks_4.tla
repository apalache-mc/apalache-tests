---- MODULE IntClocks_4 ----
EXTENDS IntClocks, TLC

MC_CLOCKS == {"c0", "c1", "c2", "c3"}
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
\* Created Thu Apr 30 15:14:42 CEST 2020 by andrey
