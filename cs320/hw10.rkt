#lang plai-typed

;; Programming Language 2015 Spring Homework 10
;; Sungwon Cho (known as Sam Jo)
;; 20150603T2053

(define-type EXPR
  [num (n : number)]
  [bool (b : boolean)]
  [add (lhs : EXPR) (rhs : EXPR)]
  [sub (lhs : EXPR) (rhs : EXPR)]
  [equ (lhs : EXPR) (rhs : EXPR)]
  [id (name : symbol)]
  [fun (param : symbol) (paramty : TE) (body : EXPR)]
  [app (fun-expr : EXPR) (arg-expr : EXPR)]
  [ifthenelse (test-expr : EXPR) (then-expr : EXPR) (else-expr : EXPR)]
  [rec (name : symbol) (ty : TE) (named-expr : EXPR) (body : EXPR)]
  [with-type (name : symbol)
             (var1-name : symbol) (var1-ty : TE)
             (var2-name : symbol) (var2-ty : TE)
             (body-expr : EXPR)]
  [cases (name : symbol) (dispatch-expr : EXPR)
    (var1-name : symbol) (bind1-name : symbol) (rhs1-expr : EXPR)
    (var2-name : symbol) (bind2-name : symbol) (rhs2-expr : EXPR)]
  [tfun (name : symbol) (expr : EXPR)]
  [tapp (body : EXPR) (type : TE)])

(define-type EXPR-Value
  [numV (n : number)]
  [boolV (b : boolean)]
  [closureV (param : symbol) (body : EXPR) (ds : DefrdSub)]
  [variantV (right? : boolean) (val : EXPR-Value)]
  [constructorV (right? : boolean)])

(define-type DefrdSub
  [mtSub]
  [aSub (name : symbol) (value : EXPR-Value) (rest : DefrdSub)]
  [aRecSub (name : symbol) (value-box : (boxof EXPR-Value)) (ds : DefrdSub)])

(define-type TE
  [numTE]
  [boolTE]
  [arrowTE (param : TE) (result : TE)]
  [polyTE (forall : symbol) (body : TE)]
  [idTE (name : symbol)]
  [tvTE (name : symbol)])

(define-type Type
  [numT]
  [boolT]
  [arrowT (param : Type) (result : Type)]
  [polyT (forall : symbol) (body : Type)]
  [idT (name : symbol)]
  [tvT (name : symbol)])

(define-type TypeEnv
  [mtEnv]
  [aBind (name : symbol) (type : Type) (rest : TypeEnv)]
  [tBind (name : symbol)
         (var1-name : symbol) (var1-type : Type)
         (var2-name : symbol) (var2-type : Type)
         (rest : TypeEnv)]
  [vBind (name : symbol) (rest : TypeEnv)])

;; PRIMITIVE FUNCTION

(define (length l)
  (if (empty? l)
      0
      (+ 1 (length (rest l)))))


;; BASIC HELPER FUNCTION

;; num-op : (number number -> number) EXPR-Value EXPR-Value -> EXPR-Value
(define (num-op op x y)
  (numV (op (numV-n x) (numV-n y))))

;; num+/- : EXPR-Value EXPR-Value -> EXPR-Value
(define (num+ x y) (num-op + x y))
(define (num- x y) (num-op - x y))

;; num= : EXPR-Value EXPR-Value -> EXPR-Value 
(define (num= x y) (boolV (= (numV-n x) (numV-n y))))

;; booltrue? : EXPR-Value -> boolean
(define (booltrue? x) (boolV-b x))

;; lookup : symbol DefrdSub -> TMFAE-Value
;; find given symbol in given DefrdSub
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "free variable")]
    [aSub (sub-name num rest-ds)
          (if (symbol=? sub-name name)
              num
              (lookup name rest-ds))]
    [aRecSub (sub-name val-box rest-ds)
             (if (symbol=? sub-name name)
                 (unbox val-box)
                 (lookup name rest-ds))]))

