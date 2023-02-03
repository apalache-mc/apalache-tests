--------------------------------- MODULE APAraft ---------------------------------
\* This is the formal specification for the Raft consensus algorithm.
\*
\* Copyright 2014 Diego Ongaro.
\* This work is licensed under the Creative Commons Attribution-4.0
\* International License https://creativecommons.org/licenses/by/4.0/

EXTENDS (*Naturals*) Integers, FiniteSets, Sequences, TLC, Variants

\* The set of server IDs
\*CONSTANTS Server
\*Server == {"s1", "s2", "s3"}
Server == {"s1", "s2", "s3", "s4", "s5"}

\* The set of requests that can go into the log
\*CONSTANTS Value
Value == {"0", "1"}

\*Quorum == {{"s1", "s2"}, {"s1", "s3"}, {"s2", "s3"}}

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

\* Server states.
\*CONSTANTS Follower, Candidate, Leader
Follower == "Follower"
Candidate == "Candidate"
Leader == "Leader"

\* A reserved value.
\*CONSTANTS Nil
Nil == "Nil"

----
\* Global variables

\* A bag of records representing requests and responses sent from one server
\* to another. TLAPS doesn't support the Bags module, so this is a function
\* mapping Message to Nat.
VARIABLE
    \* @typeAlias: entry = { term: Int, value: Str };
    \* Message types:
    \* CONSTANTS RequestVoteRequest, RequestVoteResponse,
    \*           AppendEntriesRequest, AppendEntriesResponse
    (*
       @typeAlias: requestVoteRequest = {
         mterm: Int, mlastLogTerm: Int,
         mlastLogIndex: Int, msource: Str, mdest: Str
       };
       @typeAlias: requestVoteResponse = {
         mterm: Int, msource: Str, mdest: Str,
         mvoteGranted: Bool, mlog: Seq($entry)
       };
       @typeAlias: appendEntriesRequest = {
         mterm: Int, msource: Str, mdest: Str,
         mlog: Seq($entry), mprevLogIndex: Int, mprevLogTerm: Int,
         mentries: Seq($entry), mcommitIndex: Int
       };
       @typeAlias: appendEntriesResponse = {
         mterm: Int, msource: Str, mdest: Str, msuccess: Bool, mmatchIndex: Int
       };
       @typeAlias: message = RequestVoteRequest($requestVoteRequest) |
                             RequestVoteResponse($requestVoteResponse) |
                             AppendEntriesRequest($appendEntriesRequest) |
                             AppendEntriesResponse($appendEntriesResponse);
       @type: $message -> Int;
     *)
    messages

\* @type: $requestVoteRequest => $message;
RequestVoteRequest(m) == Variant("RequestVoteRequest", m)

\* @type: $requestVoteResponse => $message;
RequestVoteResponse(m) == Variant("RequestVoteResponse", m)

\* @type: $appendEntriesRequest => $message;
AppendEntriesRequest(m) == Variant("AppendEntriesRequest", m)

\* @type: $appendEntriesResponse => $message;
AppendEntriesResponse(m) == Variant("AppendEntriesResponse", m)


\* A history variable used in the proof. This would not be present in an
\* implementation.
\* Keeps track of successful elections, including the initial logs of the
\* leader and voters' logs. Set of functions containing various things about
\* successful elections (see BecomeLeader).

VARIABLE
    (*
       @typeAlias: election = {
         eterm: Int, eleader: Str, elog: Seq($entry),
         evotes: Set(Str),
         evoterLog: (Str -> Seq($entry))
       };
       @type: Set($election);
     *)
    elections

\* A history variable used in the proof. This would not be present in an
\* implementation.
\* Keeps track of every log ever in the system (set of logs).

VARIABLE
    \* @type: Set(Seq($entry));
    allLogs
----
\* The following variables are all per server (functions with domain Server).
\* The server's term number.
VARIABLE
    \* @type: Str -> Int;
    currentTerm

\* The server's state (Follower, Candidate, or Leader).
VARIABLE
    \* @type: Str -> Str;
    state

