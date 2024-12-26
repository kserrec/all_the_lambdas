#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../division.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ NAT OBJECTS ~
;   - Idea: Typed Church Numerals
|#

(def ZERO = (make-nat zero))
(def ONE = (make-nat one))
(def TWO = (make-nat two))
(def THREE = (make-nat three))
(def FOUR = (make-nat four))
(def FIVE = (make-nat five))

#|
    ~ SUCCESSOR ~
    - Contract: NAT => NAT
    - Idea: N => N+1
    - Logic: Returns successor of N
|#
(def SUCC N = (((((type-n-check-f succ) "SUCC") nat-type) nat-type) N))

#|
    ~ READS NAT TYPED VALUES ~
    - Contract: NAT => READABLE(NAT)
|#
(def _N-READ N = 
    (_if (is-nat N)
        _then (s-a "nat:" (n-s (n-read (val N))))
        _else (err-read BOOL-ERROR)))

(def N-READ N = ((read-type _N-READ) N))

;===================================================

#|
    ~ IS ZERO
    - Contract: NAT => BOOL/ERROR
    - Logic: isZero function with type checking
|#
(def IS_ZERO N = (((((type-n-check-f isZero) "IS_ZERO") nat-type) bool-type) N))

;===================================================

; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M+N
|#
(def ADD M N = (((((((type-n-check-f2 add) "ADD") nat-type) nat-type) nat-type) M) N))

#|
    ~ MULTIPLICATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M*N
|#
(def MULT M N = (((((((type-n-check-f2 mult) "MULT") nat-type) nat-type) nat-type) M) N))

#|
    ~ EXPONENTIATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M^N
|#
(def EXP M N = (((((((type-n-check-f2 _exp) "EXP") nat-type) nat-type) nat-type) M) N))

#|
    ~ PREDECESSOR ~
    - Contract: NAT => NAT
    - Idea:
        - if n is 0
            then => 0
            else => n-1
|#
(def PRED N = (((((type-n-check-f pred) "PRED") nat-type) nat-type) N))

#|
    ~ SUBTRACTION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M-N
|#
(def SUB M N = (((((((type-n-check-f2 sub) "SUB") nat-type) nat-type) nat-type) M) N))

;===================================================

#|
    ~ MODULO ~
    - Contract: (NAT,NAT) => NAT
    - Idea: Same as remainder for natural numbers
|#
(def MOD M N = (((((((type-n-check-f2 mod) "MOD") nat-type) nat-type) nat-type) M) N))

#|
    ~ IS-EVEN ~
    - Contract: NAT => BOOL
|#
(def IS_EVEN N = (((((type-n-check-f isEven) "IS_EVEN") nat-type) bool-type) N))

; #|
;     ~ IS-ODD ~
;     - Contract: NAT => BOOL
; |#
(def IS_ODD N = (((((type-n-check-f isOdd) "IS_ODD") nat-type) bool-type) N))

;===================================================

#|
    ~ GREATER-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def GTE M N = (((((((type-n-check-f2 gte) "GTE") nat-type) nat-type) bool-type) M) N))

#|
    ~ LESS-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def LTE M N = (((((((type-n-check-f2 lte) "LTE") nat-type) nat-type) bool-type) M) N))

; #|
;     ~ EQUAL ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def EQ M N = (((((((type-n-check-f2 eq) "EQ") nat-type) nat-type) bool-type) M) N))

; #|
;     ~ GREATER-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def GT M N = (((((((type-n-check-f2 gt) "GT") nat-type) nat-type) bool-type) M) N))

; #|
;     ~ LESS-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def LT M N = (((((((type-n-check-f2 lt) "LT") nat-type) nat-type) bool-type) M) N))
