------------------------------ MODULE APAbcastFolklore ------------------------------

(* An encoding of a parameterized model of the reliable broadcast by message diffusion [1] 
   with crashed failures in TLA+. This broadcast algorithm is described in Fig. 4 of [1].
   
   [1] Chandra, Tushar Deepak, and Sam Toueg. "Unreliable failure detectors for reliable 
   distributed systems." Journal of the ACM (JACM) 43.2 (1996): 225-267.
  
   A short description of the parameterized model is described in: 
  
   [2] Gmeiner, Annu, et al. "Tutorial on parameterized model checking of fault-tolerant 
   distributed algorithms." International School on Formal Methods for the Design of 
   Computer, Communication and Software Systems. Springer International Publishing, 2014. 
 
   Igor Konnov, Thanh Hai Tran, Josef Widder, 2016
 
   This file is a subject to the license that is bundled together with this package and 
   can be found in the file LICENSE.
 *)

EXTENDS Integers \*Naturals, FiniteSets

CONSTANTS
    \* @type: Int;
    N,
    \* @type: Int;
    T,
    \* @type: Int;
    F,
    \* @type: Set(Int);
    Proc \* a set of processes

ConstInit4 == N \in {4} /\ T \in {1} /\ F \in {1} /\ Proc \in {1..4}
 
ConstInit20 == N \in {20} /\ T \in {4} /\ F \in {4} /\ Proc \in {1..10} 

VARIABLES
    \* @type: Set(Int);
    Crashed,        (* the crashed processes *)  
    \* @type: Int;
    nCrashed,       (* the number of crashed processes *)
    \* @type: Int -> Str;
    pc,             (* program counters *)
    \* @type: Int -> Set(<<Int, Str>>);
    rcvd,           (* the messages received by each process *)
    \* @type: Set(<<Int, Str>>);
    sent            (* the messages sent by all correct processes *)

\*ASSUME N \in Nat /\ T \in Nat /\ F \in Nat
\*ASSUME (N > 2 * T) /\ (T >= F) /\ (F >= 0)

Corr == Proc \ Crashed

M == { "ECHO" }                 (* only ECHO messages are sent in this encoding *)

vars == << pc, rcvd, sent, Crashed, nCrashed >>      

Init == 
  /\ Crashed = {}
  /\ nCrashed = 0                       (* Initially, there is no crashed process  
                                           or all processes are correct. *)
  /\ sent = {}                          (* No messages are sent. *)
  /\ pc \in [ Proc -> {"V0", "V1"} ]    (* If process p received an INIT message,
                                           process p is initialized with V1. Otherwise,
                                           it is initialized with V0. *)
  /\ rcvd = [ i \in Proc |-> {} ]       (* No messages are received. *)        
  

InitNoBcast ==
  /\ Crashed = {}
  /\ nCrashed = 0                       (* Initially, there is no crashed process  
                                           or all processes are correct. *)
  /\ sent = {}                          (* No messages are sent. *)
  /\ pc = [ p \in Proc |-> "V0" ]       (* Nothing is broadcasted and 
                                           no process receives an INIT message. *)
  /\ rcvd = [ i \in Proc |-> {} ]       (* No messages are received. *)  

Receive(self) ==                        (* a correct process self receives new messages *)
  /\ pc[self] # "CR"
  /\ \E msgs \in SUBSET (Proc \times M):   (* msgs is a set of messages which has been received  *)
        /\ msgs \subseteq sent
        /\ rcvd[self] \subseteq msgs
        /\ rcvd' = [rcvd EXCEPT ![self] = msgs ]

(* If a correct process received an INIT message or was initialized with V1, 
   it accepts this message and then broadcasts ECHO to all.  
 *)
UponV1(self) ==                                 
  /\ pc[self] = "V1"                        
  /\ pc' = [pc EXCEPT ![self] = "AC"]       
  /\ sent' = sent \cup { <<self, "ECHO">> } 
  /\ nCrashed' = nCrashed
  /\ Crashed' = Crashed

(* If a correct process received an ECHO messageaccepts, it accepts and then 
   broadcasts ECHO to all.  *)
UponAccept(self) ==                                 
  /\ (pc[self] = "V0" \/ pc[self] = "V1")     
  /\ rcvd'[self] # {}
  /\ pc' = [pc EXCEPT ![self] = "AC"]
  /\ sent' = sent \cup { <<self, "ECHO">> }
  /\ nCrashed' = nCrashed
  /\ Crashed' = Crashed

(* If a number of crashed processes is less than F, some correct process may crash. *) 
UponCrash(self) ==                                      
  /\ nCrashed < F
  /\ pc[self] # "CR"
  /\ nCrashed' = nCrashed + 1
  /\ pc' = [pc EXCEPT ![self] = "CR"]
  /\ sent' = sent
  /\ Crashed' = Crashed \cup { self }
        
(* A process can receive messages, broadcast ECHO to all, accept or become a crashed one *)       
Step(self) ==   
  /\ Receive(self)
  /\ \/ UponV1(self)
     \/ UponAccept(self)
     \/ UponCrash(self)
     \/ UNCHANGED << pc, sent, nCrashed, Crashed>> 

(* the transition step *)    
Next ==  (\E self \in Corr: Step(self))

(* Add the weak fairness condition since we want to check the liveness condition. *)
Spec == Init /\ [][Next]_vars
             /\ WF_vars(\E self \in Corr: /\ Receive(self)
                                          /\ \/ UponV1(self)                                             
                                             \/ UponAccept(self)
                                             \/ UNCHANGED << pc, sent, nCrashed, Crashed >> )
                                             
                                       
SpecNoBcast == InitNoBcast /\ [][Next]_vars
                           /\ WF_vars(\E self \in Corr: /\ Receive(self)
                                                        /\ \/ UponV1(self)
                                                           \/ UponAccept(self)
                                                           \/ UNCHANGED << pc, sent, nCrashed, Crashed >> )

(* V0 - a process did not received an INIT message 
   V1 - a process received an INIT message 
   AC - a process accepted and sent the message to everybody  
   CR - a process is crashed 
 *)
TypeOK == 
  /\ sent \in SUBSET (Proc \times M)
  /\ pc \in [ Proc -> {"V0", "V1", "AC", "CR"} ]   
  /\ rcvd \in [ Proc -> SUBSET (Proc \times M) ]
  /\ nCrashed \in 0..N
  /\ Corr \in SUBSET Proc   
          
(* If no correct process does not broadcast then no correct processes accepts. *)  
UnforgLtl == (\A i \in Corr: pc[i] = "V0") => [](\A i \in Corr: pc[i] /= "AC")

(* Unforg is correct iff the initial state is InitNoBcast. *)          
Unforg == (\A self \in Corr: (pc[self] /= "AC")) 

(* If a correct process broadcasts, then every correct process eventually accepts. *)
CorrLtl == (\A i \in Corr: pc[i] = "V1") => <>(\E i \in Corr: pc[i] = "AC")

(* If a correct process accepts, then every correct process eventually accepts.  *)
RelayLtl == []((\E i \in Corr: pc[i] = "AC") => <>(\A i \in Corr: pc[i] = "AC"))

(* If a message is sent by a correct process, then every correct processes eventually
   receives this message. *)
ReliableChan == 
  []( \E sndr \in 1..N : (<<sndr, "ECHO">> \in sent 
                            => <>[](\A p \in Corr : <<sndr, "ECHO">> \in rcvd[p]))) 

=============================================================================
\* Modification History
\* Last modified Sun Mar 17 23:33:44 CET 2019 by igor
\* Last modified Mon Sep 03 17:01:26 CEST 2018 by tthai
