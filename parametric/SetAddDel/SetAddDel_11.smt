; Quantified encoding for SetAddDel example of size 11
; Simulates bounded model checking run of length 11
; Created Mon Apr 27 17:00:16 CEST 2020 by andrey

(declare-datatypes () ((Values p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 )))
(define-fun init () (Set Values)
    ((as const (Set Values)) false))

(define-fun all () (Set Values)
    ((as const (Set Values)) true))    

(declare-const s0 (Set Values))
(assert (= s0 init))

(declare-const s1 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s1 x) (not (select s0 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s1 y) (select s0 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s0 x) (not (select s1 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s1 y) (select s0 y))
        )
      )
    )
  )
))

(push)
(assert (= s1 all))
(check-sat)
(pop)

(declare-const s2 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s2 x) (not (select s1 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s2 y) (select s1 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s1 x) (not (select s2 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s2 y) (select s1 y))
        )
      )
    )
  )
))

(push)
(assert (= s2 all))
(check-sat)
(pop)

(declare-const s3 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s3 x) (not (select s2 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s3 y) (select s2 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s2 x) (not (select s3 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s3 y) (select s2 y))
        )
      )
    )
  )
))

(push)
(assert (= s3 all))
(check-sat)
(pop)

(declare-const s4 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s4 x) (not (select s3 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s4 y) (select s3 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s3 x) (not (select s4 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s4 y) (select s3 y))
        )
      )
    )
  )
))

(push)
(assert (= s4 all))
(check-sat)
(pop)

(declare-const s5 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s5 x) (not (select s4 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s5 y) (select s4 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s4 x) (not (select s5 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s5 y) (select s4 y))
        )
      )
    )
  )
))

(push)
(assert (= s5 all))
(check-sat)
(pop)

(declare-const s6 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s6 x) (not (select s5 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s6 y) (select s5 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s5 x) (not (select s6 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s6 y) (select s5 y))
        )
      )
    )
  )
))

(push)
(assert (= s6 all))
(check-sat)
(pop)

(declare-const s7 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s7 x) (not (select s6 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s7 y) (select s6 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s6 x) (not (select s7 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s7 y) (select s6 y))
        )
      )
    )
  )
))

(push)
(assert (= s7 all))
(check-sat)
(pop)

(declare-const s8 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s8 x) (not (select s7 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s8 y) (select s7 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s7 x) (not (select s8 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s8 y) (select s7 y))
        )
      )
    )
  )
))

(push)
(assert (= s8 all))
(check-sat)
(pop)

(declare-const s9 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s9 x) (not (select s8 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s9 y) (select s8 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s8 x) (not (select s9 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s9 y) (select s8 y))
        )
      )
    )
  )
))

(push)
(assert (= s9 all))
(check-sat)
(pop)

(declare-const s10 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s10 x) (not (select s9 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s10 y) (select s9 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s9 x) (not (select s10 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s10 y) (select s9 y))
        )
      )
    )
  )
))

(push)
(assert (= s10 all))
(check-sat)
(pop)

(declare-const s11 (Set Values))

(assert (or
  (exists 
    ((x Values)) 
    (and 
      (select s11 x) (not (select s10 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s11 y) (select s10 y))
        )
      )
    )
  )
  (exists 
    ((x Values)) 
    (and 
      (select s10 x) (not (select s11 x))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select s11 y) (select s10 y))
        )
      )
    )
  )
))

(push)
(assert (= s11 all))
(check-sat)
(pop)
