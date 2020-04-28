---------------------------- MODULE SetSndRcv_NoFullDropCard --------------------------
\* We model message transmission from sender to receiver via transmission medium.
\* The medium models lossy transmission, i.e., it can drop messages.
\* The goal is to send messages from sender to receiver, and not to lose all of them.
\* The invariant specifies that sender, receiver, and medium are not empty.
\* This is the NoFullDropCard variant, 
\* where the medium can drop only when there are at least 2 messages present,
\* and this condition is expressed using set cardinality.
\*
\* Andrey Kuprianov, 2020

EXTENDS FiniteSets, Integers

(* APALACHE type annotation *)
a <: b == a

CONSTANT
  values

VARIABLE
  sender,
  receiver,
  medium

Init ==
  /\ sender = values
  /\ receiver = {} <: {STRING}
  /\ medium = {} <: {STRING}

Snd == 
  \E x \in sender : 
    /\ sender' = sender \ {x}
    /\ medium' = medium \union {x}
    /\ UNCHANGED(<<receiver>>)

Drop == 
  /\ Cardinality(medium) > 1
  /\ \E x \in medium : 
       /\ medium' = medium \ {x}
       /\ UNCHANGED(<<sender, receiver>>)

\* On receive, we do not remove the message from the medium;
\* this is both natural (multiple copies can be in transit),
\* and makes model checking harder (more states to consider)
Rcv == 
  \E x \in medium : 
    /\ receiver' = receiver \union {x}
    /\ UNCHANGED(<<sender, medium>>)


Next ==
  \/ Snd
  \/ Drop
  \/ Rcv

Inv == 
  \/ sender /= {} <: {STRING}
  \/ medium /= {} <: {STRING}
  \/ receiver /= {} <: {STRING}

=============================================================================
\* Modification History
\* Created Tue Apr 28 11:03:02 CEST by andrey

