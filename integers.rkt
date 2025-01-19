#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "division.rkt"
         "lists.rkt"
         "logic.rkt")

;===================================================
; SIGNED NATURALS
;===================================================

#| INTEGERS (z)

    Note: pairs will be written here in braces, {a,b}
    For the integers, a pair of this format is used: int = {bool, nat} 
    
    The lambdas are structured like this:
        -3: {false, three}
        -2: {false, two}
        -1: {false, one}
        -0/+0: {true, zero} and/or {false, zero}
        +1: {true, one}
        +2: {true, two}
        +3: {true, three}

    Completely broken down representation of -2: \f.f(\x.\y.y)(\f.\x.f(fx))

    More notes: 
        - This approach to structuring the integers seemed simpler and more logical than {nat, nat} 
            where the value of the integer would be their difference, e.g. {6,8} is -2
        - The lambdas for working with them this way below may suggest this approach is not simpler.
        - But this accords far more with our normal way of thinking of integers, 
            not as each being the difference of infinitely many (!) pairs of natural numbers,
            but as a single number with a positive or negative sign in front.
        - With this approach there is only a single redundant value, zero, as both positive or negative.

|#
;===================================================

#|
    ~ MAKE INT ~
    - Structure: (bool,nat) => {bool,nat}
    - Logic: just a pair function
|#
(def makeZ sign nat = ((pair sign) nat))

#|
    ~ INT ZERO ~
    - Structure: {bool, zero}
    - Logic: n part same as false
    - Note: bool true or false, thus -0 == +0
|#
(def posZero = ((makeZ true) zero))

#|
    ~ INT SUCCESSOR ~
    - Contract: int => int
    - Idea: z => z+1
    - Logic: If z == 0 or z is positive
                then make output positive and use regular succ
                else make output negative and use regular pred
|#
(def succZ z =
    ; let vars
    (_let zSign = (head z)
    (_let zVal = (tail z)
    ; core logic
    ((((_or ((eq zVal) zero)) zSign)
        ((makeZ true) (succ zVal)))
        ((makeZ false) (pred zVal))))))

#|
    ~ CHURCH INT READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: int => readable(int)
    - Logic: Outputs z for user 
                If z is positive or zero
                    then uses regular n-read
                    else appends minus sign
|#
(def z-read z =
    ; let vars
    (_let zSign = (head z)
    (_let zVal = (tail z)
    ; core logic
    ((((_or zSign) (isZero zVal))
        (n-read zVal))
        (string-append "-" (n-read zVal))))))

;===================================================

#|
    ~ NEGATIVE FIVE TO POSITIVE 5 INTEGERS ~
    - Logic: As created by makeZ
|#

(def negFive = ((makeZ false) five))
(def negFour = ((makeZ false) four))
(def negThree = ((makeZ false) three))
(def negTwo = ((makeZ false) two))
(def negOne = ((makeZ false) one))
(def negZero = ((makeZ false) zero))
(def posOne = ((makeZ true) one))
(def posTwo = ((makeZ true) two))
(def posThree = ((makeZ true) three))
(def posFour = ((makeZ true) four))
(def posFive = ((makeZ true) five))

;===================================================

; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1+z2
    - Logic: If both positive
                then make positive output and use regular add
                else if both negative
                    then make negative and use regular add
                    else if z1 positive (assume z2 negative)
                        then take difference and use gt to figure sign
                        else take difference and use lt to figure sign
|#
(def addZ z1 z2 =
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    (_if (_not ((xor z1Sign) z2Sign))
    ; if both same sign
        _then ((makeZ z1Sign) ((add z1Val) z2Val))
        ; then make result their sign and use regular addition
        _else (_if ((gt z1Val) z2Val)
        ; else if different signs and |z1| > |z2|
                _then ((makeZ z1Sign) ((sub z1Val) z2Val))
                ; then take sign of larger and do regular diff
                _else ((makeZ z2Sign) ((sub z2Val) z1Val)))))))))
                ; else take sign of larger and do reverse diff
            
                

#|
    ~ SUBTRACTION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1-z2
    - Logic: Use addZ by reframing z1-z2 as z1+(-z2)
|#

; (def subZ z1 z2 = 
;     ((addZ z1) ((multZ z2) negOne)))

(def invertZ z = 
    (_let z-sign = (head z)
    (_let z-val = (tail z)
    ((makeZ (_not z-sign)) z-val))))

