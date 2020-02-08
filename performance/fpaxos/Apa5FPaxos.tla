----------------------------- MODULE Apa5FPaxos -------------------------------
EXTENDS TLC
-----------------------------------------------------------------------------
VARIABLE maxBal, maxVBal, maxVal, msgs


INSTANCE APAFPaxos WITH Value <- {0, 1},
                     Acceptor <- {"a1", "a2", "a3", "a4", "a5"},
                     Quorum1 <- {
                        {"a1", "a2", "a5"}, 
                        {"a1", "a3", "a5"}, 
                        {"a2", "a3", "a5"}, 
                        {"a1", "a4", "a5"}, 
                        {"a2", "a4", "a5"}, 
                        {"a3", "a4", "a5"}
                     },
                     Quorum2 <- {
                        {"a1", "a5"}, 
                        {"a2", "a5"}, 
                        {"a3", "a5"}, 
                        {"a4", "a5"}
                     },
                     maxBal <- maxBal,
                     maxVBal <- maxVBal,
                     maxVal <- maxVal,
                     msgs <- msgs

=============================================================================
