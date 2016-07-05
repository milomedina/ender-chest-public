#lang plai

;; Programming Language 2015 Spring Homework 4
;; Sungwon Cho (known as Sam Jo)
;; 20150323T2030

(require (for-syntax racket/base) racket/match racket/list racket/string
         (only-in mzlib/string read-from-string-all))

;; build a regexp that matches restricted character expressions, can use only
;; {}s for lists, and limited strings that use '...' (normal racket escapes
;; like \n, and '' for a single ')
(define good-char "(?:[ \t\r\na-zA-Z0-9_{}!?*/<=>:+-]|[.][.][.])")
;; this would make it awkward for students to use \" for strings
;; (define good-string "\"[^\"\\]*(?:\\\\.[^\"\\]*)*\"")
(define good-string "[^\"\\']*(?:''[^\"\\']*)*")
(define expr-re
  (regexp (string-append "^"
                         good-char"*"
                         "(?:'"good-string"'"good-char"*)*"
                         "$")))
(define string-re
  (regexp (string-append "'("good-string")'")))

(define (string->sexpr str)
  (unless (string? str)
    (error 'string->sexpr "expects argument of type <string>"))
    (unless (regexp-match expr-re str)
      (error 'string->sexpr "syntax error (bad contents)"))
    (let ([sexprs (read-from-string-all
                 (regexp-replace*
                  "''" (regexp-replace* string-re str "\"\\1\"") "'"))])
    (if (= 1 (length sexprs))
      (car sexprs)
      (error 'string->sexpr "bad syntax (multiple expressions)"))))

(test/exn (string->sexpr 1) "expects argument of type <string>")
(test/exn (string->sexpr ".") "syntax error (bad contents)")
(test/exn (string->sexpr "{} {}") "bad syntax (multiple expressions)")

;; MUWAE abstract syntax trees
;; - min and max get three MUWAE that can be interpreted as one number
(define-type MUWAE
  [num  (num (listof number?))]
  [add  (left MUWAE?) (right MUWAE?)]
  [sub  (left MUWAE?) (right MUWAE?)]
  [with (name symbol?) (init MUWAE?) (body MUWAE?)]
  [id   (name symbol?)]
  [muwae-max (a MUWAE?) (b MUWAE?) (c MUWAE?)]
  [muwae-min (a MUWAE?) (b MUWAE?) (c MUWAE?)])

;; parse-sexpr : sexpr -> MUWAE
;; to convert s-expressions into MUWAEs
;; - empty list is not valid syntax
(define (parse-sexpr sexp)
  (match sexp
    [(? number?) (num (list sexp))]
    [(? empty?) (error 'parse "empty list")]
    [(? (listof number?)) (num sexp)]
    [(list '+ l r) (add (parse-sexpr l) (parse-sexpr r))]
    [(list '- l r) (sub (parse-sexpr l) (parse-sexpr r))]
    [(list 'with (list x i) b) (with x (parse-sexpr i) (parse-sexpr b))]
    [(? symbol?) (id sexp)]
    [(list 'muwae-max a b c) (muwae-max (parse-sexpr a) (parse-sexpr b) (parse-sexpr c))]
    [(list 'muwae-min a b c) (muwae-min (parse-sexpr a) (parse-sexpr b) (parse-sexpr c))]
    [else (error 'parse "bad syntax: ~a" sexp)]))

;; parses a string containing a MUWAE expression to a MUWAE AST
(define (parse str)
  (parse-sexpr (string->sexpr str)))

;; subst: MUWAE symbol number -> MUWAE
;; substitutes the second argument with the third argument in the
;; first argument, as per the rules of substitution; the resulting
;; expression contains no free instances of the second argument
(define (subst expr from to)
  (type-case MUWAE expr
    [num (n)   expr]
    [add (l r) (add (subst l from to) (subst r from to))]
    [sub (l r) (sub (subst l from to) (subst r from to))]
    [id (name) (if (symbol=? name from) (num to) expr)]
    [with (bound-id named-expr bound-body)
          (with bound-id
                (subst named-expr from to)
                (if (symbol=? bound-id from)
                    bound-body
                    (subst bound-body from to)))]
    [muwae-max (a b c) (muwae-max (subst a from to) (subst b from to) (subst c from to))]
    [muwae-min (a b c) (muwae-min (subst a from to) (subst b from to) (subst c from to))]))

;; bin-op: (number number -> number) (listof number) (listof number) -> (listof number))
;; applies a binary numeric function on all combinations of numbers from
;; the two input lists, and return the list of all of the results
(define (bin-op op ls rs)
  (define (helper l rs)
    ;; f : number -> number
    (define (f n)
      (op l n))
    (map f rs))
  (if (null? ls)
    null
    (append (helper (first ls) rs) (bin-op op (rest ls) rs))))

;; maxmin-op: (number number number -> number) (listof number) (listof number) (listof number) -> (listof number)
;; applies a triple numeric function on three input lists and return computed result with list
;; input of all three lists should have only one number
(define (maxmin-op op a b c)
  (if (and (= (length a) 1) (= (length b) 1) (= (length c) 1))
      (list (op (first a) (first b) (first c)))
      (error 'maxmin "max/min require 3 numbers")))

;; evaluates MUWAE expressions by reducing them to numbers
(define (eval expr)
  (type-case MUWAE expr
    [num (n) n]
    [add (l r) (bin-op + (eval l) (eval r))]
    [sub (l r) (bin-op - (eval l) (eval r))]
    [with (bound-id named-expr bound-body)
          (eval (subst bound-body bound-id (eval named-expr)))]
    [id (name) (error 'eval "free identifier: ~s" name)]
    [muwae-max (a b c) (maxmin-op max (eval a) (eval b) (eval c))]
    [muwae-min (a b c) (maxmin-op min (eval a) (eval b) (eval c))]))

; run : string -> listof number
;; evaluate a MUWAE program contained in a string
(define (run str)
  (eval (parse str)))


;; test for basic syntax
(test (run "5") '(5))
(test (run "{+ 5 5}") '(10))
(test (run "{with {x {+ 5 5}} {+ x x}}") '(20))
(test (run "{with {x 5} {+ x x}}") '(10))
(test (run "{with {x {+ 5 5}} {with {y {- x 3}} {+ y y}}}") '(14))
(test (run "{with {x 5} {with {y {- x 3}} {+ y y}}}") '(4))
(test (run "{with {x 5} {+ x {with {x 3} 10}}}") '(15))
(test (run "{with {x 5} {+ x {with {x 3} x}}}") '(8))
(test (run "{with {x 5} {+ x {with {y 3} x}}}") '(10))
(test (run "{with {x 5} {with {y x} y}}") '(5))
(test (run "{with {x 5} {with {x x} x}}") '(5))
(test (run "{with {x 2} {- {+ x x} x}}") '(2))
(test/exn (run "{with {x 1} y}") "free identifier")
(test/exn (run "{with x = 2 {+ x 3}}") "bad syntax")
(test/exn (run "{bleh}") "bad syntax")

;; test for basic MUWAE
(test (run "{3 4 2 1}") '(3 4 2 1))
(test (run "{+ 3 7}") '(10))
(test (run "{- 10 {3 5}}") '(7 5))

;; test for with MUWAE
(test (run "{with {x {+ 5 5}} {+ x x}}") '(20))
(test (run "{with {x {3 5}} x}") '(3 5))
(test (run "{with {x {1 2}} {+ x {4 3}}}") '(5 4 6 5))
(test (run "{with {x {3 5}} {with {y {3 5}} {+ x {+ y {3 5}}}}}") '(9 11 11 13 11 13 13 15))
(test/exn (run "{}") "empty list")
(test/exn (run "{+ {} {1 2}}") "empty list")
(test/exn (run "{with {x {}} {+ x 5}}") "empty list")

;; test for max/min MUWAE
(test (run "{muwae-min 3 4 5}") '(3))
(test (run "{muwae-max {+ 1 2} 4 5}") '(5))
(test (run "{+ {muwae-min 9 3 7} {muwae-max 6 2 20}}") '(23))
(test/exn (run "{muwae-max {1 2} 4 5}") "max/min require 3 numbers")

;; test for complex MUWAE
(test (run "{with {x 10} {muwae-max x 2 3}}") '(10))
(test (run "{with {x 20} {with {y 5} {with {z {10 20}} {+ z {muwae-max {+ x y} 0 12}}}}}") '(35 45))
(test (run "{with {x 20} {with {y 5} {with {z {10 20}} {+ z {muwae-min {+ x y} 0 12}}}}}") '(10 20))
(test/exn (run "{with {x {10 20}} {muwae-max x 1 12}}") "max/min require 3 numbers")
