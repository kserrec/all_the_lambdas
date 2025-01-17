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

    For the rationals, a pair will be used.
    The head will be an integer z and the tail a nat n.

    r = (z, n) = {{sign, nat}, nat}
    
    This let's us leverage integer functions already made.
|#
;===================================================

#|
    ~ MAIN RATIONAL NUMBER HELPERS ~
|#

; Make rational with all 3 parts
; Contract: (bool,nat,nat) => rat
(def makeR sign numer denom = ((pair ((makeZ sign) numer)) denom))

; Make rational with signed numerator (an int) and denominator (nat)
; Contract: (int,nat) => rat
(def makeR2 s-numer denom = ((pair s-numer) denom))

; These are "get" functions
(def s-numer r = (head r))
(def numer r = (tail (head r)))
(def denom r = (tail r))

;===================================================

#|
    ~ EUCLIDEAN ALGORITHM ~
    - Contract: (nat,nat) => nat
    - Idea: Use euclid's algorithm
    - Logic: Since gcd(a,b) = gcd(b,remainder),
        recursively do this until no more remainder,
        then that b is the gcd
|#
(def euclidean a b = 
    (_if ((gte a) b)
        _then (((Y euclid-helper) a) b)
        _else (((Y euclid-helper) b) a)))

(def euclid-helper f a b = 
    (_let r = ((mod a) b)
    (_if ((eq zero) r)
        _then b
        _else ((f b) r))))

#|
    ~ LEAST COMMON MULTIPLE ~
    - Contract: (nat,nat) => nat
    - Idea: a,b => (a*b)/gcd(a,b)
    - Logic: Get direct multiple a*b, then divide by gcd for lcm
|#
(def least-common-mult a b = 
    (_let a*b = ((mult a) b)
    (_let _gcd = ((euclidean a) b)
    ((div a*b) _gcd))))

;===================================================

#|
    ~ CHANGE SIGN ~
    - Contract: rat => rat
    - Idea: 
        +(a/b) => -(b/a)
        -(a/b) => +(b/a)
    - Logic: Numerator and denominator both unchanged, just flip sign
|#
(def invert-sign-R r = ((makeR2 (invertZ (s-numer r))) (denom r)))

#|
    ~ FRACTION RECIPROCAL ~
    - Contract: rat => rat
    - Idea: a/b => b/a
    - Logic: Sign is unchanged, just swap numerator and denominator
|#
(def reciprocal r = 
    (_let r-sign = (head (head r)))
    (((makeR r-sign) (denom r)) (numer r)))

;===================================================

#|
    ~ FRACTION CONVERSION ~
    - Contract: rat => rat
    - Idea: a/b => n where n/m where m is lcd 
    - Logic: Divide lcd by denominator to find value to
        multiply signed numerator by to get new signed numerator
|#
(def convert-s-numer r lcd = 
    (_let multipleZ = ((makeZ true) ((div lcd) (denom r)))
    ((multZ (s-numer r)) multipleZ)))

#|
    ~ REDUCE FRACTION ~
    - Contract: rat => rat
    - Idea: a/b => c/d where a=cx,b=dx and gcd(c,d)=1
    - Logic: If denominator equals one, escape early unchanged
        else find gcd and divide numerator and denominator by it
        when it's greater than one, 
        else they are mutually prime so return unchanged
|#
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

;===================================================

#|
    ~ ADDITION ~
    - Contract: (rat, rat) => rat
    - Idea: r1,r2 => r1+r2
    - Logic: If denominators equal, just add signed numerators
        else convert fractions with lcd and then add.
        Then reduce.
|#
(def addR r1 r2 = 
    (_let new-rational =
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
                ((makeR2 new-s-numer) lcd)))))))))))
    (reduce new-rational))

#|
    ~ MULTIPLICATION ~
    - Contract: (rat, rat) => rat
    - Idea: r1,r2 => r1*r2
    - Logic: Multiply signed numerators
        And multiply denominators.
        Then reduce.
|#
(def multR r1 r2 = 
    (_let new-rational = 
        (_let new-s-numer = ((multZ (s-numer r1)) (s-numer r2))
        (_let new-denom = ((mult (denom r1)) (denom r2))
        ((makeR2 new-s-numer) new-denom)))
    (reduce new-rational)))

#|
    ~ SUBTRACTION ~
    - Contract: (rat, rat) => rat
    - Idea: r1,r2 => r1-r2
    - Logic: Invert sign of second arg and add
|#
(def subR r1 r2 = ((addR r1) (invert-sign-R r2)))

#|
    ~ DIVISION ~
    - Contract: (rat, rat) => rat
    - Idea: r1,r2 => r1/r2
    - Logic: Take reciprocal of second arg and multiply
|#
(def div r1 r2 = 
    (_let reciprocal-r2 = (reciprocal r2)
    ((multR r1) reciprocal-r2)))

