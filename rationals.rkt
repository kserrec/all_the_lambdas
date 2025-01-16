#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "division.rkt"
         "lists.rkt"
         "logic.rkt"
         "recursion.rkt")

;===================================================
; RATIONAL NUMBEERS
;===================================================

#| RATIONALS (r)

    For the rationals, a triple of this format is used: rat = (r-sign, num, den)
    
    The lambdas are structured like this:
        -3: {false, three}
        -2: {false, two}
        -1: {false, one}
        -0/+0: {true, zero} and/or {false, zero}
        +1: {true, one}
        +2: {true, two}
        +3: {true, three}

    Completely broken down representation of -2: \f.f(\x.\y.y)(\f.\x.f(fx))


|#
;===================================================

; working with triples

(def triple a b c f = (((f a) b) c))

(def r-sign-helper a b c = a)
(def r-sign f = (f r-sign-helper))

(def numer-helper a b c = b)
(def numer f = (f numer-helper))

(def denom-helper a b c = c)
(def denom f = (f denom-helper))

;===================================================


(def makeR r-sign numer denom = (((triple r-sign) numer) denom))


(def euclidean a b = 
    (_if ((gte a) b)
        _then (((Y euclidean-helper) a) b)
        _else (((Y euclidean-helper) b) a)))

(def euclidean-helper f a b = 
    (_let r = ((mod a) b)
    (_if ((eq zero) r)
        _then b
        _else ((f b) r))))


(def least-common-mult a b = 
    (_let a*b = ((mult a) b)
    (_let _gcd = ((euclidean a) b)
    ((div a*b) _gcd))))


; (def addR r1 r2 = 
;     (_let r1-sign = (r-sign r1)
;     (_let r2-sign = (r-sign r2)
;     (_let r1-numer = (numer r1)
;     (_let r2-numer = (numer r2)
;     (_let r1-denom = (denom r1)
;     (_let r2-denom = (denom r2)
;     (_let lcd = ((least-common-mult r1-denom) r2-denom)
;     (_if ((_and r1-sign) r2-sign) ; if both positive
;         _then ()
;         _else ()

;     ))))))))
; )