\* The candidate the server voted for in its current term, or
\* Nil if it hasn't voted for any.
VARIABLE
    \* @type: Str -> Str;
    votedFor
serverVars == <<currentTerm, state, votedFor>>

\* A Sequence of log entries. The index into this sequence is the index of the
\* log entry. Unfortunately, the Sequence module defines Head(s) as the entry
\* with index 1, so be careful not to use that!
VARIABLE
    \* @type: Str -> Seq($entry);
    log
\* The index of the latest entry in the log the state machine may apply.
VARIABLE
    \* @type: Str -> Int;
    commitIndex
logVars == <<log, commitIndex>>

\* The following variables are used only on candidates:
\* The set of servers from which the candidate has received a RequestVote
\* response in its currentTerm.
VARIABLE
    \* @type: Str -> Set(Str);
    votesResponded
\* The set of servers from which the candidate has received a vote in its
\* currentTerm.
VARIABLE
    \* @type: Str -> Set(Str);
    votesGranted
\* A history variable used in the proof. This would not be present in an
\* implementation.
\* Function from each server that voted for this candidate in its currentTerm
\* to that voter's log.
VARIABLE
    \* @type: Str -> (Str -> Seq($entry));
    voterLog
candidateVars == <<votesResponded, votesGranted, voterLog>>

\* The following variables are used only on leaders:
\* The next entry to send to each follower.
VARIABLE
    \* @type: Str -> (Str -> Int);
    nextIndex
\* The latest entry that each follower has acknowledged is the same as the
\* leader's. This is used to calculate commitIndex on the leader.
VARIABLE
    \* @type: Str -> (Str -> Int);
    matchIndex
leaderVars == <<nextIndex, matchIndex, elections>>

\* End of per server variables.
----

