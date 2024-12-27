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
(def SUCC N = (((((fully-type succ) "SUCC") nat) N) nat))

#|
    ~ READS NAT TYPED VALUES ~
    - Contract: NAT => READABLE(NAT)
|#
(def _nat-read N = 
    (_if (is-nat N)
        _then (string-append "nat:" (n-read (val N)))
        ; _then (n-read (val N))
        _else (err-read BOOL-ERROR)))

(def nat-read N = ((read-type _nat-read) N))

;===================================================

#|
    ~ IS ZERO
    - Contract: NAT => BOOL/ERROR
    - Logic: isZero function with type checking
|#
(def IS_ZERO N = (((((fully-type isZero) "IS_ZERO") nat) N) bool))

;===================================================

; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M+N
|#
(def ADD M N = (((((((fully-type2 add) "ADD") nat) M) nat) N) nat))

#|
    ~ MULTIPLICATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M*N
|#
(def MULT M N = (((((((fully-type2 mult) "MULT") nat) M) nat) N) nat))

#|
    ~ EXPONENTIATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M^N
|#
(def EXP M N = (((((((fully-type2 _exp) "EXP") nat) M) nat) N) nat))

#|
    ~ PREDECESSOR ~
    - Contract: NAT => NAT
    - Idea:
        - if n is 0
            then => 0
            else => n-1
|#
(def PRED N = (((((fully-type pred) "PRED") nat) N) nat))

#|
    ~ SUBTRACTION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M-N
|#
(def SUB M N = (((((((fully-type2 sub) "SUB") nat) M) nat) N) nat))

;===================================================

#|
    ~ DIVISION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M/N
|#
(def DIV M N = (((((((fully-type2 div) "DIV") nat) M) nat) N) nat))

#|
    ~ MODULO ~
    - Contract: (NAT,NAT) => NAT
    - Idea: Same as remainder for natural numbers
|#
(def MOD M N = (((((((fully-type2 mod) "MOD") nat) M) nat) N) nat))

#|
    ~ IS-EVEN ~
    - Contract: NAT => BOOL
|#
(def IS_EVEN N = (((((fully-type isEven) "IS_EVEN") nat) N) bool))

; #|
;     ~ IS-ODD ~
;     - Contract: NAT => BOOL
; |#
(def IS_ODD N = (((((fully-type isOdd) "IS_ODD") nat) N) bool))

;===================================================

#|
    ~ GREATER-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def GTE M N = (((((((fully-type2 gte) "GTE") nat) M) nat) N) bool))

#|
    ~ LESS-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def LTE M N = (((((((fully-type2 lte) "LTE") nat) M) nat) N) bool))

; #|
;     ~ EQUAL ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def EQ M N = (((((((fully-type2 eq) "EQ") nat) M) nat) N) bool))

; #|
;     ~ GREATER-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def GT M N = (((((((fully-type2 gt) "GT") nat) M) nat) N) bool))

; #|
;     ~ LESS-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def LT M N = (((((((fully-type2 lt) "LT") nat) M) nat) N) bool))
