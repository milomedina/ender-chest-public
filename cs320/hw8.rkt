#lang plai-typed

;; Programming Language 2015 Spring Homework 8
;; Sungwon Cho (known as Sam Jo)
;; 20150518T1212

(define-type TMFAE
  [num (n : number)]
  [bool (b : boolean)]
  [add (lhs : TMFAE)
       (rhs : TMFAE)]
  [sub (lhs : TMFAE)
       (rhs : TMFAE)]
  [eq (lhs : TMFAE)
      (rhs : TMFAE)]
  [id (name : symbol)]
  [ifthenelse (test : TMFAE)
              (then : TMFAE)
              (else : TMFAE)]
  [fun (params : (listof symbol))
       (paramtys : (listof TE))
       (body : TMFAE)]
  [app (fun-expr : TMFAE)
       (arg-exprs : (listof TMFAE))]
  [with (names : (listof symbol))
        (nametys : (listof TE))
        (inits : (listof TMFAE))
        (body : TMFAE)]
  [try1 (try-expr : TMFAE)
        (catch-exprs : TMFAE)]
  [throw]
  [pair (e1 : TMFAE)
        (e2 : TMFAE)]
  [fst (p : TMFAE)]
  [snd (p : TMFAE)])

(define-type TE
  [numTE]
  [boolTE]
  [crossTE (t1 : TE)
           (t2 : TE)]
  [arrowTE (params : (listof TE))
           (result : TE)])

(define-type TMFAE-Value
  [numV (n : number)]
  [boolV (b : boolean)]
  [crossV (v1 : TMFAE-Value)
          (v2 : TMFAE-Value)]
  [closureV (params : (listof symbol))
            (body : TMFAE)
            (ds : DefrdSub)])

(define-type DefrdSub
  [mtSub]
  [aSub (name : symbol) (value : TMFAE-Value) (rest : DefrdSub)])

(define-type Type
  [numT]
  [boolT]
  [anyT]
  [crossT (t1 : Type) (t2 : Type)]
  [arrowT (params : (listof Type)) (result : Type)])

(define-type TypeEnv
  [mtEnv]
  [aBind (name : symbol) (type : Type) (rest : TypeEnv)])


;; PRIMITIVE FUNCTION

(define (length l)
  (if (empty? l)
      0
      (+ 1 (length (rest l)))))


;; BASIC HELPER FUNCTION

;; num-op : (number number -> number) TMFAE-Value TMFAE-Value -> TMFAE-Value
(define (num-op op x y)
  (numV (op (numV-n x) (numV-n y))))

;; num+/- : TMFAE-Value TMFAE-Value -> TMFAE-Value
(define (num+ x y) (num-op + x y))
(define (num- x y) (num-op - x y))

;; num= : TMFAE-Value TMFAE-Value -> TMFAE-Value 
(define (num= x y) (boolV (= (numV-n x) (numV-n y))))

;; booltrue? : TMFAE-Value -> boolean
(define (booltrue? x) (boolV-b x))

;; sub-a-lot : list-of-symbol list-of-TMFAE-Value DefrdSub -> DefrdSub
;; add symbol-value mapping to given DefrdSub
(define (sub-a-lot arg-names arg-vals ds)
  (if (empty? arg-names)
      ds
      (aSub (first arg-names) (first arg-vals)
            (sub-a-lot (rest arg-names) (rest arg-vals) ds))))

;; bind-a-lot : list-of-symbol list-of-Type TypeEnv -> TypeEnv
;; add symbol-type mapping to given TypeEnv
(define (bind-a-lot arg-names arg-types env)
  (if (empty? arg-names)
      env
      (aBind (first arg-names) (first arg-types)
            (bind-a-lot (rest arg-names) (rest arg-types) env))))

;; lookup : symbol DefrdSub -> TMFAE-Value
;; find given symbol in given DefrdSub
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "free variable")]
    [aSub (sub-name num rest-ds)
          (if (symbol=? sub-name name)
              num
              (lookup name rest-ds))]))

