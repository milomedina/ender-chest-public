#lang plai

;; Programming Language 2015 Spring Homework 3
;; Sungwon Cho (known as Sam Jo)
;; 20150311T1812

;; Problem 0 ;;

;; definition for WAE
(define-type WAE
  [num (n number?)]
  [add (lhs WAE?) (rhs WAE?)]
  [sub (lhs WAE?) (rhs WAE?)]
  [with (name symbol?) (named-expr WAE?) (body WAE?)]
  [id (name symbol?)])

(define wae0 (num 0)) ; 0
(define wae1 (with 'x (num 42) (add (id 'x) (num 3)))) ; {with x 42 {+ x 3}}
(define wae2 (with 'x (id 'x) (add (id 'x) (id 'y)))) ; {with x x {+ x y}}
(define wae3 (with 'x (with 'y (num 4) (sub (id 'x) (id 'z))) (sub (id 'z) (id 'x)))) ; {with x {with y 4 {- x z}} {- z x}}
(define wae4 (with 'x (add (num 3) (num 4)) (with 'x (sub (num 3) (id 'y)) (id 'z)))) ; {with x {+ 3 4} {with x {- 3 y} z}}

;; symbol<?: symbol symbol -> boolean
;; constraints: types of first and second should be symbols
;; check second symbol is bigger than first symbol according to lexicographic order
(define (symbol<? a b)
  (string<? (symbol->string a) (symbol->string b)))

(test (symbol<? 'a 'c) true)
(test (symbol<? 'cc 'ca) false)
(test (symbol<? 'a 'abc) true)

;; make-pretty: list(symbols) -> list(symbols)
;; constraints: type of first input should be list of symbols
;; get a list of symbols and produces a list that duplicates are removed and orderd using symbol<?
(define (make-pretty list)
  (remove-duplicates (sort list symbol<?)))

(test (make-pretty '(b a c c e g)) '(a b c e g))
(test (make-pretty '(z y x ab cd aa a x)) '(a aa ab cd x y z))
(test (make-pretty '()) '())


;; Problem 1;;

;; raw-free-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of free identifiers in the given WAE.
(define (raw-free-ids wae)
  (type-case WAE wae
    [num (n) empty]
    [add (l r) (append (raw-free-ids l) (raw-free-ids r))]
    [sub (l r) (append (raw-free-ids l) (raw-free-ids r))]
    [with (i e1 e2) (append (raw-free-ids e1) (remove* (list i) (raw-free-ids e2)))]
    [id (i) (list i)]))

;; free-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of free identifiers in the given WAE. duplicated results are removed and ordered by symbol<?
(define (free-ids wae)
  (make-pretty (raw-free-ids wae)))

(test (free-ids wae0) '())
(test (free-ids wae1) '())
(test (free-ids wae2) '(x y))
(test (free-ids wae3) '(x z))
(test (free-ids wae4) '(y z))


;; Problem 2 ;;

;; raw-binding-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of binding identifiers in the given WAE.
(define (raw-binding-ids wae)
  (type-case WAE wae
    [num (n) empty]
    [add (l r) (append (raw-binding-ids l) (raw-binding-ids r))]
    [sub (l r) (append (raw-binding-ids l) (raw-binding-ids r))]
    [with (i e1 e2) (append (list i) (raw-binding-ids e1) (raw-binding-ids e2))]
    [id (i) empty]))

;; binding-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of binding identifiers in the given WAE. duplicated results are removed and ordered by symbol<?
(define (binding-ids wae)
  (make-pretty (raw-binding-ids wae)))

(test (binding-ids wae0) '())
(test (binding-ids wae1) '(x))
(test (binding-ids wae2) '(x))
(test (binding-ids wae3) '(x y))
(test (binding-ids wae4) '(x))


;; Problem 3 ;;

;; id-bound?: symbol WAE -> boolean
;; constraints: type of first input should be symbol, second input should be WAE
;; assume given symbol is defined in global scope.
;; then, determine whether the symbol is bound in the give WAE
(define (id-bound? x wae)
  (type-case WAE wae
    [num (n) false]
    [add (l r) (or (id-bound? x l) (id-bound? x r))]
    [sub (l r) (or (id-bound? x l) (id-bound? x r))]
    [with (i e1 e2) (or (id-bound? x e1) (if (symbol=? x i) false (id-bound? x e2)))]
    [id (i) (symbol=? x i)]))

(test (id-bound? 'y wae0) false)
(test (id-bound? 'x wae1) false)
(test (id-bound? 'y wae2) true)
(test (id-bound? 'x wae4) false)
(test (id-bound? 'y wae4) true)

;; raw-bound-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of bound identifiers in the given WAE.
(define (raw-bound-ids wae)
  (type-case WAE wae
    [num (n) empty]
    [add (l r) (append (raw-bound-ids l) (raw-bound-ids r))]
    [sub (l r) (append (raw-bound-ids l) (raw-bound-ids r))]
    [with (i e1 e2) (append (if (id-bound? i e2) (list i) empty) (raw-bound-ids e1) (raw-bound-ids e2))]
    [id (i) empty]))

;; bound-ids: WAE -> list(symbols)
;; constraints: type of first input should be WAE
;; get list of bound identifiers in the given WAE. duplicated results are removed and ordered by symbol<?
(define (bound-ids wae)
  (make-pretty (raw-bound-ids wae)))

(test (bound-ids wae0) '())
(test (bound-ids wae1) '(x))
(test (bound-ids wae2) '(x))
(test (bound-ids wae3) '(x))
(test (bound-ids wae4) '())