;; get-type : symbol TypeEnv -> Type
;; find give symbol in given TypeEnv
(define (get-type name-to-find env)
  (type-case TypeEnv env
    [mtEnv () (error 'get-type "free variable, so no type")]
    [aBind (name ty rest)
           (if (symbol=? name-to-find name)
               ty
               (get-type name-to-find rest))]
    [tBind (name var1-name var1-ty var2-name var2-ty rest)
           (get-type name-to-find rest)]
    [vBind (name rest)
           (get-type name-to-find rest)]))

;; get-type-var : symbol TypeEnv -> TypeEnv
(define (get-type-var name-to-find env)
  (type-case TypeEnv env
    [mtEnv () (error 'get-type "free variable, so no type")]
    [aBind (name ty rest)
           (get-type-var name-to-find rest)]
    [tBind (name var1-name var1-ty var2-name var2-ty rest)
           (get-type-var name-to-find rest)]
    [vBind (name rest)
           (if (symbol=? name-to-find name)
               env
               (get-type-var name-to-find rest))]))

;; find-type-id : symbol TypeEnv -> TypeEnv
;; find given type in given TypeEnv
(define (find-type-id name-to-find env)
  (type-case TypeEnv env
    [mtEnv () (error 'find-type-id "free type name, so no type")]
    [aBind (name ty rest)
           (find-type-id name-to-find rest)]
    [tBind (name var1-name var1-ty var2-name var2-ty rest)
           (if (symbol=? name-to-find name)
               env
               (find-type-id name-to-find rest))]
    [vBind (name rest)
           (find-type-id name-to-find rest)]))

;; parse-type : TE -> Type
;; parse given type expression to type
(define (parse-type te)
  (type-case TE te
    [numTE () (numT)]
    [boolTE () (boolT)]
    [arrowTE (p r) (arrowT (parse-type p) (parse-type r))]
    [polyTE (f b) (polyT f (parse-type b))]
    [idTE (n) (idT n)]
    [tvTE (n) (tvT n)]))

;; validtype : TE TypeEnv -> TypeEnv
(define (validtype ty env)
  (type-case Type ty
    [numT () (mtEnv)]
    [boolT () (mtEnv)]
    [arrowT (p r) (begin (validtype p env)
                         (validtype r env))]
    [polyT (f b) (validtype b (vBind f env))]
    [idT (id) (find-type-id id env)]
    [tvT (id) (get-type-var id env)]))

;; type-error : TMFAE string -> void
;; raise typecheck exception with pretty message
(define (type-error TMFAE msg)
  (error 'typecheck (string-append
                     "no type: "
                     (string-append
                      (to-string TMFAE)
                      (string-append " not "
                                     msg)))))

;; is-(type)? : Type -> boolean
;; exactly same as predicate (type)?
(define (is-num? t) (equal? t (numT)))
(define (is-bool? t) (equal? t (boolT)))
(define (is-arrow? t)
  (type-case Type t
    [arrowT (a b) true]
    [else false]))

;; sub-poly-name : Type symbol symbol -> Type
;; used to replace polyT name. change tvT name from old to new
(define (sub-poly-name org-type old-id new-id)
  (type-case Type org-type
    [arrowT (p r) (arrowT (sub-poly-name p old-id new-id) (sub-poly-name r old-id new-id))]
    [polyT (f b)
           (if (symbol=? old-id f)
               org-type
               (polyT f (sub-poly-name b old-id new-id)))]
    [tvT (n)
         (if (symbol=? old-id n) (tvT new-id) org-type)]
    [else org-type]))

;; type-eq : Type Type -> Type
;; raise error if two types are different. otherwise return first type
(define (type-eq a b)
  (type-case Type a
    [numT () (type-case Type b
               [numT () (numT)]
               [else (error 'type-eq "not numT")])]
    [boolT () (type-case Type b
                [boolT () (boolT)]
                [else (error 'type-eq "not boolT")])]
    [arrowT (p1 r1) (type-case Type b
                      [arrowT (p2 r2) (begin (type-eq p1 p2) (type-eq r1 r2) a)]
                      [else (error 'type-eq "not arrowT")])]
    [polyT (f1 b1) (type-case Type b
                     [polyT (f2 b2)
                            (if (symbol=? f1 f2)
                                (polyT f1 (type-eq b1 b2))
                                (polyT f1 (type-eq b1 (sub-poly-name b2 f2 f1))))]
                     [else (error 'type-eq "not polyT")])]
    [idT (n1) (type-case Type b
                [idT (n2) (begin (symbol=? n1 n2) a)]
                [else (error 'type-eq "not idT")])]
    [tvT (n1) (type-case Type b
                [tvT (n2) (begin (symbol=? n1 n2) a)]
                [else (error 'type-eq "not tvT")])]))

;; sub-type : Type symbol Type -> Type
;; replace tvT which have given symbol to actual Type
(define (sub-type org-type tyid rep-type)
  (type-case Type org-type
    [arrowT (p r) (arrowT (sub-type p tyid rep-type) (sub-type r tyid rep-type))]
    [polyT (f b)
           (if (symbol=? tyid f)
               org-type
               (polyT f (sub-type b tyid rep-type)))]
    [tvT (n)
         (if (symbol=? tyid n) rep-type org-type)]
    [else org-type]))

;; get-real-type : Type TypeEnv -> Type
;; remove all tvT and replace using TypeEnv
(define (get-real-type type env)
  (type-case Type type
    [arrowT (p r) (arrowT (get-real-type p env) (get-real-type r env))]
    [polyT (f b) (polyT f (get-real-type b env))]
    [tvT (n) (try (get-type n env) (lambda () type))]
    [else type]))

;; typecheck : EXPR TypeEnv -> Type
;; get type of given EXPR in given type env
(define (typecheck expr env)
  (type-case EXPR expr
    [num (n) (numT)]
    [bool (b) (boolT)]
    [add (l r) (begin (type-eq (typecheck l env) (numT)) (type-eq (typecheck r env) (numT)) (numT))]
    [sub (l r) (begin (type-eq (typecheck l env) (numT)) (type-eq (typecheck r env) (numT)) (numT))]
    [equ (l r) (begin (type-eq (typecheck l env) (numT)) (type-eq (typecheck r env) (numT)) (boolT))]
    [id (name) (get-type name env)]
    [fun (param paramty body)
         (local [(define param-type (parse-type paramty))]
           (begin
             (validtype param-type env)
             (arrowT param-type (typecheck body (aBind param param-type env)))))]
    [app (fun-expr arg-expr)
         (local [(define fun-type (typecheck fun-expr env))
                 (define arg-type (typecheck arg-expr env))]
           (type-case Type fun-type
             [arrowT (param-type result-type)
                     (begin
                       (type-eq param-type arg-type)
                       result-type)]
             [else (type-error fun-expr "function")]))]
    [ifthenelse (test-expr then-expr else-expr)
         (begin
           (type-eq (typecheck test-expr env) (boolT))
           (type-eq (typecheck then-expr env) (typecheck else-expr env)))]
    [rec (name ty named-expr body)
      (local [(define rhs-ty (parse-type ty))
              (define new-env (aBind name rhs-ty env))]
        (begin
          (validtype rhs-ty env)
          (type-eq (typecheck named-expr new-env) rhs-ty)
          (typecheck body new-env)))]
    [with-type (type-name var1-name var1-te var2-name var2-te body-expr)
               (local [(define var1-ty (parse-type var1-te))
                       (define var2-ty (parse-type var2-te))
                       (define new-env (tBind type-name var1-name var1-ty var2-name var2-ty env))]
                 (begin
                   (validtype var1-ty new-env)
                   (validtype var2-ty new-env)
                   (typecheck body-expr (aBind var1-name (arrowT var1-ty (idT type-name))
                                               (aBind var2-name (arrowT var2-ty (idT type-name)) new-env)))))]
    [cases (type-name dispatch-expr var1-name var1-id var1-rhs var2-name var2-id var2-rhs)
      (local [(define bind (find-type-id type-name env))]
        (if (and (equal? var1-name (tBind-var1-name bind))
                 (equal? var2-name (tBind-var2-name bind)))
            (type-case Type (typecheck dispatch-expr env)
              [idT (name)
                   (if (equal? name type-name)
                       (local [(define rhs1-ty (typecheck var1-rhs (aBind var1-id (tBind-var1-type bind) env)))
                               (define rhs2-ty (typecheck var2-rhs (aBind var2-id (tBind-var2-type bind) env)))]
                         (type-eq rhs1-ty rhs2-ty))
                       (type-error dispatch-expr (to-string type-name)))]
              [else (type-error dispatch-expr (to-string type-name))])
            (type-error expr "matching variant names")))]
    [tfun (name expr) (polyT name (typecheck expr (vBind name env)))]
    [tapp (body type)
          (local [(define fun-type (typecheck body env))
                  (define ptype (get-real-type (parse-type type) env))]
            (begin
              (validtype ptype env)
              (type-case Type fun-type
                [polyT (f b) (sub-type b f ptype)]
                [else (type-error body "polyT")])))]))

;; interp : EXPR DefrdSub -> EXPR-Value
;; eval given EXPR with given DefrdSub
(define (interp expr ds)
  (type-case EXPR expr
    [num (n) (numV n)]
    [bool (b) (boolV b)]
    [add (l r) (num+ (interp l ds) (interp r ds))]
    [sub (l r) (num- (interp l ds) (interp r ds))]
    [equ (l r) (num= (interp l ds) (interp r ds))]
    [id (name) (lookup name ds)]
    [fun (param paramty body) (closureV param body ds)]
    [app (fun-expr arg-expr)
         (local [(define fun-val (interp fun-expr ds))
                 (define arg-val (interp arg-expr ds))]
           (type-case EXPR-Value fun-val
             [closureV (param body ds) (interp body (aSub param arg-val ds))]
             [constructorV (right?) (variantV right? arg-val)]
             [else (error 'interp "not function")]))]
    [ifthenelse (test-expr then-expr else-expr)
         (if (booltrue? (interp test-expr ds))
             (interp then-expr ds)
             (interp else-expr ds))]
    [rec (name ty named-expr body)
      (local [(define value-holder (box (numV 42)))
              (define new-ds (aRecSub name value-holder ds))]
        (begin
          (set-box! value-holder (interp named-expr new-ds))
          (interp body new-ds)))]
    [with-type (type-name var1-name var1-te var2-name var2-te body-expr)
               (interp body-expr
                       (aSub var1-name (constructorV false)
                             (aSub var2-name (constructorV true)
                                   ds)))]
    [cases (ty dispatch-expr var1-name bind1-name rhs1-expr var2-name bind2-name rhs2-expr)
      (type-case EXPR-Value (interp dispatch-expr ds)
        [variantV (right? val)
                  (if (not right?)
                      (interp rhs1-expr (aSub bind1-name val ds))
                      (interp rhs2-expr (aSub bind2-name val ds)))]
        [else (error 'interp "not a variant result")])]
    [tfun (name expr) (interp expr ds)]
    [tapp (body type) (interp body ds)]))


(test (typecheck (tfun 'alpha (num 3)) (mtEnv)) (polyT 'alpha (numT)))
(test (typecheck (tfun 'alpha (tfun 'beta (num 3))) (mtEnv)) (polyT 'alpha (polyT 'beta (numT))))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (typecheck (tapp (id 'f) (numTE)) (aBind 'f (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))) (mtEnv))) (arrowT (numT) (numT)))
(test (typecheck (tfun 'alpha (tfun 'beta (fun 'x (polyTE 'alpha (polyTE 'beta (tvTE 'alpha))) (id 'x)))) (mtEnv)) (polyT 'alpha (polyT 'beta (arrowT (polyT 'alpha (polyT 'beta (tvT 'alpha))) (polyT 'alpha (polyT 'beta (tvT 'alpha)))))))
(test (typecheck (tapp (tfun 'alpha (tfun 'beta (fun 'x (polyTE 'alpha (polyTE 'beta (tvTE 'alpha))) (id 'x)))) (numTE)) (mtEnv)) (polyT 'beta (arrowT (polyT 'alpha (polyT 'beta (tvT 'alpha))) (polyT 'alpha (polyT 'beta (tvT 'alpha))))))
(test (typecheck (fun 'x (polyTE 'alpha (tvTE 'alpha)) (id 'x)) (mtEnv)) (arrowT (polyT 'alpha (tvT 'alpha)) (polyT 'alpha (tvT 'alpha))))
(test/exn (typecheck (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'beta))) (id 'x)) (mtEnv)) "free")
(test/exn (typecheck (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (mtEnv)) "free")
(test/exn (typecheck (tapp (id 'f) (numTE)) (aBind 'f (arrowT (numT) (numT)) (mtEnv))) "no")
(test/exn (typecheck (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (mtEnv)) "free")
(test/exn (typecheck (tapp (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (numTE)) (mtEnv)) "free")
(test/exn (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (tfun 'beta (fun 'y (tvTE 'beta) (add (id 'x) (id 'y)))))) (mtEnv)) "no")
(test/exn (typecheck (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (mtEnv)) "free")
(test (interp (app (app (tapp (tfun 'alpha (fun 'f (tvTE 'alpha) (id 'f))) (arrowTE (numTE) (numTE))) (fun 'x (numTE) (id 'x))) (num 10)) (mtSub)) (numV 10))
(test (interp (tapp (tfun 'alpha (fun 'f (tvTE 'alpha) (id 'f))) (arrowTE (numTE) (numTE))) (mtSub)) (closureV 'f (id 'f) (mtSub)))
(test (interp (tapp (tapp (tfun 'alpha (tfun 'beta (num 3))) (numTE)) (numTE)) (mtSub)) (numV 3))
(test (interp (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (mtSub)) (closureV 'x (id 'x) (mtSub)))
(test (interp (tfun 'alpha (fun 'x (tvTE 'beta) (id 'x))) (mtSub)) (closureV 'x (id 'x) (mtSub)))
(test (interp (id 'x) (aSub 'x (numV 10) (mtSub))) (numV 10))
(test (interp (app (fun 'x (numTE) (app (fun 'f (arrowTE (numTE) (numTE)) (add (app (id 'f) (num 1)) (app (fun 'x (numTE) (app (id 'f) (num 2))) (num 3)))) (fun 'y (numTE) (add (id 'x) (id 'y))))) (num 0)) (mtSub)) (numV 3))
(test (typecheck (tfun 'alpha (num 3)) (mtEnv)) (polyT 'alpha (numT)))
(test (typecheck (tfun 'alpha (tfun 'beta (num 3))) (mtEnv)) (polyT 'alpha (polyT 'beta (numT))))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (typecheck (tapp (id 'f) (numTE)) (aBind 'f (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))) (mtEnv))) (arrowT (numT) (numT)))
(test (typecheck (tapp (id 'f) (numTE)) (aBind 'f (polyT 'alpha (polyT 'alpha (tvT 'alpha))) (mtEnv))) (polyT 'alpha (tvT 'alpha))) 
(test (interp (tapp (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (numTE)) (mtSub)) (closureV 'x (id 'x) (mtSub)))     
(test (typecheck (tapp (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (polyTE 'beta (arrowTE (tvTE 'beta) (tvTE 'beta)))) (mtEnv)) (arrowT (polyT 'beta (arrowT (tvT 'beta) (tvT 'beta))) (polyT 'beta (arrowT (tvT 'beta) (tvT 'beta)))))
(test (typecheck (tfun 'alpha (tfun 'beta (num 3))) (mtEnv)) (polyT 'alpha (polyT 'beta (numT))))
(test (interp (tfun 'alpha (tfun 'beta (num 3))) (mtSub)) (numV 3))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (interp (app (app (tapp (tfun 'alpha (fun 'f (tvTE 'alpha) (id 'f))) (arrowTE (numTE) (numTE))) (fun 'x (numTE) (id 'x))) (num 10)) (mtSub)) (numV 10))
(test (interp (tapp (tfun 'alpha (fun 'f (tvTE 'alpha) (id 'f))) (arrowTE (numTE) (numTE))) (mtSub)) (closureV 'f (id 'f) (mtSub)))
(test (interp (tapp (tapp (tfun 'alpha (tfun 'beta (num 3))) (numTE)) (numTE)) (mtSub)) (numV 3))
(test (typecheck (tapp (tfun 'alpha (num 3)) (tvTE 'beta)) (aBind 'beta (numT) (mtEnv))) (numT))
(test (interp (tapp (tfun 'alpha (fun 'f (tvTE 'alpha) (id 'f))) (arrowTE (numTE) (numTE))) (mtSub)) (closureV 'f (id 'f) (mtSub)))
(test (typecheck (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (id 'x))))  (mtEnv)) (polyT 'alpha (polyT 'beta (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (typecheck (ifthenelse (bool true) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (tfun 'beta (fun 'y (tvTE 'beta) (id 'y)))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (typecheck (ifthenelse (bool true) (tfun 'beta (fun 'y (tvTE 'beta) (id 'y))) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x)))) (mtEnv)) (polyT 'beta (arrowT (tvT 'beta) (tvT 'beta))))
(test (typecheck (ifthenelse (bool true) (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (id 'x)))) (tfun 'beta (tfun 'gamma (fun 'x (tvTE 'beta) (id 'x))))) (mtEnv)) (polyT 'alpha (polyT 'beta (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (tfun 'beta (fun 'y (tvTE 'alpha) (ifthenelse (bool true) (id 'x) (id 'y)))))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (polyT 'beta (arrowT (tvT 'alpha) (tvT 'alpha))))))
(test (interp (app (tapp (ifthenelse (bool true) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (tfun 'beta (fun 'x (tvTE 'beta) (id 'x)))) (numTE)) (num 30)) (mtSub)) (numV 30)) 
(test (interp (app (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (app (tapp (id 'x) (numTE)) (num 10))) (tfun 'beta (fun 'y (tvTE 'beta) (id 'y)))) (mtSub)) (numV 10))
(test (typecheck (tfun 'alpha (fun 'alpha (arrowTE (numTE) (numTE)) (fun 'x (tvTE 'alpha) (id 'x)))) (mtEnv)) (polyT 'alpha (arrowT (arrowT (numT) (numT)) (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (typecheck (fun 'alpha (arrowTE (numTE) (numTE)) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x)))) (mtEnv)) (arrowT (arrowT (numT) (numT)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (interp (tapp (tfun 'alpha (fun 'x (tvTE 'alpha) (num 5))) (numTE)) (mtSub)) (closureV 'x (num 5) (mtSub)))
(test (interp (tapp (tfun 'alpha (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (id 'x))) (numTE)) (mtSub)) (closureV 'x (id 'x) (mtSub)))
(test (typecheck (tapp (tfun 'alpha (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (id 'x))) (numTE)) (mtEnv)) (arrowT (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (typecheck (tapp (tfun 'alpha (fun 'x (tvTE 'alpha) (num 5))) (numTE)) (mtEnv)) (arrowT (numT) (numT)))
(test (interp (app (app (tapp (tapp (tfun 'alpha (tfun 'beta (fun 'x (arrowTE (tvTE 'alpha) (tvTE 'beta)) (id 'x)))) (numTE)) (numTE)) (fun 'x (numTE) (add (num 5) (id 'x)))) (num 3)) (mtSub)) (numV 8))
(test (interp (app (app (tapp (tapp (tfun 'alpha (tfun 'alpha (fun 'x (arrowTE (tvTE 'alpha) (tvTE 'alpha)) (id 'x)))) (numTE)) (numTE)) (fun 'x (numTE) (add (num 5) (id 'x)))) (num 3)) (mtSub)) (numV 8))
(test (typecheck (ifthenelse (bool false) (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (fun 'y (tvTE 'beta) (id 'y))))) (tfun 'beta (tfun 'alpha (fun 'x (tvTE 'beta) (fun 'y (tvTE 'alpha) (id 'y)))))) (mtEnv)) (polyT 'alpha (polyT 'beta (arrowT (tvT 'alpha) (arrowT (tvT 'beta) (tvT 'beta))))))
(test (typecheck (tapp (tfun 'alpha (fun 'alpha (tvTE 'alpha) (app (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (app (tapp (id 'x) (numTE)) (num 10))) (tfun 'beta (fun 'beta (tvTE 'beta) (id 'beta)))))) (arrowTE (numTE) (numTE))) (mtEnv)) (arrowT (arrowT (numT) (numT)) (numT)))
(test (typecheck (tapp (tfun 'alpha (fun 'alpha (tvTE 'alpha) (app (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (app (tapp (id 'x) (numTE)) (num 10))) (tfun 'beta (fun 'beta (tvTE 'beta) (id 'beta)))))) (numTE)) (mtEnv)) (arrowT (numT) (numT)))
(test (typecheck (tapp (tfun 'alpha (fun 'alpha (tvTE 'alpha) (app (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (app (tapp (id 'x) (numTE)) (num 10))) (tfun 'alpha (fun 'alpha (tvTE 'alpha) (id 'alpha)))))) (numTE)) (mtEnv)) (arrowT (numT) (numT)))
(test (typecheck (tfun 'alpha (num 3)) (mtEnv)) (polyT 'alpha (numT)))
(test (typecheck (tfun 'alpha (tfun 'beta (num 3))) (mtEnv)) (polyT 'alpha (polyT 'beta (numT))))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (typecheck (tapp (id 'f) (numTE)) (aBind 'f (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))) (mtEnv))) (arrowT (numT) (numT)))
(test (typecheck (ifthenelse (bool true) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x))) (tfun 'beta (fun 'y (tvTE 'beta) (id 'y)))) (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (tvT 'alpha))))
(test (typecheck (ifthenelse (bool true) (tfun 'beta (fun 'y (tvTE 'beta) (id 'y))) (tfun 'alpha (fun 'x (tvTE 'alpha) (id 'x)))) (mtEnv)) (polyT 'beta (arrowT (tvT 'beta) (tvT 'beta))))
(test (typecheck (ifthenelse (bool true) (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (id 'x)))) (tfun 'beta (tfun 'gamma (fun 'x (tvTE 'beta) (id 'x))))) (mtEnv)) (polyT 'alpha (polyT 'beta (arrowT (tvT 'alpha) (tvT 'alpha)))))
(test (interp (tapp (tapp (tfun 'alpha (tfun 'beta (num 3))) (numTE)) (numTE)) (mtSub)) (numV 3))
(test (typecheck (tfun 'alpha (fun 'x (tvTE 'alpha) (tfun 'beta (fun 'y (tvTE 'alpha) (ifthenelse (bool true) (id 'x) (id 'y))))))  (mtEnv)) (polyT 'alpha (arrowT (tvT 'alpha) (polyT 'beta (arrowT (tvT 'alpha) (tvT 'alpha))))))
(test (typecheck (app (fun 'x (polyTE 'alpha (arrowTE (tvTE 'alpha) (tvTE 'alpha))) (num 42)) (id 'f)) (aBind 'f (polyT 'beta (arrowT (tvT 'beta) (tvT 'beta))) (mtEnv))) (numT))
(test (typecheck (fun 'x (polyTE 'alpha (tvTE 'alpha)) (id 'x)) (mtEnv)) (arrowT (polyT 'alpha (tvT 'alpha)) (polyT 'alpha (tvT 'alpha))))
(test (typecheck (tapp (tfun 'alpha (tfun 'beta (fun 'x (polyTE 'alpha (polyTE 'beta (tvTE 'alpha))) (id 'x)))) (numTE)) (mtEnv)) (polyT 'beta (arrowT (polyT 'alpha (polyT 'beta (tvT 'alpha))) (polyT 'alpha (polyT 'beta (tvT 'alpha))))))
(test (typecheck (app (tapp (tapp (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (id 'x)))) (numTE)) (numTE)) (num 10)) (mtEnv)) (numT))
(test (interp (app (tapp (tapp (tfun 'alpha (tfun 'beta (fun 'x (tvTE 'alpha) (id 'x)))) (numTE)) (numTE)) (num 10)) (mtSub)) (numV 10))

(test (typecheck (rec 'fib (arrowTE (numTE) (numTE)) (fun 'n (numTE) (ifthenelse (equ (id 'n) (num 0)) (num 1) (ifthenelse (equ (id 'n) (num 1)) (num 1) (add (app (id 'fib) (sub (id 'n) (num 1))) (app (id 'fib) (sub (id 'n) (num 2))))))) (app (id 'fib) (num 4))) (mtEnv)) (numT))
(test (interp (rec 'fib (arrowTE (numTE) (numTE)) (fun 'n (numTE) (ifthenelse (equ (id 'n) (num 0)) (num 1) (ifthenelse (equ (id 'n) (num 1)) (num 1) (add (app (id 'fib) (sub (id 'n) (num 1))) (app (id 'fib) (sub (id 'n) (num 2))))))) (app (id 'fib) (num 4))) (mtSub)) (numV 5))
(test (typecheck (with-type 'fruit 'apple (numTE) 'banana (boolTE) (cases 'fruit (app (id 'apple) (num 5)) 'apple 'x (id 'x) 'banana 'x (num 0))) (mtEnv)) (numT))
(test (interp (with-type 'fruit 'apple (numTE) 'banana (boolTE) (cases 'fruit (app (id 'apple) (num 5)) 'apple 'x (id 'x) 'banana 'x (num 0))) (mtSub)) (numV 5))
(test (typecheck (with-type 'fruit 'apple (numTE) 'banana (arrowTE (numTE) (numTE)) (app (id 'apple) (num 10))) (mtEnv)) (idT 'fruit))
(test (interp (with-type 'fruit 'apple (numTE) 'banana (arrowTE (numTE) (numTE)) (app (id 'apple) (num 10))) (mtSub)) (variantV false (numV 10))) 
