#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "binary-lists.rkt"
         "church.rkt"
         "core.rkt"
         "lists.rkt"
         "logic.rkt"
         "recursion.rkt")

;===================================================
; INTEGER BINARY-LISTS - signed binary numbers
;===================================================

#| INTEGERS (z-bin)

    This approach to integers borrows as much as possible from integers.rkt.
    The main difference is that the natural-number part is represented as a
    binary digit list instead of a Church numeral, so these integers scale
    the same way binary-list naturals do.

    An integer is a pair {sign, bin-nat} where the sign is a bool
    (true = positive) and the magnitude is a binary digit list.

|#
;===================================================

#|
    ~ MAKE INT ~
    - Structure: (bool,bin) => {bool,bin}
    - Logic: just a pair function
|#
(def makeZ-bin sign bin = ((pair sign) bin))

#|
    ~ INT ZERO ~
    - Structure: {bool, bin-zero}
    - Note: sign can be true or false, thus -0 == +0
|#
(def bin-posZero = ((makeZ-bin true) bin-zero))

#|
    ~ INT SUCCESSOR ~
    - Contract: int => int
    - Idea: z => z+1
    - Logic: If z == 0 or z is positive
                then make output positive and use regular succ
                else make output negative and use regular pred
|#
(def succZ-bin bin-z =
    ; let vars
    (_let zSign = (head bin-z)
    (_let zVal = (tail bin-z)
    ; core logic
    ((((_or (bin-is-zero zVal)) zSign)
        ((makeZ-bin true) (bin-succ zVal)))
        ((makeZ-bin false) (bin-pred zVal))))))

#|
    ~ BINARY INT READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: int => readable(int)
    - Logic: Outputs z for user
                If z is positive or zero
                    then uses regular bin-read
                    else appends minus sign
|#
(def bin-z-read bin-z =
    ; let vars
    (_let zSign = (head bin-z)
    (_let zVal = (tail bin-z)
    ; core logic
    ((((_or zSign) (bin-is-zero zVal))
        (bin-read zVal))
        (string-append "-" (bin-read zVal))))))

;===================================================

#|
    ~ NEGATIVE FIVE TO POSITIVE FIVE INTEGERS ~
    - Logic: As created by makeZ-bin
|#

(def bin-negFive = ((makeZ-bin false) bin-five))
(def bin-negFour = ((makeZ-bin false) bin-four))
(def bin-negThree = ((makeZ-bin false) bin-three))
(def bin-negTwo = ((makeZ-bin false) bin-two))
(def bin-negOne = ((makeZ-bin false) bin-one))
(def bin-negZero = ((makeZ-bin false) bin-zero))
(def bin-posOne = ((makeZ-bin true) bin-one))
(def bin-posTwo = ((makeZ-bin true) bin-two))
(def bin-posThree = ((makeZ-bin true) bin-three))
(def bin-posFour = ((makeZ-bin true) bin-four))
(def bin-posFive = ((makeZ-bin true) bin-five))

;===================================================

; ARITHMETIC

#|
    ~ ADDITION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1+z2
    - Logic: If both same sign
                then make result their sign and use regular add
                else take the sign of the larger magnitude
                    and use regular sub, larger magnitude first
|#
(def addZ-bin bin-z1 bin-z2 =
    ; let vars
    (_let z1Sign = (head bin-z1)
    (_let z1Val = (tail bin-z1)
    (_let z2Sign = (head bin-z2)
    (_let z2Val = (tail bin-z2)
    ; core logic
    (_if (_not ((xor z1Sign) z2Sign))
    ; if both same sign
        _then ((makeZ-bin z1Sign) ((bin-add z1Val) z2Val))
        ; then make result their sign and use regular addition
        _else (_if ((bin-gt z1Val) z2Val)
        ; else if different signs and |z1| > |z2|
                _then ((makeZ-bin z1Sign) ((bin-sub z1Val) z2Val))
                ; then take sign of larger and do regular diff
                _else ((makeZ-bin z2Sign) ((bin-sub z2Val) z1Val)))))))))
                ; else take sign of larger and do reverse diff


#|
    ~ INVERT SIGN ~
    - Contract: int => int
    - Idea: z => -z
    - Logic: flip the sign, keep the magnitude
|#
(def invertZ-bin bin-z =
    (_let zSign = (head bin-z)
    (_let zVal = (tail bin-z)
    ((makeZ-bin (_not zSign)) zVal))))

#|
    ~ SUBTRACTION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1-z2
    - Logic: Use addZ-bin by reframing z1-z2 as z1+(-z2)
|#
(def subZ-bin z1 z2 = ((addZ-bin z1) (invertZ-bin z2)))

#|
    ~ PREDECESSOR ~
    - Contract: int => int
    - Idea: z1 => z1-1
    - Logic: Use subZ-bin (really, this is unnecessary since subtraction is more general)
|#
(def predZ-bin z-bin = ((subZ-bin z-bin) bin-posOne))

#|
    ~ MULTIPLICATION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1*z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign
                and do regular multiplication for number
|#
(def multZ-bin z1-bin z2-bin =
    ; let vars
    (_let z1Sign = (head z1-bin)
    (_let z1Val = (tail z1-bin)
    (_let z2Sign = (head z2-bin)
    (_let z2Val = (tail z2-bin)
    ; core logic
    ((makeZ-bin
        (_not ((xor z1Sign) z2Sign))) ; sign
        ((bin-mult z1Val) z2Val)))))))    ; val

