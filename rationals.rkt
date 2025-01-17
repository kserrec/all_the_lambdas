#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "division.rkt"
         "integers.rkt"
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


;===================================================


(def makeR sign numer denom = ((pair ((makeZ sign) numer)) denom))

(def makeR2 s-numer denom = ((pair s-numer) denom))

(def s-numer r = (head r))

(def numer r = (tail (head r)))

(def denom r = (tail r))



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


(def convert-s-numer r lcd = 
    (_let multipleZ = ((makeZ true) ((div lcd) (denom r)))
    ((multZ (s-numer r)) multipleZ)))

(def reduce r = 
    (_if ((eq one) (denom r))
        _then r
        _else 
        (_let _gcd = ((euclidean (numer r)) (denom r))
        (_if ((gt _gcd) one)
            _then 
                (_let r-sign = (head (head r))
                (_let new-numer = ((div (numer r)) _gcd)
                (_let new-denom = ((div (denom r)) _gcd)
                (((makeR r-sign) new-numer) new-denom))))
            _else r))))


(def addR r1 r2 = 
    (reduce 
    (_let r1-s-numer = (s-numer r1)
    (_let r2-s-numer = (s-numer r2)
    (_let r1-denom = (denom r1)
    (_let r2-denom = (denom r2)
    (_if ((eq r1-denom) r2-denom)
        _then 
            (_let new-s-numer = ((addZ r1-s-numer) r2-s-numer)
            ((makeR2 new-s-numer) r1-denom))
        _else 
            (_let lcd = ((least-common-mult r1-denom) r2-denom)
            (_let new-r1-s-numer = ((convert-s-numer r1) lcd)
            (_let new-r2-s-numer = ((convert-s-numer r2) lcd)
            (_let new-s-numer = ((addZ new-r1-s-numer) new-r2-s-numer)
            ((makeR2 new-s-numer) lcd))))))))))))

(def invert-sign-R r = ((makeR2 (invertZ (s-numer r))) (denom r)))

(def subR r1 r2 = ((addR r1) (invert-sign-R r2)))

(def invertR r = 
    (_let r-sign = (head (head r)))
    (_let new-numer = (denom r)
    (_let new-denom = (numer r)
    (((makeR r-sign) new-numer) new-denom))))

(def multR r1 r2 = 
    (reduce 
    (_let r1-s-numer = (s-numer r1)
    (_let r2-s-numer = (s-numer r2)
    (_let r1-denom = (denom r1)
    (_let r2-denom = (denom r2)
    (_let new-s-numer = ((multZ r1-s-numer) r2-s-numer)
    (_let new-denom = ((mult r1-denom) r2-denom)
    ((makeR2 new-s-numer) new-denom)))))))))

(def div r1 r2 = 
    (_let inverted-r2 = (invertR r2)
    ((multR r1) inverted-r2)))

    