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
(def r-sign r = (head (head r)))
(def s-numer r = (head r)) ; as in "signed numerator"
(def numer r = (tail (head r))) ; raw numerator value without sign
(def denom r = (tail r))

;===================================================

#|
    ~ RAT ZERO ~
    - Structure: {{bool, zero}, nat}
    - Logic: 0 int for numerator is a 0 rat
    - Note: bool true or false, thus -0 == +0
        also, the denominator can be ANY value and it is zero
        - Thus -0/0 == +0/0 == -0/1 == +0/1 == -0/2 == ...
|#
(def r-pos-0 = ((makeR2 posZero) one))

#|
    ~ CHURCH RAT READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: rat => readable(rat)
    - Logic: Outputs r for user 
                If numerator is zero or denominator is one,
                don't show fraction sign, otherwise do
|#
(def r-read r =
   (_let r-s-numer = (s-numer r)
   (_let r-denom = (denom r)
   (_if (isZero r-denom)
    _then "0"
    _else 
    (_if ((_or (isZeroR r)) (isZero (pred r-denom)))
        _then (z-read r-s-numer)
        _else 
            (string-append 
                (z-read r-s-numer)
                "/" 
                (n-read r-denom)))))))

;===================================================

#|
    ~ A FEW RATIONALS ~
    - Logic: As created by makeR2
|#
(def r-neg1-2 = ((makeR2 negOne) two))
(def r-neg1 = ((makeR2 negOne) one))
(def r-neg0-1 = ((makeR2 negZero) one))
(def r-0 = ((makeR2 posZero) one))
(def r-pos1 = ((makeR2 posOne) one))
(def r-pos1-2 = ((makeR2 posOne) two))
(def r-pos1-3 = ((makeR2 posOne) three))
(def r-pos2-1 = ((makeR2 posTwo) one))
(def r-pos2-3 = ((makeR2 posTwo) three))
(def r-neg2-4 = ((makeR2 negTwo) four))
(def r-neg3-3 = ((makeR2 negThree) three))
(def r-pos4-2 = ((makeR2 posFour) two))
(def r-pos8 = ((makeR2 ((multZ posTwo) posFour)) one))

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
    (_if ((eq zero) b)
        _then a
        _else
        (_let r = ((mod a) b)
        (_if ((eq zero) r)
            _then b
            _else ((f b) r)))))

#|
    ~ LEAST COMMON MULTIPLE ~
    - Contract: (nat,nat) => nat
    - Idea: a,b => (a*b)/gcd(a,b)
    - Logic: Get direct multiple a*b, then divide by gcd for lcm
|#
(def _lcm a b = 
    (_let ab = ((mult a) b)
    (_let greatest-common-div = ((euclidean a) b)
    ((div ab) greatest-common-div))))

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
    (((makeR (r-sign r)) (denom r)) (numer r)))

;===================================================

#|
    ~ FRACTION CONVERSION ~
    - Contract: rat => int
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
                (_let new-numer = ((div (numer r)) _gcd)
                (_let new-denom = ((div (denom r)) _gcd)
                (((makeR (r-sign r)) new-numer) new-denom)))
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
                (_let lcd = ((_lcm r1-denom) r2-denom)
                (_let new-r1-s-numer = ((convert-s-numer r1) lcd)
                (_let new-r2-s-numer = ((convert-s-numer r2) lcd)
                (_let new-s-numer = ((addZ new-r1-s-numer) new-r2-s-numer)
                ((makeR2 new-s-numer) lcd))))))))))))

#|
    ~ MULTIPLICATION ~
    - Contract: (rat, rat) => rat
    - Idea: r1,r2 => r1*r2
    - Logic: Multiply signed numerators
        And multiply denominators.
        Then reduce.
|#
(def multR r1 r2 = 
    (reduce 
        (_let new-s-numer = ((multZ (s-numer r1)) (s-numer r2))
        (_let new-denom = ((mult (denom r1)) (denom r2))
        ((makeR2 new-s-numer) new-denom)))))

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
(def divR r1 r2 = 
    ((multR r1) (reciprocal r2)))

; this should work right now when r2 is a whole number
; needs checking for r1 == 1 for early escape
; (def expR r1 r2 = 
;         (_if ((eqR r2) r-0)
;             _then r-1
;             _else 
;                 (_let base = (_if ((gtR r2) r-0)
;                     _then r1
;                     _else (reciprocal r1))
;                 (_let new-s-numer = ((expZ (s-numer base)) (s-numer r2)) 
;                 (_let new-denom = ((expZ (denom base)) (s-numer r2))
;                 ((makeR2 ((expZ new-s-numer) new-denom)))
;                 )))
;         )
;     )


;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: rat => bool
    - Logic: Check if (int part of r is zero)
                true, else false
|#
(def isZeroR r = ((_or (isZeroZ (head r))) (isZero (denom r))))

#|
    ~ EQUALS ~
    - Contract: (rat,rat) => bool
    - Logic: If both zero, equals true,
        else reduce and checks for equality of numerator and denominator
|#
(def eqR r1 r2 = 
    (_if ((_and (isZeroR r1)) (isZeroR r2))
        _then true
        _else
        (_let reduced-r1 = (reduce r1)
        (_let reduced-r2 = (reduce r2)
        (_let r1-s-numer = (s-numer reduced-r1)
        (_let r2-s-numer = (s-numer reduced-r2)
        (_let r1-denom = (denom reduced-r1)
        (_let r2-denom = (denom reduced-r2)
        ((_and 
            ((eqZ r1-s-numer) r2-s-numer)) 
            ((eq r1-denom) r2-denom))))))))))

#|
    ~ GTE ~
    - Contract: (rat,rat) => bool
    - Logic: If both equal, equals true,
        else reduce and convert for common denominators
        and compare signed numerators
|#
(def gteR r1 r2 = 
    (_if ((eqR r1) r2)
        _then true
        _else
        (_let reduced-r1 = (reduce r1)
        (_let reduced-r2 = (reduce r2)
        (_let lcd = ((_lcm (denom reduced-r1)) (denom reduced-r2))
        (_let new-r1-s-numer = ((convert-s-numer reduced-r1) lcd)
        (_let new-r2-s-numer = ((convert-s-numer reduced-r2) lcd)
        ((gteZ new-r1-s-numer) new-r2-s-numer))))))))

#|
    ~ GT ~
    - Contract: (rat,rat) => bool
    - Logic: If both equal, equals false,
        else reduce and convert for common denominators
        and compare signed numerators
|#
(def gtR r1 r2 = 
    (_if ((eqR r1) r2)
        _then false
        _else ((gteR r1) r2)))

#|
    ~ LT ~
    - Contract: (rat,rat) => bool
    - Logic: If not gte, then lt
|#
(def ltR r1 r2 = (_not ((gteR r1) r2)))

#|
    ~ LTE ~
    - Contract: (rat,rat) => bool
    - Logic: If not gt, then lte
|#
(def lteR r1 r2 = (_not ((gtR r1) r2)))

;===================================================

(def floorR r = 
    (_let reduced-r = (reduce r)
    (_let sign-of-r = (r-sign r)
    (_let divided = ((div (numer r)) (denom r))
    (_let new-numer = 
        (_if (sign-of-r)
            _then divided
            _else (succ divided))
    (((makeR sign-of-r) new-numer) one))))))