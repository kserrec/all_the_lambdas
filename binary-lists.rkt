#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "lists.rkt"
         "logic.rkt"
         "church.rkt"
         "recursion.rkt")

;===================================================
; BINARY LISTS - a new numerical encoding
;===================================================

#|
    MOTIVATION: Using Church Numerals defined in Racket has serious limits.
    Representing numbers beyond the tens of millions is not possible on my machine with this encoding.
    The goal here is to support greater values, hopefully far greater, by encoding numbers as lists of binary digits.

    NATURAL NUMBERS as BINARY DIGIT LISTS

    These will be lists like this [1] and [1,1,0]

        0: [0]
        1: [1]
        2: [1,0]
        3: [1,1]
        4: [1,0,0]
        5: [1,0,1]

|#
;===================================================

#|
    ~ FIRST FEW NUMBERS ~
|#
(def bin-zero = (_cons zero))
(def bin-one = (_cons one))
(def bin-two = (_cons one zero))
(def bin-three = (_cons one one))
(def bin-four = (_cons one zero zero))
(def bin-five = (_cons one zero one))

;===================================================

#|
    ~ BINARY LIST READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: b-dig => readable(b-dig)
    - Logic: Outputs n for user 
|#
(define (church-to-nat n)
  ((n (lambda (x) (+ x 1))) 0))

(define (bin-read bin-list)
  (let loop ([lst bin-list]
             [len-remaining (church-to-nat (len bin-list))]
             [total 0])
    (if (zero? len-remaining)
        total
        (loop (tail lst)
              (sub1 len-remaining)
              (if (equal? (head lst) one)
                  (+ total (expt 2 (sub1 len-remaining)))
                  total)))))

; (displayln (bin-read bin-zero))
; (displayln (bin-read bin-one))
; (displayln (bin-read bin-two))
; (displayln (bin-read bin-three))
; (displayln (bin-read bin-four))
; (displayln (bin-read bin-five))

(def bin-one-billion =
  (_cons one one one zero one one one zero 
         zero one one zero one zero one one 
         zero zero one zero one zero zero zero 
         zero zero zero zero zero zero)
)

(def bin-one-trillion = 
    (_cons one one one zero one zero zero zero one one zero one zero one zero zero one zero one zero zero one zero one zero zero zero one zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quadrillion = 
    (_cons one one one zero zero zero one one zero one zero one one one one one one zero one zero one zero zero one zero zero one one zero zero zero one one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quintillion = 
    (_cons one one zero one one one one zero zero zero zero zero one zero one one zero one one zero one zero one one zero zero one one one zero one zero zero one one one zero one one zero zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-sextillion = 
    (_cons one one zero one one zero zero zero one one zero one zero one one one zero zero one zero zero one one zero one zero one one zero one one one zero zero zero one zero one one one zero one one one one zero one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(displayln "binary digit list - one billion:")
(displayln (bin-read bin-one-billion))

(displayln "binary digit list - one trillion:")
(displayln (bin-read bin-one-trillion))

(displayln "binary digit list - one quadrillion:")
(displayln (bin-read bin-one-quadrillion))

(displayln "binary digit list - one quintillion:")
(displayln (bin-read bin-one-quintillion))

(displayln "binary digit list - one sextillion:")
(displayln (bin-read bin-one-sextillion))




;===================================================

#|
    ~ ADD ~
    - Contract: (b-dig,b-dig) => b-dig
    - Idea: m,n => m+n
|#




