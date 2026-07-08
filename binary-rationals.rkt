#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "lists.rkt"
         "logic.rkt"
         "binary-lists.rkt"
         "int-binary-lists.rkt")

;===================================================
; BINARY RATIONAL NUMBERS - the scalable counterpart to rationals.rkt
;===================================================

#| BINARY RATIONALS (binR)

    This mirrors rationals.rkt exactly, but swaps the Church-numeral numeric
    core for the binary-list one so the numbers scale the same way binary nats
    and binary integers do.

    A binary rational is a pair whose head is a signed binary integer (the
    numerator) and whose tail is a binary natural (the denominator):

        binR = (binZ, binNat) = {{sign, binNat}, binNat}

    Reusing the binary integer functions for the numerator gives the sign
    handling for free, exactly as rationals.rkt leans on the Church integers.
|#

;===================================================

#|
    ~ MAIN BINARY RATIONAL HELPERS ~
|#

; Make a binary rational from sign, numerator (binNat), denominator (binNat)
; Contract: (bool, binNat, binNat) => binR
(def makeR-bin sign numer denom = ((pair ((makeZ-bin sign) numer)) denom))

; Make a binary rational from a signed numerator (binZ) and denominator (binNat)
; Contract: (binZ, binNat) => binR
(def makeR2-bin s-numer denom = ((pair s-numer) denom))

; "get" functions
(def r-sign-bin r = (head (head r)))
(def s-numer-bin r = (head r))       ; the signed numerator (a binZ)
(def numer-bin r = (tail (head r)))  ; the raw numerator magnitude (a binNat)
(def denom-bin r = (tail r))

;===================================================

#|
    ~ IS-ZERO ~
    - Contract: binR => bool
    - Logic: zero when the numerator is zero, or the denominator is zero
        (a zero denominator is treated as a zero value, as in rationals.rkt)
|#
(def isZeroR-bin r =
    ((_or (isZeroZ-bin (s-numer-bin r))) (bin-is-zero (denom-bin r))))

#|
    ~ BINARY RATIONAL READER ~
    - Note: for viewing lambda calculus - not pure LC
    - Contract: binR => readable(binR)
    - Logic: show "0" for a zero value; drop the "/denom" when the denominator
        is one; otherwise render numerator/denominator
|#
(def r-read-bin r =
    (_let r-s-numer = (s-numer-bin r)
    (_let r-denom = (denom-bin r)
    (_if (bin-is-zero r-denom)
        _then "0"
        _else
        (_if ((_or (isZeroR-bin r)) (bin-is-zero (bin-pred r-denom)))
            _then (bin-z-read r-s-numer)
            _else
                (string-append (bin-z-read r-s-numer) "/" (bin-read r-denom)))))))

;===================================================

#|
    ~ A FEW BINARY RATIONALS ~
    - Logic: as created by makeR2-bin
|#
(def binR-0 = ((makeR2-bin bin-posZero) bin-one))
(def binR-pos1 = ((makeR2-bin bin-posOne) bin-one))
(def binR-neg1 = ((makeR2-bin bin-negOne) bin-one))
(def binR-pos1-2 = ((makeR2-bin bin-posOne) bin-two))
(def binR-neg1-2 = ((makeR2-bin bin-negOne) bin-two))
(def binR-pos1-3 = ((makeR2-bin bin-posOne) bin-three))
(def binR-pos2-3 = ((makeR2-bin bin-posTwo) bin-three))
(def binR-pos2-1 = ((makeR2-bin bin-posTwo) bin-one))
(def binR-neg3-4 = ((makeR2-bin bin-negThree) bin-four))
(def binR-pos2-4 = ((makeR2-bin bin-posTwo) bin-four))
(def binR-neg2-4 = ((makeR2-bin bin-negTwo) bin-four))
(def binR-pos4-2 = ((makeR2-bin bin-posFour) bin-two))

;===================================================

#|
    ~ CHANGE SIGN ~
    - Contract: binR => binR
    - Logic: flip the numerator's sign, keep magnitudes
|#
(def invert-sign-R-bin r = ((makeR2-bin (invertZ-bin (s-numer-bin r))) (denom-bin r)))

