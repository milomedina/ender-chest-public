; declare datatypes - apple, orange, and mixed
(declare-datatypes () ((content apple orange mixed))) 

; declare crates
(declare-const realApple content)
(declare-const realOrange content)
(declare-const realMixed content)

; assert all crates are different
(assert (distinct realApple realOrange realMixed))

; assert none of the crates has the right label
(assert (not (= realApple apple)))
(assert (not (= realOrange orange)))
(assert (not (= realMixed mixed)))

; get apple from mixed-labeled crates
(assert (or (= realMixed apple) (= realMixed mixed)))

(check-sat)
(get-model)
