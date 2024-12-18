#lang lazy
(provide (all-defined-out))
(require "church.rkt"
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
            where the value of the would be their difference, e.g. {6,8} is -2
        - The lambdas for working with them below this way may suggest this approach is not simpler.
        - But this accords far more with our normal way of thinking of integers, 
            not as each being the difference of infinitely many (!) pairs of natural numbers,
            but as a single natural number with a positive or negative.
        - With this approach there is only a single redundant value, zero, as both positive or negative

|#
;===================================================

#|
    ~ MAKE INT ~
    - Structure: (bool,nat) => {bool,nat}
    - Logic: just a pair function
|#
(define makeZ
    (lambda (sign)
        (lambda (nat)
            ((_pair sign) nat)
        )
    )
)

#|
    ~ INT ZERO ~
    - Structure: {bool, zero}
    - Logic: n part same as false
    - Note: bool true or false, thus -0 == +0
|#
(define zeroZ ((makeZ true) zero))

#|
    ~ INT SUCCESSOR ~
    - Contract: int => int
    - Idea: z => z+1
    - Logic: If z == 0 or z is positive
                then make output positive and use regular succ
                else make output negative and use regular pred
|#
(define succZ
    (lambda (z1)
        ((((_or ((eq (_tail z1)) zero)) (_head z1))
            ((makeZ true) (succ (_tail z1))))
            ((makeZ false) (pred (_tail z1)))
        )
    )
)

#|
    ~ CHURCH INT READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: int => readable(int)
    - Logic: Outputs z for user 
                If z is positive or zero
                    then uses regular n-read
                    else appends minus sign
|#
(define z-read
    (lambda (z1)
        ((((_or (_head z1)) (isZero (_tail z1)))
            (n-read (_tail z1)))
            (string-append "-" (number->string (n-read (_tail z1))))
        )
    )
)

;===================================================

#|
    ~ NEGATIVE FIVE TO POSITIVE 5 INTEGERS ~
    - Logic: As created by makeZ
|#

(define negFive ((makeZ false) five))
(define negFour ((makeZ false) four))
(define negThree ((makeZ false) three))
(define negTwo ((makeZ false) two))
(define negOne ((makeZ false) one))
(define negZero ((makeZ false) zero))
(define posZero ((makeZ true) zero))
(define posOne ((makeZ true) one))
(define posTwo ((makeZ true) two))
(define posThree ((makeZ true) three))
(define posFour ((makeZ true) four))
(define posFive ((makeZ true) five))

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
(define addZ
    (lambda (z1)
        (lambda (z2)
            ((((_and (_head z1)) (_head z2))
                ((makeZ true) ((add (_tail z1)) (_tail z2))))
                ((((_and (_not (_head z1))) (_not (_head z2)))
                    ((makeZ false) ((add (_tail z1)) (_tail z2))))
                    (((_head z1)
                        ((makeZ ((gt (_tail z1)) (_tail z2))) ((sub (_tail z2)) (_tail z1))))
                        ((makeZ ((lt (_tail z1)) (_tail z2))) ((sub (_tail z1)) (_tail z2)))
                    )
                )
            )
        )
    )
)

#|
    ~ SUBTRACTION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1-z2
    - Logic: Use addZ by reframing z1-z2 as z1+(-z2)
|#
(define subZ
    (lambda (z1)
        (lambda (z2)
            ((addZ z1) ((makeZ (_not (_head z2))) (_tail z2)))
        )
    )
)

#|
    ~ MULTIPLICATION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1*z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign 
                and do regular multiplication for number
|#
(define multZ
    (lambda (z1)
        (lambda (z2)
            ((makeZ
                (_not ((xor (_head z1)) (_head z2)))) 
                ((mult (_tail z1)) (_tail z2))
            )
        )
    )
)

#|
    ~ DIVISION ~
    - Contract: (int,int) => int
    - Idea: z1,z2 => z1/z2
    - Logic: Negate logical xor (if both same sign, true, else false) for sign 
                and do regular division for number
|#
(define divZ
    (lambda (z1)
        (lambda (z2)
            ((makeZ
                (_not ((xor (_head z1)) (_head z2)))) 
                ((div (_tail z1)) (_tail z2))
            )
        )
    )
)

;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: int => bool
    - Logic: Check if (n part of z is zero)
                true, else false
|#
(define isZeroZ
    (lambda (z)
        (isZero (_tail z))
    )
)

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 >= z2)
                then => true
                else => false
    - Logic: IF (z1 AND z2 positive)
                then (n1 >= n2)
                else IF (z1 AND z2 negative)
                    then (n2 <= n1)
                    else (z1 positive OR both z1 AND z2 equal zero)
|#
(define gteZ
    (lambda (z1)
        (lambda (z2)
            ((((_and (_head z1)) (_head z2))
                ((gte (_tail z1)) (_tail z2)))
                ((((_and (_not (_head z1))) (_not (_head z2)))
                    ((lte (_tail z1)) (_tail z2)))
                    ((_or (_head z1)) ((_and (isZeroZ z1)) (isZeroZ z2)))
                )
            )
        )
    )
)

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
(define lteZ
    (lambda (z1)
        (lambda (z2)
            ((((_and (_head z1)) (_head z2))
                ((lte (_tail z1)) (_tail z2)))
                ((((_and (_not (_head z1))) (_not (_head z2)))
                    ((gte (_tail z1)) (_tail z2)))
                    ((_or (_head z2)) ((_and (isZeroZ z1)) (isZeroZ z2)))
                )
            )
        )
    )
)

#|
    ~ EQUAL ~
    - Contract: (int,int) => bool
    - Idea: if (z1 == z2)
                then => true
                else => false
    - Logic: Check if (z1 >= z2) AND (z1 <= z2)
|#
(define eqZ
    (lambda (z1)
        (lambda (z2) 
            ((_and ((lteZ z1) z2)) ((gteZ z1) z2))
        )
    )
)

#|
    ~ GREATER THAN ~
    - Contract: (int,int) => bool
    - Idea: if (z1 > z2)
                then => true
                else => false
    - Logic: Check if (z1 >= z2) AND not(z1 == z2)
|#
(define gtZ
    (lambda (z1)
        (lambda (z2)
            ((_and (_not ((eqZ z1) z2))) ((gteZ z1) z2))      
        )
    )
)

#|
    ~ LESS THAN ~
    - Contract: (int,int) => bool
    - Idea: if (z1 < z2)
                then => true
                else => false
    - Logic: Check if (z1 <= z2) AND not(z1 == z2)
|#
(define ltZ
    (lambda (z1)
        (lambda (z2)
            ((_and (_not ((eqZ z1) z2))) ((lteZ z1) z2))      
        )
    )
)

;===================================================