#|
    ~ RECIPROCAL ~
    - Contract: binR => binR
    - Logic: sign unchanged, swap numerator and denominator
|#
(def reciprocal-bin r =
    (((makeR-bin (r-sign-bin r)) (denom-bin r)) (numer-bin r)))

#|
    ~ CONVERT NUMERATOR TO A COMMON DENOMINATOR ~
    - Contract: (binR, binNat) => binZ
    - Logic: scale the signed numerator by (lcd / denom)
|#
(def convert-s-numer-bin r lcd =
    (_let multipleZ = ((makeZ-bin true) ((bin-div lcd) (denom-bin r)))
    ((multZ-bin (s-numer-bin r)) multipleZ)))

#|
    ~ REDUCE FRACTION ~
    - Contract: binR => binR
    - Logic: if the denominator is one, already lowest terms; otherwise divide
        numerator and denominator by their gcd when it exceeds one
|#
(def reduce-bin r =
    (_if ((bin-eq (denom-bin r)) bin-one)
        _then r
        _else
        (_let _gcd = ((bin-gcd (numer-bin r)) (denom-bin r))
        (_if ((bin-gt _gcd) bin-one)
            _then
                (_let new-numer = ((bin-div (numer-bin r)) _gcd)
                (_let new-denom = ((bin-div (denom-bin r)) _gcd)
                (((makeR-bin (r-sign-bin r)) new-numer) new-denom)))
            _else r))))

;===================================================

; ARITHMETIC

#|
    ~ ADDITION ~
    - Contract: (binR, binR) => binR
    - Logic: if denominators match, add signed numerators; otherwise put both
        over their lcd first. Reduce the result.
|#
(def addR-bin r1 r2 =
    (reduce-bin
        (_let r1-s-numer = (s-numer-bin r1)
        (_let r2-s-numer = (s-numer-bin r2)
        (_let r1-denom = (denom-bin r1)
        (_let r2-denom = (denom-bin r2)
        (_if ((bin-eq r1-denom) r2-denom)
            _then
                (_let new-s-numer = ((addZ-bin r1-s-numer) r2-s-numer)
                ((makeR2-bin new-s-numer) r1-denom))
            _else
                (_let lcd = ((bin-lcm r1-denom) r2-denom)
                (_let new-r1-s-numer = ((convert-s-numer-bin r1) lcd)
                (_let new-r2-s-numer = ((convert-s-numer-bin r2) lcd)
                (_let new-s-numer = ((addZ-bin new-r1-s-numer) new-r2-s-numer)
                ((makeR2-bin new-s-numer) lcd))))))))))))

#|
    ~ MULTIPLICATION ~
    - Contract: (binR, binR) => binR
    - Logic: multiply numerators, multiply denominators, reduce
|#
(def multR-bin r1 r2 =
    (reduce-bin
        (_let new-s-numer = ((multZ-bin (s-numer-bin r1)) (s-numer-bin r2))
        (_let new-denom = ((bin-mult (denom-bin r1)) (denom-bin r2))
        ((makeR2-bin new-s-numer) new-denom)))))

#|
    ~ SUBTRACTION ~
    - Contract: (binR, binR) => binR
    - Logic: invert the sign of the second argument and add
|#
(def subR-bin r1 r2 = ((addR-bin r1) (invert-sign-R-bin r2)))

#|
    ~ DIVISION ~
    - Contract: (binR, binR) => binR
    - Logic: multiply by the reciprocal of the second argument
|#
(def divR-bin r1 r2 = ((multR-bin r1) (reciprocal-bin r2)))

;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ EQUALS ~
    - Contract: (binR, binR) => bool
    - Logic: both zero => equal; otherwise reduce both and compare signed
        numerators and denominators
