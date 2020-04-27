; Quantified encoding for SetAdd example of size 5
; Simulates bounded model checking run of length 5
; Created Mon Apr 27 16:26:24 CEST 2020 by andrey

(declare-datatypes () ((Values p0 p1 p2 p3 p4 )))
(define-fun init () (Set Values)
    ((as const (Set Values)) false))

(define-fun all () (Set Values)
    ((as const (Set Values)) true))    

(declare-const s0 (Set Values))
(assert (= s0 init))

(declare-const s1 (Set Values))

(assert 
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
)

(push)
(assert (= s1 all))
(check-sat)
(pop)

(declare-const s2 (Set Values))

(assert 
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
)

(push)
(assert (= s2 all))
(check-sat)
(pop)

(declare-const s3 (Set Values))

(assert 
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
)

(push)
(assert (= s3 all))
(check-sat)
(pop)

(declare-const s4 (Set Values))

(assert 
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
)

(push)
(assert (= s4 all))
(check-sat)
(pop)

(declare-const s5 (Set Values))

(assert 
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
)

(push)
(assert (= s5 all))
(check-sat)
(pop)