(def subZ z1 z2 = ((addZ z1) (invertZ z2)))

#|
    ~ PREDECESSOR ~
    - Contract: (int,int) => int
    - Idea: z1 => z1-1
    - Logic: Use subZ (really, this is unnecessary since subtraction is more general)
|#
(def predZ z1 = ((subZ z1) posOne))

#|
    ~ MULTIPLICATION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1*z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign 
                and do regular multiplication for number
|#
(def multZ z1 z2 = 
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    ((makeZ 
        (_not ((xor z1Sign) z2Sign))) ; sign
        ((mult z1Val) z2Val)))))))    ; val

#|
    ~ DIVISION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1/z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign 
                and do regular division for number
|#
(def divZ z1 z2 = 
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    ((makeZ
        (_not ((xor z1Sign) z2Sign))) ; sign
        ((div z1Val) z2Val)))))))     ; val

#|
    ~ EXPONENTIATION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1^z2
    - Logic: Do regular exponent except when z2 < 0, then result is 0
|#
(def expZ z1 z2 = 
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    (_if (_not z2Sign)
    ; if raised to negative power
        _then posZero
        ; then default to zero
        _else (_if z1Sign
        ; else if z1 positive
                _then ((makeZ true) ((_exp z1Val) z2Val))
                ; then make positive and do regular exponent
                _else ((makeZ (isEven z2Val)) ((_exp z1Val) z2Val)))))))))
                ; else flip sign based on even or odd power
            
;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: int => bool
    - Logic: Check if (n part of z is zero)
                true, else false
|#
(def isZeroZ z = (isZero (tail z)))

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 >= z2)
                then => true
                else => false
    - Logic: IF (both positive)
                then (n1 >= n2)
                else IF (both negative)
                    then (n2 <= n1)
                    else (z1 positive OR both are zero)
|#
(def gteZ z1 z2 = 
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    (_if ((_and z1Sign) z2Sign)
        _then ((gte z1Val) z2Val)
        _else (_if ((_and (_not z1Sign)) (_not z2Sign))
                _then ((lte z1Val) z2Val)
                _else ((_or z1Sign) ((_and (isZeroZ z1)) (isZeroZ z2))))))))))

#|
    ~ LESS THAN OR EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 <= z2)
                then => true
                else => false
    - Logic: IF (z1 AND z2 positive)
                then (n1 <= n2)
                else IF (z1 AND z2 negative)
                    then (n2 >= n1)
                    else (z2 positive OR both z1 AND z2 equal zero)
|#
(def lteZ z1 z2 = 
    ; let vars
    (_let z1Sign = (head z1)
    (_let z1Val = (tail z1)
    (_let z2Sign = (head z2)
    (_let z2Val = (tail z2)
    ; core logic
    (_if ((_and z1Sign) z2Sign)
        _then ((lte z1Val) z2Val)
        _else (_if ((_and (_not z1Sign)) (_not z2Sign))
                _then ((gte z1Val) z2Val)
                _else ((_or z2Sign) ((_and (isZeroZ z1)) (isZeroZ z2))))))))))

#|
    ~ EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 == z2)
                then => true
                else => false
    - Logic: Check if (z1 >= z2) AND (z1 <= z2)
|#
(def eqZ z1 z2 = 
    ((_and 
        ((lteZ z1) z2)) 
        ((gteZ z1) z2)))

#|
    ~ GREATER THAN ~
    - Contract: (int,int) => bool
    - Idea: if (z1 > z2)
                then => true
                else => false
    - Logic: Check if (z1 >= z2) AND not(z1 == z2)
|#
(def gtZ z1 z2 =
    ((_and 
        (_not ((eqZ z1) z2))) 
        ((gteZ z1) z2)))

#|
    ~ LESS THAN ~
    - Contract: (int,int) => bool
    - Idea: if (z1 < z2)
                then => true
                else => false
    - Logic: Check if (z1 <= z2) AND not(z1 == z2)
|#
(def ltZ z1 z2 =
    ((_and 
        (_not ((eqZ z1) z2))) 
        ((lteZ z1) z2)))

;===================================================

#|
    ~ ABSOLUTE VALUE ~
    - Contract: int => int
    - Idea: force sign to be positive
    - Logic: make new int with positive sign
|#
(def absValZ z = ((makeZ true) (tail z)))