;; get-type : symbol TypeEnv -> Type
;; find give symbol in given TypeEnv
(define (get-type name-to-find env)
  (type-case TypeEnv env
    [mtEnv () (error 'get-type "free variable, so no type")]
    [aBind (name ty rest)
           (if (symbol=? name-to-find name)
               ty
               (get-type name-to-find rest))]))

;; is-(type)? : Type -> boolean
;; exactly same as predicate (type)?
(define (is-any? t) (equal? t (anyT)))
(define (is-num? t) (equal? t (numT)))
(define (is-bool? t) (equal? t (boolT)))
(define (is-cross? t)
  (type-case Type t
    [crossT (a b) true]
    [else false]))
(define (is-arrow? t)
  (type-case Type t
    [arrowT (a b) true]
    [else false]))

;; type-equal? : Type Type -> Type
;; check given two types are equals. anyT is considered same
(define (type-equal? a b)
  (if (is-any? b)
      true
      (type-case Type a
        [anyT () true]
        [numT () (is-num? b)]
        [boolT () (is-bool? b)]
        [crossT (a1 a2) (and (is-cross? b)
                             (type-equal? a1 (crossT-t1 b))
                             (type-equal? a2 (crossT-t2 b)))]
        [arrowT (p r) (and (is-arrow? b)
                                   (type-all-equal? p (arrowT-params b))
                                   (type-equal? r (arrowT-result b)))])))

;; type-all-equal? : list-of-Type list-of-Type -> boolean
;; check given two list of types are all equals
(define (type-all-equal? a b)
  (if (empty? a)
      true
      (and (type-equal? (first a) (first b))
           (type-all-equal? (rest a) (rest b)))))

;; merge-type : Type Type -> Type
;; merge two type, replacing anyT to other type
(define (merge-type a b)
  (if (type-equal? a b)
      (if (is-any? b) a
          (type-case Type a
            [anyT () b]
            [numT () (numT)]
            [boolT () (boolT)]
            [crossT (a1 a2) (crossT (merge-type a1 (crossT-t1 b))
                                    (merge-type a2 (crossT-t2 b)))]
            [arrowT (p r) (arrowT p (merge-type r (arrowT-result b)))]))
      (error 'merge-type "not equal type")))

;; get-pair-type : Type number -> Type
;; if pos is 0, return first type of given pair type, otherwise return second
;; if given type is anyT, simply return anyT
(define (get-pair-type p pos)
  (type-case Type p
    [anyT () (anyT)]
    [crossT (a b) (if (= pos 0) a b)]
    [else (error 'get-pair-type "not crossT")]))

;; parse-type-a-lot : list-of-TE -> list-of-Type
;; parse given list of type expressions to list of types
(define (parse-type-a-lot tes)
  (map (lambda (te) (parse-type te)) tes))

;; parse-type : TE -> Type
;; parse given type expression to type
(define (parse-type te)
  (type-case TE te
    [numTE () (numT)]
    [boolTE () (boolT)]
    [crossTE (a b) (crossT (parse-type a) (parse-type b))]
    [arrowTE (a b) (arrowT (parse-type-a-lot a) (parse-type b))]))

;; type-error : TMFAE string -> void
;; raise typecheck exception with pretty message
(define (type-error TMFAE msg)
  (error 'typecheck (string-append
                     "no type: "
                     (string-append
                      (to-string TMFAE)
                      (string-append " not "
                                     msg)))))

;; typecheck-a-lot : list-of-TMFAE TypeEnv -> list-of-Type
;; get list of types of the given list of TMFAEs with given TypeEnv
(define (typecheck-a-lot tmfaes env)
  (map (lambda (tmfae) (typecheck tmfae env)) tmfaes))

;; get type of given TMFAE with given type environment
(define typecheck : (TMFAE TypeEnv -> Type)
  (lambda (tmfae env)
    (type-case TMFAE tmfae
      [num (n) (numT)]
      [bool (b) (boolT)]
      [add (l r) (if (type-equal? (typecheck l env) (numT))
                     (if (type-equal? (typecheck r env) (numT))
                         (numT)
                         (type-error r "num"))
                     (type-error l "num"))]
      [sub (l r) (if (type-equal? (typecheck l env) (numT))
                     (if (type-equal? (typecheck r env) (numT))
                         (numT)
                         (type-error r "num"))
                     (type-error l "num"))]
      [eq (l r) (if (type-equal? (typecheck l env) (numT))
                     (if (type-equal? (typecheck r env) (numT))
                         (boolT)
                         (type-error r "num"))
                     (type-error l "num"))]
      [id (name) (get-type name env)]
      [ifthenelse (test e1 e2)
                  (if (type-equal? (typecheck test env) (boolT))
                      (local [(define e1-type (typecheck e1 env))
                              (define e2-type (typecheck e2 env))]
                        (if (type-equal? e1-type e2-type)
                            (merge-type e1-type e2-type)
                            (type-error e2 (to-string e1-type))))
                      (type-error test "bool"))]
      [fun (names tes body)
           (local [(define param-types (parse-type-a-lot tes))]
             (arrowT param-types
                     (typecheck body (bind-a-lot names param-types env))))]
      [app (fn args)
           (local [(define fun-type (typecheck fn env))
                   (define arg-types (typecheck-a-lot args env))]
             (type-case Type fun-type
               [anyT () (anyT)]
               [arrowT (param-types result-type)
                       (local [(define arg-types (typecheck-a-lot args env))]
                         (if (= (length param-types) (length arg-types))
                             (if (type-all-equal? param-types arg-types)
                                 result-type
                                 (type-error tmfae "wrong type on params"))
                             (type-error tmfae "arity mismatch")))]
             [else (type-error fn "function")]))]
      [pair (e1 e2) (crossT (typecheck e1 env) (typecheck e2 env))]
      [fst (p) (local [(define pair (typecheck p env))]
                 (if (type-equal? pair (crossT (anyT) (anyT)))
                     (get-pair-type pair 0)
                     (type-error p "pair")))]
      [snd (p) (local [(define pair (typecheck p env))]
                 (if (type-equal? pair (crossT (anyT) (anyT)))
                     (get-pair-type pair 1)
                     (type-error p "pair")))]
      [with (names nametys inits body)
            (local [(define name-types (parse-type-a-lot nametys))
                    (define init-types (typecheck-a-lot inits env))]
              (if (type-all-equal? name-types init-types)
                  (typecheck body (bind-a-lot names name-types env))
                  (type-error tmfae "wrong type on name types")))]
      [try1 (try-expr catch-expr)
            (local [(define try-type (typecheck try-expr env))
                    (define catch-type (typecheck catch-expr env))]
              (if (type-equal? try-type catch-type)
                  (merge-type try-type catch-type)
                  (type-error catch-expr (to-string try-type))))]
      [throw () (anyT)])))

;; interp : TMFAE DefrdSub (alpha -> alpha) (-> alpha) -> TMFAE-Value
;; interp given TMFAE using defrdsub, cont and exception handle.
(define (interp tmfae ds k ehandle)
  (type-case TMFAE tmfae
    [num (n) (k (numV n))]
    [bool (b) (k (boolV b))]
    [add (l r) (interp-two l r ds num+ k ehandle)]
    [sub (l r) (interp-two l r ds num- k ehandle)]
    [eq (l r) (interp-two l r ds num= k ehandle)]
    [id (name) (k (lookup name ds))]
    [ifthenelse (test-expr then-expr else-expr)
                (interp test-expr ds
                        (lambda (v)
                          (if (booltrue? v)
                              (interp then-expr ds k ehandle)
                              (interp else-expr ds k ehandle)))
                        ehandle)]
    [fun (params params-te body-expr)
         (k (closureV params body-expr ds))]
    [app (fun-expr arg-exprs)
         (interp fun-expr ds
                 (lambda (fun-val)
                   (interp-a-lot arg-exprs ds
                                 (lambda (arg-vals)
                                   (type-case TMFAE-Value fun-val
                                     [closureV (params body ds)
                                               (if (= (length params) (length arg-vals))
                                                   (interp body (sub-a-lot params arg-vals ds) k ehandle)
                                                   (error 'interp "wrong arity"))]
                                     [else (error 'interp "not a function")]))
                                 ehandle))
                 ehandle)]
    [pair (e1 e2) (interp-two e1 e2 ds crossV k ehandle)]
    [fst (p) (interp p ds (lambda (p) (k (crossV-v1 p))) ehandle)]
    [snd (p) (interp p ds (lambda (p) (k (crossV-v2 p))) ehandle)]
    [with (names nametys inits body)
          (interp-a-lot inits ds
                        (lambda (init-vals)
                          (interp body (sub-a-lot names init-vals ds) k ehandle))
                        ehandle)]
    [try1 (try-expr catch-expr) (interp try-expr ds k
                                        (lambda ()
                                          (interp catch-expr ds k ehandle)))]
    [throw () (ehandle)]))


;; interp-two : TMFAE TMFAE DefrdSub (alpha alpha -> alpha) (alpha -> alpha) (-> alpha) -> TMFAE-Value
;; interp first TMFAE, interp second TMFAE and then run cont k with function op
(define (interp-two tmfae1 tmfae2 ds op k ehandle)
  (interp tmfae1 ds
          (lambda (v1)
            (interp tmfae2 ds
                    (lambda (v2)
                      (k (op v1 v2))) ehandle)) ehandle))
  
;; @copied from hw6
;; interp-a-lot : list-of-TMFAE DefrdSub (alpha -> alpha) (-> alpha) -> TMFAE-Value
;; interp many expressions from top to bottom and execute k
(define (interp-a-lot tmfaes ds k ehandle)
  (if (empty? tmfaes)
      (k empty)
      (interp (first tmfaes) ds
              (lambda (val)
                (interp-a-lot (rest tmfaes) ds
                              (lambda (vals)
                                (k (append (list val) vals)))
                              ehandle))
              ehandle)))


;; WRAPPER FUNCTION

;; evalutes TMFAE with empty environment, identity cont and default error handler
(define run : (TMFAE -> TMFAE-Value)
  (lambda (tmfae)
    (interp tmfae (mtSub) (lambda (x) x) (lambda () (error 'interp "unhandled")))))

;; run given TMFAE after typecheck
(define eval : (TMFAE -> TMFAE-Value)
  (lambda (tmfae)
    (begin
      (try (typecheck tmfae (mtEnv))
           (lambda () (error 'type-error "typecheck")))
      (run tmfae))))


;; Modified from first and second question ;;
(test (run (num 10)) (numV 10))
(test (run (add (num 10) (num 17))) (numV 27))
(test (run (sub (num 10) (num 7))) (numV 3))
(test (run (app (fun (list 'x) (list (numTE)) (add (id 'x) (num 12))) (list (add (num 1) (num 17))))) (numV 30))
(test (run (app (fun (list 'x) (list (numTE)) (app (fun (list 'f) (list (arrowTE (list (numTE)) (numTE))) (add (app (id 'f) (list (num 1))) (app (fun (list 'x) (list (numTE)) (app (id 'f) (list (num 2)))) (list (num 3))))) (list (fun (list 'y) (list (numTE)) (add (id 'x) (id 'y)))))) (list (num 0)))) (numV 3))

(test/exn (run (id 'x)) "free variable")
(test (typecheck (num 10) (mtEnv)) (numT))
(test (typecheck (add (num 10) (num 17)) (mtEnv)) (numT))
(test (typecheck (sub (num 10) (num 7)) (mtEnv)) (numT))
(test (typecheck (fun (list 'x) (list (numTE)) (add (id 'x) (num 12))) (mtEnv)) (arrowT (list (numT)) (numT)))
(test (typecheck (fun (list 'x) (list (numTE)) (fun (list 'y) (list (boolTE)) (id 'x))) (mtEnv)) (arrowT (list (numT)) (arrowT (list (boolT))  (numT))))
(test (typecheck (app (fun (list 'x) (list (numTE)) (add (id 'x) (num 12))) (list (add (num 1) (num 17)))) (mtEnv)) (numT))
(test (typecheck (app (fun (list 'x) (list (numTE)) (app (fun (list 'f) (list (arrowTE (list (numTE)) (numTE))) (add (app (id 'f) (list (num 1))) (app (fun (list 'x) (list (numTE)) (app (id 'f) (list (num 2)))) (list (num 3))))) (list (fun (list 'y) (list (numTE)) (add (id 'x) (id' y)))))) (list (num 0))) (mtEnv)) (numT))

(test/exn (typecheck (app (num 1) (list (num 2))) (mtEnv)) "no type")
(test/exn (typecheck (add (fun (list 'x) (list (numTE)) (num 12)) (num 2)) (mtEnv)) "no type")

(test (run (eq (num 13) (ifthenelse (eq (num 1) (add (num -1) (num 2))) (num 12) (num 13)))) (boolV false))
(test (typecheck (eq (num 13) (ifthenelse (eq (num 1) (add (num -1) (num 2))) (num 12) (num 13))) (mtEnv)) (boolT))
(test/exn (typecheck (add (num 1) (ifthenelse (bool true) (bool true) (bool false))) (mtEnv)) "no type")

;; Given test cases ;;
(test (run (fst (pair (num 10) (num 8)))) (numV 10))
(test (run (snd (pair (num 10) (num 8)))) (numV 8))
(test (typecheck (pair (num 10) (num 8)) (mtEnv)) (crossT (numT) (numT)))
(test (typecheck (add (num 1) (snd (pair (num 10) (num 8)))) (mtEnv)) (numT))
(test (typecheck (fun (list 'x) (list (crossTE (numTE) (boolTE))) (ifthenelse (snd (id 'x)) (num 0) (fst (id 'x)))) (mtEnv)) (arrowT (list (crossT (numT) (boolT))) (numT)))
(test/exn (typecheck (fst (num 10)) (mtEnv)) "no type")
(test/exn (typecheck (add (num 1) (fst (pair (bool false) (num 8)))) (mtEnv)) "no type")
(test/exn (typecheck (fun (list 'x) (list (crossTE (numTE) (boolTE))) (ifthenelse (fst (id 'x)) (num 0) (fst (id 'x)))) (mtEnv)) "no type")

(test (typecheck (throw) (mtEnv)) (anyT))
(test (typecheck (try1 (num 8) (num 10)) (mtEnv)) (numT))
(test (typecheck (try1 (throw) (num 10)) (mtEnv)) (numT))
(test/exn (typecheck (try1 (num 8) (bool false)) (mtEnv)) "no type")
(test (typecheck (ifthenelse (throw) (num 1) (num 2)) (mtEnv)) (numT))
(test/exn (typecheck (app (throw) (list (ifthenelse (num 1) (num 2) (num 3)))) (mtEnv)) "no type")
(test/exn (typecheck (add (bool true) (throw)) (mtEnv)) "no type")
(test (typecheck (fst (throw)) (mtEnv)) (anyT))
(test (typecheck (ifthenelse (bool true) (pair (num 1) (throw)) (pair (throw) (bool false))) (mtEnv)) (crossT (numT) (boolT)))
(test (typecheck (bool true) (mtEnv)) (boolT))
(test (typecheck (ifthenelse (bool false) (num 2) (throw)) (mtEnv)) (numT))
(test (typecheck (ifthenelse (bool false) (throw) (num 2)) (mtEnv)) (numT))
(test (typecheck (ifthenelse (bool false) (throw) (throw)) (mtEnv)) (anyT))
(test (typecheck (pair (num 2) (bool false)) (mtEnv)) (crossT (numT) (boolT)))
(test (typecheck (pair (num 2) (throw)) (mtEnv)) (crossT (numT) (anyT)))
(test (typecheck (snd (throw)) (mtEnv)) (anyT))
(test (typecheck (fst (pair (num 2) (bool false))) (mtEnv)) (numT))
(test (typecheck (snd (pair (num 2) (bool false))) (mtEnv)) (boolT))
(test (typecheck (fun empty empty (num 2)) (mtEnv)) (arrowT empty (numT)))
(test (typecheck (fun (list 'x) (list (numTE)) (throw)) (mtEnv)) (arrowT (list (numT)) (anyT)))
(test (typecheck (app (fun empty empty (num 2)) empty) (mtEnv)) (numT))
(test (typecheck (app (throw) (list (num 2) (bool false))) (mtEnv)) (anyT))
(test (typecheck (app (fun (list 'x 'y) (list (numTE) (numTE)) (add (id 'x) (id 'y))) (list (num 2) (num 3))) (mtEnv)) (numT))
(test (typecheck (with (list 'x) (list (numTE)) (list (num 2)) (id 'x)) (mtEnv)) (numT))
(test (typecheck (with (list 'x 'y 'z) (list (boolTE) (numTE) (numTE)) (list (bool false) (num 2) (num 3)) (ifthenelse (id 'x) (id 'y) (id 'z))) (mtEnv)) (numT))
(test (typecheck (with empty empty empty (num 2)) (mtEnv)) (numT))
(test (typecheck (with (list 'x) (list (numTE)) (list (throw)) (num 2)) (mtEnv)) (numT))
(test (run (eq (num 2) (num 3))) (boolV false))
(test (run (eq (num 2) (num 2))) (boolV true))
(test (run (ifthenelse (bool true) (num 2) (num 3))) (numV 2))
(test (run (ifthenelse (bool false) (num 2) (num 3))) (numV 3))
(test (run (with (list 'x 'y 'z) (list (numTE) (numTE) (numTE)) (list (num 2) (num 3) (num 4)) (add (id 'x) (id 'y)))) (numV 5))
(test (run (fun (list 'x 'y) (list (numTE) (numTE)) (add (id 'x) (id 'y)))) (closureV (list 'x 'y) (add (id 'x) (id 'y)) (mtSub)))
(test (run (app (fun (list 'x 'y) (list (numTE) (numTE)) (add (id 'x) (id 'y))) (list (num 2) (num 3)))) (numV 5))
(test (run (fst (pair (num 2) (num 3)))) (numV 2))
(test (typecheck (try1 (throw) (throw)) (mtEnv)) (anyT))
(test (typecheck (app (throw) (list (num 1))) (mtEnv)) (anyT))
(test (typecheck (fst (throw)) (mtEnv)) (anyT))
(test (typecheck (ifthenelse (bool true) (fun (list 'x 'y) (list (numTE) (numTE)) (throw)) (fun (list 'z 'a) (list (numTE) (numTE)) (add (id 'z) (id 'a)))) (mtEnv)) (arrowT (list (numT) (numT)) (numT)))
(test (typecheck (try1 (num 2) (throw)) (mtEnv)) (numT))
(test (typecheck (try1 (throw) (num 2)) (mtEnv)) (numT))
(test (typecheck (try1 (num 2) (num 2)) (mtEnv)) (numT))
(test (typecheck (app (fun (list 'a) (list (numTE)) (add (throw) (num 10))) (list (throw))) (mtEnv)) (numT))
(test (typecheck (try1 (with (list 'map 'foo) (list (arrowTE (list (arrowTE (list (numTE)) (boolTE)) (crossTE (numTE) (numTE))) (crossTE (boolTE) (boolTE))) (crossTE (numTE) (numTE))) (list (fun (list 'f 'p) (list (arrowTE (list (numTE)) (boolTE)) (crossTE (numTE) (numTE))) (pair (app (id 'f) (list (fst (id 'p)))) (app (id 'f) (list (snd (id 'p)))))) (pair (num 10) (num 42))) (app (id 'map) (list (throw) (id 'foo)))) (pair (bool false) (bool false))) (mtEnv)) (crossT (boolT) (boolT)))
(test (typecheck (try1 (add (throw) (num 8)) (num 10)) (mtEnv)) (numT))
(test (typecheck (try1 (pair (num 8) (num 2)) (throw)) (mtEnv)) (crossT (numT) (numT)))
(test (typecheck (eq (num 42) (try1 (ifthenelse (bool true) (throw) (throw)) (num 10))) (mtEnv)) (boolT))
(test (typecheck (ifthenelse (throw) (pair (throw) (num 42)) (pair (bool false) (throw))) (mtEnv)) (crossT (boolT) (numT)))
(test (typecheck (with (list 'x 'y 'z) (list (boolTE) (numTE) (numTE)) (list (bool false) (num 2) (num 3)) (ifthenelse (id 'x) (id 'y) (id 'z))) (mtEnv)) (numT))
(test (typecheck (with (list 'x) (list (numTE)) (list (num 2)) (id 'x)) (mtEnv)) (numT))
(test (typecheck (with (list 'dup) (list (arrowTE (list (numTE)) (crossTE (numTE) (numTE)))) (list (fun (list 'n) (list (numTE)) (pair (id 'n) (id 'n)))) (app (id 'dup) (list (throw)))) (mtEnv))   (crossT (numT) (numT)))
(test/exn (typecheck (app (throw) (list (add (bool true) (throw)))) (mtEnv)) "no type")
(test/exn (typecheck (app (throw) (list (ifthenelse (num 1) (num 2) (num 3)))) (mtEnv)) "no type")
(test/exn (typecheck (app (throw) (list (app (bool true) (list (throw))))) (mtEnv)) "no type")

;; Test cases are on noah board
(test (typecheck (eq (throw) (throw)) (mtEnv)) (boolT))

(test/exn (run (app (fun (list 'x 'y) (list (numTE) (numTE)) (add (id 'x) (id 'y))) empty)) "wrong arity")
