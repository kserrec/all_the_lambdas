#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "logic.rkt")

;===================================================
; CHURCH NUMERALS
;===================================================

#| NATURAL NUMBERS (n)

    For the Church Numerals (natural numbers in lambda calculus):
    Definition: nat ::= 0 | Succ(nat)

    The lambdas look like this:
        0: \fx.x
        1: \fx.fx
        2: \fx.f(fx)
        3: \fx.f(f(fx))
        4: \fx.f(f(f(fx)))
        5: \fx.f(f(f(f(fx))))

    Logic: A natural number function n has two parameters...
                and applies the first to the second n times 
|#
;===================================================

#|
    ~ ZERO ~
    - Contract: (func,func) => func
    - Logic: Same as false
|#
(def zero = false)

#|
    ~ SUCCESSOR ~
    - Contract: nat => nat
    - Idea: n => n+1
    - Logic: Returns successor of n
|#
(def succ n f x = (f ((n f) x)))

#|
    ~ CHURCH READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: nat => readable(nat)
    - Logic: Outputs n for user 
|#
(def n-read n = (number->string ((n (lambda (x) (+ x 1))) 0)))

;===================================================

#|
    ~ FIRST FIVE CHURCH NUMERALS ~
    - Logic: As created by SUCCESSION
|#

; ONE, TWO, THREE, FOUR, and FIVE
(def one = (succ zero))
(def two = (succ one))
(def three = (succ two))
(def four = (succ three))
(def five = (succ four))

;===================================================

; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (nat,nat) => nat
    - Idea: m,n => m+n
    - Logic: Repeatedly applies SUCCESSION m times to n
|#
(def add m n = ((m succ) n))

#|
    ~ MULTIPLICATION ~
    - Contract: (nat,nat) => nat
    - Idea: m,n => m*n
    - Logic: Multiplication is repeated addition so this...
        repeatedly applies ADDITION n times to m on zero
|#
(def mult m n = ((n (add m)) zero))

#|
    ~ EXPONENTIATION ~
    - Contract: (nat,nat) => nat
    - Idea: m,n => m^n
    - Logic: Exponentiation is repeated multiplication so this...
        repeatedly applies MULTIPLICATION n times to m on one
|#
(def _exp m n = ((n (mult m)) one))

#|
    ~ PREDECESSOR ~
    - Contract: nat => nat
    - Idea:
        - if n is 0
            then => 0
            else => n-1
    - Logic: Successively builds up n from 0...
                but constant function (\u.x) cuts one out
|#
(def pred n f x =
    (((n
        (lambda (g) (lambda (h) (h (g f)))))    
            (lambda (u) x))
                (lambda (a) a)
    )
)

#|
    ~ SUBTRACTION ~
    - Contract: (nat,nat) => nat
    - Idea: m,n => m-n
    - Logic: Repeatedly applies PREDECESSOR n times from m
|#
(def sub m n = ((n pred) m))

;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: nat => bool
    - Idea: if (n is 0)
                then => true
                else => false
    - Logic: 
        - zero takes second argument, returns true
        - other numbers always return constant false, disregarding true 
|#
(def isZero n = ((n (lambda (x) false)) true))

#|
    ~ GREATER-THAN-OR-EQUAL ~
    - Contract: (nat,nat) => bool
    - Idea: if (m >= n)
                then => true
                else => false
    - Logic: Check if n-m is zero. 
                Since pred(0) == 0, n-m will only equal 0 if (m >= n)
|#
(def gte m n = (isZero ((sub n) m)))

#|
    ~ LESS-THAN-OR-EQUAL ~
    - Contract: (nat,nat) => bool
    - Idea: if (m <= n)
                then => true
                else => false
    - Logic: Check if m-n is zero.
                Since pred(0) == 0, m-n will only equal 0 if (m <= n)
|#
(def lte m n = (isZero ((sub m) n)))

#|
    ~ EQUAL ~
    - Contract: (nat,nat) => bool
    - Idea: if (m == n)
                then => true
                else => false
    - Logic: Check if (m >= n) AND (m <= n)
|#
(def eq m n = ((_and ((lte m) n)) ((gte m) n)))

#|
    ~ GREATER-THAN ~
    - Contract: (nat,nat) => bool
    - Idea: if (m > n)
                then => true
                else => false
    - Logic: Check if (m >= n) AND not(m == n)
|#
(def gt m n = 
    ((_and 
        ((gte m) n)) 
        (_not ((eq m) n)))
)

#|
    ~ LESS-THAN ~
    - Contract: (nat,nat) => bool
    - Idea: if (m < n)
                then => true
                else => false
    - Logic: Check if (m <= n) AND not(m == n)
|#
(def lt m n = 
    ((_and 
        ((lte m) n)) 
        (_not ((eq m) n)))
)

;===================================================