\* All variables; used for stuttering (asserting state hasn't changed).
vars == <<messages, allLogs, (* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>
  
----
\* Helpers

\* The set of all quorums. This just calculates simple majorities, but the only
\* important property is that every quorum overlaps with every other.
\*Quorum == {i \in SUBSET(Server) : Cardinality(i) * 2 > Cardinality(Server)}
\* igor: see the constant above

\* The term of the last entry in a log, or 0 if the log is empty.
\* @type: Seq($entry) => Int;
LastTerm(xlog) == IF Len(xlog) = 0 THEN 0 ELSE xlog[Len(xlog)].term

\* Helper for Send and Reply. Given a message m and bag of messages, return a
\* new bag of messages with one more m in it.
\* @type: ($message, $message -> Int) => $message -> Int ;
WithMessage(m, msgs) ==
    IF m \in DOMAIN msgs THEN
        [msgs EXCEPT ![m] = msgs[m] + 1]
    ELSE
        msgs @@ (m :> 1)

\* Helper for Discard and Reply. Given a message m and bag of messages, return
\* a new bag of messages with one less m in it.
\*
\* A monster annotation. TODO: we need type aliases.
\* @type: ($message, $message -> Int) => $message -> Int ;
WithoutMessage(m, msgs) ==
    IF m \in DOMAIN msgs THEN
        [msgs EXCEPT ![m] = msgs[m] - 1]
    ELSE
        msgs

\* Add a message to the bag of messages.
Send(m) == messages' = WithMessage(m, messages)

\* Remove a message from the bag of messages. Used when a server is done
\* processing a message.
\* @type: $message => Bool;
Discard(m) == messages' = WithoutMessage(m, messages)

\* Combination of Send and Discard
\* @type: ($message, $message) => Bool;
Reply(response, request) ==
    messages' = WithoutMessage(request, WithMessage(response, messages))

\* Return the minimum value from a set, or undefined if the set is empty.
Min(s) == CHOOSE x \in s : \A y \in s : x <= y
\* Return the maximum value from a set, or undefined if the set is empty.
Max(s) == CHOOSE x \in s : \A y \in s : x >= y

----
\* Define initial values for all variables

InitHistoryVars == /\ elections = {}
                   /\ allLogs   = {}
                   /\ voterLog  = [i \in Server |-> [j \in {} |-> << >>]]
InitServerVars == /\ currentTerm = [i \in Server |-> 1]
                  /\ state       = [i \in Server |-> Follower]
                  /\ votedFor    = [i \in Server |-> Nil]
InitCandidateVars == /\ votesResponded = [i \in Server |-> {}]
                     /\ votesGranted   = [i \in Server |-> {}]
\* The values nextIndex[i][i] and matchIndex[i][i] are never read, since the
\* leader does not send itself messages. It's still easier to include these
\* in the functions.
InitLeaderVars == /\ nextIndex  = [i \in Server |-> [j \in Server |-> 1]]
                  /\ matchIndex = [i \in Server |-> [j \in Server |-> 0]]
InitLogVars == /\ log          = [i \in Server |-> << >>]
               /\ commitIndex  = [i \in Server |-> 0]
Init == /\ messages = [m \in {} |-> 0]
        /\ InitHistoryVars
        /\ InitServerVars
        /\ InitCandidateVars
        /\ InitLeaderVars
        /\ InitLogVars

----
\* Define state transitions

\* Server i restarts from stable storage.
\* It loses everything but its currentTerm, votedFor, and log.
Restart(i) ==
    /\ state'          = [state EXCEPT ![i] = Follower]
    /\ votesResponded' = [votesResponded EXCEPT ![i] = {}]
    /\ votesGranted'   = [votesGranted EXCEPT ![i] = {}]
    /\ voterLog'       = [voterLog EXCEPT ![i] = [j \in {} |-> <<>>]]
    /\ nextIndex'      = [nextIndex EXCEPT ![i] = [j \in Server |-> 1]]
    /\ matchIndex'     = [matchIndex EXCEPT ![i] = [j \in Server |-> 0]]
    /\ commitIndex'    = [commitIndex EXCEPT ![i] = 0]
    /\ UNCHANGED <<messages, currentTerm, votedFor, log, elections>>

\* Server i times out and starts a new election.
Timeout(i) == /\ state[i] \in {Follower, Candidate}
              /\ state' = [state EXCEPT ![i] = Candidate]
              /\ currentTerm' = [currentTerm EXCEPT ![i] = currentTerm[i] + 1]
              \* Most implementations would probably just set the local vote
              \* atomically, but messaging localhost for it is weaker.
              /\ votedFor' = [votedFor EXCEPT ![i] = Nil]
              /\ votesResponded' = [votesResponded EXCEPT ![i] = {}]
              /\ votesGranted'   = [votesGranted EXCEPT ![i] = {}]
              /\ voterLog'       = [voterLog EXCEPT ![i] = [j \in {} |-> <<>>]]
              /\ UNCHANGED <<messages, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Candidate i sends j a RequestVote request.
RequestVote(i, j) ==
    /\ state[i] = Candidate
    /\ j \notin votesResponded[i]
    /\ Send(RequestVoteRequest([
             mterm         |-> currentTerm[i],
             mlastLogTerm  |-> LastTerm(log[i]),
             mlastLogIndex |-> Len(log[i]),
             msource       |-> i,
             mdest         |-> j]))
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Leader i sends j an AppendEntries request containing up to 1 entry.
\* While implementations may want to send more than 1 at a time, this spec uses
\* just 1 because it minimizes atomic regions without loss of generality.
AppendEntries(i, j) ==
    /\ i /= j
    /\ state[i] = Leader
    /\ LET prevLogIndex == nextIndex[i][j] - 1
           prevLogTerm == IF prevLogIndex > 0 THEN
                              log[i][prevLogIndex].term
                          ELSE
                              0
           \* Send up to 1 entry, constrained by the end of the log.
           lastEntry == Min({Len(log[i]), nextIndex[i][j]})
           entries == SubSeq(log[i], nextIndex[i][j], lastEntry)
       IN Send(AppendEntriesRequest([
                mterm          |-> currentTerm[i],
                mprevLogIndex  |-> prevLogIndex,
                mprevLogTerm   |-> prevLogTerm,
                mentries       |-> entries,
                \* mlog is used as a history variable for the proof.
                \* It would not exist in a real implementation.
                mlog           |-> log[i],
                mcommitIndex   |-> Min({commitIndex[i], lastEntry}),
                msource        |-> i,
                mdest          |-> j]))
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Candidate i transitions to leader.
BecomeLeader(i) ==
    /\ state[i] = Candidate
    /\ votesGranted[i] \in Quorum
    /\ state'      = [state EXCEPT ![i] = Leader]
    /\ nextIndex'  = [nextIndex EXCEPT ![i] =
                         [j \in Server |-> Len(log[i]) + 1]]
    /\ matchIndex' = [matchIndex EXCEPT ![i] =
                         [j \in Server |-> 0]]
    /\ elections'  = elections \cup
                         {[eterm     |-> currentTerm[i],
                           eleader   |-> i,
                           elog      |-> log[i],
                           evotes    |-> votesGranted[i],
                           evoterLog |-> voterLog[i]]}
    /\ UNCHANGED <<messages, currentTerm, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, log, commitIndex>> \*logVars>>

