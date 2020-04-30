; Quantified encoding for IntClocks_Bounded example of size 2
; Simulates bounded model checking run of length 2*10
; Created Thu Apr 30 15:16:08 CEST 2020 by andrey

(declare-datatypes () ((Values p0 p1 )))
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
      (= (select c1 x) (ite (< (select c0 x) 9) (+ (select c0 x) 1) 0))
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
      (= (select c2 x) (ite (< (select c1 x) 9) (+ (select c1 x) 1) 0))
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
      (= (select c3 x) (ite (< (select c2 x) 9) (+ (select c2 x) 1) 0))
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
      (= (select c4 x) (ite (< (select c3 x) 9) (+ (select c3 x) 1) 0))
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
      (= (select c5 x) (ite (< (select c4 x) 9) (+ (select c4 x) 1) 0))
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
      (= (select c6 x) (ite (< (select c5 x) 9) (+ (select c5 x) 1) 0))
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
      (= (select c7 x) (ite (< (select c6 x) 9) (+ (select c6 x) 1) 0))
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
      (= (select c8 x) (ite (< (select c7 x) 9) (+ (select c7 x) 1) 0))
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
      (= (select c9 x) (ite (< (select c8 x) 9) (+ (select c8 x) 1) 0))
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
      (= (select c10 x) (ite (< (select c9 x) 9) (+ (select c9 x) 1) 0))
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

(declare-const c11 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c11 x) (ite (< (select c10 x) 9) (+ (select c10 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c11 y) (select c10 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c11 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c11 y) (select c10 y))
        )
      )
    )
  )
))

(push)
(assert (= c11 all))
(check-sat)
(pop)

(declare-const c12 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c12 x) (ite (< (select c11 x) 9) (+ (select c11 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c12 y) (select c11 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c12 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c12 y) (select c11 y))
        )
      )
    )
  )
))

(push)
(assert (= c12 all))
(check-sat)
(pop)

(declare-const c13 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c13 x) (ite (< (select c12 x) 9) (+ (select c12 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c13 y) (select c12 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c13 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c13 y) (select c12 y))
        )
      )
    )
  )
))

(push)
(assert (= c13 all))
(check-sat)
(pop)

(declare-const c14 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c14 x) (ite (< (select c13 x) 9) (+ (select c13 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c14 y) (select c13 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c14 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c14 y) (select c13 y))
        )
      )
    )
  )
))

(push)
(assert (= c14 all))
(check-sat)
(pop)

(declare-const c15 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c15 x) (ite (< (select c14 x) 9) (+ (select c14 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c15 y) (select c14 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c15 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c15 y) (select c14 y))
        )
      )
    )
  )
))

(push)
(assert (= c15 all))
(check-sat)
(pop)

(declare-const c16 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c16 x) (ite (< (select c15 x) 9) (+ (select c15 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c16 y) (select c15 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c16 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c16 y) (select c15 y))
        )
      )
    )
  )
))

(push)
(assert (= c16 all))
(check-sat)
(pop)

(declare-const c17 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c17 x) (ite (< (select c16 x) 9) (+ (select c16 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c17 y) (select c16 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c17 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c17 y) (select c16 y))
        )
      )
    )
  )
))

(push)
(assert (= c17 all))
(check-sat)
(pop)

(declare-const c18 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c18 x) (ite (< (select c17 x) 9) (+ (select c17 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c18 y) (select c17 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c18 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c18 y) (select c17 y))
        )
      )
    )
  )
))

(push)
(assert (= c18 all))
(check-sat)
(pop)

(declare-const c19 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c19 x) (ite (< (select c18 x) 9) (+ (select c18 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c19 y) (select c18 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c19 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c19 y) (select c18 y))
        )
      )
    )
  )
))

(push)
(assert (= c19 all))
(check-sat)
(pop)

(declare-const c20 (Array Values Int))

(assert (or
  ; Advance
  (exists 
    ((x Values)) 
    (and 
      (= (select c20 x) (ite (< (select c19 x) 9) (+ (select c19 x) 1) 0))
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c20 y) (select c19 y))
        )
      )
    )
  )
  ; Reset
  (exists 
    ((x Values)) 
    (and 
      (= (select c20 x) 0)
      (forall 
        ((y Values))
        (=>
           (not (= x y))
           (= (select c20 y) (select c19 y))
        )
      )
    )
  )
))

(push)
(assert (= c20 all))
(check-sat)
(pop)
