---------------------------- MODULE counterexample ----------------------------

EXTENDS SetSndRcv

(* Constant initialization state *)
ConstInit == Values = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }

(* Initial state *)
State0 ==
  Values = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }
    /\ medium = {}
    /\ receiver = {}
    /\ sender = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }

(* Transition 0 to State1 *)
State1 ==
  Values = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }
    /\ medium = {2}
    /\ receiver = {}
    /\ sender = { 0, 1, 3, 4, 5, 6, 7, 8 }

(* Transition 0 to State2 *)
State2 ==
  Values = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }
    /\ medium = {2}
    /\ receiver = {}
    /\ sender = {}

(* Transition 1 to State3 *)
State3 ==
  Values = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }
    /\ medium = {}
    /\ receiver = {}
    /\ sender = {}

(* The following formula holds true in the last state and violates the invariant *)
InvariantViolation == sender = {} /\ medium = {} /\ receiver = {}

================================================================================
(* Created by Apalache on Thu Dec 02 20:06:27 UTC 2021 *)
(* https://github.com/informalsystems/apalache *)