|#
(def eqR-bin r1 r2 =
    (_if ((_and (isZeroR-bin r1)) (isZeroR-bin r2))
        _then true
        _else
        (_let reduced-r1 = (reduce-bin r1)
        (_let reduced-r2 = (reduce-bin r2)
        (_let r1-s-numer = (s-numer-bin reduced-r1)
        (_let r2-s-numer = (s-numer-bin reduced-r2)
        (_let r1-denom = (denom-bin reduced-r1)
        (_let r2-denom = (denom-bin reduced-r2)
        ((_and ((eqZ-bin r1-s-numer) r2-s-numer)) ((bin-eq r1-denom) r2-denom))))))))))

#|
    ~ GTE ~
    - Contract: (binR, binR) => bool
    - Logic: equal => true; otherwise put both over their lcd and compare the
        signed numerators
|#
(def gteR-bin r1 r2 =
    (_if ((eqR-bin r1) r2)
        _then true
        _else
        (_let reduced-r1 = (reduce-bin r1)
        (_let reduced-r2 = (reduce-bin r2)
        (_let lcd = ((bin-lcm (denom-bin reduced-r1)) (denom-bin reduced-r2))
        (_let new-r1-s-numer = ((convert-s-numer-bin reduced-r1) lcd)
        (_let new-r2-s-numer = ((convert-s-numer-bin reduced-r2) lcd)
        ((gteZ-bin new-r1-s-numer) new-r2-s-numer))))))))

#|
    ~ GT ~
    - Contract: (binR, binR) => bool
    - Logic: equal => false; otherwise gte
|#
(def gtR-bin r1 r2 =
    (_if ((eqR-bin r1) r2)
        _then false
        _else ((gteR-bin r1) r2)))

#|
    ~ LT ~
    - Contract: (binR, binR) => bool
    - Logic: not gte
|#
(def ltR-bin r1 r2 = (_not ((gteR-bin r1) r2)))

#|
    ~ LTE ~
    - Contract: (binR, binR) => bool
    - Logic: not gt
|#
(def lteR-bin r1 r2 = (_not ((gtR-bin r1) r2)))

;===================================================

#|
    ~ FLOOR ~
    - Contract: binR => binR
    - Idea: a/b => greatest whole number n with n <= a/b
    - Logic: divide the magnitudes (binary nat division truncates). For a
        non-negative value that truncation is already the floor. A negative
        value must go one further down, but ONLY when the division left a
        remainder - a negative whole number is already its own floor. (This is
        the exact edge that once made the Church floorR send e.g. -4/2 to -3.)
|#
(def floorR-bin r =
    (_let sign-of-r = (r-sign-bin r)
    (_let divided = ((bin-div (numer-bin r)) (denom-bin r))
    (_let remainder = ((bin-mod (numer-bin r)) (denom-bin r))
    (_let new-numer =
        (_if ((_or sign-of-r) (bin-is-zero remainder))
            _then divided
            _else (bin-succ divided))
    (((makeR-bin sign-of-r) new-numer) bin-one))))))

#|
    ~ EXPONENTIATION ~
    - Contract: (binR, binR) => binR
    - Idea: r1,r2 => r1^floor(r2)
    - Logic: floor the exponent to a whole integer z so the rationals stay
        closed under this operation (a genuine rational power like (1/2)^(1/2)
        is irrational). A zero exponent gives one, with 0^0 = 1 by convention.
        A negative z flips the base to its reciprocal and uses |z|. The base is
        reduced first, so lowest terms in means lowest terms out - no reduce
        afterward. The signed numerator is raised with expZ-bin (which sets the
        sign by parity) and the denominator with the plain nat bin-exp.
    - Note: the zero check must come before floorR-bin, since flooring a
        denominator-zero "zero" would divide by zero.
|#
(def expR-bin r1 r2 =
    (_if (isZeroR-bin r2)
        _then binR-pos1
        _else
        (_let z = (s-numer-bin (floorR-bin r2))
        (_if (isZeroZ-bin z)
            _then binR-pos1
            _else
            (_let base = (reduce-bin (_if (head z)
                            _then r1
                            _else (reciprocal-bin r1)))
            (_let n = (tail z)
            (_let new-s-numer = ((expZ-bin (s-numer-bin base)) ((makeZ-bin true) n))
            (_let new-denom = ((bin-exp (denom-bin base)) n)
            ((makeR2-bin new-s-numer) new-denom)))))))))
