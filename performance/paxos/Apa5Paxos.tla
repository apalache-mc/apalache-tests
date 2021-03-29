------------------------ MODULE Apa5Paxos -------------------------------
EXTENDS Integers
VARIABLE
    \* @type: Str -> Int;
    maxBal, 
    \* @type: Str -> Int;
    maxVBal, \* <<maxVBal[a], maxVal[a]>> is the vote with the largest
    \* @type: Str -> Int;
    maxVal,    \* ballot number cast by a; it equals <<-1, None>> if
                    \* a has not cast any vote.
    \* @type: Set([type: Str, bal: Int, mbal: Int, acc: Str, val: Int, mval: Int]);
    msgs     \* The set of all messages that have been sent.

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

INSTANCE APAPaxos WITH Value <- Value,
                    Ballot <- Ballot,
                    Acceptor <- Acceptor,
                    Quorum <- Quorum

============================================================================
