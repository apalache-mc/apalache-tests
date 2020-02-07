------------------------ MODULE Apa5Paxos -------------------------------
EXTENDS Integers
VARIABLE maxBal, maxVBal, maxVal, msgs

Value == {0, 1}
Ballot == 0..4
Acceptor == {"a1", "a2", "a3", "a4", "a5"}
Quorum == {
        {"a1", "a2", "a3"},
        {"a1", "a2", "a4"},
        {"a1", "a3", "a4"},
        {"a2", "a3", "a4"},
        {"a1", "a2", "a5"},
        {"a1", "a3", "a5"},
        {"a2", "a3", "a5"},
        {"a1", "a4", "a5"},
        {"a2", "a4", "a5"},
        {"a3", "a4", "a5"}
       }

INSTANCE Paxos WITH Value <- Value,
                    Ballot <- Ballot,
                    Acceptor <- Acceptor,
                    Quorum <- Quorum

============================================================================
