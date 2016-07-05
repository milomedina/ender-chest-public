#lang plai

;; Programming Language 2015 Spring Homework 2
;; Sungwon Cho (known as Sam Jo)
;; 20150310T0143

;; Type ANIMAL
;; - octopus:
;;   - legs(integer): number of remaining legs
;;   - space(integer): number of space units needs in case of transport
;; - tiger:
;;   - space(integer): number of space units needs in case of transport
;; - cat:
;;   - lives(integer): number of remaining lives
;;   - space(integer): number of space units needs in case of transport
(define-type ANIMAL
  [octopus (legs integer?)
           (space integer?)]
  [tiger (space integer?)]
  [cat (lives integer?)
       (space integer?)])

(define healthy-octopus (octopus 8 3))
(define sick-octopus (octopus 4 2))
(define normal-tiger (tiger 10))
(define powerful-cat (cat 100 3))
(define normal-cat (cat 9 3))
(define old-cat (cat 1 3))


;; need-space: ANIMAL -> integer
;; constraints: type of first input should be ANIMAL
;; get number of space units needed to transport the given animal
(define (need-space an-animal)
  (type-case ANIMAL an-animal
    [octopus (l s) s]
    [tiger (s) s]
    [cat (l s) s]))

(test (need-space healthy-octopus) 3)
(test (need-space sick-octopus) 2)
(test (need-space normal-tiger) 10)
(test (need-space normal-cat) 3)


;; can-live: ANIMAL -> boolean
;; constraints: type of first input should be ANIMAL
;; return true if and only if given input is cat which lives are greater than or equal to 2
(define (can-live an-animal)
  (and (cat? an-animal) (<= 2 (cat-lives an-animal))))

(test (can-live healthy-octopus) false)
(test (can-live normal-tiger) false)
(test (can-live powerful-cat) true)
(test (can-live old-cat) false)


;; name-toys: list -> list
;; constraints: type of first input should be list of symbols
;; name given list of toys and return them.
;; For 'snowman, 'queen, 'girl, name 'olaf, 'elsa and 'anna respectively.
;; other toys are still remain without any changes.
(define (name-toys toys)
  (cond
    [(empty? toys) empty]
    [(symbol=? (first toys) 'snowman) (cons 'olaf (name-toys (rest toys)))]
    [(symbol=? (first toys) 'queen) (cons 'elsa (name-toys (rest toys)))]
    [(symbol=? (first toys) 'girl) (cons 'anna (name-toys (rest toys)))]
    [else (cons (first toys) (name-toys (rest toys)))]))

(test (name-toys '()) '())
(test (name-toys '(snowman girl abcd robot samjo queen)) '(olaf anna abcd robot samjo elsa))
(test (name-toys '(snowman snowman abcd snowman samjo queen)) '(olaf olaf abcd olaf samjo elsa))


;; give-name: string string list -> list
;; constraints: second input should not be empty symbol. type of third input should be list of symbols
;; name given list of toys and return them.
;; For toys which is old, name new. others are not changed
(define (give-name old new toys)
  (cond
    [(empty? toys) empty]
    [(symbol=? (first toys) old) (cons new (give-name old new (rest toys)))]
    [else (cons (first toys) (give-name old new (rest toys)))]))

(test (give-name 'bear 'pooh '()) '())
(test (give-name 'bear 'pooh '(girl robot bear)) '(girl robot pooh))
(test (give-name 'handsome 'samjo '(girl robot bear handsome snowman handsome)) '(girl robot bear samjo snowman samjo))
