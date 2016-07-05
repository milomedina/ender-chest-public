#lang plai

;; Programming Language 2015 Spring Homework 5
;; Sungwon Cho (known as Sam Jo)
;; 20150411T0116

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


(define-type FunDef
  [fundef (fun-name symbol?) (arg-names (listof symbol?)) (body FnWAE?)])

(define-type FnWAE
  [num (n number?)]
  [add (lhs FnWAE?) (rhs FnWAE?)]
  [sub (lhs FnWAE?) (rhs FnWAE?)]
  [with (name symbol?) (named-expr FnWAE?) (body FnWAE?)]
  [id (name symbol?)]
  [app (ftn symbol?) (args (listof FnWAE?))]
  [rec (ids (listof symbol?)) (exprs (listof FnWAE?))]
  [get (record FnWAE?) (id symbol?)])

(define-type FnWAE-Value
  [numV (n number?)]
  [recordV (ids (listof symbol?)) (vals (listof FnWAE-Value?))])

(define-type DefrdSub
  [mtSub]
  [aSub (name symbol?) (value FnWAE-Value?) (rest DefrdSub?)])

;; parse: sexp -> FnWAE
;; parse sexp to FnWAE. All list type except +, -, with, rec, get
;; will parsed as function application.
(define (parse sexp)
  (match sexp
    [(? number?) (num sexp)]
    [(list '+ l r) (add (parse l) (parse r))]
    [(list '- l r) (sub (parse l) (parse r))]
    [(list 'with (list x i) b) (with x (parse i) (parse b))]
    [(? symbol?) (id sexp)]
    [(list 'rec r ...)
     (local [(define ids (map (lambda(e) (first e)) r))]
       (unless (uniq? ids)
         (error 'parse "duplicate fields"))
       (rec ids (map (lambda (e) (parse (second e))) r)))]
    [(list 'get r i) 
     (unless (symbol? i)
       (error 'parse "get id is not symbol"))
     (get (parse r) i)]
    [(list f a ...) (app f (map parse a))]
    [else (error 'parse "bad syntax: ~a" sexp)]))

;; parse-defn: sexp -> FunDef
;; parse sexp to FunDef. All parameter symvols should be different.
(define (parse-defn sexp)
  (match sexp
    [(list 'deffun (list f x ...) body)
     (unless (uniq? x)
       (error 'parse-defn "bad syntax"))
     (fundef f x (parse body))]))
      
;; exist?: symbol list-of-symbol -> bool
;; check whether given symbol in the given list of symbols.
(define (exist? symbol list)
  (if (empty? list)
      false
      (or (symbol=? symbol (first list)) (exist? symbol (rest list)))))

(test (exist? 'a '(a b c d)) true)
(test (exist? 'a '()) false)
(test (exist? 'a '(b c d)) false)
      
;; uniq?: list-of-symbol -> bool
;; check whether given list of symbols are distinct. return true if empty.
(define (uniq? symbols)
  (if (empty? symbols)
      true
      (and (not (exist? (first symbols) (rest symbols))) (uniq? (rest symbols)))))

(test (uniq? '(a b c d)) true)
(test (uniq? '()) true)
(test (uniq? '(a b c d b)) false)

;; lookup-fundef: symbol list-of-FunDef -> FunDef
;; find function in list of FunDef using given function name.
;; return FunDef object if found.
(define (lookup-fundef name fundefs)
  (if (empty? fundefs)
      (error 'lookup-fundef "no function")
      (local [(define a-fundef (first fundefs))]
        (if (symbol=? (fundef-fun-name a-fundef) name)
            a-fundef
            (lookup-fundef name (rest fundefs))))))

;; lookup-rec: symbol list-of-symbol list-of-FnWAE-Value -> FnWAE-Value
;; find value that corresponds to given name.
;; given list-of-symbol and list-of-FnWAE-Values match respectively.
(define (lookup-rec name ids vals)
  (if (empty? ids)
      (error 'lookup-rec "no such field")
      (if (symbol=? name (first ids))
          (first vals)
          (lookup-rec name (rest ids) (rest vals)))))

;; lookup: symbol DefrdSub -> number
;; find value for given name in DefrdSub
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "free variable")]
    [aSub (x val rest)
          (if (symbol=? x name)
              val
              (lookup name rest))]))

;; make-ds: list-of-FnWAE list-of-symbol list-of-FunDef DefrdSub -> DefrdSub
;; make defrdsub for function application.
;; list-of-FnWAE and list-of-symbol match respectively.
(define (make-ds args arg-names fundefs ds)
  (if (empty? args)
      (mtSub)
      (aSub (first arg-names) (interp (first args) fundefs ds)
            (make-ds (rest args) (rest arg-names) fundefs ds))))

;; num-op: (number number -> number) numV numV -> numV
;; add or sub between two numV and return numV
(define (num-op op x y)
  (unless (and (numV? x) (numV? y))
    (error 'num-op "not a number"))
  (numV (op (numV-n x) (numV-n y))))

;; interp: FnWAE list-of-FunDef DefrdSub -> FnWAE-Value
;; interp given FnWAE using list of fundefs and defrdsub.
(define (interp fnwae fundefs ds)
  (type-case FnWAE fnwae
    [num (n) (numV n)]
    [add (l r) (num-op + (interp l fundefs ds) (interp r fundefs ds))]
    [sub (l r) (num-op - (interp l fundefs ds) (interp r fundefs ds))]
    [with (x i b) (interp b fundefs (aSub x (interp i fundefs ds) ds))]
    [id (s) (lookup s ds)]
    [app (ftn args)
         (local [(define a-fundef (lookup-fundef ftn fundefs))]
           (unless (= (length (fundef-arg-names a-fundef)) (length args))
             (error 'parse-defn "wrong arity"))
           (interp (fundef-body a-fundef)
                   fundefs
                   (make-ds args (fundef-arg-names a-fundef) fundefs ds)))]
    [rec (ids exprs) (recordV ids (map (lambda(e) (interp e fundefs ds)) exprs))]
    [get (rec id)
         (local [(define record (interp rec fundefs ds))]
           (unless (recordV? record)
             (error 'interp "not record"))
           (lookup-rec id (recordV-ids record) (recordV-vals record)))]))

;; extract-fun-name: list-of-FunDef -> list-of-symbol
;; get function name for given fundefs
(define (extract-fun-name fundefs)
  (map (lambda (e) (fundef-fun-name e)) fundefs))

;; interp-expr: FnWAE list-of-Fundef -> (number or symbol)
;; interp given FnWAE with empty environment.
;; returns number if result is numV, 'record if result is recordV
(define (interp-expr fnwae fundefs)
  (type-case FnWAE-Value (interp fnwae fundefs (mtSub))
    [numV (n) n]
    [recordV (ids vals) 'record]))

;; run: string list-of-FunDef -> (number or symbol)
;; get result of given FnWAE string and list of fundefs
(define (run str fundefs)
  (unless (uniq? (extract-fun-name fundefs))
    (error 'run "duplicate function definition"))
  (interp-expr (parse (string->sexpr str)) fundefs))


(test (parse-defn '{deffun {f} 3}) (fundef 'f '() (num 3)))
(test (parse-defn '{deffun {f x y} {+ x y}}) (fundef 'f '(x y) (add (id 'x) (id 'y))))
(test (run "{f 1 2}" (list (parse-defn '{deffun {f x y} {+ x y}}))) 3)
(test (run "{+ {f} {f}}" (list (parse-defn '{deffun {f} 5}))) 10)

(test/exn (parse-defn '{deffun {f a b c a} {+ a b}}) "bad syntax")
(test/exn (parse-defn '{deffun {f a a b} {+ a b}}) "bad syntax")
(test/exn (run "{f 1}" (list (parse-defn '{deffun {f x y} {+ x y}}))) "wrong arity")

(define fun0 (parse-defn '{deffun {f x} {+ 3 x}}))
(define fun1 (parse-defn '{deffun {f} 3}))
(define fun2 (parse-defn '{deffun {sum x y} {+ x y}}))
(define fun3 (parse-defn '{deffun {record x} {rec {a x}}}))
(define fun4 (parse-defn '{deffun {gett r} {get r a}}))
(define fun5 (parse-defn '{deffun {crazy x y z} {+ x {- y z}}}))
(define fun-list (list fun1 fun2 fun3 fun4 fun5))

;; test for basic syntax from WAE
(test (run "5" empty) 5)
(test (run "{+ 5 5}" empty) 10)
(test (run "{with {x {+ 5 5}} {+ x x}}" empty) 20)
(test (run "{with {x 5} {+ x x}}" empty) 10)
(test (run "{with {x {+ 5 5}} {with {y {- x 3}} {+ y y}}}" empty) 14)
(test (run "{with {x 5} {with {y {- x 3}} {+ y y}}}" empty) 4)
(test (run "{with {x 5} {+ x {with {x 3} 10}}}" empty) 15)
(test (run "{with {x 5} {+ x {with {x 3} x}}}" empty) 8)
(test (run "{with {x 5} {+ x {with {y 3} x}}}" empty) 10)
(test (run "{with {x 5} {with {y x} y}}" empty) 5)
(test (run "{with {x 5} {with {x x} x}}" empty) 5)
(test (run "{with {x 2} {- {+ x x} x}}" empty) 2)

;; test for basic syntax
(test (run "{+ 3 {- 4 5}}" empty) 2)
(test (run "{with {x {with {x 3} {+ x 3}}} {+ 4 x}}" empty) 10)
(test (run "{with {x 3} {- 4 5}}" empty) -1)
(test (run "{crazy 3 4 5}" fun-list) 2)
(test (run "{sum {crazy 3 4 5} 4}" fun-list) 6)
(test (run "{- 3 {+ {f} {f}}}" fun-list) -3)

;; test for errors
(test/exn (run "{with {x 42} y}" empty) "free variable")
(test/exn (run "{}" empty) "bad syntax")
(test/exn (run "abc{}d" empty) "bad syntax")
(test/exn (run "{f 3}" empty) "no function")
(test/exn (run "{f 3}" (list fun0 fun1)) "duplicate function definition")

;; test for rec and get
(test (run "{rec {a 10} {b {+ 1 2}}}" empty) 'record)
(test (run "{get {rec {a 10} {b {+ 1 2}}} b}" empty) 3)
(test (run "{g {rec {a 0} {c 12} {b 7}}}" (list (parse-defn '{deffun {g r} {get r c}}))) 12)
(test (run "{get {rec {r {rec {z 0}}}} r}" empty) 'record)
(test (run "{get {get {rec {r {rec {z 0}}}} r} z}" empty) 0)
(test (run "{record 3}" fun-list) 'record)
(test (run "{gett {record {+ 3 5}}}" fun-list) 8)
(test (run "{crazy 4 5 {get {record {gett {rec {a {+ 3 5}} {b 42}}}} a}}" fun-list) 1)

;; THE HOT TOPIC on noah board
(test (run "{with {y 3} {get {rec {x y}} x}}" empty) 3)

;; error check
(test/exn (run "{get {rec {b 10} {b {+ 1 2}}} b}" empty) "duplicate fields")
(test/exn (run "{get {rec {a 10}} b}" empty) "no such field")
(test/exn (run "{rec {z {get {rec {z 0}} y}}}" empty) "no such field")
(test/exn (run "{get 3 a}" empty) "not record")
(test/exn (run "{+ {rec {z 3} {y 2}} 3}" empty) "not a number")
(test/exn (run "{get {rec {a 42}} 42}" empty) "get id is not symbol")
