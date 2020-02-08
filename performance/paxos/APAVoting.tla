------------------------------- MODULE APAVoting ------------------------------- 
(***************************************************************************)
(* This module specifies a consensus algorithm that at first glance looks  *)
(* perfectly useless.  It's a multiprocess algorithm in which evaluating   *)
(* the enabling condition of an action in one process requires atomically  *)
(* reading values of variables maintained by all the other processes.  It  *)
(* can be directly implemented only by using a central lock that each      *)
(* process must acquire before its own variables.  Such a simple-minded    *)
(* implementation is ridiculously inefficient.  Yet this is the basic      *)
(* algorithm implemented by Paxos.  It was the algorithm that I first      *)
(* developed when I invented Paxos, though while developing it I knew how  *)
(* it would be implemented.                                                *)
(*                                                                         *)
(* The algorithm is executed by a set of processes that, for historical    *)
(* reasons, are called `acceptors'.  Each acceptor can propose a value.    *)
(* To implement consensus, a single number must be chosen--despite the     *)
(* failure of some acceptors--where a failed acceptor simply stops doing   *)
(* anything.  The obvious approach is to let the acceptors vote on which   *)
(* value to choose, and to let the value be chosen if a majority of        *)
(* acceptors have voted for it.  The problem with that approach is that if *)
(* there are 2N+1 acceptors, what happens if N acceptors vote for one      *)
(* value v1, N acceptors vote for another value v2, and the remaining      *)
(* acceptor fails.  It's possible that the failed acceptor had voted for   *)
(* either v1 or v2, causing that value to be chosen.  How can the other    *)
(* acceptors know to do?                                                   *)
(*                                                                         *)
(* Instead of trying to solve that problem, our algorithm has the          *)
(* acceptors cast votes in a sequence of numbered ballots.  A value is     *)
(* considered to be chosen if a majority of the acceptors vote for it in   *)
(* any single ballot.  The ballots satisfy two properties:                 *)
(*                                                                         *)
(*   1. All acceptors that vote in a ballot must vote for the same value.  *)
(*                                                                         *)
(*   2. An acceptor can vote for a value v in ballot number b only if      *)
(*      the following condition holds: it is impossible that in a          *)
(*      lower-numbered ballot, any value other v has been chosen or will   *)
(*      be chosen.  (When this condition holds, we say that v is `safe'    *)
(*      at ballot number b.                                                *)
(*                                                                         *)
(* Property 1 is guaranteed by simply not permitting an acceptor to vote   *)
(* for value v in a ballot if some other acceptor has voted for a          *)
(* different value in that ballot.  Property 2 ensures that at most one    *)
(* value can be chosen.  Satisfying that property is not trivial and lies  *)
(* at the heart of this algorithm (and of the Paxos algorithm).            *)
(*                                                                         *)
(* We will not assume any liveness property of the algorithm, which means  *)
(* that any acceptor can stop at any time.  Hence, the specification does  *)
(* not need any explicit acceptor-failure action.                          *)
(***************************************************************************)
EXTENDS Integers, TLC 
-----------------------------------------------------------------------------
CONSTANT Value,     \* The set of choosable values.
         Acceptor,  \* The set of acceptors.
         Quorum     
           (****************************************************************)
           (* An election requires a candidate to receive a majority of    *)
           (* votes to win because that ensures that at most one candidate *)
           (* will win.  The property of a majority that we need for that  *)
           (* is that any two majorities of voters have at least one voter *)
           (* in common.  There are other ways to ensure that.  So to be   *)
           (* more general, we let a value be chosen in a ballot if the    *)
           (* set of acceptors voting for it is a "quorum", where the set  *)
           (* `Quorum' of all quorums satisfies the following properties.  *)
           (****************************************************************)
 
ASSUME /\ \A Q \in Quorum : Q \subseteq Acceptor
       /\ \A Q1, Q2 \in Quorum : Q1 \cap Q2 # {}  
-----------------------------------------------------------------------------
(***************************************************************************)
(* Ballot is the set of all possible ballot numbers.  For simplicity, we   *)
(* let it be the set of natural numbers.  However, we write Ballot for     *)
(* that set to distinguish ballots from natural numbers used for other     *)
(* purposes.                                                               *)
(***************************************************************************)
Ballot == Nat
-----------------------------------------------------------------------------
(***************************************************************************)
(* In the algorithm, each acceptor can cast one or more votes, where each  *)
(* vote cast by an acceptor has the form <<b, v>> indicating that the      *)
(* acceptor has voted for value v in ballot b.  A value is chosen if a     *)
(* quorum of acceptors have voted for it in the same ballot.               *)
(***************************************************************************)


(***************************************************************************)
(* The algorithm's variables.                                              *)
(***************************************************************************)
VARIABLE votes,   (*********************************************************)
                  (* `votes[a]' is the set of votes cast by acceptor `a',  *)
                  (* where the element <<b, v>> in votes[a] indicates that *)
                  (* `a' voted for value v in ballot number b.             *)
                  (*********************************************************)

         maxBal   (*********************************************************)
                  (* `maxBal[a]' is a ballot number or -1.  Acceptor `a'   *)
                  (* will cast further votes only in ballots numbered >=   *)
                  (* maxBal[a].                                            *)
                  (*********************************************************)

(***************************************************************************)
(* The type-correctness invariant.                                         *)
(***************************************************************************)
TypeOK == /\ votes \in [Acceptor -> SUBSET (Ballot \X Value)]
          /\ maxBal \in [Acceptor -> Ballot \cup {-1}]
-----------------------------------------------------------------------------
(***************************************************************************)
(* We now make a series of operator definition and assert some simple      *)
(* theorems about those operators that lead to the algorithm.              *)
(***************************************************************************)
VotedFor(a, b, v) == <<b, v>> \in votes[a]
  (*************************************************************************)
  (* True iff acceptor `a' has voted for v in ballot b.                    *)
  (*************************************************************************)
  
ChosenAt(b, v) == \E Q \in Quorum : 
                     \A a \in Q : VotedFor(a, b, v)
  (*************************************************************************)
  (* True iff a quorum of acceptors have all voted for v in ballot b.      *)
  (*************************************************************************)

chosen == {v \in Value : \E b \in Ballot : ChosenAt(b, v)}
  (*************************************************************************)
  (* The set of values that have been chosen.                              *)
  (*************************************************************************)
  
DidNotVoteAt(a, b) == \A v \in Value : ~ VotedFor(a, b, v) 

CannotVoteAt(a, b) == /\ maxBal[a] > b
                      /\ DidNotVoteAt(a, b)
  (*************************************************************************)
  (* Because acceptor `a' will not cast any more votes in a ballot         *)
  (* numbered less than maxBal[a], CannotVoteAt(a, b) implies that `a' has *)
  (* not and never will cast a vote in ballot b.                           *)
  (*************************************************************************)

NoneOtherChoosableAt(b, v) == 
   \E Q \in Quorum : \A a \in Q : VotedFor(a, b, v) \/ CannotVoteAt(a, b)
  (*************************************************************************)
  (* NoneOtherChoosableAt(b, v) implies that ChosenAt(b, w) is not and can *)
  (* never become true for any w # v.                                      *)
  (*************************************************************************)

SafeAt(b, v) == \A c \in 0..(b-1) : NoneOtherChoosableAt(c, v)
  (*************************************************************************)
  (* This defines SafeAt(b, v) to be true if and only if v is safe at      *)
  (* ballot number b.                                                      *)
  (*************************************************************************)
-----------------------------------------------------------------------------
(***************************************************************************)
(* The following two theorems tell us that Property 2 above is satisfied   *)
(* by allowing an acceptor to vote for value v in ballot number b only if  *)
(* SafeAt(b, v) is true, and that an acceptor can vote for any value in    *)
(* ballot number 0.  (These and some of the other theorems asserted here   *)
(* are proved in module VotingProof.)                                      *)
(***************************************************************************)
THEOREM (* AllSafeAtZero *)  \A v \in Value : SafeAt(0, v)

THEOREM (* ChoosableThm *)  \A b \in Ballot, v \in Value : 
                               ChosenAt(b, v) => NoneOtherChoosableAt(b, v)
-----------------------------------------------------------------------------
(***************************************************************************)
(* We now define the inductive invariant Inv that explains why the         *)
(* algorithm works.  The predicates OneValuePerBallot and VotesSafe assert *)
(* that the algorithm satisfies Properties 1 and 2 stated above,           *)
(* respectively.                                                           *)
(***************************************************************************)
OneValuePerBallot ==  
    \A a1, a2 \in Acceptor, b \in Ballot, v1, v2 \in Value : 
       VotedFor(a1, b, v1) /\ VotedFor(a2, b, v2) => (v1 = v2)

VotesSafe == \A a \in Acceptor, b \in Ballot, v \in Value :
                 VotedFor(a, b, v) => SafeAt(b, v)
       
Inv == TypeOK /\ VotesSafe /\ OneValuePerBallot
-----------------------------------------------------------------------------
(***************************************************************************)
(* The following operator will be used in the enabling condition of an     *)
(* acceptors voting action.  Since Inv is an invariant the algorithm, the  *)
(* following theorem implies that in any reachable state, ShowsSafeAt(Q,   *)
(* b, v) true for some quorum Q implies that v is safe at b                *)
(***************************************************************************)
ShowsSafeAt(Q, b, v) == 
  /\ \A a \in Q : maxBal[a] \geq b
  /\ \E c \in -1..(b-1) : 
      /\ (c # -1) => \E a \in Q : VotedFor(a, c, v)
      /\ \A d \in (c+1)..(b-1), a \in Q : DidNotVoteAt(a, d)

THEOREM (* ShowsSafety *) 
          Inv  =>  \A Q \in Quorum, b \in Ballot, v \in Value :
                     ShowsSafeAt(Q, b, v) => SafeAt(b, v)
-----------------------------------------------------------------------------
(***************************************************************************)
(* We now write the specification.  The initial condition is               *)
(* straightforward.                                                        *)
(***************************************************************************)
Init == /\ votes = [a \in Acceptor |-> {}]
        /\ maxBal = [a \in Acceptor |-> -1]

(***************************************************************************)
(* We now define the two subactions that make up the next-state action.    *)
(*                                                                         *)
(* The first subaction allows an acceptor a to increase maxBal[a] to a     *)
(* ballot number b at any time.                                            *)
(***************************************************************************)
IncreaseMaxBal(a, b) ==
  /\ b > maxBal[a]
  /\ maxBal' = [maxBal EXCEPT ![a] = b]
  /\ UNCHANGED votes

(***************************************************************************)
(* The second subaction allows an acceptor `a' to vote for value v in      *)
(* ballot b.  The first four conjuncts are enabling conditions.  The first *)
(* maintains the requirement that the acceptor cannot cast a vote in a     *)
(* ballot less than maxBal[a].  The next two conjuncts maintain the        *)
(* invariance of OneValuePerBallot.  The fourth conjunct maintains the     *)
(* invariance of VotesSafe.                                                *)
(***************************************************************************)
VoteFor(a, b, v) ==
    /\ maxBal[a] \leq b
    /\ \A vt \in votes[a] : vt[1] # b
    /\ \A c \in Acceptor \ {a} : 
         \A vt \in votes[c] : (vt[1] = b) => (vt[2] = v)
    /\ \E Q \in Quorum : ShowsSafeAt(Q, b, v)
    /\ votes' = [votes EXCEPT ![a] = @ \cup {<<b, v>>}]
    /\ maxBal' = [maxBal EXCEPT ![a] = b]


(***************************************************************************)
(* Here are the next-state action and the complete specification.          *)
(***************************************************************************)
Next  ==  \E a \in Acceptor, b \in Ballot : 
            \/ IncreaseMaxBal(a, b)
            \/ \E v \in Value : VoteFor(a, b, v)

Spec == Init /\ [][Next]_<<votes, maxBal>>
-----------------------------------------------------------------------------
(***************************************************************************)
(* This theorem asserts that Inv is an invariant of the specification.     *)
(***************************************************************************)
THEOREM (* Invariance *)  Spec => []Inv
-----------------------------------------------------------------------------
(***************************************************************************)
(* The following statement instantiates module Consensus with the constant *)
(* Value of this module substituted for the constant Value of module       *)
(* Consensus, and the state function `chosen' defined in this module       *)
(* substituted for the variable `chosen' of module Consensus.  More        *)
(* precisely, for each defined identifier id of module Consensus, this     *)
(* statement defines C!id to equal the value of id under these             *)
(* substitutions.                                                          *)
(***************************************************************************)

(*
commented out by Igor:
C == INSTANCE Consensus
*)

(***************************************************************************)
(* This theorem asserts that the algorithm of this module implements the   *)
(* specification of consensus in module Consensus under the refinement     *)
(* mapping that substitutes for the constant Value and the variable        *)
(* `chosen' of module Consensus the constant Value and expression `chosen' *)
(* of this module.                                                         *)
(***************************************************************************)
(*
THEOREM Spec  => C!Spec
*)
=============================================================================
