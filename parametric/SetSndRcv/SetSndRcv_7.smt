; Quantified encoding for SetSndRcv example of size 7
; Simulates bounded model checking run of length 2*7
; Created Tue Apr 28 15:57:52 CEST 2020 by andrey

(declare-datatypes () ((Values p0 p1 p2 p3 p4 p5 p6 )))
(define-fun none () (Set Values)
    ((as const (Set Values)) false))

(define-fun all () (Set Values)
    ((as const (Set Values)) true))    

; sender
(declare-const s0 (Set Values))
(assert (= s0 all))

; receiver
(declare-const r0 (Set Values))
(assert (= r0 none))

; medium
(declare-const m0 (Set Values))
(assert (= m0 none))

(declare-const s1 (Set Values))
(declare-const r1 (Set Values))
(declare-const m1 (Set Values))

(assert (or
  ; Send
  (and
  (= r0 r1)
  (exists 
    ((x Values)) 
    (and 
      (select s0 x) (not (select s1 x))
      (select m1 x) (not (select m0 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s1 y) (select s0 y))
             (= (select m1 y) (select m0 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r0 r1)
  (= s0 s1)
  (exists 
    ((x Values)) 
    (and 
      (select m0 x) (not (select m1 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m1 y) (select m0 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s0 s1)
  (= m0 m1)
  (exists 
    ((x Values)) 
    (and 
      (select r1 x) (not (select r0 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r1 y) (select r0 y))
        )
      )
    )
  ))
))

(push)
(assert (= s1 none))
(assert (= r1 none))
(assert (= m1 none))
(check-sat)
(pop)

(declare-const s2 (Set Values))
(declare-const r2 (Set Values))
(declare-const m2 (Set Values))

(assert (or
  ; Send
  (and
  (= r1 r2)
  (exists 
    ((x Values)) 
    (and 
      (select s1 x) (not (select s2 x))
      (select m2 x) (not (select m1 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s2 y) (select s1 y))
             (= (select m2 y) (select m1 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r1 r2)
  (= s1 s2)
  (exists 
    ((x Values)) 
    (and 
      (select m1 x) (not (select m2 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m2 y) (select m1 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s1 s2)
  (= m1 m2)
  (exists 
    ((x Values)) 
    (and 
      (select r2 x) (not (select r1 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r2 y) (select r1 y))
        )
      )
    )
  ))
))

(push)
(assert (= s2 none))
(assert (= r2 none))
(assert (= m2 none))
(check-sat)
(pop)

(declare-const s3 (Set Values))
(declare-const r3 (Set Values))
(declare-const m3 (Set Values))

(assert (or
  ; Send
  (and
  (= r2 r3)
  (exists 
    ((x Values)) 
    (and 
      (select s2 x) (not (select s3 x))
      (select m3 x) (not (select m2 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s3 y) (select s2 y))
             (= (select m3 y) (select m2 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r2 r3)
  (= s2 s3)
  (exists 
    ((x Values)) 
    (and 
      (select m2 x) (not (select m3 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m3 y) (select m2 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s2 s3)
  (= m2 m3)
  (exists 
    ((x Values)) 
    (and 
      (select r3 x) (not (select r2 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r3 y) (select r2 y))
        )
      )
    )
  ))
))

(push)
(assert (= s3 none))
(assert (= r3 none))
(assert (= m3 none))
(check-sat)
(pop)

(declare-const s4 (Set Values))
(declare-const r4 (Set Values))
(declare-const m4 (Set Values))

(assert (or
  ; Send
  (and
  (= r3 r4)
  (exists 
    ((x Values)) 
    (and 
      (select s3 x) (not (select s4 x))
      (select m4 x) (not (select m3 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s4 y) (select s3 y))
             (= (select m4 y) (select m3 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r3 r4)
  (= s3 s4)
  (exists 
    ((x Values)) 
    (and 
      (select m3 x) (not (select m4 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m4 y) (select m3 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s3 s4)
  (= m3 m4)
  (exists 
    ((x Values)) 
    (and 
      (select r4 x) (not (select r3 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r4 y) (select r3 y))
        )
      )
    )
  ))
))

(push)
(assert (= s4 none))
(assert (= r4 none))
(assert (= m4 none))
(check-sat)
(pop)

(declare-const s5 (Set Values))
(declare-const r5 (Set Values))
(declare-const m5 (Set Values))

(assert (or
  ; Send
  (and
  (= r4 r5)
  (exists 
    ((x Values)) 
    (and 
      (select s4 x) (not (select s5 x))
      (select m5 x) (not (select m4 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s5 y) (select s4 y))
             (= (select m5 y) (select m4 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r4 r5)
  (= s4 s5)
  (exists 
    ((x Values)) 
    (and 
      (select m4 x) (not (select m5 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m5 y) (select m4 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s4 s5)
  (= m4 m5)
  (exists 
    ((x Values)) 
    (and 
      (select r5 x) (not (select r4 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r5 y) (select r4 y))
        )
      )
    )
  ))
))

(push)
(assert (= s5 none))
(assert (= r5 none))
(assert (= m5 none))
(check-sat)
(pop)

(declare-const s6 (Set Values))
(declare-const r6 (Set Values))
(declare-const m6 (Set Values))

(assert (or
  ; Send
  (and
  (= r5 r6)
  (exists 
    ((x Values)) 
    (and 
      (select s5 x) (not (select s6 x))
      (select m6 x) (not (select m5 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s6 y) (select s5 y))
             (= (select m6 y) (select m5 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r5 r6)
  (= s5 s6)
  (exists 
    ((x Values)) 
    (and 
      (select m5 x) (not (select m6 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m6 y) (select m5 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s5 s6)
  (= m5 m6)
  (exists 
    ((x Values)) 
    (and 
      (select r6 x) (not (select r5 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r6 y) (select r5 y))
        )
      )
    )
  ))
))

(push)
(assert (= s6 none))
(assert (= r6 none))
(assert (= m6 none))
(check-sat)
(pop)

(declare-const s7 (Set Values))
(declare-const r7 (Set Values))
(declare-const m7 (Set Values))

(assert (or
  ; Send
  (and
  (= r6 r7)
  (exists 
    ((x Values)) 
    (and 
      (select s6 x) (not (select s7 x))
      (select m7 x) (not (select m6 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s7 y) (select s6 y))
             (= (select m7 y) (select m6 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r6 r7)
  (= s6 s7)
  (exists 
    ((x Values)) 
    (and 
      (select m6 x) (not (select m7 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m7 y) (select m6 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s6 s7)
  (= m6 m7)
  (exists 
    ((x Values)) 
    (and 
      (select r7 x) (not (select r6 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r7 y) (select r6 y))
        )
      )
    )
  ))
))

(push)
(assert (= s7 none))
(assert (= r7 none))
(assert (= m7 none))
(check-sat)
(pop)

(declare-const s8 (Set Values))
(declare-const r8 (Set Values))
(declare-const m8 (Set Values))

(assert (or
  ; Send
  (and
  (= r7 r8)
  (exists 
    ((x Values)) 
    (and 
      (select s7 x) (not (select s8 x))
      (select m8 x) (not (select m7 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s8 y) (select s7 y))
             (= (select m8 y) (select m7 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r7 r8)
  (= s7 s8)
  (exists 
    ((x Values)) 
    (and 
      (select m7 x) (not (select m8 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m8 y) (select m7 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s7 s8)
  (= m7 m8)
  (exists 
    ((x Values)) 
    (and 
      (select r8 x) (not (select r7 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r8 y) (select r7 y))
        )
      )
    )
  ))
))

(push)
(assert (= s8 none))
(assert (= r8 none))
(assert (= m8 none))
(check-sat)
(pop)

(declare-const s9 (Set Values))
(declare-const r9 (Set Values))
(declare-const m9 (Set Values))

(assert (or
  ; Send
  (and
  (= r8 r9)
  (exists 
    ((x Values)) 
    (and 
      (select s8 x) (not (select s9 x))
      (select m9 x) (not (select m8 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s9 y) (select s8 y))
             (= (select m9 y) (select m8 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r8 r9)
  (= s8 s9)
  (exists 
    ((x Values)) 
    (and 
      (select m8 x) (not (select m9 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m9 y) (select m8 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s8 s9)
  (= m8 m9)
  (exists 
    ((x Values)) 
    (and 
      (select r9 x) (not (select r8 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r9 y) (select r8 y))
        )
      )
    )
  ))
))

(push)
(assert (= s9 none))
(assert (= r9 none))
(assert (= m9 none))
(check-sat)
(pop)

(declare-const s10 (Set Values))
(declare-const r10 (Set Values))
(declare-const m10 (Set Values))

(assert (or
  ; Send
  (and
  (= r9 r10)
  (exists 
    ((x Values)) 
    (and 
      (select s9 x) (not (select s10 x))
      (select m10 x) (not (select m9 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s10 y) (select s9 y))
             (= (select m10 y) (select m9 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r9 r10)
  (= s9 s10)
  (exists 
    ((x Values)) 
    (and 
      (select m9 x) (not (select m10 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m10 y) (select m9 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s9 s10)
  (= m9 m10)
  (exists 
    ((x Values)) 
    (and 
      (select r10 x) (not (select r9 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r10 y) (select r9 y))
        )
      )
    )
  ))
))

(push)
(assert (= s10 none))
(assert (= r10 none))
(assert (= m10 none))
(check-sat)
(pop)

(declare-const s11 (Set Values))
(declare-const r11 (Set Values))
(declare-const m11 (Set Values))

(assert (or
  ; Send
  (and
  (= r10 r11)
  (exists 
    ((x Values)) 
    (and 
      (select s10 x) (not (select s11 x))
      (select m11 x) (not (select m10 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s11 y) (select s10 y))
             (= (select m11 y) (select m10 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r10 r11)
  (= s10 s11)
  (exists 
    ((x Values)) 
    (and 
      (select m10 x) (not (select m11 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m11 y) (select m10 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s10 s11)
  (= m10 m11)
  (exists 
    ((x Values)) 
    (and 
      (select r11 x) (not (select r10 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r11 y) (select r10 y))
        )
      )
    )
  ))
))

(push)
(assert (= s11 none))
(assert (= r11 none))
(assert (= m11 none))
(check-sat)
(pop)

(declare-const s12 (Set Values))
(declare-const r12 (Set Values))
(declare-const m12 (Set Values))

(assert (or
  ; Send
  (and
  (= r11 r12)
  (exists 
    ((x Values)) 
    (and 
      (select s11 x) (not (select s12 x))
      (select m12 x) (not (select m11 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s12 y) (select s11 y))
             (= (select m12 y) (select m11 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r11 r12)
  (= s11 s12)
  (exists 
    ((x Values)) 
    (and 
      (select m11 x) (not (select m12 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m12 y) (select m11 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s11 s12)
  (= m11 m12)
  (exists 
    ((x Values)) 
    (and 
      (select r12 x) (not (select r11 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r12 y) (select r11 y))
        )
      )
    )
  ))
))

(push)
(assert (= s12 none))
(assert (= r12 none))
(assert (= m12 none))
(check-sat)
(pop)

(declare-const s13 (Set Values))
(declare-const r13 (Set Values))
(declare-const m13 (Set Values))

(assert (or
  ; Send
  (and
  (= r12 r13)
  (exists 
    ((x Values)) 
    (and 
      (select s12 x) (not (select s13 x))
      (select m13 x) (not (select m12 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s13 y) (select s12 y))
             (= (select m13 y) (select m12 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r12 r13)
  (= s12 s13)
  (exists 
    ((x Values)) 
    (and 
      (select m12 x) (not (select m13 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m13 y) (select m12 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s12 s13)
  (= m12 m13)
  (exists 
    ((x Values)) 
    (and 
      (select r13 x) (not (select r12 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r13 y) (select r12 y))
        )
      )
    )
  ))
))

(push)
(assert (= s13 none))
(assert (= r13 none))
(assert (= m13 none))
(check-sat)
(pop)

(declare-const s14 (Set Values))
(declare-const r14 (Set Values))
(declare-const m14 (Set Values))

(assert (or
  ; Send
  (and
  (= r13 r14)
  (exists 
    ((x Values)) 
    (and 
      (select s13 x) (not (select s14 x))
      (select m14 x) (not (select m13 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (and
             (= (select s14 y) (select s13 y))
             (= (select m14 y) (select m13 y))
           )
        )
      )
    )
  ))

  ; Drop
  (and
  (= r13 r14)
  (= s13 s14)
  (exists 
    ((x Values)) 
    (and 
      (select m13 x) (not (select m14 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select m14 y) (select m13 y))
        )
      )
    )
  ))
  ; Receive
  (and
  (= s13 s14)
  (= m13 m14)
  (exists 
    ((x Values)) 
    (and 
      (select r14 x) (not (select r13 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select r14 y) (select r13 y))
        )
      )
    )
  ))
))

(push)
(assert (= s14 none))
(assert (= r14 none))
(assert (= m14 none))
(check-sat)
(pop)