\* Leader i receives a client request to add v to the log.
ClientRequest(i, v) ==
    /\ state[i] = Leader
    /\ LET entry == [term  |-> currentTerm[i],
                     value |-> v]
           newLog == Append(log[i], entry)
       IN  log' = [log EXCEPT ![i] = newLog]
    /\ UNCHANGED <<messages, (* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog,
                   (*leaderVars*) nextIndex, matchIndex, elections, commitIndex>>

\* Leader i advances its commitIndex.
\* This is done as a separate step from handling AppendEntries responses,
\* in part to minimize atomic regions, and in part so that leaders of
\* single-server clusters are able to mark entries committed.
AdvanceCommitIndex(i) ==
    /\ state[i] = Leader
    /\ LET \* The set of servers that agree up through index.
           Agree(index) == {i} \cup {k \in Server :
                                         matchIndex[i][k] >= index}
           \* The maximum indexes for which a quorum agrees
           agreeIndexes == {index \in DOMAIN log[i] : \* APALACHE FIX: using DOMAIN instead of 1..Len(log[i])
                                Agree(index) \in Quorum}
           \* New value for commitIndex'[i]
           newCommitIndex ==
              IF /\ agreeIndexes /= {}
                 /\ log[i][Max(agreeIndexes)].term = currentTerm[i]
              THEN
                  Max(agreeIndexes)
              ELSE
                  commitIndex[i]
       IN commitIndex' = [commitIndex EXCEPT ![i] = newCommitIndex]
    /\ UNCHANGED <<messages, (* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log>>

----
\* Message handlers
\* i = recipient, j = sender, m = message

\* Server i receives a RequestVote request from server j with
\* m.mterm <= currentTerm[i].
\* @type: (Str, Str, $requestVoteRequest) => Bool;
HandleRequestVoteRequest(i, j, m) ==
    LET logOk == \/ m.mlastLogTerm > LastTerm(log[i])
                 \/ /\ m.mlastLogTerm = LastTerm(log[i])
                    /\ m.mlastLogIndex >= Len(log[i])
        grant == /\ m.mterm = currentTerm[i]
                 /\ logOk
                 /\ votedFor[i] \in {Nil, j}
    IN /\ m.mterm <= currentTerm[i]
       /\ \/ grant  /\ votedFor' = [votedFor EXCEPT ![i] = j]
          \/ ~grant /\ UNCHANGED votedFor
       /\ Reply(RequestVoteResponse([
                 mterm        |-> currentTerm[i],
                 mvoteGranted |-> grant,
                 \* mlog is used just for the `elections' history variable for
                 \* the proof. It would not exist in a real implementation.
                 mlog         |-> log[i],
                 msource      |-> i,
                 mdest        |-> j]),
                 RequestVoteRequest(m))
       /\ UNCHANGED <<state, currentTerm, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Server i receives a RequestVote response from server j with
\* m.mterm = currentTerm[i].
\* @type: (Str, Str, $requestVoteResponse) => Bool;
HandleRequestVoteResponse(i, j, m) ==
    \* This tallies votes even when the current state is not Candidate, but
    \* they won't be looked at, so it doesn't matter.
    /\ m.mterm = currentTerm[i]
    /\ votesResponded' = [votesResponded EXCEPT ![i] =
                              votesResponded[i] \cup {j}]
    /\ \/ /\ m.mvoteGranted
          /\ votesGranted' = [votesGranted EXCEPT ![i] =
                                  votesGranted[i] \cup {j}]
          /\ voterLog' = [voterLog EXCEPT ![i] =
                              voterLog[i] @@ (j :> m.mlog)]
       \/ /\ ~m.mvoteGranted
          /\ UNCHANGED <<votesGranted, voterLog>>
    /\ Discard(RequestVoteResponse(m))
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Server i receives an AppendEntries request from server j with
\* m.mterm <= currentTerm[i]. This just handles m.entries of length 0 or 1, but
\* implementations could safely accept more by treating them the same as
\* multiple independent requests of 1 entry.
\* @type: (Str, Str, $appendEntriesRequest) => Bool;
HandleAppendEntriesRequest(i, j, m) ==
    LET logOk == \/ m.mprevLogIndex = 0
                 \/ /\ m.mprevLogIndex > 0
                    /\ m.mprevLogIndex <= Len(log[i])
                    /\ m.mprevLogTerm = log[i][m.mprevLogIndex].term
    IN /\ m.mterm <= currentTerm[i]
       /\ \/ /\ \* reject request
                \/ m.mterm < currentTerm[i]
                \/ /\ m.mterm = currentTerm[i]
                   /\ state[i] = Follower
                   /\ \lnot logOk
             /\ Reply(AppendEntriesResponse([
                       mterm           |-> currentTerm[i],
                       msuccess        |-> FALSE,
                       mmatchIndex     |-> 0,
                       msource         |-> i,
                       mdest           |-> j]),
                       AppendEntriesRequest(m))
             /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, log, commitIndex>> \*logVars>>
          \/ \* return to follower state
             /\ m.mterm = currentTerm[i]
             /\ state[i] = Candidate
             /\ state' = [state EXCEPT ![i] = Follower]
             /\ UNCHANGED <<currentTerm, votedFor, log, commitIndex, messages>> \* logVars>>
          \/ \* accept request
             /\ m.mterm = currentTerm[i]
             /\ state[i] = Follower
             /\ logOk
             /\ LET index == m.mprevLogIndex + 1
                IN \/ \* already done with request
                       /\ \/ m.mentries = << >>
                          \/ /\ Len(log[i]) >= index
                             /\ log[i][index].term = m.mentries[1].term
                          \* This could make our commitIndex decrease (for
                          \* example if we process an old, duplicated request),
                          \* but that doesn't really affect anything.
                       /\ commitIndex' = [commitIndex EXCEPT ![i] =
                                              m.mcommitIndex]
                       /\ Reply(AppendEntriesResponse([
                                 mterm           |-> currentTerm[i],
                                 msuccess        |-> TRUE,
                                 mmatchIndex     |-> m.mprevLogIndex +
                                                     Len(m.mentries),
                                 msource         |-> i,
                                 mdest           |-> j]),
                                 AppendEntriesRequest(m))
                       /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, log>> \*logVars>>
                   \/ \* conflict: remove 1 entry
                       /\ m.mentries /= << >>
                       /\ Len(log[i]) >= index
                       /\ log[i][index].term /= m.mentries[1].term
                       (*/\ LET new == [index2 \in 1..(Len(log[i]) - 1)} |->
                                          log[i][index2]] \* APALACHE: type error, a function treated as a sequence
                        *) \* the commented code above treats a function as a sequence, which is OK in pure TLA+ 
                       /\ LET new == SubSeq(log[i], 1, Len(log[i]) - 1) \* Igor: why not writing this simple expression?
                          IN log' = [log EXCEPT ![i] = new]
                       /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, commitIndex, messages>>
                   \/ \* no conflict: append entry
                       /\ m.mentries /= << >>
                       /\ Len(log[i]) = m.mprevLogIndex
                       /\ log' = [log EXCEPT ![i] =
                                      Append(log[i], m.mentries[1])]
                       /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, commitIndex, messages>>
       /\ UNCHANGED <<(*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections>>

\* Server i receives an AppendEntries response from server j with
\* m.mterm = currentTerm[i].
\* @type: (Str, Str, $appendEntriesResponse) => Bool;
HandleAppendEntriesResponse(i, j, m) ==
    /\ m.mterm = currentTerm[i]
    /\ \/ /\ m.msuccess \* successful
          /\ nextIndex'  = [nextIndex  EXCEPT ![i][j] = m.mmatchIndex + 1]
          /\ matchIndex' = [matchIndex EXCEPT ![i][j] = m.mmatchIndex]
       \/ /\ \lnot m.msuccess \* not successful
          /\ nextIndex' = [nextIndex EXCEPT ![i][j] =
                               Max({nextIndex[i][j] - 1, 1})]
          /\ UNCHANGED <<matchIndex>>
    /\ Discard(AppendEntriesResponse(m))
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, elections, log, commitIndex>> \* logVars

\* Any RPC with a newer term causes the recipient to advance its term first.
\* @type: (Str, Str, Int) => Bool;
UpdateTerm(i, j, mterm) ==
    /\ mterm > currentTerm[i]
    /\ currentTerm'    = [currentTerm EXCEPT ![i] = mterm]
    /\ state'          = [state       EXCEPT ![i] = Follower]
    /\ votedFor'       = [votedFor    EXCEPT ![i] = Nil]
       \* messages is unchanged so m can be processed further.
    /\ UNCHANGED <<messages, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Responses with stale terms are ignored.
\* @type: (Str, Str, $message) => Bool;
DropStaleResponse(i, j, m) ==
    LET mterm ==
      IF VariantTag(m) = "RequestVoteResponse"
      THEN VariantGetUnsafe("RequestVoteResponse", m).mterm
      ELSE VariantGetUnsafe("AppendEntriesResponse", m).mterm
    IN
    /\ mterm < currentTerm[i]
    /\ Discard(m)
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* Receive a message.
\* @type: $message => Bool;
Receive(m) ==
    LET i == IF VariantTag(m) = "RequestVoteResponse"
             THEN VariantGetUnsafe("RequestVoteResponse", m).mdest
             ELSE
                IF VariantTag(m) = "RequestVoteResponse"
                THEN VariantGetUnsafe("RequestVoteResponse", m).mdest
                ELSE
                    IF VariantTag(m) = "AppendEntriesRequest"
                    THEN VariantGetUnsafe("AppendEntriesRequest", m).mdest
                    ELSE
                        VariantGetUnsafe("AppendEntriesResponse", m).mdest
        j == IF VariantTag(m) = "RequestVoteResponse"
             THEN VariantGetUnsafe("RequestVoteResponse", m).msource
             ELSE
                IF VariantTag(m) = "RequestVoteResponse"
                THEN VariantGetUnsafe("RequestVoteResponse", m).msource
                ELSE
                    IF VariantTag(m) = "AppendEntriesRequest"
                    THEN VariantGetUnsafe("AppendEntriesRequest", m).msource
                    ELSE
                        VariantGetUnsafe("AppendEntriesResponse", m).msource
        mterm == IF VariantTag(m) = "RequestVoteResponse"
             THEN VariantGetUnsafe("RequestVoteResponse", m).mterm
             ELSE
                IF VariantTag(m) = "RequestVoteResponse"
                THEN VariantGetUnsafe("RequestVoteResponse", m).mterm
                ELSE
                    IF VariantTag(m) = "AppendEntriesRequest"
                    THEN VariantGetUnsafe("AppendEntriesRequest", m).mterm
                    ELSE
                        VariantGetUnsafe("AppendEntriesResponse", m).mterm
    IN \* Any RPC with a newer term causes the recipient to advance
       \* its term first. Responses with stale terms are ignored.
       \/ UpdateTerm(i, j, mterm)
       \/ /\ VariantTag(m) = "RequestVoteRequest"
          /\ HandleRequestVoteRequest(i, j, VariantGetUnsafe("RequestVoteRequest", m))
       \/ /\ VariantTag(m) = "RequestVoteResponse"
          /\ \/ DropStaleResponse(i, j, m)
             \/ HandleRequestVoteResponse(i, j, VariantGetUnsafe("RequestVoteResponse", m))
       \/ /\ VariantTag(m) = "AppendEntriesRequest"
          /\ HandleAppendEntriesRequest(i, j, VariantGetUnsafe("AppendEntriesRequest", m))
       \/ /\ VariantTag(m) = "AppendEntriesResponse"
          /\ \/ DropStaleResponse(i, j, m)
             \/ HandleAppendEntriesResponse(i, j, VariantGetUnsafe("AppendEntriesResponse", m))
        
\* End of message handlers.
----
\* Network state transitions

\* The network duplicates a message
DuplicateMessage(m) ==
    /\ Send(m)
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

\* The network drops a message
DropMessage(m) ==
    /\ Discard(m)
    /\ UNCHANGED <<(* serverVars *) currentTerm, state, votedFor, (*candidateVars*) votesResponded, votesGranted, voterLog, (*leaderVars*) nextIndex, matchIndex, elections, log, commitIndex>> \*logVars>>

----
\* Defines how the variables may transition.
Next == /\ \/ \E i \in Server : Restart(i)
           \/ \E i \in Server : Timeout(i)
           \/ \E i,j \in Server : RequestVote(i, j)
           \/ \E i \in Server : BecomeLeader(i)
           \/ \E i \in Server, v \in Value : ClientRequest(i, v)
           \/ \E i \in Server : AdvanceCommitIndex(i)
           \/ \E i,j \in Server : AppendEntries(i, j)
           \/ \E m \in DOMAIN messages : Receive(m)
           \/ \E m \in DOMAIN messages : DuplicateMessage(m)
           \/ \E m \in DOMAIN messages : DropMessage(m)
           \* History variable that tracks every log ever:
        /\ allLogs' = allLogs \cup {log[i] : i \in Server}

\* The specification must start with the initial state and transition according
\* to Next.
Spec == Init /\ [][Next]_vars

----
\* THIS IS NOT PART OF THE ORIGINAL RAFT SPECIFICATION
\* Safety properties that can be found in Appendix B of Ongaro's thesis

Lemma2 == \A e, f \in elections: e.eterm = f.eterm => e.eleader = f.eleader

Lemma4 ==
  \A l, m \in allLogs:
    \A index \in DOMAIN l:
      index \in DOMAIN m /\ m[index].term = l[index].term
        => \A pindex \in {i \in DOMAIN l: i <= index}:
          l[pindex] = m[pindex]
          
\* obviously, this property should be violated at some point
NoLeaders == \A s \in Server: state[s] /= Leader

OneLeader == \A s, t \in Server: s = t \/ state[s] /= Leader \/ state[t] /= Leader          

\* obviously, this property should be violated at some point          
NoCommits == \A s \in Server: commitIndex[s] = 0
          
\* obviously, this property should be violated at some point          
TwoLogs ==
  \A l, m \in allLogs: l = m

\* APALACHE: to use finite sets, we need bounds on the maximum index and term
MaxIndex == 4
MaxTerm == 4

===============================================================================

\* Changelog:
\*
\* 2014-12-02:
\* - Fix AppendEntries to only send one entry at a time, as originally
\*   intended. Since SubSeq is inclusive, the upper bound of the range should
\*   have been nextIndex, not nextIndex + 1. Thanks to Igor Kovalenko for
\*   reporting the issue.
\* - Change matchIndex' to matchIndex (without the apostrophe) in
\*   AdvanceCommitIndex. This apostrophe was not intentional and perhaps
\*   confusing, though it makes no practical difference (matchIndex' equals
\*   matchIndex). Thanks to Hugues Evrard for reporting the issue.
\*
\* 2014-07-06:
\* - Version from PhD dissertation
