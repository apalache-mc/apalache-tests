----------------------------- MODULE Apa4FPaxos -------------------------------
EXTENDS TLC
-----------------------------------------------------------------------------
VARIABLE maxBal, maxVBal, maxVal, msgs


INSTANCE APAFPaxos WITH Value <- {0, 1},
                     Acceptor <- {"a1", "a2", "a3", "a4"},
                     Quorum1 <- {{"a1", "a2"},{"a3", "a4"}},
                     Quorum2 <- {{"a1", "a3"},{"a2", "a4"}},
                     maxBal <- maxBal,
                     maxVBal <- maxVBal,
                     maxVal <- maxVal,
                     msgs <- msgs

=============================================================================
