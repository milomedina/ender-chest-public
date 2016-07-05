; declare datatypes - apple, orange, and mixed
(declare-datatypes () ((content apple orange mixed))) 

; declare crates of solution 1
(declare-const realApple1 content)
(declare-const realOrange1 content)
(declare-const realMixed1 content)

; assert all crates of solution 1 are different
(assert (distinct realApple1 realOrange1 realMixed1))

; assert none of the crates of solution 1 has the right label
(assert (not (= realApple1 apple)))
(assert (not (= realOrange1 orange)))
(assert (not (= realMixed1 mixed)))

; get apple from orange-labeled crates of solution 1
(assert (or (= realOrange1 apple) (= realOrange1 mixed)))


; declare crates of solution 2
(declare-const realApple2 content)
(declare-const realOrange2 content)
(declare-const realMixed2 content)

; assert all crates of solution 2 are different
(assert (distinct realApple2 realOrange2 realMixed2))

; assert none of the crates of solution 1 has the right label
(assert (not (= realApple2 apple)))
(assert (not (= realOrange2 orange)))
(assert (not (= realMixed2 mixed)))

; get apple from orange-labeled crates of solution 2
(assert (or (= realOrange2 apple) (= realOrange2 mixed)))


; solution 1 and solution 2 should be different
(assert (not (and (= realApple1 realApple2) (= realOrange1 realOrange2) (= realMixed1 realMixed2))))

(check-sat)
(get-model)
