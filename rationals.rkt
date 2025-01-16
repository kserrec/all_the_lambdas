#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "division.rkt"
         "lists.rkt"
         "logic.rkt")

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


; (def gcd-func r1 r2 = )