#|
    ~ DIVISION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1/z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign
                and do regular division for number
    - Note: quotient truncates toward zero (e.g. -3/2 => -1), since the
            magnitude is divided as a natural number
|#
(def divZ-bin z1-bin z2-bin =
    ; let vars
    (_let z1Sign = (head z1-bin)
    (_let z1Val = (tail z1-bin)
    (_let z2Sign = (head z2-bin)
    (_let z2Val = (tail z2-bin)
    ; core logic
    ((makeZ-bin
        (_not ((xor z1Sign) z2Sign))) ; sign
        ((bin-div z1Val) z2Val)))))))     ; val

#|
    ~ EXPONENTIATION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1^z2
    - Logic: Do regular exponent except when z2 < 0, then result is 0
                (negative powers leave the integers; zero is the convention here)
             If z1 is negative, the result's sign follows the parity of the
                exponent: even power => positive, odd power => negative
|#
(def expZ-bin z1-bin z2-bin =
    ; let vars
    (_let z1Sign = (head z1-bin)
    (_let z1Val = (tail z1-bin)
    (_let z2Sign = (head z2-bin)
    (_let z2Val = (tail z2-bin)
    ; core logic
    (_if (_not z2Sign)
    ; if raised to negative power
        _then bin-posZero
        ; then default to zero
        _else (_if z1Sign
        ; else if z1 positive
                _then ((makeZ-bin true) ((bin-exp z1Val) z2Val))
                ; then make positive and do regular exponent
                _else ((makeZ-bin (bin-is-even z2Val)) ((bin-exp z1Val) z2Val)))))))))
                ; else flip sign based on even or odd power

;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: int => bool
    - Logic: Check if the magnitude part of z is zero (sign is ignored, -0 == +0)
|#
(def isZeroZ-bin z-bin = (bin-is-zero (tail z-bin)))

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 >= z2)
                then => true
                else => false
    - Logic: IF (both positive)
                then (n1 >= n2)
                else IF (both negative)
                    then (n1 <= n2)
                    else (z1 positive OR both are zero)
|#
(def gteZ-bin z1-bin z2-bin =
    ; let vars
    (_let z1Sign = (head z1-bin)
    (_let z1Val = (tail z1-bin)
    (_let z2Sign = (head z2-bin)
    (_let z2Val = (tail z2-bin)
    ; core logic
    (_if ((_and z1Sign) z2Sign)
        _then ((bin-gte z1Val) z2Val)
        _else (_if ((_and (_not z1Sign)) (_not z2Sign))
                _then ((bin-lte z1Val) z2Val)
                _else ((_or z1Sign) ((_and (isZeroZ-bin z1-bin)) (isZeroZ-bin z2-bin))))))))))

#|
    ~ LESS THAN OR EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 <= z2)
                then => true
                else => false
    - Logic: IF (z1 AND z2 positive)
                then (n1 <= n2)
                else IF (z1 AND z2 negative)
                    then (n1 >= n2)
                    else (z2 positive OR both z1 AND z2 equal zero)
|#
(def lteZ-bin z1-bin z2-bin =
    ; let vars
    (_let z1Sign = (head z1-bin)
    (_let z1Val = (tail z1-bin)
    (_let z2Sign = (head z2-bin)
    (_let z2Val = (tail z2-bin)
    ; core logic
    (_if ((_and z1Sign) z2Sign)
        _then ((bin-lte z1Val) z2Val)
        _else (_if ((_and (_not z1Sign)) (_not z2Sign))
                _then ((bin-gte z1Val) z2Val)
                _else ((_or z2Sign) ((_and (isZeroZ-bin z1-bin)) (isZeroZ-bin z2-bin))))))))))

#|
    ~ EQUAL ~
    - Contract: (int,int) => bool
    - Logic: Check if (z1 >= z2) AND (z1 <= z2)
|#
(def eqZ-bin z1-bin z2-bin =
    ((_and
        ((lteZ-bin z1-bin) z2-bin))
        ((gteZ-bin z1-bin) z2-bin)))

#|
    ~ GREATER THAN ~
    - Contract: (int,int) => bool
    - Logic: Check if (z1 >= z2) AND not(z1 == z2)
|#
(def gtZ-bin z1-bin z2-bin =
    ((_and
        (_not ((eqZ-bin z1-bin) z2-bin)))
        ((gteZ-bin z1-bin) z2-bin)))

#|
    ~ LESS THAN ~
    - Contract: (int,int) => bool
    - Logic: Check if (z1 <= z2) AND not(z1 == z2)
|#
(def ltZ-bin z1-bin z2-bin =
    ((_and
        (_not ((eqZ-bin z1-bin) z2-bin)))
        ((lteZ-bin z1-bin) z2-bin)))

;===================================================

#|
    ~ ABSOLUTE VALUE ~
    - Contract: int => int
    - Idea: force sign to be positive
    - Logic: make new int with positive sign
|#
(def absValZ-bin z-bin = ((makeZ-bin true) (tail z-bin)))

#|
    ~ IS ODD z ~
    - Contract: int => bool
    - Idea: check if magnitude part is odd (sign is irrelevant to parity)
|#
(def isOddZ-bin z-bin = (bin-is-odd (tail z-bin)))

#|
    ~ IS EVEN z ~
    - Contract: int => bool
    - Idea: check if magnitude part is even (sign is irrelevant to parity)
|#
(def isEvenZ-bin z-bin = (bin-is-even (tail z-bin)))
