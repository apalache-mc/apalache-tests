; Quantified encoding for IntClocks example of size 1
; Simulates bounded model checking run of length 1*10
; Created Thu Apr 30 15:16:06 CEST 2020 by andrey

(declare-datatypes () ((Values p0 )))
(define-fun none () (Array Values Int)
    ((as const (Array Values Int)) 0))

(define-fun all () (Array Values Int)
    ((as const (Array Values Int)) 10))

(declare-const c0 (Array Values Int))
(assert (= c0 none))

(declare-const c1 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c1 x) (ite (< (select c0 x) 10) (+ (select c0 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c1 y) (select c0 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c1 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c1 y) (select c0 y))
        )
      )
    )
  )
))

(push)
(assert (= c1 all))
(check-sat)
(pop)

(declare-const c2 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c2 x) (ite (< (select c1 x) 10) (+ (select c1 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c2 y) (select c1 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c2 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c2 y) (select c1 y))
        )
      )
    )
  )
))

(push)
(assert (= c2 all))
(check-sat)
(pop)

(declare-const c3 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c3 x) (ite (< (select c2 x) 10) (+ (select c2 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c3 y) (select c2 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c3 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c3 y) (select c2 y))
        )
      )
    )
  )
))

(push)
(assert (= c3 all))
(check-sat)
(pop)

(declare-const c4 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c4 x) (ite (< (select c3 x) 10) (+ (select c3 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c4 y) (select c3 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c4 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c4 y) (select c3 y))
        )
      )
    )
  )
))

(push)
(assert (= c4 all))
(check-sat)
(pop)

(declare-const c5 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c5 x) (ite (< (select c4 x) 10) (+ (select c4 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c5 y) (select c4 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c5 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c5 y) (select c4 y))
        )
      )
    )
  )
))

(push)
(assert (= c5 all))
(check-sat)
(pop)

(declare-const c6 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c6 x) (ite (< (select c5 x) 10) (+ (select c5 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c6 y) (select c5 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c6 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c6 y) (select c5 y))
        )
      )
    )
  )
))

(push)
(assert (= c6 all))
(check-sat)
(pop)

(declare-const c7 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c7 x) (ite (< (select c6 x) 10) (+ (select c6 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c7 y) (select c6 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c7 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c7 y) (select c6 y))
        )
      )
    )
  )
))

(push)
(assert (= c7 all))
(check-sat)
(pop)

(declare-const c8 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c8 x) (ite (< (select c7 x) 10) (+ (select c7 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c8 y) (select c7 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c8 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c8 y) (select c7 y))
        )
      )
    )
  )
))

(push)
(assert (= c8 all))
(check-sat)
(pop)

(declare-const c9 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c9 x) (ite (< (select c8 x) 10) (+ (select c8 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c9 y) (select c8 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c9 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c9 y) (select c8 y))
        )
      )
    )
  )
))

(push)
(assert (= c9 all))
(check-sat)
(pop)

(declare-const c10 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c10 x) (ite (< (select c9 x) 10) (+ (select c9 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c10 y) (select c9 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c10 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c10 y) (select c9 y))
        )
      )
    )
  )
))

(push)
(assert (= c10 all))
(check-sat)
(pop)
