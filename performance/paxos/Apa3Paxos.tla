------------------------ MODULE Apa3Paxos -------------------------------
EXTENDS Integers
VARIABLE maxBal, maxVBal, maxVal, msgs

Value == {0, 1}
Ballot == 0..4
Acceptor == {"a1", "a2", "a3"}
Quorum == {{"a1", "a2"}, {"a2", "a3"}, {"a1", "a3"}}

INSTANCE APAPaxos WITH Value <- Value,
                    Ballot <- Ballot,
                    Acceptor <- Acceptor,
                    Quorum <- Quorum

============================================================================
