#lang plai

;; Programming Language 2015 Spring Homework 6
;; Sungwon Cho (known as Sam Jo)
;; 20150504T1728

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


(define-type KCFAE
  [num (n number?)]
  [add (lhs KCFAE?) (rhs KCFAE?)]
  [sub (lhs KCFAE?) (rhs KCFAE?)]
  [id (name symbol?)]
  [fun (param (listof symbol?)) (body KCFAE?)]
  [app (fun-expr KCFAE?) (arg-expr (listof KCFAE?))]
  [if0 (test KCFAE?) (then KCFAE?) (else KCFAE?)]
  [withcc (name symbol?) (body KCFAE?)]
  [trycatch (try KCFAE?) (catch KCFAE?)]
  [throw])

(define-type KCFAE-Value
  [numV (n number?)]
  [closureV (param (listof symbol?)) (body KCFAE?) (sc DefrdSub?)]
  [contV (proc procedure?)]
  [undefinedV])

(define-type DefrdSub
  [mtSub]
  [aSub (name symbol?) (value KCFAE-Value?) (rest DefrdSub?)])


;; parse : S-expr -> KCFAE
;; parse sexp to KCFAE. All list type except +, -, withcc, fun, if0,
;; try, throw will parsed as function application.
(define (parse sexp)
  (match sexp
    [(? number?) (num sexp)]
    [(list '+ l r) (add (parse l) (parse r))]
    [(list '- l r) (sub (parse l) (parse r))]
    [(? symbol?) (id sexp)]
    [(list 'fun (list a ...) b)
     (unless (uniq? a)
       (error 'parse "duplicated param name"))
     (fun a (parse b))] 
    [(list 'if0 q t e) (if0 (parse q) (parse t) (parse e))]
    [(list 'withcc k b) (withcc k (parse b))]
    [(list 'try t 'catch c) (trycatch (parse t) (parse c))]
    [(list 'throw) (throw)]
    [(list f a ...) (app (parse f) (map parse a))]
    [else (error 'parse "bad syntax: ~a" sexp)]))

;; from hw5 import exists?
;; exist?: symbol list-of-symbol -> bool
;; check whether given symbol in the given list of symbols.
(define (exist? symbol list)
  (if (empty? list)
      false
      (or (symbol=? symbol (first list)) (exist? symbol (rest list)))))

;; from hw5 import uniq?
;; uniq?: list-of-symbol -> bool
;; check whether given list of symbols are distinct. return true if empty.
(define (uniq? symbols)
  (if (empty? symbols)
      true
      (and (not (exist? (first symbols) (rest symbols))) (uniq? (rest symbols)))))

;; num-op: (number number -> number) numV numV -> numV
;; add or sub between two numV and return numV
(define (num-op op x y)
  (unless (and (numV? x) (numV? y))
    (error 'num-op "not a number"))
  (numV (op (numV-n x) (numV-n y))))

;; numzero? : KCFAE-Value -> boolean
;; check give KCFAE-Value is numV and zero
(define (numzero? x)
  (unless (numV? x)
    (error 'numzero? "not a number"))
  (zero? (numV-n x)))

;; lookup : symbol DefrdSub -> KCFAE-Value
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "free variable")]
    [aSub (sub-name num rest-sc)
          (if (symbol=? sub-name name)
              num
              (lookup name rest-sc))]))

;; a-lot-sub : list-of-symbol list-of-KCFAE-Value DefrdSub -> DefrdSub
;; add many params-values pair to given defrdsub and return the defrdsub  
(define (a-lot-sub params arg-vals ds)
  (foldl (lambda (param arg-val ds)
           (aSub param arg-val ds))
         ds params arg-vals))

;; interp-a-lot : list-of-KCFAE DefrdSub (list-of-KCFAE-Value -> alpha) (-> alpha) -> alpha
;; interp given list-of-KCFAE to get arg-vals using defrdsub, cont and exception handle.
(define (interp-a-lot arg-exprs ds k ehandle)
  (if (empty? arg-exprs)
      (k empty)
      (interp (first arg-exprs) ds
              (lambda (arg-val)
                (interp-a-lot (rest arg-exprs) ds
                              (lambda (arg-vals)
                                (k (append (list arg-val) arg-vals)))
                              ehandle))
              ehandle)))

;; interp : KCFAE DefrdSub (KCFAE-Value -> alpha) (-> alpha) -> alpha
;; interp given KCFAE using defrdsub, cont and exception handle.
(define (interp a-fae ds k ehandle)
  (type-case KCFAE a-fae
    [num (n) (k (numV n))]
    [add (l r) (interp l ds
                       (lambda (v1)
                         (interp r ds
                                 (lambda (v2)
                                   (k (num-op + v1 v2)))
                                 ehandle))
                       ehandle)]
    [sub (l r) (interp l ds
                       (lambda (v1)
                         (interp r ds
                                 (lambda (v2)
                                   (k (num-op - v1 v2)))
                                 ehandle))
                       ehandle)]
    [id (name) (k (lookup name ds))]
    [fun (param body-expr)
         (k (closureV param body-expr ds))]
    [app (fun-expr arg-exprs)
         (interp fun-expr ds
                 (lambda (fun-val)
                   (interp-a-lot arg-exprs ds
                                 (lambda (arg-vals)
                                   (type-case KCFAE-Value fun-val
                                     [closureV (params body ds)
                                               (if (= (length params) (length arg-vals))
                                                   (interp body
                                                           (a-lot-sub params arg-vals ds)
                                                           k ehandle)
                                                   (error 'interp "arity mismatch"))]
                                     [contV (k)
                                            (if (= (length arg-vals) 1)
                                                (k (first arg-vals))
                                                (error 'interp "arity mismatch"))]
                                     [else (error 'interp "not a function")]))
                                 ehandle))
                 ehandle)]
    [if0 (test-expr then-expr else-expr)
         (interp test-expr ds
                 (lambda (v)
                   (if (numzero? v)
                       (interp then-expr ds k ehandle)
                       (interp else-expr ds k ehandle)))
                 ehandle)]
    [withcc (id body-expr)
            (interp body-expr 
                    (aSub id
                          (contV k)
                          ds)
                    k ehandle)]
    [trycatch (t c) (interp t ds k
                            (lambda ()
                              (interp c ds k ehandle)))]
    [throw () (ehandle)]))

;; interp-expr : KCFAE -> number-or-'function-or-'undefined
;; interp given KCFAE with empty environment and identity cont.
;; returns number if result is numV, 'function if result is closureV or contV
(define (interp-expr a-fae)
  (type-case KCFAE-Value (interp a-fae (mtSub) (lambda (x) x) (lambda () (undefinedV)))
    [numV (n) n]
    [closureV (param body ds) 'function]
    [contV (k) 'function]
    [undefinedV () 'undefined]))

;; run: string KCFAE-Value -> number-or-'function-or-'undefined
;; get result of given KCFAE string
(define (run str)
  (interp-expr (parse (string->sexpr str))))


(test (run "10") 10)
(test (run "{+ 10 7}") 17)
(test (run "{- 10 7}") 3)
(test (run "{{fun {x} {+ x 12}} {+ 1 17}}") 30)
(test (run "{{fun {x} {{fun {f} {+ {f 1} {{fun {x} {f 2}} 3}}} {fun {y} {+ x y}}}} 0}") 3)
(test (run "{fun {x} x}") 'function)
(test (run "{withcc x x}") 'function)
(test (run "{fun {x} {fun {} x}}") 'function)

(test (run "{withcc k {k 10}}") 10)
(test (run "{withcc k {+ {k 10} 17}}") 10)
(test (run "{{fun {mk-list} {{fun {list} {if0 {list 0} {list 1} {0 {{list 2} {{{mk-list {- {list 0} 1}} {+ {list 1} 2}} {list 2}}}}}} {withcc k {{{mk-list 3} 0} k}}}} {fun {a} {fun {b} {fun {c} {fun {sel} {if0 sel a {if0 {- sel 1} b c}}}}}}}") 6)

(test (run "{- 0 {withcc k {+ {k 10} 17}}}") -10)
(test (run "{- 0 {withcc k {+ 1 {withcc c {k {+ {c 10} 17}}}}}}") -11)
(test (run "{+ 5 {withcc k {+ 1000 {k 5}}}}") 10)
(test (run "{- 0 {withcc k {+ 15 {k 3}}}}") -3)
(test (run "{withcc a {- 0 {withcc b {b 15}}}}") -15)
(test (run "{{{fun {x y} {fun {c} {+ {+ x y} c}}} 1 2} 3}") 6)
(test (run "{if0 {withcc esc {+ 3 {esc 1}}} 10 {- 0 10}}") -10)
(test (run "{if0 {withcc esc {+ 3 {esc 0}}} 10 {- 0 10}}") 10)
(test (run "{- 0 {withcc esc {{fun {f} {f 3}} esc}}}") -3)
(test (run "{{fun {x y} {- y x}} 10 12}") 2)
(test (run "{{{fun {x} {fun {} x}} 13}}") 13)
(test (run "{withcc esc {{fun {x y} x} 1 {esc 3}}}") 3)
(test (run "{+ 3 {withcc k {+ 5 {k 9}}}}") 12)
(test (run "{{withcc k {fun {x y} {+ x y}}} 4 5}") 9)
(test (run "{+ {withcc k {k 5}} 4}" ) 9)
(test (run "{{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} 1 {+ y {g g {- y 1}}}}} 10}") 55) ; recursive function
(test (run "{withcc done {{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} {done 100} {+ y {g g {- y 1}}}}} 10}}") 100) ; exit from recursive function using continuation
(test (run "{withcc k {- 0 {k 100}}}" ) 100)
(test (run "{withcc k {k {- 0 100}}}" ) -100)
(test (run "{withcc k {k {+ 100 11}}}" ) 111)
(test (run "{{fun {a b c} {- {+ {withcc k {+ {k 100} a}} b} c}} 100 200 300}" ) 0)
(test (run "{withcc esc {{fun {x y} x} 1 {esc 3}}}") 3)
(test (run "{{withcc esc {{fun {x y} {fun {z} {+ z y}}} 1 {withcc k {esc k}}}} 10}") 20)
(test (run "{try {{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} {throw} {+ y {g g {- y 1}}}}} 10} catch 110}") 110) ; exit from recursive function using try-catch
(test (run "{{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} {throw} {try {+ y {g g {- y 1}}} catch y}}} 10}") 54) ; test for multiple recursive try-catch
(test (run "{withcc done {{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} {throw} {try {+ y {g g {- y 1}}} catch {done y}}}} 10}}") 2)
(test (run "{try {{fun {f x} {f f x}} {fun {g y} {if0 {- y 1} {throw} {try {+ y {g g {- y 1}}} catch {throw}}}} 10} catch 20110464}") 20110464) ; recursive try-catch throwing (1)
(test (run "{try {{fun {x y z} {a b c}} 1 2 {throw}} catch 0}") 0)
(test (run "{{fun {f} {try {f 3} catch 8}} {fun {x} {throw}}}") 8)
(test (run "{try {- 0 {withcc k {+ 3 {k {throw}}}}} catch 89}") 89)
(test (run "{try {+ 3 {withcc k {+ 1000 {k {throw}}}}} catch 11}") 11)
(test (run "{{fun {x y z} {try {+ 1 {+ x {throw}}} catch {+ y z}}} 1 2 3}") 5)
(test (run "{+ {try {- 10 {throw}} catch 3} 10}") 13)
(test (run "{try {if0 0 {throw} {+ 1 2}} catch {if0 10 1 {try {throw} catch 54}}}") 54)
(test (run "{try {withcc a {+ 1 {withcc b {throw}}}} catch 10}") 10)
(test (run "{try {- 0 {throw}} catch 5}") 5)
(test (run "{try {if0 {throw} 3 4} catch 5}") 5)
(test (run "{try {{fun {x y} {try x catch y}} {throw} 0} catch -1}") -1)
(test (run "{try {try {throw} catch {throw}} catch 9}") 9)
(test (run "{{withcc esc {try {{withcc k {esc k}} 0} catch {fun {x} 8}}} {fun {x} {throw}}}") 8)
(test (run "{{withcc esc {try {{withcc k {try {esc k} catch {fun {x} {fun {y} 9}}}} 0} catch {fun {x} 8}}} {fun {x} {throw}}}") 8)
(test (run "{withcc foo {{fun {x y} {y x}} {+ 2 3} {withcc bar {+ 1 {bar foo}}}}}") 5)
(test (run "{try {withcc zzz {{fun {x y z w} {+ {+ x y} {+ z w}}} 1 2 {zzz 10} {throw}}} catch 42}") 10)
(test (run "{try {withcc zzz {{fun {x y z w} {+ {+ x y} {+ z w}}} 1 2 {throw} {zzz 10}}} catch 42}") 42)
(test (run "{try {withcc zzz {{fun {x y z w} {+ {w {+ x y}} {+ {throw} z}}} 1 2 3 zzz}} catch 42}") 3)
(test (run "{withcc esc {try {+ {throw} {esc 3}} catch 4}}") 4)
(test (run "{withcc esc {{fun {x y} {+ {+ x 3} y}} {withcc k {try {k {esc {throw}}} catch {k 5}}} 7}}") 15)
(test (run "{try {withcc x {+ {x 1} {throw}}} catch 0}") 1)
(test (run "{+ 12 {withcc k {+ 1 {k {{fun {} 7}}}}}}") 19)
(test (run "{+ {try {+ 1 {throw}} catch 3} {throw}}") 'undefined)
(test (run "{{fun {x y} {+ x y}} {throw}}") 'undefined)
(test (run "{try {throw} catch {throw}}") 'undefined)

(test/exn (run "{fun {} {} {}}") "bad syntax")
(test/exn (run "x") "free variable")
(test/exn (run "{{fun {x} 0} {1 {fun {y} y}}}") "not a function")
(test/exn (run "{{fun {x y x} {+ x y}} 3 5 4}") "duplicated param name")
(test/exn (run "{{fun {x} x} 3 4}") "arity mismatch")
(test/exn (run "{withcc x {x}}") "arity mismatch")
(test/exn (run "{+ 3 {fun {x} x}}") "not a number")
(test/exn (run "{if0 {fun {} 3} 3 5}") "not a number")
