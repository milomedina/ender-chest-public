#lang plai

;; Programming Language 2015 Spring Homework 1
;; Sungwon Cho (known as Sam Jo)
;; 20150304T1659

;; hkd->won: number -> number
;; exchange from Hong Kong dollars to won, which rate is 150won/hkd
(define (hkd->won money)
  (* 150 money))

(test (hkd->won 100) 15000)
(test (hkd->won 42) 6300)
(test (hkd->won 0) 0)


;; is-multiple-three?: number -> boolean
;; constraints: input number should be integers
;; check whether the input number is a multiple of three
(define (is-multiple-three? num)
  (cond
    [(= num 0) true]
    [(>= num 3) (is-multiple-three? (- num 3))]
    [(< num 0) (is-multiple-three? (+ num 3))]
    [else false]))
    
(test (is-multiple-three? 42) true)
(test (is-multiple-three? -3) true)
(test (is-multiple-three? 1) false)
(test (is-multiple-three? 0) true)
(test (is-multiple-three? -124) false)


;; area-rectangle: number number -> number
;; constraints: both input numbers should be non-negative number 
;; calculate area of rectangle from lengths of two sides
(define (area-rectangle width height)
  (* width height))

(test (area-rectangle 3 4) 12)
(test (area-rectangle 42 10) 420)
(test (area-rectangle 420 0) 0)
(test (area-rectangle 420 0.5) 210)


;; gcd: number number -> number
;; constraints: both input numbers should be positive integers
;; calculate the greatest common divisor of given two numbers
(define (gcd a b)
  (cond
    [(= a b) a]
    [(> a b) (gcd (- a b) b)]
    [else (gcd a (- b a))]))
    
(test (gcd 10 30) 10)
(test (gcd 12 18) 6)
(test (gcd 1 42) 1)
(test (gcd 7 5) 1)


;; lcm: number number -> numberr
;; constraints: both input numbers should be positive integers
;; calculate the least common multiple of given two numbers
(define (lcm a b)
  (/ (* a b) (gcd a b)))

(test (lcm 10 30) 30)
(test (lcm 18 12) 36)
(test (lcm 1 42) 42)
(test (lcm 7 5) 35)
